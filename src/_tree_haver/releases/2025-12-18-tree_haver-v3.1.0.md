---
layout: post
title: "tree_haver v3.1.0 released!"
date: "2025-12-18T20:22:51Z"
tags: ["release", "tree_haver", "v3.1.0"]
---

## [3.1.0] - 2025-12-18

- TAG: [v3.1.0][3.1.0t]
- COVERAGE: 82.65% -- 943/1141 lines in 11 files
- BRANCH COVERAGE: 63.80% -- 349/547 branches in 11 files
- 88.97% documented

### Added

- **Position API Enhancements** – Added consistent position methods to all backend Node classes for compatibility with `*-merge` gems
  - `start_line` - Returns 1-based line number where node starts (converts 0-based `start_point.row` to 1-based)
  - `end_line` - Returns 1-based line number where node ends (converts 0-based `end_point.row` to 1-based)
  - `source_position` - Returns hash `{start_line:, end_line:, start_column:, end_column:}` with 1-based lines and 0-based columns
  - `first_child` - Convenience method that returns `children.first` for iteration compatibility
  - **Fixed:** `TreeHaver::Node#start_point` and `#end_point` now handle both Point objects and hashes from backends (Prism, Citrus return hashes)
  - **Fixed:** Added Psych, Commonmarker, and Markly backends to `resolve_backend_module` and `backend_module` case statements so they can be explicitly selected with `TreeHaver.backend = :psych` etc.
  - **Fixed:** Added Prism, Psych, Commonmarker, and Markly backends to `unwrap_language` method so language objects are properly passed to backend parsers
  - **Fixed:** Commonmarker backend's `text` method now safely handles container nodes that don't have string_content (wraps in rescue TypeError)
  - **Added to:**
    - Main `TreeHaver::Node` wrapper (used by tree-sitter backends: MRI, FFI, Java, Rust)
    - `Backends::Commonmarker::Node` - uses Commonmarker's `sourcepos` (already 1-based)
    - `Backends::Markly::Node` - uses Markly's `source_position` (already 1-based)
    - `Backends::Prism::Node` - uses Prism's `location` (already 1-based)
    - `Backends::Psych::Node` - calculates from `start_point`/`end_point` (0-based)
    - `Backends::Citrus::Node` - calculates from `start_point`/`end_point` (0-based)
  - **Backward Compatible:** Existing `start_point`/`end_point` methods continue to work unchanged
  - **Purpose:** Enables all `*-merge` gems to use consistent position API without backend-specific workarounds

- **Prism Backend** – New backend wrapping Ruby's official Prism parser (stdlib in Ruby 3.4+, gem for 3.2+)
  - `TreeHaver::Backends::Prism::Language` - Language wrapper (Ruby-only)
  - `TreeHaver::Backends::Prism::Parser` - Parser with `parse` and `parse_string` methods
  - `TreeHaver::Backends::Prism::Tree` - Tree wrapper with `root_node`, `errors`, `warnings`, `comments`
  - `TreeHaver::Backends::Prism::Node` - Node wrapper implementing full TreeHaver::Node protocol
  - Registered with `:prism` backend name, no conflicts with other backends

- **Psych Backend** – New backend wrapping Ruby's standard library YAML parser
  - `TreeHaver::Backends::Psych::Language` - Language wrapper (YAML-only)
  - `TreeHaver::Backends::Psych::Parser` - Parser with `parse` and `parse_string` methods
  - `TreeHaver::Backends::Psych::Tree` - Tree wrapper with `root_node`, `errors`
  - `TreeHaver::Backends::Psych::Node` - Node wrapper implementing TreeHaver::Node protocol
  - Psych-specific methods: `mapping?`, `sequence?`, `scalar?`, `alias?`, `mapping_entries`, `anchor`, `tag`, `value`
  - Registered with `:psych` backend name, no conflicts with other backends

