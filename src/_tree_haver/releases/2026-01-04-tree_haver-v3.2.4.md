---
layout: post
title: "tree_haver v3.2.4 released!"
date: "2026-01-04T13:28:16Z"
tags: ["release", "tree_haver", "v3.2.4"]
---

## [3.2.4] - 2026-01-04

- TAG: [v3.2.4][3.2.4t]
- COVERAGE: 92.07% -- 2229/2421 lines in 23 files
- BRANCH COVERAGE: 74.79% -- 786/1051 branches in 23 files
- 90.37% documented

### Added

- **External backend registration via `backend_module`** - External gems can now register
  their own pure Ruby backends using the same API as built-in backends. This enables gems
  like rbs-merge to integrate with `TreeHaver.parser_for` without modifying tree_haver:
```ruby
TreeHaver.register_language(
  :rbs,
  backend_module: Rbs::Merge::Backends::RbsBackend,
  backend_type: :rbs,
  gem_name: "rbs",
)
# Now TreeHaver.parser_for(:rbs) works!
```
- **`Backends::PURE_RUBY_BACKENDS` constant** - Maps pure Ruby backend names to their
  language and module info. Used for auto-registration of built-in backends.
- **`TreeHaver.register_builtin_backends!`** - Registers built-in pure Ruby backends
  (Prism, Psych, Commonmarker, Markly) in the LanguageRegistry using the same API that
  external backends use. Called automatically by `parser_for` on first use.
- **`TreeHaver.ensure_builtin_backends_registered!`** - Idempotent helper that ensures
  built-in backends are registered exactly once.
- **`parser_for` now supports registered `backend_module` backends** - When a language
  has a registered `backend_module`, `parser_for` will use it. This enables external
  gems to provide language support without tree-sitter grammars:
  - Checks LanguageRegistry for registered `backend_module` entries
  - Creates parser from the backend module's `Parser` and `Language` classes
  - Falls back to tree-sitter and Citrus if no backend_module matches
- **RBS dependency tags in `DependencyTags`** - New RSpec tags for RBS parsing:
  - `:rbs_grammar` - tree-sitter-rbs grammar is available and parsing works
  - `:rbs_parsing` - at least one RBS parser (rbs gem OR tree-sitter-rbs) is available
  - `:rbs_gem` - the official rbs gem is available (MRI only)
  - Negated versions: `:not_rbs_grammar`, `:not_rbs_parsing`, `:not_rbs_gem`
  - New availability methods: `tree_sitter_rbs_available?`, `rbs_gem_available?`, `any_rbs_backend_available?`
- **Support for tree-sitter 0.26.x ABI** - TreeHaver now fully supports grammars built
  against tree-sitter 0.26.x (LANGUAGE_VERSION 15). This required updates to vendored
  dependencies:
  - **ruby-tree-sitter**: Updated to support tree-sitter 0.26.3 C library API changes
    including new `ts_language_abi_version()` function, UTF-16 encoding split, and
    removal of deprecated parser timeout/cancellation APIs
  - **tree_stump (Rust backend)**: Updated to tree-sitter Rust crate 0.26.3 with new
    `abi_version()` method, `u32` child indices, and streaming iterator-based query matches
- **MRI backend now loads grammars with LANGUAGE_VERSION 15** - Previously, MRI backend
  using ruby_tree_sitter could only load grammars with LANGUAGE_VERSION ≤ 14. Now supports
  grammars built against tree-sitter 0.26.x.
- **Rust backend now loads grammars with LANGUAGE_VERSION 15** - Previously, the tree_stump
  Rust backend reported "Incompatible language version 15. Expected minimum 13, maximum 14".
  Now supports the latest grammar format.
- **BackendAPI validation module** - New `TreeHaver::BackendAPI` module for validating
  backend API compliance:
  - `BackendAPI.validate(backend_module)` - Returns validation results hash
  - `BackendAPI.validate!(backend_module)` - Raises on validation failure
  - `BackendAPI.validate_node_instance(node)` - Validates a node instance
  - Defines required and optional methods for Language, Parser, Tree, and Node classes
  - Documents API contract for wrapper vs raw backends
  - New `examples/validate_backends.rb` script to validate all backends
