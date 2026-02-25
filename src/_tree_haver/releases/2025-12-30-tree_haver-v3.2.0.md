---
layout: post
title: "tree_haver v3.2.0 released!"
date: "2025-12-30T13:00:42Z"
tags: ["release", "tree_haver", "v3.2.0"]
---

## [3.2.0] - 2025-12-30

- TAG: [v3.2.0][3.2.0t]
- COVERAGE: 86.82% -- 2167/2496 lines in 22 files
- BRANCH COVERAGE: 66.79% -- 734/1099 branches in 22 files
- 90.03% documented

### Added

- `TreeHaver::CITRUS_DEFAULTS` constant with default Citrus configurations for known languages
  - Enables automatic Citrus fallback for TOML without explicit `citrus_config` parameter
  - Currently includes configuration for `:toml` (gem: `toml-rb`, const: `TomlRB::Document`)
- Regression test suite for Citrus fallback (`spec/integration/citrus_fallback_spec.rb`)
  - Tests `parser_for` with all tree-sitter backends stubbed as unavailable (simulating TruffleRuby)
  - Tests `CitrusGrammarFinder` with nil `gem_name` and `require_path`
  - Tests explicit Citrus backend usage on MRI via `with_backend(:citrus)`
- Shared examples for TOML parsing tests (`spec/support/shared_examples/toml_parsing_examples.rb`)
  - `"toml parsing basics"` - tests basic parsing, positions, children, text extraction
  - `"toml node navigation"` - tests first_child, named_children navigation
- Multi-backend TOML test suite (`spec/integration/multi_backend_toml_spec.rb`)
  - Runs shared examples against both tree-sitter-toml and Citrus/toml-rb backends
  - Tests backend equivalence for parsing results and positions
  - Tagged appropriately so tests run on whichever backends are available
- Backend Platform Compatibility section to README
  - Complete compatibility matrix showing which backends work on MRI, JRuby, TruffleRuby
  - Detailed explanations for TruffleRuby and JRuby limitations
- `FFI.available?` method at module level for API consistency with other backends
- `TreeHaver.resolve_native_backend_module` method for resolving only tree-sitter backends
- `TreeHaver::NATIVE_BACKENDS` constant listing backends that support shared libraries
- TruffleRuby short-circuit in `resolve_native_backend_module` for efficiency
  - Avoids trying 3 backends that are all known to fail on TruffleRuby
- `citrus_available?` method to check if Citrus backend is available

### Fixed

- **`TreeHaver::Node#child` now returns `nil` for out-of-bounds indices on all backends**
  - MRI backend (ruby_tree_sitter) raises `IndexError` for invalid indices
  - Other backends return `nil` for invalid indices
  - Now consistently returns `nil` across all backends for API compatibility
- **Citrus backend `calculate_point` returns negative column values**
  - When `offset` was 0, `@source.rindex("\n", -1)` searched from end of string
  - This caused `column = 0 - (position_of_last_newline) - 1` to be negative (e.g., -34)
  - Fix: Early return `{row: 0, column: 0}` for `offset <= 0`
  - This bug affected both MRI and TruffleRuby when using Citrus backend
- **Citrus fallback fails on TruffleRuby when no explicit `citrus_config` provided**
  - `parser_for(:toml)` would fail with `TypeError: no implicit conversion of nil into String`
  - Root cause: `citrus_config` defaulted to `{}`, so `citrus_config[:gem_name]` was `nil`
  - `CitrusGrammarFinder` was instantiated with `gem_name: nil`, causing `require nil`
  - On TruffleRuby, this triggered a bug in `bundled_gems.rb` calling `File.path` on nil
  - Fix: Added `CITRUS_DEFAULTS` with known Citrus configurations (TOML currently)
  - Fix: `parser_for` now uses `CITRUS_DEFAULTS[name]` when no explicit config provided
  - Fix: Added guard in `CitrusGrammarFinder#available?` to return false when `require_path` is nil
  - Fix: Added `TypeError` to rescue clause for TruffleRuby-specific edge cases
- **`from_library` no longer falls back to pure-Ruby backends**
  - Previously, calling `Language.from_library(path)` on TruffleRuby would fall back to Citrus
    backend which then raised a confusing error about not supporting shared libraries
  - Now `from_library` only considers native tree-sitter backends (MRI, Rust, FFI, Java)
  - Clear error message when no native backend is available explaining the situation
- **Integration specs now use `parser_for` instead of explicit paths**
  - `tree_edge_cases_spec.rb` and `node_edge_cases_spec.rb` now use `TreeHaver.parser_for(:toml)`
    which auto-discovers the best available backend (tree-sitter or Citrus fallback)
  - Tests now work correctly on all platforms (MRI, JRuby, TruffleRuby)
  - Tagged with `:toml_parsing` which passes if ANY toml parser is available
- **Core specs now use `parser_for` instead of explicit paths**
  - `tree_spec.rb`, `node_spec.rb`, `parser_spec.rb` converted to use `TreeHaver.parser_for(:toml)`
  - All `:toml_grammar` tags changed to `:toml_parsing` for cross-platform compatibility
  - Tests now run on JRuby and TruffleRuby via Citrus/toml-rb fallback
- FFI backend now properly reports as unavailable on TruffleRuby
  - `ffi_gem_available?` returns `false` on TruffleRuby since tree-sitter uses STRUCT_BY_VALUE return types
  - `FFI.available?` added at module level (was only in Native submodule)
  - Prevents confusing runtime errors (Polyglot::ForeignException) by detecting incompatibility upfront
  - Dependency tags now check `truffleruby?` before attempting FFI backend tests
