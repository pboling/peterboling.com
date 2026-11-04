# frozen_string_literal: true

module Builders
  # Helpers for the project cards (src/projects.erb, src/_partials/_pcard.erb).
  class CardHelpersBuilder < SiteBuilder
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