- **Java backend Node class now implements full API** - Added missing methods to ensure
  API consistency with other backends:
  - `parent` - Get parent node
  - `next_sibling` - Get next sibling node
  - `prev_sibling` - Get previous sibling node
  - `named?` - Check if node is named
  - `child_by_field_name` - Get child by field name
  - All methods properly handle jtreesitter 0.26.0's `Optional<Node>` return types
- **Three environment variables for backend control** - Fine-grained control over which
  backends are available:
  - `TREE_HAVER_BACKEND` - Single backend selection (auto, mri, ffi, rust, java, citrus, etc.)
  - `TREE_HAVER_NATIVE_BACKEND` - Allow list for native backends (auto, none, or comma-separated
    list like `mri,ffi`). Use `none` for pure-Ruby-only mode.
  - `TREE_HAVER_RUBY_BACKEND` - Allow list for pure Ruby backends (auto, none, or comma-separated
    list like `citrus,prism`). Use `none` for native-only mode.
- **Backend availability now respects allow lists** - When `TREE_HAVER_NATIVE_BACKEND` is set
  to specific backends (e.g., `mri,ffi`), all other native backends are treated as unavailable.
  This applies to ALL backend selection mechanisms:
  - Auto-selection in `backend_module`
  - Explicit selection via `with_backend(:rust)` - returns nil/unavailable
  - Explicit selection via `resolve_backend_module(:rust)` - returns nil
  - RSpec dependency tags (`ffi_available?`, etc.)

  This makes the environment variables a **hard restriction**, not just a hint for auto-selection.
  Use `TREE_HAVER_NATIVE_BACKEND=none` for pure-Ruby-only mode, or specify exactly which
  native backends are permitted (e.g., `mri,ffi`).
- **Java backend updated for jtreesitter 0.26.0** - Full compatibility with jtreesitter 0.26.0:
  - Updated `Parser#parse` and `Parser#parse_string` to handle `Optional<Tree>` return type
  - Updated `Tree#root_node` to handle `Optional<Node>` return type
  - Fixed `parse_string` argument order to match jtreesitter 0.26.0 API: `parse(String, Tree)`
  - Updated `Language.load_by_name` to use `SymbolLookup` API (single-arg `load(name)` removed)
  - Added `bin/setup-jtreesitter` script to download jtreesitter JAR from Maven Central
  - Added `bin/build-grammar` script to build tree-sitter grammars from source
  - Older versions of jtreesitter are NOT supported
- **`TREE_HAVER_BACKEND_PROTECT` environment variable** - Explicit control over backend
  conflict protection. Set to `false` to disable protection that prevents mixing
  incompatible native backends (e.g., FFI after MRI). Useful for testing scenarios
  where you understand the risks. Default behavior (protection enabled) unchanged.

### Changed

- **API normalized: `from_library` is now universal** - All language-specific backends
  (Psych, Prism, Commonmarker, Markly) now implement `Language.from_library` for API
  consistency. This allows `TreeHaver.parser_for(:yaml)` to work uniformly regardless
  of which backend is active:
  - **Psych**: `from_library` accepts (and ignores) path/symbol, returns YAML language
  - **Prism**: `from_library` accepts (and ignores) path/symbol, returns Ruby language
  - **Commonmarker**: `from_library` accepts (and ignores) path/symbol, returns Markdown language
  - **Markly**: `from_library` accepts (and ignores) path/symbol, returns Markdown language
  - All raise `TreeHaver::NotAvailable` if a different language is requested
- **Citrus backend `from_library` now looks up registered grammars** - Instead of always
  raising an error, `Backends::Citrus::Language.from_library` now looks up registered
  Citrus grammars by name via `LanguageRegistry`. This enables `TreeHaver.parser_for(:toml)`
  to work seamlessly when a Citrus grammar has been registered with
  `TreeHaver.register_language(:toml, grammar_module: TomlRB::Document)`.
