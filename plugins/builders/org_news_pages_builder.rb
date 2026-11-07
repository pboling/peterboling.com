# frozen_string_literal: true

require_relative "../helpers/org_news_helpers"

module Builders
  # One news page per GitHub organization listed on the home page: /news/<org>/ gathers the posts of every
  # project the organization owns (the post index behind the organization's project count).
  class OrgNewsPagesBuilder < SiteBuilder
    def build
      generator do
        Helpers::OrgNewsHelpers.owner_projects(site.data.projects).each do |owner, entries|
          next unless Helpers::OrgNewsHelpers.repo_count(entries) > 1

          add_resource :pages, "news/#{Helpers::OrgNewsHelpers.slug(owner)}.erb" do
            layout :page
            title "#{owner} news"
            org owner
            content "<%= render \"org_news\", owner: data.org %>"
          end
        end
      end
    end
  end
end
