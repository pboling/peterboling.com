# frozen_string_literal: true

module Helpers
  # Which projects belong to which GitHub organization/account (the home page's org list and the /news/<org>/ pages).
  # Mine and maintained: not contributor, archived or up for adoption; the same selection as /projects.
  module OrgNewsHelpers
    module_function

    # { "galtzo-floss" => [project hashes...], ... } keyed by GitHub owner as written in the data
    def owner_projects(projects)
      out = Hash.new { |h, k| h[k] = [] }
      projects.each do |p|
        next if p["role"] == "contributor" || p["status"] == "archived" || p["adoptable"] || p["theme"] == "adopt-me"

        gh = Array(p["forges"]).find { |f| f["type"] == "GitHub" }
        next unless gh

        owner = gh["url"].to_s.sub(%r{\Ahttps://github\.com/}, "").split("/").first
        out[owner] << p if owner
      end
      out
    end

    def repo_count(entries)
      entries.map { |p| Array(p["forges"]).find { |f| f["type"] == "GitHub" }["url"].downcase }.uniq.size
    end

    def slug(owner) = owner.to_s.downcase
  end
end
