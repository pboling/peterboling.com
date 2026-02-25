---
layout: post
title: "psych-merge v1.0.0 released!"
date: "2026-02-19T13:02:53Z"
tags: ["release", "psych-merge", "v1.0.0"]
---

## [1.0.0] - 2026-02-19

- TAG: [v1.0.0][1.0.0t]
- COVERAGE: 91.92% -- 921/1002 lines in 14 files
- BRANCH COVERAGE: 73.00% -- 311/426 branches in 14 files
- 97.39% documented

### Added

- AGENTS.md
- `Psych::Merge::DiffMapper` - Maps unified git diffs to YAML AST key paths
  - Inherits from `Ast::Merge::DiffMapperBase`
  - `#map_hunk_to_paths` - Maps diff hunks to YAML key paths (e.g., `["AllCops", "Exclude"]`)
  - `#create_analysis` - Creates `FileAnalysis` for YAML content
  - Tracks nested paths via indentation and MappingEntry location data
  - Groups consecutive changed lines by their containing YAML node
- `Psych::Merge::PartialTemplateMerger` - Merges partial YAML templates into specific key paths
  - Navigate to specific key paths (e.g., `["AllCops", "Exclude"]`) in destination
  - Merge template content at that location while preserving rest of document
  - `key_path:` - Array of keys/indices to navigate to target location
  - `add_missing:` - Whether to add template items not in destination (default: `true`)
  - `remove_missing:` - Whether to remove destination items not in template (default: `false`)
  - `when_missing:` - Behavior when key path not found (`:skip` or `:add`, default: `:skip`)
  - `recursive:` - Whether to recursively merge nested structures (default: `true`)
  - Returns `Result` object with `content`, `has_key_path`, `changed`, `stats`, `message`
- `Psych::Merge::SmartMerger` - New options for advanced merge control:
  - `recursive: true | false | Integer` - Control recursive merging of nested structures
    - `true` (default): Merge nested mappings/sequences recursively instead of replacing wholesale
    - `false`: Replace entire matched nodes (original behavior)
    - `Integer > 0`: Maximum recursion depth
  - `remove_template_missing_nodes: false` - When `true`, removes destination nodes not present in template
- `Psych::Merge::ConflictResolver` - Recursive merge implementation:
  - `#emit_recursive_merge` - Recursively merge matched nodes
  - `#emit_recursive_mapping_merge` - Merge nested mapping entries
  - `#emit_recursive_sequence_merge` - Merge sequences with union semantics
  - `#can_merge_recursively?` - Check if two nodes can be recursively merged
  - Handles both `MappingEntry` and raw `NodeWrapper` nodes
- `node_typing` parameter for per-node-type merge preferences
  - Enables `preference: { default: :destination, special_type: :template }` pattern
  - Works with custom merge_types assigned via node_typing lambdas
- `regions` and `region_placeholder` parameters for nested content merging
- Initial release

### Changed

- appraisal2 v3.0.6
- kettle-test v1.0.10
- stone_checksums v1.0.3
- [ast-merge v4.0.6](https://github.com/kettle-rb/ast-merge/releases/tag/v4.0.6)
- [tree_haver v5.0.5](https://github.com/kettle-rb/tree_haver/releases/tag/v5.0.5)
- tree_stump v0.2.0
  - fork no longer required, updates all applied upstream
- Updated documentation on hostile takeover of RubyGems
  - https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo
- **SmartMerger**: Added `**options` for forward compatibility
  - Accepts additional options that may be added to base class in future
  - Passes all options through to `SmartMergerBase`
- **ConflictResolver**: Added `**options` for forward compatibility
  - Now passes `match_refiner` to base class instead of storing locally
- **MergeResult**: Added `**options` for forward compatibility
- Updated documentation on hostile takeover of RubyGems
  - https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo

### Fixed

- ConflictResolver now applies Hash-based per-node-type preferences via `node_typing`.

### Security

[Unreleased]: https://github.com/kettle-rb/psych-merge/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/kettle-rb/psych-merge/compare/3330d3309d6962a4e676aa1c43e4ca90dfd21dc4...v1.0.0
[1.0.0t]: https://github.com/kettle-rb/psych-merge/tags/v1.0.0

[1.0.0]: https://github.com/kettle-rb/psych-merge/compare/3330d3309d6962a4e676aa1c43e4ca90dfd21dc4...v1.0.0
[1.0.0t]: https://github.com/kettle-rb/psych-merge/tags/v1.0.0

Official Discord 👉️ [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite]

Many paths lead to being a sponsor or a backer of this project. Are you on such a path?

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal]

[![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS efforts using Patreon][🖇patreon-img]][🖇patreon]

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-backers]: https://opencollective.com/kettle-rb#backer
[🖇osc-backers-i]: https://opencollective.com/kettle-rb/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/kettle-rb#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/kettle-rb/sponsors/badge.svg?style=flat
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/O5O86SNP4
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-a51611.svg?style=flat
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-%E2%9C%93-a51611.svg?style=flat
[🖇buyme]: https://www.buymeacoffee.com/pboling
[🖇paypal-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=flat&logo=paypal
[🖇paypal]: https://www.paypal.com/paypalme/peterboling
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img]: https://img.shields.io/discord/1373797679469170758?style=flat
