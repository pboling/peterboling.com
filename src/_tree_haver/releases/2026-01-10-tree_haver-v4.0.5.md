---
layout: post
title: "tree_haver v4.0.5 released!"
date: "2026-01-10T00:36:45Z"
tags: ["release", "tree_haver", "v4.0.5"]
---

## [4.0.5] - 2026-01-09

- TAG: [v4.0.5][4.0.5t]
- COVERAGE: 93.50% -- 2058/2201 lines in 28 files
- BRANCH COVERAGE: 81.11% -- 803/990 branches in 28 files
- 95.60% documented

### Added

- **FFI Backend**: Added `child_by_field_name` method to `TreeHaver::Backends::FFI::Node`
  - Enables field-based child access using tree-sitter's `ts_node_child_by_field_name` C API
  - Works with all grammars (JSON, JSONC, TOML, Bash, etc.) that define field names
  - Fixes compatibility issues with json-merge, jsonc-merge, and other gems that use field access
  - Example: `pair.child_by_field_name("key")` returns the key node from a JSON pair
- **RSpec Dependency Tags**: Added `compute_blocked_backends` method
  - Determines blocked backends from `TREE_HAVER_BACKEND` env and ARGV `--tag` options
  - Called by `summary` when `@blocked_backends` isn't set yet (before RSpec.configure runs)
  - Fixes issue where gem-specific `before(:suite)` hooks could load blocked backends
- **RSpec Dependency Tags**: Added `LD_LIBRARY_PATH` and `DYLD_LIBRARY_PATH` to `env_summary`
  - These library paths are relevant for tree-sitter shared library loading
  - Useful for debugging grammar loading issues
- **RSpec Dependency Tags**: Added `TREE_SITTER_RBS_PATH` to `env_summary`

### Changed

- **Language#method_missing**: Simplified error handling in `Language#method_missing`
  - Removed unreachable rescue block for `FFI::NotFoundError`
  - `FFI::NotFoundError` inherits from `LoadError`, so it's already caught by the prior rescue clause
  - Reduces code complexity without changing behavior
- **Parser#initialize**: Simplified error handling in `Parser#initialize`
  - Same fix as Language - removed unreachable `FFI::NotFoundError` handling
  - Added comment noting that `FFI::NotFoundError` inherits from `LoadError`
- **FFI Backend Native#try_load!**: Removed redundant `FFI::NotFoundError` from rescue clause
  - Only rescues `LoadError` now with comment explaining inheritance
- **GrammarFinder.tree_sitter_runtime_usable?**: Removed redundant `StandardError` rescue clause
  - `LoadError` already catches `FFI::NotFoundError`
  - Added comment explaining the inheritance relationship

### Fixed

- **Test Isolation**: Fixed state leakage in `language_registry_spec.rb`
  - Tests were registering real language names (`:toml`, `:json`, `:yaml`) with fake paths
  - These registrations persisted and polluted other tests that expected real grammar paths
  - Changed all tests to use unique test-only language names (prefixed with `test_lang_`)
  - Fixes 2 spec failures when running all tests together (`TreeHaver::Tree#edit` specs)

[4.0.5]: https://github.com/kettle-rb/tree_haver/compare/v4.0.4...v4.0.5
[4.0.5t]: https://github.com/kettle-rb/tree_haver/releases/tag/v4.0.5

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
