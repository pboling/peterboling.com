#!/usr/bin/env ruby
# frozen_string_literal: true
#
# check_new_releases.rb - Detects new releases in projects.yml and generates release posts
# with syndication to dev.to, Open Collective, RubyForum, daily.dev, and Reddit.
#
# Usage:
#   ruby scripts/check_new_releases.rb [--dry-run] [--project PROJECT_NAME]
#   ruby scripts/check_new_releases.rb --help

require 'yaml'
require 'json'
require 'net/http'
require 'uri'
require 'date'
require 'time'
require 'fileutils'
require 'optparse'
require 'open3'

# ============================================================================
# CONFIGURATION
# ============================================================================

PROJECTS_FILE = File.expand_path('../src/_data/projects.yml', __dir__)
STATE_FILE = File.expand_path('../tmp/release_checker_state.json', __dir__)
FAMILIES_FILE = File.expand_path('../src/_data/families.yml', __dir__)
PERSON_FILE = File.expand_path('../src/_data/person.yml', __dir__)

# Tier thresholds (cumulative: Medium includes Low, High includes Medium, etc.)
TIER_THRESHOLDS = {
  none: 0,
  low: 25,
  medium: 50,
  high: 75,
  maximum: 90
}.freeze

# Release impact scoring (max ~60 points)
RELEASE_IMPACT = {
  major_bump: 30,
  minor_bump: 15,
  patch_bump: 0,
  prerelease_penalty: -10,
  security_fix: 30,
  breaking_changes: 15,
  significant_features: 10,
  deprecations: 5,
  runtime_compatibility_shift: 10,
  maintenance_only_penalty: -15,
  user_facing_bug_fix: 25  # Guaranteed floor for user-facing fixes
}.freeze

# Project reach scoring (max ~45 points)
PROJECT_REACH = {
  daily_downloads: {
    very_high: { threshold: 5000, points: 20 },
    high: { threshold: 500, points: 12 },
    medium: { threshold: 50, points: 6 },
    low: { threshold: 0, points: 2 }
  },
  total_downloads: {
    very_high: { threshold: 10_000_000, points: 15 },
    high: { threshold: 1_000_000, points: 10 },
    medium: { threshold: 100_000, points: 6 },
    low: { threshold: 0, points: 2 }
  },
  stars: {
    very_high: { threshold: 100, points: 10 },
    high: { threshold: 25, points: 6 },
    medium: { threshold: 5, points: 3 },
    low: { threshold: 0, points: 1 }
  }
}.freeze

# Weighted check cadence (in hours)
CHECK_CADENCE = {
  top24: 1,      # Check every 1-2 hours
  active_families: 4,   # Check every 4-6 hours
  rest: 24       # Check daily
}.freeze

# Tier -> Destinations mapping (cumulative)
TIER_DESTINATIONS = {
  low: [:blog],
  medium: [:blog, :devto, :opencollective, :rubyforum],
  high: [:blog, :devto, :opencollective, :rubyforum, :dailydev],
  maximum: [:blog, :devto, :opencollective, :rubyforum, :dailydev, :reddit]
}.freeze

# ============================================================================
# UTILITY CLASSES
# ============================================================================