- **Commonmarker Backend** – New backend wrapping the Commonmarker gem (comrak Rust parser)
  - `TreeHaver::Backends::Commonmarker::Language` - Language wrapper with parse options passthrough
  - `TreeHaver::Backends::Commonmarker::Parser` - Parser with `parse` and `parse_string` methods
  - `TreeHaver::Backends::Commonmarker::Tree` - Tree wrapper with `root_node`
  - `TreeHaver::Backends::Commonmarker::Node` - Node wrapper implementing TreeHaver::Node protocol
  - Commonmarker-specific methods: `header_level`, `fence_info`, `url`, `title`, `next_sibling`, `previous_sibling`, `parent`
  - Registered with `:commonmarker` backend name, no conflicts with other backends

- **Markly Backend** – New backend wrapping the Markly gem (cmark-gfm C library)
  - `TreeHaver::Backends::Markly::Language` - Language wrapper with flags and extensions passthrough
  - `TreeHaver::Backends::Markly::Parser` - Parser with `parse` and `parse_string` methods
  - `TreeHaver::Backends::Markly::Tree` - Tree wrapper with `root_node`
  - `TreeHaver::Backends::Markly::Node` - Node wrapper implementing TreeHaver::Node protocol
  - Type normalization: `:header` → `"heading"`, `:hrule` → `"thematic_break"`, `:html` → `"html_block"`
  - Markly-specific methods: `header_level`, `fence_info`, `url`, `title`, `next_sibling`, `previous_sibling`, `parent`, `raw_type`
  - Registered with `:markly` backend name, no conflicts with other backends

- **Automatic Citrus Fallback** – When tree-sitter fails, automatically fall back to Citrus backend
  - `TreeHaver::Language.method_missing` now catches tree-sitter loading errors (`NotAvailable`, `ArgumentError`, `LoadError`, `FFI::NotFoundError`) and falls back to registered Citrus grammar
  - `TreeHaver::Parser#initialize` now catches parser creation errors and falls back to Citrus parser when backend is `:auto`
  - `TreeHaver::Parser#language=` automatically switches to Citrus parser when a Citrus language is assigned
  - Enables seamless use of pure-Ruby parsers (like toml-rb) when tree-sitter runtime is unavailable

- **GrammarFinder Runtime Check** – `GrammarFinder#available?` now verifies tree-sitter runtime is actually usable
  - New `GrammarFinder.tree_sitter_runtime_usable?` class method tests if parser can be created
  - `TREE_SITTER_BACKENDS` constant defines which backends use tree-sitter (MRI, FFI, Rust, Java)
  - Prevents registration of grammars when tree-sitter runtime isn't functional
  - `GrammarFinder.reset_runtime_check!` for testing

- **Empty ENV Variable as Explicit Skip** – Setting `TREE_SITTER_<LANG>_PATH=''` explicitly disables that grammar
  - Previously, empty string was treated same as unset (would search paths)
  - Now, empty string means "do not use tree-sitter for this language"
  - Allows explicit opt-out to force fallback to alternative backends like Citrus
  - Useful for testing and environments where tree-sitter isn't desired

- **TOML Examples** – New example scripts demonstrating TOML parsing with various backends
  - `examples/auto_toml.rb` - Auto backend selection with Citrus fallback demonstration
  - `examples/ffi_toml.rb` - FFI backend with TOML
  - `examples/mri_toml.rb` - MRI backend with TOML
  - `examples/rust_toml.rb` - Rust backend with TOML
  - `examples/java_toml.rb` - Java backend with TOML (JRuby only)

### Fixed

- **BREAKING**: `TreeHaver::Language.method_missing` no longer raises `ArgumentError` when only Citrus grammar is registered and tree-sitter backend is active – it now falls back to Citrus instead
  - Previously: Would raise "No grammar registered for :lang compatible with tree_sitter backend"
  - Now: Returns `TreeHaver::Backends::Citrus::Language` if Citrus grammar is registered
  - Migration: If you were catching this error, update your code to handle the fallback behavior
  - This is a bug fix, but would be a breaking change for some users who were relying on the old behavior

[3.1.0]: https://github.com/kettle-rb/tree_haver/compare/v3.0.0...v3.1.0
[3.1.0t]: https://github.com/kettle-rb/tree_haver/releases/tag/v3.1.0

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
