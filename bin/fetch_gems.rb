# frozen_string_literal: true
require 'net/http'
require 'json'
require 'yaml'

# Load current projects.yml
data_path = File.expand_path('../src/_data/projects.yml', __dir__)
data = YAML.load_file(data_path)
projects = data['projects']
forge_colors = data['forge_colors']

# Fetch gems from RubyGems API
uri = URI('https://rubygems.org/api/v1/owners/pboling/gems.json')
res = Net::HTTP.get_response(uri)
raise "Failed to fetch gems: #{res.code}" unless res.is_a?(Net::HTTPSuccess)
gems = JSON.parse(res.body)

# Create api_projects hash
api_projects = {}
gems.each do |gem|
  name = gem['name']
  description = gem['info']
  source_code_uri = gem['source_code_uri']
  forges = []
  if source_code_uri
    if source_code_uri.include?('github.com')
      url = source_code_uri.sub(%r{/tree/.*}, '')
      forges << { 'type' => 'github', 'url' => url }
    elsif source_code_uri.include?('gitlab.com')
      url = source_code_uri.sub(%r{/tree/.*}, '')
      forges << { 'type' => 'gitlab', 'url' => url }
    elsif source_code_uri.include?('codeberg.org')
      url = source_code_uri.sub(%r{/src/.*}, '')
      forges << { 'type' => 'codeberg', 'url' => url }
    elsif source_code_uri.include?('bitbucket.org')
      url = source_code_uri.sub(%r{/src/.*}, '')
      forges << { 'type' => 'bitbucket', 'url' => url }
    end
  end
  tags = []
  # Infer tags from name
  tags << 'oauth' if name.include?('oauth')
  tags << 'email' if name.include?('email')
  tags << 'rspec' if name.include?('rspec')
  tags << 'testing' if name.include?('test') || name.include?('spec')
  tags << 'coverage' if name.include?('cover')
  tags << 'rails' if name.include?('rails') || name.include?('activerecord')
  tags << 'ruby'
  tags.uniq!
  api_projects[name] = {
    'name' => name,
    'description' => description,
    'forges' => forges,
    'tags' => tags
  }
end

# Merge with manual changes taking precedence
overridden = {}
updated_projects = projects.dup
api_projects.each do |name, api_proj|
  existing_index = updated_projects.find_index { |p| p['name'] == name }
  if existing_index.nil?
    updated_projects << api_proj
  else
    existing = updated_projects[existing_index]
    if existing == api_proj
      # No change
    else
      overridden[name] = api_proj
      # Keep the manual version in projects.yml
    end
  end
end

# Write updated projects.yml
updated_data = { 'projects' => updated_projects, 'forge_colors' => forge_colors }
File.write(data_path, updated_data.to_yaml)

# Write overridden if any
if overridden.any?
  overridden_path = File.expand_path('../src/_data/project_gems_overridden.yml', __dir__)
  File.write(overridden_path, overridden.to_yaml)
  puts "Overridden data written to src/_data/project_gems_overridden.yml"
end

puts "Projects updated in src/_data/projects.yml"
