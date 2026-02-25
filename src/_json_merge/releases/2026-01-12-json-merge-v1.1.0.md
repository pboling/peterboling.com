---
layout: post
title: "json-merge v1.1.0 released!"
date: "2026-01-12T13:56:55Z"
tags: ["release", "json-merge", "v1.1.0"]
---

## [1.1.0] - 2026-01-12

- TAG: [v1.1.0][1.1.0t]
- COVERAGE: 95.77% -- 589/615 lines in 10 files
- BRANCH COVERAGE: 78.82% -- 227/288 branches in 10 files
- 96.63% documented

### Added

- bin/rspec-ffi to run FFI isolated specs
  - Also bin/rake ffi_specs
- FFI backend isolation for test suite
  - Added `bin/rspec-ffi` script to run FFI specs in isolation (before MRI backend loads)
  - Added `spec/spec_ffi_helper.rb` for FFI-specific test configuration
  - Updated Rakefile with `ffi_specs` and `remaining_specs` tasks
  - The `:test` task now runs FFI specs first, then remaining specs

### Changed

- ast-merge v4.0.2
  - Includes Ast::Merge::EmitterBase
- tree_haver v5.0.1
  - Many Backend improvements
  - Many error handling improvements
- **Simplified dependency_tags.rb**: Removed redundant debug code
  - Removed `JSON_MERGE_DEBUG` env var handling (use `TREE_HAVER_DEBUG` instead)
  - tree_haver's debug output now respects blocked backends via `compute_blocked_backends`
  - Avoids accidentally loading MRI backend during FFI-only test runs

### Removed

- **Obsolete Tests**: Removed 3 obsolete integration tests
  - Tests for `add_node_to_result` and `add_wrapper_to_result` methods
  - These methods don't exist in the `:batch` strategy (ConflictResolver now uses Emitter)
  - Tests were for old `:node` strategy pattern

### Fixed

- **NodeWrapper signature tests**: Updated tests to expect `:root_object`/`:root_array` for root-level containers
  - Root-level objects now correctly return `[:root_object, ...]` instead of `[:object, ...]`
  - Root-level arrays now correctly return `[:root_array]` instead of `[:array, count]`
  - Added `:parent` method stubs to mock node tests for `root_level_container?` compatibility
- **ConflictResolver#emit_node**: Fixed handling of pair nodes with object values
  - When emitting a pair like `"features": {...}`, the value was treated as raw text
  - Now correctly detects when a pair's value is an object container
  - Recursively emits object structure using `emit_nested_object_start/end`
  - Treats arrays as atomic values (emits as raw text)
  - Prevents double key emission and invalid JSON output in nested merges
- **ConflictResolver#merge_matched_nodes_to_emitter**: Fixed array handling in merge logic
  - Arrays are now treated atomically and replaced based on preference setting
  - Only objects (not arrays) are recursively merged
  - Fixes potential "expected object key, got number" errors when merging arrays
  - Arrays like `[1,2,3]` are now correctly replaced with `[4,5]` based on preference

[1.1.0]: https://github.com/kettle-rb/json-merge/compare/v1.0.0...v1.1.0
[1.1.0t]: https://github.com/kettle-rb/json-merge/releases/tag/v1.1.0

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