- MRI backend now properly reports as unavailable on JRuby and TruffleRuby
  - `available?` returns `false` on non-MRI platforms (C extension only works on MRI)
- Rust backend now properly reports as unavailable on JRuby and TruffleRuby
  - `available?` returns `false` on non-MRI platforms (magnus requires MRI's C API)
- Backend compatibility matrix spec now properly skips tests for platform-incompatible backends
  - MRI and Rust backends skip on JRuby/TruffleRuby with clear skip messages
  - FFI backend skips on TruffleRuby with clear skip message

### Changed

- **BREAKING: RSpec Dependency Tag Naming Convention Overhaul**
  - All dependency tags now follow consistent naming conventions with suffixes
  - Backend tags now use `*_backend` suffix (e.g., `:commonmarker_backend`, `:markly_backend`)
  - Engine tags now use `*_engine` suffix (e.g., `:mri_engine`, `:jruby_engine`, `:truffleruby_engine`)
  - Grammar tags now use `*_grammar` suffix (e.g., `:bash_grammar`, `:toml_grammar`, `:json_grammar`)
  - Parsing capability tags now use `*_parsing` suffix (e.g., `:toml_parsing`, `:markdown_parsing`)
  - **Migration required**: Update specs using legacy tags:
    - `:commonmarker` → `:commonmarker_backend`
    - `:markly` → `:markly_backend`
    - `:mri` → `:mri_engine`
    - `:jruby` → `:jruby_engine`
    - `:truffleruby` → `:truffleruby_engine`
    - `:tree_sitter_bash` → `:bash_grammar`
    - `:tree_sitter_toml` → `:toml_grammar`
    - `:tree_sitter_json` → `:json_grammar`
    - `:tree_sitter_jsonc` → `:jsonc_grammar`
    - `:toml_backend` → `:toml_parsing`
    - `:markdown_backend` → `:markdown_parsing`
- **Removed inner-merge dependency tags from tree_haver**
  - Tags `:toml_merge`, `:json_merge`, `:prism_merge`, `:psych_merge` removed
  - These belong in ast-merge gem, not tree_haver
  - Use `require "ast/merge/rspec/dependency_tags"` for merge gem tags
- **API Consistency**: All backends now have uniform `available?` API at module level:
  - `TreeHaver::Backends::FFI.available?` - checks ffi gem + not TruffleRuby + MRI not loaded
  - `TreeHaver::Backends::MRI.available?` - checks MRI platform + ruby_tree_sitter gem
  - `TreeHaver::Backends::Rust.available?` - checks MRI platform + tree_stump gem
  - `TreeHaver::Backends::Java.available?` - checks JRuby platform + jtreesitter JAR
  - `TreeHaver::Backends::Prism.available?` - checks prism gem (all platforms)
  - `TreeHaver::Backends::Psych.available?` - checks psych stdlib (all platforms)
  - `TreeHaver::Backends::Commonmarker.available?` - checks commonmarker gem (all platforms)
  - `TreeHaver::Backends::Markly.available?` - checks markly gem (all platforms)
  - `TreeHaver::Backends::Citrus.available?` - checks citrus gem (all platforms)
- README now accurately documents TruffleRuby backend support
  - FFI backend doesn't work on TruffleRuby due to `STRUCT_BY_VALUE` limitation in TruffleRuby's FFI
  - Rust backend (tree_stump) doesn't work due to magnus/rb-sys incompatibility with TruffleRuby's C API
  - TruffleRuby users should use Prism, Psych, Commonmarker, Markly, or Citrus backends
- Documented confirmed tree-sitter backend limitations:
  - **TruffleRuby**: No tree-sitter backend works (FFI, MRI, Rust all fail)
  - **JRuby**: Only Java and FFI backends work; Rust/MRI don't
- Updated Rust Backend section with platform compatibility notes
- Updated FFI Backend section with TruffleRuby limitation details
- Use kettle-rb/ts-grammar-setup GHA in CI workflows

### Fixed

- Rakefile now properly overrides `test` task after `require "kettle/dev"`
  - Works around a bug in kettle-dev where test task runs minitest loader in CI
  - Ensures `rake test` runs RSpec specs instead of empty minitest suite
- `TreeHaver::RSpec::DependencyTags` now catches TruffleRuby FFI exceptions
  - TruffleRuby's FFI raises `Polyglot::ForeignException` for unsupported types like `STRUCT_BY_VALUE`
  - `ffi_available?` and `libtree_sitter_available?` now return `false` instead of crashing
  - Fixes spec loading errors on TruffleRuby
- `TreeHaver::Backends::FFI::Language.from_library` now catches `RuntimeError` from TruffleRuby
  - TruffleRuby raises `RuntimeError` instead of `LoadError` when a shared library cannot be opened
  - Now properly converts to `TreeHaver::NotAvailable` with descriptive message
- `TreeHaver::Backends::FFI::Native.try_load!` now only sets `@loaded = true` after all `attach_function` calls succeed
  - Previously, `loaded?` returned `true` even when `attach_function` failed (e.g., on TruffleRuby)
  - Now `loaded?` correctly returns `false` when FFI functions couldn't be attached
  - Ensures FFI tests are properly skipped on TruffleRuby

[3.2.0]: https://github.com/kettle-rb/tree_haver/compare/v3.1.2...v3.2.0
[3.2.0t]: https://github.com/kettle-rb/tree_haver/releases/tag/v3.2.0

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
