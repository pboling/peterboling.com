# frozen_string_literal: true

module Builders
  # Excludes non-tech collections (pages, blog, data) from the bridgetown-paginate
  # "all" collection aggregation by setting `exclude_from_pagination: true` on
  # every resource in those collections.
  #
  # This lets src/posts.erb use `collection: all` and only get actual tech posts.
  class PaginationDefaultsBuilder < SiteBuilder
    EXCLUDED_COLLECTIONS = %w[pages blog data].freeze

    def build
      hook :resources, :post_read do |resource|
        if EXCLUDED_COLLECTIONS.include?(resource.collection.label)
          resource.data.exclude_from_pagination = true
        end
      end
    end
  end
end
