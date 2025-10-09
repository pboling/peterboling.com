#!/usr/bin/env ruby
# frozen_string_literal: true
require 'net/http'
require 'json'
require 'yaml'

# List of projects and their forges
projects = YAML.load_file(File.expand_path('../src/_data/projects.yml', __dir__))['projects']

# Helper methods for each forge API
def github_stars(repo_url)
  repo = repo_url.split('github.com/').last
  uri = URI("https://api.github.com/repos/#{repo}")
  res = Net::HTTP.get_response(uri)
  return nil unless res.is_a?(Net::HTTPSuccess)
  json = JSON.parse(res.body)
  json['stargazers_count']
end

def gitlab_stars(repo_url)
  repo = repo_url.split('gitlab.com/').last
  uri = URI("https://gitlab.com/api/v4/projects/#{URI.encode_www_form_component(repo)}")
  res = Net::HTTP.get_response(uri)
  return nil unless res.is_a?(Net::HTTPSuccess)
  json = JSON.parse(res.body)
  json['star_count']
end

def codeberg_stars(repo_url)
  repo = repo_url.split('codeberg.org/').last
  uri = URI("https://codeberg.org/api/v1/repos/#{repo}")
  res = Net::HTTP.get_response(uri)
  return nil unless res.is_a?(Net::HTTPSuccess)
  json = JSON.parse(res.body)
  json['stars']
end

def bitbucket_stars(repo_url)
  repo = repo_url.split('bitbucket.org/').last
  uri = URI("https://api.bitbucket.org/2.0/repositories/#{repo}")
  res = Net::HTTP.get_response(uri)
  return nil unless res.is_a?(Net::HTTPSuccess)
  json = JSON.parse(res.body)
  json['stars'] || json['watchers']&.dig('count')
end

forge_api = {
  'github' => method(:github_stars),
  'gitlab' => method(:gitlab_stars),
  'codeberg' => method(:codeberg_stars),
  'bitbucket' => method(:bitbucket_stars)
}

star_data = {}
projects.each do |project|
  project_name = project['name']
  star_data[project_name] = {}
  project['forges'].each do |forge|
    type = forge['type']
    url = forge['url']
    begin
      stars = forge_api[type].call(url)
    rescue
      stars = nil
    end
    star_data[project_name][type] = stars
  end
end

File.write(File.expand_path('../src/_data/project_stars.yml', __dir__), star_data.to_yaml)
puts "Star data written to src/_data/project_stars.yml"