class ReleaseChecker
  attr_reader :options, :projects, :state, :person, :families

  def initialize(options = {})
    @options = options
    @dry_run = options[:dry_run] || false
    @target_project = options[:project]
    @verbose = options[:verbose] || false

    load_env
    load_data
    load_state
  end

  def load_env
    env_paths = [
      File.expand_path('../.env.local', __dir__),
      File.expand_path('../.env', __dir__)
    ]
    env_paths.each do |path|
      next unless File.file?(path)

      File.readlines(path).each do |line|
        line = line.strip
        next if line.empty? || line.start_with?('#')

        # Handle "export KEY=val" or "KEY=val"
        line = line.sub(/^export\s+/, '')
        key, val = line.split('=', 2)
        next unless key && val

        # Strip surrounding quotes if present
        val = val.strip.sub(/^["']/, '').sub(/["']$/, '')
        ENV[key.strip] ||= val
      end
    end
  end

  def load_data
    @projects = YAML.load_file(PROJECTS_FILE, permitted_classes: [Date, Time], aliases: true)
    @families = YAML.load_file(FAMILIES_FILE, permitted_classes: [Date, Time], aliases: true)
    @person = YAML.load_file(PERSON_FILE, permitted_classes: [Date, Time], aliases: true)
  rescue => e
    abort "Failed to load data files: #{e.message}"
  end

  def load_state
    if File.exist?(STATE_FILE)
      @state = JSON.parse(File.read(STATE_FILE))
    else
      @state = { 'projects' => {}, 'last_check' => Time.now.utc.iso8601 }
    end
  end

  def save_state
    FileUtils.mkdir_p(File.dirname(STATE_FILE))
    @state['last_check'] = Time.now.utc.iso8601
    File.write(STATE_FILE, JSON.pretty_generate(@state))
  end

  def run
    puts "=== Release Checker Started at #{Time.now.utc.iso8601} ==="
    puts "Dry run: #{@dry_run}" if @dry_run
    puts "Target project: #{@target_project || 'all'}"

    projects_to_check = select_projects_to_check
    puts "Projects to check: #{projects_to_check.size}"

    results = []
    projects_to_check.each do |project|
      result = check_project(project)
      results << result if result
    end

    save_state unless @dry_run

    print_summary(results)
    results
  end

  def select_projects_to_check
    now = Time.now.utc
    projects_to_check = []

    @projects.each do |project|
      next if @target_project && project['name'] != @target_project
      next unless should_check_project?(project, now)

      projects_to_check << project
    end

    projects_to_check
  end

  def should_check_project?(project, now)
    name = project['name']
    project_state = @state['projects'][name] || {}

    # Determine tier based on project characteristics
    tier = determine_tier(project)
    cadence_hours = CHECK_CADENCE[tier] || CHECK_CADENCE[:rest]

    last_checked = project_state['last_checked']
    if last_checked
      last_check_time = Time.iso8601(last_checked)
      return false if (now - last_check_time) < cadence_hours * 3600
    end

    true
  end

  def determine_tier(project)
    # Top 24 by downloads (matching galtzo.com's refresh-project.yml)
    # We approximate by checking if it's in the top tier
    total_downloads = project['total_downloads'] || 0
    daily_downloads = project['daily_downloads'] || 0

    # Check if project is in a core family (kettle-rb, structuredmerge, etc.)
    family_id = project['family_id']
    is_core_family = family_id && ['kettle-rb', 'structuredmerge', 'smorg-rb', 'smorg-dev', 'smorg-test', 'smorg-data'].include?(family_id)

    # High velocity projects
    if daily_downloads > 1000 || total_downloads > 1_000_000
      :top24
    elsif is_core_family || daily_downloads > 100
      :active_families
    else
      :rest
    end
  end

  def check_project(project)
    name = project['name']
    current_release_date = project['release_date']
    github_url = extract_github_url(project)

    return nil unless github_url

    # Fetch latest release from GitHub
    latest_release = fetch_latest_github_release(github_url)
    return nil unless latest_release

    latest_tag = latest_release['tag_name']
    latest_published = latest_release['published_at']

    # Check if this is a new release
    project_state = @state['projects'][name] || {}
    last_known_tag = project_state['last_tag']
    last_known_date = project_state['last_release_date']

    if last_known_tag == latest_tag && last_known_date == current_release_date
      # No new release
      update_check_time(name)
      return nil
    end

    puts "  🔔 New release detected: #{name} #{latest_tag}"

    # Fetch changelog/release notes
    release_data = fetch_changelog(github_url, latest_tag)
    return nil unless release_data

    changelog = release_data.fetch('markdown')

    # Score the release
    score_data = score_release(project, latest_tag, latest_release, changelog)
    tier = determine_tier_from_score(score_data[:total])

    # Get destinations for this tier
    destinations = TIER_DESTINATIONS[tier] || []

    puts "    Score: #{score_data[:total]} (#{tier})"
    puts "    Destinations: #{destinations.join(', ')}"

    # Generate release post
    post_path = generate_release_post(project, latest_tag, latest_published, changelog, score_data)

    # Publishing to external services requires an explicit instruction.
    syndication_results = {}

    # Update state
    @state['projects'][name] = {
      'last_tag' => latest_tag,
      'last_release_date' => current_release_date,
      'last_checked' => Time.now.utc.iso8601,
      'last_score' => score_data[:total],
      'last_tier' => tier.to_s
    }

    {
      project: name,
      tag: latest_tag,
      score: score_data[:total],
      tier: tier,
      post_path: post_path,
      syndication: syndication_results
    }
  end

  def update_check_time(name)
    @state['projects'][name] ||= {}
    @state['projects'][name]['last_checked'] = Time.now.utc.iso8601
  end

  def extract_github_url(project)
    forges = project['forges'] || []
    github_forge = forges.find { |f| f['type'] == 'GitHub' }
    return github_forge['url'] if github_forge

    # Fallback: try to construct from source_code_uri patterns
    nil
  end

  def fetch_latest_github_release(github_url)
    # Convert to API URL
    repo_path = github_url.sub(%r{^https?://github\.com/}, '').sub(/\.git$/, '')
    api_url = "https://api.github.com/repos/#{repo_path}/releases/latest"

    uri = URI(api_url)
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = 'application/vnd.github.v3+json'
    req['Authorization'] = "token #{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)

    return nil unless res.code == '200'

    JSON.parse(res.body)
  rescue => e
    warn "    Failed to fetch release for #{github_url}: #{e.message}"
    nil
  end

  def fetch_changelog(github_url, tag)
    repo_path = github_url.sub(%r{^https?://github\.com/}, '').sub(/\.git$/, '')
    uri = URI("https://raw.githubusercontent.com/#{repo_path}/#{URI.encode_www_form_component(tag)}/CHANGELOG.md")
    req = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
    raise "changelog fetch returned HTTP #{response.code}" unless response.code == '200'

    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'kettle-changelog', '--release', tag, stdin_data: response.body)
    raise "kettle-changelog failed: #{stderr.strip}" unless status.success?

    release = JSON.parse(stdout)
    unless release.is_a?(Hash) && release['version'] == tag.delete_prefix('v') &&
        release['markdown'].is_a?(String) && !release['markdown'].strip.empty?
      raise 'kettle-changelog returned invalid or mismatched release data'
    end
    release
  rescue StandardError => e
    warn "    Cannot extract #{tag} from #{github_url}: #{e.message}"
    nil
  end

  def score_release(project, tag, release, changelog)
    score = 0
    breakdown = {}

    # --- Release Impact (SemVer) ---
    semver_type = classify_semver(tag)
    case semver_type
    when :major
      score += RELEASE_IMPACT[:major_bump]
      breakdown[:semver] = RELEASE_IMPACT[:major_bump]
    when :minor
      score += RELEASE_IMPACT[:minor_bump]
      breakdown[:semver] = RELEASE_IMPACT[:minor_bump]
    when :patch
      score += RELEASE_IMPACT[:patch_bump]
      breakdown[:semver] = RELEASE_IMPACT[:patch_bump]
    when :prerelease
      score += RELEASE_IMPACT[:prerelease_penalty]
      breakdown[:semver] = RELEASE_IMPACT[:prerelease_penalty]
    end

    # --- Changelog Analysis ---
    changelog_lower = changelog.downcase

    # Security fix detection
    if changelog_lower.match?(/security|cve-|vulnerab|advisory|exploit/)
      score += RELEASE_IMPACT[:security_fix]
      breakdown[:security] = RELEASE_IMPACT[:security_fix]
    end

    # Breaking changes
    if changelog_lower.match?(/breaking change|\[breaking\]|!! breaking|migration required/)
      score += RELEASE_IMPACT[:breaking_changes]
      breakdown[:breaking] = RELEASE_IMPACT[:breaking_changes]
    end

    # Deprecations
    if changelog_lower.match?(/deprecat/)
      score += RELEASE_IMPACT[:deprecations]
      breakdown[:deprecations] = RELEASE_IMPACT[:deprecations]
    end

    # Runtime compatibility shift
    if changelog_lower.match?(/ruby \d+\.\d+|dropp?ing? ruby|support for ruby|minimum.*ruby|requires? ruby/)
      score += RELEASE_IMPACT[:runtime_compatibility_shift]
      breakdown[:runtime_shift] = RELEASE_IMPACT[:runtime_compatibility_shift]
    end

    # Maintenance-only penalty
    if maintenance_only?(changelog)
      score += RELEASE_IMPACT[:maintenance_only_penalty]
      breakdown[:maintenance_penalty] = RELEASE_IMPACT[:maintenance_only_penalty]
    end

    # --- Project Reach ---
    reach_score, reach_breakdown = score_project_reach(project)
    score += reach_score
    breakdown.merge!(reach_breakdown)

    { total: score, breakdown: breakdown, semver_type: semver_type }
  end

  def classify_semver(tag)
    # Strip 'v' prefix
    version = tag.sub(/^v/, '')
    parts = version.split('.').map(&:to_i)
    return :prerelease if version.match?(/alpha|beta|rc|pre/)

    major, minor, patch = parts[0] || 0, parts[1] || 0, parts[2] || 0

    if minor == 0 && patch == 0
      :major
    elsif patch == 0
      :minor
    else
      :patch
    end
  end

  def user_facing_bug_fix?(fixed_section)
    # Check for user-facing signals
    user_facing_keywords = %w[
      regression crash error exception flag option parameter
      environment variable nil compat prevent restore
      cli command argument parsing
    ]

    fixed_section.downcase.match?(Regexp.union(user_facing_keywords.map { |k| Regexp.escape(k) }))
  end

  def maintenance_only?(changelog)
    changelog_lower = changelog.downcase
    # Only maintenance if it has docs/ci/internal but no features/fixes
    has_maintenance = changelog_lower.match?(/ci|workflow|typo|doc|readme|lint|rubocop|test.*internal|spec.*internal|refactor.*internal/)
    has_functional = changelog_lower.match?(/added|fixed|changed|deprecated|removed|security/)

    has_maintenance && !has_functional
  end

  def score_project_reach(project)
    score = 0
    breakdown = {}

    daily = project['daily_downloads'] || 0
    total = project['total_downloads'] || 0
    stars = project['github_stars'] || 0

    # Daily downloads
    PROJECT_REACH[:daily_downloads].each do |level, data|
      if daily >= data[:threshold]
        score += data[:points]
        breakdown[:daily_downloads] = data[:points]
        break
      end
    end

    # Total downloads
    PROJECT_REACH[:total_downloads].each do |level, data|
      if total >= data[:threshold]
        score += data[:points]
        breakdown[:total_downloads] = data[:points]
        break
      end
    end

    # Stars
    PROJECT_REACH[:stars].each do |level, data|
      if stars >= data[:threshold]
        score += data[:points]
        breakdown[:stars] = data[:points]
        break
      end
    end

    [score, breakdown]
  end

  def determine_tier_from_score(score)
    case score
    when TIER_THRESHOLDS[:maximum]..Float::INFINITY then :maximum
    when TIER_THRESHOLDS[:high]...TIER_THRESHOLDS[:maximum] then :high
    when TIER_THRESHOLDS[:medium]...TIER_THRESHOLDS[:high] then :medium
    when TIER_THRESHOLDS[:low]...TIER_THRESHOLDS[:medium] then :low
    else :none
    end
  end

  def generate_release_post(project, tag, published_at, changelog, score_data)
    name = project['name']
    collection_name = name.gsub('-', '_')
    date_str = published_at.split('T')[0]

    releases_dir = File.expand_path("../src/_#{collection_name}/releases", __dir__)
    FileUtils.mkdir_p(releases_dir)

    filename = "#{date_str}-#{name}-#{tag}.md"
    filepath = File.join(releases_dir, filename)

    # Don't overwrite if exists
    if File.exist?(filepath) && !@dry_run
      puts "    Post already exists: #{filepath}"
      return filepath
    end

    # Build the post content from kettle-changelog without altering its Markdown.
    title = "#{name} #{tag} released!"
    content = <<~MARKDOWN
    ---
    layout: post
    title: "#{title}"
    date: "#{published_at}"
    tags: ["release", "#{name}", "#{tag}"]
    ---

    #{changelog}
    MARKDOWN

    unless @dry_run
      File.write(filepath, content)
      puts "    ✓ Created release post: #{filepath}"
    else
      puts "    [DRY RUN] Would create: #{filepath}"
    end

    filepath
  end

  def build_tag_url(project, tag)
    github_url = extract_github_url(project)
    return "#" unless github_url

    repo = github_url.sub(%r{^https?://github\.com/}, '').sub(/\.git$/, '')
    "https://github.com/#{repo}/releases/tag/#{tag}"
  end

  # ============================================================================
  # SYNDICATION METHODS
  # ============================================================================

  def syndicate(destination, project, tag, published_at, changelog, score_data, post_path)
    name = project['name']
    send("syndicate_to_#{destination}", project, tag, published_at, changelog, score_data, post_path)
  rescue => e
    warn "    ✗ Syndication to #{destination} failed: #{e.message}"
    { success: false, error: e.message }
  end

  def syndicate_to_blog(project, tag, published_at, changelog, score_data, post_path)
    # Blog post is already generated - just verify it exists
    { success: true, url: "https://peterboling.com/#{post_path.sub(/.*src\//, '').sub(/\.md$/, '')}" }
  end

  def syndicate_to_devto(project, tag, published_at, changelog, score_data, post_path)
    api_key = ENV['DEVTO_API_KEY']
    return { success: false, error: 'DEVTO_API_KEY not set' } unless api_key

    name = project['name']
    title = "#{name} #{tag} released!"
    
    # Build article body from post content
    body = build_devto_body(project, tag, published_at, changelog, post_path)

    uri = URI('https://dev.to/api/articles')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'
    req['api-key'] = api_key

    payload = {
      article: {
        title: title,
        body_markdown: body,
        published: true,
        tags: ['ruby', 'opensource', name],
        canonical_url: "https://peterboling.com/#{post_path.sub(/.*src\//, '').sub(/\.md$/, '')}"
      }
    }

    req.body = payload.to_json
    res = http.request(req)

    if res.code.start_with?('2')
      data = JSON.parse(res.body)
      { success: true, url: data['url'], id: data['id'] }
    else
      { success: false, error: "HTTP #{res.code}: #{res.body}" }
    end
  end

  def syndicate_to_opencollective(project, tag, published_at, changelog, score_data, post_path)
    api_key = ENV['OPENCOLLECTIVE_API_KEY']
    return { success: false, error: 'OPENCOLLECTIVE_API_KEY not set' } unless api_key

    # Get collective slug from project funding
    funding_sites = project['funding_sites'] || []
    oc_site = funding_sites.find { |f| f['type'] == 'OpenCollective' }
    return { success: false, error: 'No OpenCollective for this project' } unless oc_site

    collective_slug = oc_site['url'].sub(%r{^https?://opencollective\.com/}, '')

    name = project['name']
    title = "#{name} #{tag} released!"
    html = build_opencollective_html(project, tag, published_at, changelog, post_path)

    uri = URI('https://api.opencollective.com/graphql/v2')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{api_key}"

    mutation = <<~GRAPHQL
    mutation CreateUpdate($update: UpdateInput!) {
      createUpdate(update: $update) {
        id
        slug
        url
      }
    }
    GRAPHQL

    payload = {
      query: mutation,
      variables: {
        update: {
          account: { slug: collective_slug },
          title: title,
          html: html,
          isPublished: true
        }
      }
    }

    req.body = payload.to_json
    res = http.request(req)

    if res.code == '200'
      data = JSON.parse(res.body)
      if data['errors']
        { success: false, error: data['errors'].map { |e| e['message'] }.join(', ') }
      else
        { success: true, url: data.dig('data', 'createUpdate', 'url') }
      end
    else
      { success: false, error: "HTTP #{res.code}: #{res.body}" }
    end
  end

  def syndicate_to_rubyforum(project, tag, published_at, changelog, score_data, post_path)
    api_key = ENV['RUBYFORUM_API_KEY']
    api_user = ENV['RUBYFORUM_API_USERNAME']
    return { success: false, error: 'RubyForum credentials not set' } unless api_key && api_user

    name = project['name']
    title = "#{name} #{tag} released!"
    body = build_rubyforum_body(project, tag, published_at, changelog, post_path)

    # Find appropriate category/tags
    category = find_rubyforum_category(project)
    tags = find_rubyforum_tags(project)

    uri = URI('https://www.rubyforum.org/posts.json')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'
    req['Api-Key'] = api_key
    req['Api-Username'] = api_user

    payload = {
      title: title,
      raw: body,
      category: category,
      tags: tags
    }

    req.body = payload.to_json
    res = http.request(req)

    if res.code.start_with?('2')
      data = JSON.parse(res.body)
      { success: true, url: "https://www.rubyforum.org/t/#{data['topic_slug']}/#{data['id']}" }
    else
      { success: false, error: "HTTP #{res.code}: #{res.body}" }
    end
  end

  def syndicate_to_dailydev(project, tag, published_at, changelog, score_data, post_path)
    # daily.dev squad sharing - typically via webhook or RSS
    webhook_url = ENV['DAILYDEV_WEBHOOK_URL']
    return { success: false, error: 'DAILYDEV_WEBHOOK_URL not set' } unless webhook_url

    # daily.dev accepts RSS/Atom or direct submission
    # For now, we'll use a simple webhook approach
    uri = URI(webhook_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'

    payload = {
      title: "#{project['name']} #{tag} released!",
      url: "https://peterboling.com/#{post_path.sub(/.*src\//, '').sub(/\.md$/, '')}",
      tags: ['ruby', 'opensource', project['name']]
    }

    req.body = payload.to_json
    res = http.request(req)

    if res.code.start_with?('2')
      { success: true, url: "https://app.daily.dev/squads/rubyfriends" }
    else
      { success: false, error: "HTTP #{res.code}: #{res.body}" }
    end
  end

  def syndicate_to_reddit(project, tag, published_at, changelog, score_data, post_path)
    client_id = ENV['REDDIT_CLIENT_ID']
    client_secret = ENV['REDDIT_CLIENT_SECRET']
    username = ENV['REDDIT_USERNAME']
    password = ENV['REDDIT_PASSWORD']
    return { success: false, error: 'Reddit credentials not set' } unless client_id && client_secret && username && password

    name = project['name']
    title = "[Release] #{name} #{tag}"
    
    # Build self-text post
    selftext = build_reddit_selftext(project, tag, published_at, changelog, post_path)

    # OAuth flow
    token = get_reddit_token(client_id, client_secret, username, password)
    return { success: false, error: 'Failed to get Reddit token' } unless token

    uri = URI('https://oauth.reddit.com/api/submit')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "Bearer #{token}"
    req['User-Agent'] = "peterboling.com release bot v1.0"
    req['Content-Type'] = 'application/x-www-form-urlencoded'

    payload = {
      sr: 'ruby',
      kind: 'self',
      title: title,
      text: selftext,
      api_type: 'json'
    }

    req.body = URI.encode_www_form(payload)
    res = http.request(req)

    if res.code == '200'
      data = JSON.parse(res.body)
      if data['json']['errors'].empty?
        post_id = data['json']['data']['id']
        { success: true, url: "https://reddit.com/r/ruby/comments/#{post_id}" }
      else
        { success: false, error: data['json']['errors'].join(', ') }
      end
    else
      { success: false, error: "HTTP #{res.code}: #{res.body}" }
    end
  end

  def get_reddit_token(client_id, client_secret, username, password)
    uri = URI('https://www.reddit.com/api/v1/access_token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri)
    req.basic_auth(client_id, client_secret)
    req['User-Agent'] = "peterboling.com release bot v1.0"
    req.set_form_data(
      grant_type: 'password',
      username: username,
      password: password
    )

    res = http.request(req)
    return nil unless res.code == '200'

    JSON.parse(res.body)['access_token']
  rescue => e
    warn "    Reddit auth failed: #{e.message}"
    nil
  end

  # ============================================================================
  # CONTENT BUILDERS FOR SYNDICATION
  # ============================================================================

  def build_devto_body(project, tag, published_at, changelog, post_path)
    name = project['name']
    post_url = "https://peterboling.com/#{post_path.sub(/.*src\//, '').sub(/\.md$/, '')}"

    changelog_sections = changelog

    <<~BODY
    #{changelog_sections}

    ---

    **Full release notes:** #{post_url}
    **GitHub Release:** #{build_tag_url(project, tag)}

    *Cross-posted from [peterboling.com](#{post_url})*
    BODY
  end

  def build_opencollective_html(project, tag, published_at, changelog, post_path)
    name = project['name']
    post_url = "https://peterboling.com/#{post_path.sub(/.*src\//, '').sub(/\.md$/, '')}"

    changelog_sections = changelog.gsub("\n", "<br>")

    <<~HTML
    <h2>#{name} #{tag} Released!</h2>
    <p><strong>Published:</strong> #{published_at}</p>
    <div>#{changelog_sections}</div>
    <hr>
    <p><a href="#{post_url}">Full release notes on peterboling.com</a></p>
    <p><a href="#{build_tag_url(project, tag)}">View on GitHub</a></p>
    HTML
  end

  def build_rubyforum_body(project, tag, published_at, changelog, post_path)
    name = project['name']
    post_url = "https://peterboling.com/#{post_path.sub(/.*src\//, '').sub(/\.md$/, '')}"

    changelog_sections = changelog

    <<~BODY
    #{changelog_sections}

    ---

    **Full release notes:** #{post_url}
    **GitHub Release:** #{build_tag_url(project, tag)}

    *Cross-posted from [peterboling.com](#{post_url})*
    BODY
  end

  def build_reddit_selftext(project, tag, published_at, changelog, post_path)
    name = project['name']
    post_url = "https://peterboling.com/#{post_path.sub(/.*src\//, '').sub(/\.md$/, '')}"

    changelog_sections = changelog

    <<~BODY
    #{changelog_sections}

    ---

    **Full release notes:** #{post_url}
    **GitHub Release:** #{build_tag_url(project, tag)}

    *Cross-posted from [peterboling.com](#{post_url})*
    BODY
  end

  def find_rubyforum_category(project)
    # Map project families to RubyForum categories
    family_id = project['family_id']
    case family_id
    when 'kettle-rb' then 17  # Ruby Libraries
    when /smorg/ then 17
    when 'rubocop-lts' then 17
    when 'oauth' then 17
    else 17  # Default to Ruby Libraries
    end
  end

  def find_rubyforum_tags(project)
    tags = ['release', project['name']]
    tags << project['family_id'] if project['family_id']
    tags << project['language'].downcase if project['language']
    tags.uniq
  end

  def print_summary(results)
    puts "\n=== Summary ==="
    if results.empty?
      puts "No new releases detected."
    else
      results.each do |r|
        puts "  #{r[:project]} #{r[:tag]} - Score: #{r[:score]} (#{r[:tier]})"
        r[:syndication].each do |dest, result|
          status = result[:success] ? '✓' : '✗'
          puts "    #{status} #{dest}: #{result[:url] || result[:error]}"
        end
      end
    end
  end
end

# ============================================================================
# CLI
# ============================================================================

def parse_options
  options = { dry_run: false, verbose: false }

  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"

    opts.on('-d', '--dry-run', 'Do not write files or make API calls') do
      options[:dry_run] = true
    end

    opts.on('-p', '--project PROJECT', 'Check only specific project') do |project|
      options[:project] = project
    end

    opts.on('-v', '--verbose', 'Verbose output') do
      options[:verbose] = true
    end

    opts.on('-h', '--help', 'Show this help') do
      puts opts
      exit
    end
  end.parse!

  options
end

# ============================================================================
# MAIN
# ============================================================================

if __FILE__ == $0
  options = parse_options

  checker = ReleaseChecker.new(options)
  results = checker.run

  exit(results.any? ? 0 : 0)
end