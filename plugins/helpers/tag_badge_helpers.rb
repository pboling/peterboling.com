# frozen_string_literal: true

# Helper methods for resolving tag badge icons and generating
# the full set of derived tags for a project.
#
# Included into Bridgetown's helper pipeline via the builder
# in plugins/builders/tag_badge_builder.rb
module Helpers
  module TagBadgeHelpers
    # Known language SVGs that ship in src/images/languages/
    KNOWN_LANGUAGES = %w[Bash Go JavaScript Ruby Rust TypeScript].freeze

    # Resolve badge display info for a single tag string.
    #
    # Returns a Hash:
    #   { type:, label:, logo_url: (or nil), emoji: (or nil) }
    #
    # Logo hierarchy by tag type:
    #   org        → org logo from orgs.yml
    #   family     → family logo (future) > 👪 emoji
    #   project    → org logo > language SVG > 🏷️
    #   language   → language SVG > 🏷️
    #   generic    → 🏷️
    def tag_badge_info(tag)
      site_data = site.data
      tag_s = tag.to_s
      tag_down = tag_s.downcase

      # 1. Check if tag matches an org id
      org = site_data.orgs&.find { |o| o["id"].to_s.downcase == tag_down }
      if org
        return {
          type: "org",
          label: tag_s,
          logo_url: org["logo"],
          emoji: nil
        }
      end

      # 2. Check if tag matches a family id
      family = site_data.families&.find { |f| f["id"].to_s.downcase == tag_down }
      if family
        logo = family["logo"] if family["logo"] && !family["logo"].to_s.empty?
        return {
          type: "family",
          label: tag_s,
          logo_url: logo,
          emoji: logo ? nil : "👪"
        }
      end

      # 3. Check if tag matches a project name
      project = site_data.projects&.find { |p| p["name"].to_s.downcase == tag_down }
      if project
        # Try to resolve an org logo via the first forge owner
        owner = project.dig("forges", 0, "owner")
        proj_org = owner ? site_data.orgs&.find { |o| o["id"].to_s.downcase == owner.to_s.downcase } : nil
        if proj_org&.dig("logo")
          return {
            type: "project",
            label: tag_s,
            logo_url: proj_org["logo"],
            emoji: nil
          }
        end

        # Fall back to language SVG
        lang = project["language"].to_s
        lang_match = KNOWN_LANGUAGES.find { |l| l.downcase == lang.downcase }
        if lang_match
          return {
            type: "project",
            label: tag_s,
            logo_url: "/images/languages/#{lang_match}.svg",
            emoji: nil
          }
        end

        # Final project fallback
        return {
          type: "project",
          label: tag_s,
          logo_url: nil,
          emoji: "📦"
        }
      end

      # 4. Check if tag matches a known language
      lang_match = KNOWN_LANGUAGES.find { |l| l.downcase == tag_down }
      if lang_match
        return {
          type: "language",
          label: tag_s,
          logo_url: "/images/languages/#{lang_match}.svg",
          emoji: nil
        }
      end

      # 5. Generic fallback
      {
        type: "generic",
        label: tag_s,
        logo_url: nil,
        emoji: "🏷️"
      }
    end

    # Build the full, deduplicated tag list for a project.
    #
    # Derived from: project name, GH forge owner (org), family_id, and explicit tags.
    # Order: family_id, org (owner), project name, then explicit tags.
    def project_full_tags(project)
      tags = []

      # Family tag
      fid = project["family_id"].to_s
      tags << fid unless fid.empty?

      # Org tag (from first GitHub forge owner)
      gh_forge = project["forges"]&.find { |f| f["type"].to_s.downcase == "github" }
      owner = gh_forge&.dig("owner").to_s
      tags << owner unless owner.empty?

      # Project name tag
      pname = project["name"].to_s
      tags << pname unless pname.empty?

      # Explicit tags from the project data
      explicit = project["tags"]
      tags.concat(explicit) if explicit.is_a?(Array)

      # Deduplicate (case-insensitive) while preserving first occurrence order
      seen = {}
      tags.select do |t|
        key = t.to_s.downcase
        next false if seen[key]
        seen[key] = true
        true
      end
    end
  end
end
