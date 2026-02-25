---
layout: post
title: "tree_haver v3.2.1 released!"
date: "2026-01-01T02:43:49Z"
tags: ["release", "tree_haver", "v3.2.1"]
---

## [3.2.1] - 2025-12-31

- TAG: [v3.2.1][3.2.1t]
- COVERAGE: 94.75% -- 2075/2190 lines in 22 files
- BRANCH COVERAGE: 81.35% -- 733/901 branches in 22 files
- 90.14% documented

### Added

- `TreeHaver::LibraryPathUtils` module for consistent path parsing across all backends
  - `derive_symbol_from_path(path)` - derives tree-sitter symbol (e.g., `tree_sitter_toml`) from library path
  - `derive_language_name_from_path(path)` - derives language name (e.g., `toml`) from library path
  - `derive_language_name_from_symbol(symbol)` - strips `tree_sitter_` prefix from symbol
  - Handles various naming conventions: `libtree-sitter-toml.so`, `libtree_sitter_toml.so`, `tree-sitter-toml.so`, `toml.so`
- Isolated backend RSpec tags for running tests without loading conflicting backends
  - `:ffi_backend_only` - runs FFI tests without triggering `mri_backend_available?` check
  - `:mri_backend_only` - runs MRI tests without triggering `ffi_available?` check
  - Uses `TreeHaver::Backends::BLOCKED_BY` to dynamically determine which availability checks to skip
  - Enables `rake ffi_specs` to run FFI tests before MRI is loaded
- `DependencyTags.ffi_backend_only_available?` - checks FFI availability without loading MRI
- `DependencyTags.mri_backend_only_available?` - checks MRI availability without checking FFI

### Changed

- All backends now use shared `LibraryPathUtils` for path parsing
  - MRI, Rust, FFI, and Java backends updated for consistency
  - Ensures identical behavior across all tree-sitter backends
- `TreeHaver::Language` class extracted to `lib/tree_haver/language.rb`
  - No API changes, just file organization
  - Loaded via autoload for lazy loading
- `TreeHaver::Parser` class extracted to `lib/tree_haver/parser.rb`
  - No API changes, just file organization
  - Loaded via autoload for lazy loading
- Backend availability exclusions in `dependency_tags.rb` are now dynamic
  - Uses `TreeHaver::Backends::BLOCKED_BY` to skip availability checks for blocked backends
  - When running with `--tag ffi_backend_only`, MRI availability is not checked
  - Prevents MRI from being loaded before FFI tests can run
- Rakefile `ffi_specs` task now uses `:ffi_backend_only` tag
  - Ensures FFI tests run without loading MRI backend first

### Fixed

- Rakefile now uses correct RSpec tags for FFI isolation
  - The `ffi_specs` task uses `:ffi_backend_only` to prevent MRI from loading
  - The `remaining_specs` task excludes `:ffi_backend_only` tests
  - Tags in Rakefile align with canonical tags from `dependency_tags.rb`
- `TreeHaver::RSpec::DependencyTags.mri_backend_available?` now uses correct require path
  - Was: `require "ruby_tree_sitter"` (wrong - causes LoadError)
  - Now: `require "tree_sitter"` (correct - gem name is ruby_tree_sitter but require path is tree_sitter)
  - This fix ensures the MRI backend is correctly detected as available in CI environments
- `TreeHaver::Backends::MRI::Language.from_library` now properly derives symbol from path
  - Previously, calling `from_library(path)` without `symbol:` would fail because `language_name` was nil
  - Now delegates to private `from_path` after deriving symbol, ensuring proper language name derivation
  - `from_path` is now private (but still accessible via `send` for testing if needed)
  - Extracts language name from paths like `/usr/lib/libtree-sitter-toml.so` → `tree_sitter_toml`
  - Handles both dash and underscore separators in filenames
  - Handles simple language names like `toml.so` → `tree_sitter_toml`
- `TreeHaver::Backends::MRI::Parser#language=` now unwraps `TreeHaver::Backends::MRI::Language` wrappers
  - Accepts both raw `TreeSitter::Language` and wrapped `TreeHaver::Backends::MRI::Language`
- `TreeHaver::GrammarFinder.tree_sitter_runtime_usable?` no longer references `FFI::NotFoundError` directly
  - Prevents `NameError` when FFI gem is not loaded
- `TreeHaver::Parser#initialize` no longer references `FFI::NotFoundError` directly in rescue clause
  - Uses `defined?(::FFI::NotFoundError)` check to safely handle FFI errors when FFI is loaded
  - Prevents `NameError: uninitialized constant TreeHaver::Parser::FFI` when FFI gem is not available
  - Extracted error handling to `handle_parser_creation_failure` private method for clarity
- RSpec `dependency_tags.rb` now correctly detects `--tag` options during configuration
  - RSpec's `config.inclusion_filter.rules` is empty during configuration phase
  - Now parses `ARGV` directly to detect `--tag ffi_backend_only` and similar tags
  - Skips grammar availability checks (which load MRI) when running isolated backend tests
  - Skips full dependency summary in `before(:suite)` when backends are blocked
- `TreeHaver::Backends::FFI.reset!` now uses consistent pattern with other backends
  - Was using `@ffi_gem_available` with `defined?()` check, which returned truthy after `reset!` set it to nil
  - Now uses `@load_attempted` / `@loaded` pattern like MRI, Rust, Citrus, Prism, Psych, etc.
  - This fixes FFI tests failing after the first test when `reset!` was called in `after` blocks
- `TreeHaver::Language.method_missing` no longer references `FFI::NotFoundError` directly in rescue clause
  - Uses `defined?(::FFI::NotFoundError)` check to safely handle FFI errors when FFI is loaded
  - Prevents `NameError` when FFI gem is not available but tree-sitter backends are used
  - Extracted Citrus fallback logic to `handle_tree_sitter_load_failure` private method

[3.2.1]: https://github.com/kettle-rb/tree_haver/compare/v3.2.0...v3.2.1
[3.2.1t]: https://github.com/kettle-rb/tree_haver/releases/tag/v3.2.1

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
