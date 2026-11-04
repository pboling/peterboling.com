# frozen_string_literal: true

module Builders
  # Builds synthetic collections for project roll-up families (e.g. StructuredMerge, RuboCop-LTS).
  # Aggregates resources from member project collections into a combined collection so
  # plugins like bridgetown-feed can automatically generate dedicated feeds for them.
  #
  # Rollups are derived from galtzo.com's families.yml: every family flagged with
  # `rollup: <slug>` (families may share a slug) contributes its member projects'
  # posts to the `<slug underscored>` collection. No posts on this site yet for a
  # member is fine — its contributions join automatically once synced in.
  class RollupCollectionsBuilder < SiteBuilder
    def build
      hook :site, :post_read, priority: :low do
        populate_rollups
      end
    end

    private

    # { "structuredmerge" => ["smorg-rb", ...], "tree-sitter-language-pack" => ["tree-sitter-language-pack"], ... }
    def rollup_family_ids
      @rollup_family_ids ||= (site.data.families || []).select { |f| f["rollup"] }
        .group_by { |f| f["rollup"] }
        .transform_values { |fs| fs.map { |f| f["id"] } }
    end

    def populate_rollups
      projects = site.data.projects || []
      family_ids_by_project = {}

      projects.each do |p|
        label = p["name"].to_s.tr("-", "_")
        family_ids_by_project[label] = p["family_id"]
      end

      rollup_family_ids.each do |slug, family_ids|
        collection = site.collections[slug.tr("-", "_")]
        next unless collection

        member_resources = family_ids_by_project
          .select { |_, fid| family_ids.include?(fid) }
          .keys
          .flat_map { |col_name| site.collections[col_name]&.resources || [] }
          .uniq
          .sort_by(&:date)
          .reverse

        collection.resources.replace(member_resources)
      end
    end
  end
end