- **Java backend requires jtreesitter >= 0.26.0** - Due to API changes in jtreesitter,
  older versions are no longer supported. The tree-sitter runtime library must also be
  version 0.26.x to match.
  by the RSpec dependency tags. This ensures tests tagged with `:mri_backend` only run when
  MRI is in the allow list. Same for `TREE_HAVER_RUBY_BACKEND` and pure Ruby backends.
- New `TreeHaver.allowed_native_backends` method returns the allow list for native backends.
- New `TreeHaver.allowed_ruby_backends` method returns the allow list for pure Ruby backends.
- New `TreeHaver.backend_allowed?(backend)` method checks if a specific backend is allowed
  based on the current environment variable settings.
- New `DependencyTags.allowed_native_backends` and `DependencyTags.allowed_ruby_backends` methods.
- Updated `examples/test_backend_selection.rb` script to test all three environment variables.
- **`LanguageRegistry` now supports any backend type** - Previously only `:tree_sitter` and
  `:citrus` were documented. Now supports arbitrary backend types including `:prism`, `:psych`,
  `:commonmarker`, `:markly`, `:rbs`, or any custom type. External gems can register their
  own backend types using the same API.
- **`register_language` accepts `backend_module` parameter** - New parameter for registering
  pure Ruby backends. The module must provide `Language` and `Parser` classes with the
  standard TreeHaver API (`available?`, `capabilities`, `from_library`, etc.).

### Fixed

- **`TreeHaver::Node#text` now handles backends with different `text` method signatures** -
  Previously, `Node#text` would call `@inner_node.text` directly, but `TreeStump::Node#text`
  (Rust backend) requires the source as an argument (`text(source)`). This caused
  `ArgumentError: wrong number of arguments (given 0, expected 1)` when using the Rust
  backend. Now `Node#text` checks the method arity and passes the source when required:
  - Arity 0 or -1: calls `@inner_node.text` without arguments
  - Arity >= 1: calls `@inner_node.text(@source)` with source
  - Falls back to byte-based extraction if source is available

- **AUTO mode now gracefully falls back when explicitly requested backend is blocked** -
  Previously, if `TREE_HAVER_BACKEND=ffi` was set in the environment but FFI was blocked
  due to MRI being used first (backend conflict protection), `parser_for` would raise a
  `BackendConflict` error. Now, when the explicitly requested backend is blocked by a
  **backend conflict** (e.g., FFI after MRI causes segfaults):
  - `backend_module` detects the conflict and falls back to auto-selection
  - `resolve_native_backend_module` rescues `BackendConflict` and continues to the next
    backend in the priority list
  - This enables seamless multi-backend usage in test suites where different tests use
    different backends, but one backend has already "poisoned" the process for another.

  Note: This fallback only applies to **backend conflicts** (runtime incompatibility).
  If a backend is disallowed by `TREE_HAVER_NATIVE_BACKEND` or `TREE_HAVER_RUBY_BACKEND`,
  it will simply be unavailable—no error is raised, but no fallback occurs either.

- **`java_backend_available?` now verifies grammar loading works** - Previously, the
  `DependencyTags.java_backend_available?` method only checked if java-tree-sitter
  classes could be loaded, but didn't verify that grammars could actually be used.
  This caused tests tagged with `:java_backend` to run on JRuby even when the grammar
  `.so` files (built for MRI) were incompatible with java-tree-sitter's Foreign Function
  Memory API. Now the check does a live test by attempting to load a grammar, ensuring
  the tag accurately reflects whether the Java backend is fully functional.

[3.2.4]: https://github.com/kettle-rb/tree_haver/compare/v3.2.3...v3.2.4
[3.2.4t]: https://github.com/kettle-rb/tree_haver/releases/tag/v3.2.4

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
