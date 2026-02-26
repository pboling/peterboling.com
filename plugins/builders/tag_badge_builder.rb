# frozen_string_literal: true

require_relative "../helpers/tag_badge_helpers"

module Builders
  class TagBadgeBuilder < SiteBuilder
    include Helpers::TagBadgeHelpers

    def build
      helper :tag_badge_info
      helper :project_full_tags
    end
  end
end
