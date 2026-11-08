# frozen_string_literal: true

require_relative "../helpers/org_news_helpers"
require_relative "../helpers/tag_badge_helpers"

module Builders
  # Helpers for the project cards (src/projects.erb, src/_partials/_pcard.erb).
  class CardHelpersBuilder < SiteBuilder
    include Helpers::TagBadgeHelpers
    def build
      helper :human_count do |n|
        n = n.to_i
        if n >= 1_000_000_000 then format("%.1fB", n / 1e9)
        elsif n >= 1_000_000 then format("%.1fM", n / 1e6)
        elsif n >= 10_000 then format("%dK", n / 1000)
        elsif n >= 1000 then format("%.1fK", n / 1000.0)
        else n.to_s
        end
      end

      # Projects per GitHub organization/account for the home page: the live project data, one project per
      # repository (see Helpers::OrgNewsHelpers for the selection), with each organization's post count and latest post.
      helper :org_project_counts do
        counted = Helpers::OrgNewsHelpers.owner_projects(site.data.projects).map do |owner, entries|
          { owner: owner, slug: Helpers::OrgNewsHelpers.slug(owner), count: Helpers::OrgNewsHelpers.repo_count(entries) }
        end
        multi, single = counted.partition { |o| o[:count] > 1 }
        { multi: multi.sort_by { |o| o[:owner].downcase }, single_projects: single.sum { |o| o[:count] } }
      end

      # Every post from an organization's projects, newest first, as [project name, post] pairs (a post that
      # also sits in a roll-up collection is listed once).
      helper :org_news_posts do |owner|
        entries = Helpers::OrgNewsHelpers.owner_projects(site.data.projects)[owner] || []
        seen = {}
        entries.map { |p| p["name"] }.uniq.flat_map do |name|
          coll = site.collections[name.tr("-", "_")]
          (coll ? coll.resources.to_a : []).filter_map do |post|
            next if seen[post.relative_url]

            seen[post.relative_url] = true
            [name, post]
          end
        end.sort_by { |_, post| post.date }.reverse
      end

      # Post count and latest post date behind a card: the project's own collection, or for a rolled-up family
      # the combined roll-up collection (one blog for the whole family). Intro and release posts all count.
      helper :card_posts do |card|
        coll = site.collections[card["name"].to_s.tr("-", "_")]
        posts = coll ? coll.resources.to_a : []
        { count: posts.size, latest: posts.map(&:date).compact.max }
      end

      # Resolve the same synced card artwork for a post's project, including projects
      # represented by a family rollup on the projects page.
      helper :post_project_icons do |context|
        key = context.to_s.downcase.tr("-", "_")
        cards = site.data.cards.cards
        card = cards.find { |c| c["name"].to_s.downcase.tr("-", "_") == key }
        rollup = card || cards.find { |c| c["rollup"] && Array(c["members"]).any? { |m| m.downcase.tr("-", "_") == key } }
        project = site.data.projects.find { |p| p["name"].to_s.downcase.tr("-", "_") == key }
        logo = rollup && rollup["logo"]
        extension = %w[png jpg].find { |ext| logo && File.exist?(File.join(site.source, "cards/logos/#{logo}.#{ext}")) }
        badge = tag_badge_info(context)
        languages = card ? Array(card["languages"]) : [project && project["language"]]
        known = Helpers::TagBadgeHelpers::KNOWN_LANGUAGES
        languages = languages.filter_map { |lang| known.find { |l| l.casecmp?(lang.to_s) } }.uniq.first(4)
        { logo: extension ? "/cards/logos/#{logo}.#{extension}" : badge[:logo_url],
          emoji: extension ? nil : badge[:emoji], languages: languages }
      end

      # Where a card leads: the project's own blog page when this site has one (rolled-up families have a
      # single family blog), otherwise the project's repository.
      helper :card_target do |card|
        slug = card["name"]
        if File.exist?(File.join(site.source, "#{slug}.erb")) || File.exist?(File.join(site.source, "#{slug}.md"))
          ["/#{slug}/", false]
        else
          [card["url"] || card["docs"] || "#", true]
        end
      end
    end
  end
end
