---
layout: post
title: "tree_haver v3.1.1 released!"
date: "2025-12-28T22:29:57Z"
tags: ["release", "tree_haver", "v3.1.1"]
---

## [3.1.1] - 2025-12-28

- TAG: [v3.1.1][3.1.1t]
- COVERAGE: 87.44% -- 2152/2461 lines in 22 files
- BRANCH COVERAGE: 66.67% -- 710/1065 branches in 22 files
- 90.02% documented

### Added

- **`TreeHaver::RSpec::DependencyTags`**: Shared RSpec dependency detection for the entire gem family
  - New `lib/tree_haver/rspec.rb` entry point - other gems can simply `require "tree_haver/rspec"`
  - Detects all TreeHaver backends: FFI, MRI, Rust, Java, Prism, Psych, Commonmarker, Markly, Citrus
  - Ruby engine detection: `jruby?`, `truffleruby?`, `mri?`
  - Language grammar detection: `tree_sitter_bash_available?`, `tree_sitter_toml_available?`, `tree_sitter_json_available?`, `tree_sitter_jsonc_available?`
  - Inner-merge dependency detection: `toml_merge_available?`, `json_merge_available?`, `prism_merge_available?`, `psych_merge_available?`
  - Composite checks: `any_toml_backend_available?`, `any_markdown_backend_available?`
  - Records MRI backend usage when checking availability (critical for FFI conflict detection)
  - Configures RSpec exclusion filters for all dependency tags automatically
  - Supports debug output via `TREE_HAVER_DEBUG=1` environment variable
  - Comprehensive documentation with usage examples

- **`TreeHaver.parser_for`**: New high-level factory method for creating configured parsers
  - Handles all language loading complexity in one call
  - Auto-discovers tree-sitter grammar via `GrammarFinder`
  - Falls back to Citrus grammar if tree-sitter unavailable
  - Accepts `library_path` for explicit grammar location
  - Accepts `citrus_config` for Citrus fallback configuration
  - Raises `NotAvailable` with helpful message if no backend works
  - Example: `parser = TreeHaver.parser_for(:toml)`
  - Raises `NotAvailable` if the specified path doesn't exist (Principle of Least Surprise)
  - Does not back to auto-discovery when an explicit path is provided
  - Re-raises with context-rich error message if loading from explicit path fails
  - Auto-discovery still works normally when no `library_path` is provided

### Changed

- **Backend sibling navigation**: Backends that don't support sibling/parent navigation now raise `NotImplementedError` instead of returning `nil`
  - This distinguishes "not implemented" from "no sibling exists"
  - Affected backends: Prism, Psych
  - Affected methods: `next_sibling`, `prev_sibling`, `parent`

- **Canonical sibling method name**: All backends now use `prev_sibling` as the canonical method name (not `previous_sibling`)
  - Matches the universal `TreeHaver::Node` API

### Fixed

- **Backend conflict detection**: Fixed bug where MRI backend usage wasn't being recorded during availability checks
  - `mri_backend_available?` now calls `TreeHaver.record_backend_usage(:mri)` after successfully loading ruby_tree_sitter
  - This ensures FFI conflict detection works correctly even when MRI is loaded indirectly

- **GrammarFinder#not_found_message**: Improved error message when grammar file exists but no tree-sitter runtime is available
  - Now suggests adding `ruby_tree_sitter`, `ffi`, or `tree_stump` gem to Gemfile
  - Clearer guidance for users who have grammar files but are missing the Ruby tree-sitter bindings

[3.1.1]: https://github.com/kettle-rb/tree_haver/compare/v3.1.0...v3.1.1
[3.1.1t]: https://github.com/kettle-rb/tree_haver/releases/tag/v3.1.1

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
