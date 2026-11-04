# frozen_string_literal: true

module Builders
  # Builds synthetic collections for project roll-up families (e.g. StructuredMerge, RuboCop-LTS).
  # Aggregates resources from member project collections into a combined collection so
  # plugins like bridgetown-feed can automatically generate dedicated feeds for them.
  class RollupCollectionsBuilder < SiteBuilder
    ROLLUPS = {
      "structuredmerge" => { prefix: "smorg-", title: "StructuredMerge" },
      "rubocop_lts" => { prefix: "rubocop-lts", title: "RuboCop LTS" },
      # Family matched by exact family_id; members span non-Ruby ecosystems
      # TODO: once galtzo.com's families.yml adds `rollup: tree-sitter-language-pack`,
      # this can be derived from site.data.families instead of hardcoded here.
      "tree_sitter_language_pack" => { family_id: "tree-sitter-language-pack", title: "Tree-sitter Language Pack" }
    }.freeze

    def build
      hook :site, :post_read, priority: :low do
        populate_rollups
      end
    end

    private

    def populate_rollups
      projects = site.data.projects || []

      ROLLUPS.each do |rollup_label, info|
        collection = site.collections[rollup_label]
        next unless collection

        # Find member projects by family prefix or exact family_id
        member_names = projects.select do |p|
          if info[:family_id]
            p["family_id"] == info[:family_id]
          else
            p["ecosystem"] == "rubygems" && p["family_id"].to_s.start_with?(info[:prefix])
          end
        end.map { |p| p["name"].tr("-", "_") }

        # Gather resources from member collections
        member_resources = member_names.flat_map do |col_name|
          c = site.collections[col_name]
          c ? c.resources : []
        end.uniq.sort_by(&:date).reverse

        # Populate the rollup collection's resources
        collection.resources.replace(member_resources)
      end
    end
  end
end
