---
layout: post
title: "tree_haver v3.0.0 released!"
date: "2025-12-17T02:22:52Z"
tags: ["release", "tree_haver", "v3.0.0"]
---

## [3.0.0] - 2025-12-16

- TAG: [v3.0.0][3.0.0t]
- COVERAGE: 85.19% -- 909/1067 lines in 11 files
- BRANCH COVERAGE: 67.47% -- 338/501 branches in 11 files
- 92.93% documented

### Added

#### Backend Requirements

- **MRI Backend**: Requires `ruby_tree_sitter` v2.0+ (exceptions inherit from `Exception` not `StandardError`)
  - In ruby_tree_sitter v2.0, TreeSitter errors were changed to inherit from Exception for thread-safety
  - TreeHaver now properly handles: `ParserNotFoundError`, `LanguageLoadError`, `SymbolNotFoundError`, etc.

#### Thread-Safe Backend Selection (Hybrid Approach)

- **NEW: Block-based backend API** - `TreeHaver.with_backend(:ffi) { ... }` for thread-safe backend selection
  - Thread-local context with proper nesting support
  - Exception-safe (context restored even on errors)
  - Fully backward compatible with existing global backend setting
- **NEW: Explicit backend parameters**
  - `Parser.new(backend: :mri)` - specify backend when creating parser
  - `Language.from_library(path, backend: :ffi)` - specify backend when loading language
  - Backend parameters override thread context and global settings
- **NEW: Backend introspection** - `parser.backend` returns the current backend name (`:ffi`, `:mri`, etc.)
- **Backend precedence chain**: `explicit parameter > thread context > global setting > :auto`
- **Backend-aware caching** - Language cache now includes backend in cache key to prevent cross-backend pollution
- Added `TreeHaver.effective_backend` - returns the currently effective backend considering precedence
- Added `TreeHaver.current_backend_context` - returns thread-local backend context
- Added `TreeHaver.resolve_backend_module(explicit_backend)` - resolves backend module with precedence

#### Examples and Discovery

- Added 18 comprehensive examples demonstrating all backends and languages
  - JSON examples (5): auto, MRI, Rust, FFI, Java
  - JSONC examples (5): auto, MRI, Rust, FFI, Java
  - Bash examples (5): auto, MRI, Rust, FFI, Java
  - Citrus examples (3): TOML, Finitio, Dhall
  - All examples use bundler inline (self-contained, no Gemfile needed)
  - Added `examples/run_all.rb` - comprehensive test runner with colored output
  - Updated `examples/README.md` - complete guide to all examples
- Added `TreeHaver::CitrusGrammarFinder` for language-agnostic discovery and registration of Citrus-based grammar gems
  - Automatically discovers Citrus grammar gems by gem name and grammar constant path
  - Validates grammar modules respond to `.parse(source)` before registration
  - Provides helpful error messages when grammars are not found
- Added multi-backend language registry supporting multiple backends per language simultaneously
  - Restructured `LanguageRegistry` to use nested hash: `{ language: { backend_type: config } }`
  - Enables registering both tree-sitter and Citrus grammars for the same language without conflicts
  - Supports runtime backend switching, benchmarking, and fallback scenarios
- Added `LanguageRegistry.register(name, backend_type, **config)` with backend-specific configuration storage
- Added `LanguageRegistry.registered(name, backend_type = nil)` to query by specific backend or get all backends
- Added `TreeHaver::Backends::Citrus::Node#structural?` method to distinguish structural nodes from terminals
  - Uses Citrus grammar's `terminal?` method to dynamically determine node classification
  - Works with any Citrus grammar without language-specific knowledge

### Changed

- **BREAKING**: All errors now inherit from `TreeHaver::Error` which inherits from `Exception`
  - see: https://github.com/Faveod/ruby-tree-sitter/pull/83 for reasoning
- **BREAKING**: `LanguageRegistry.register` signature changed from `register(name, path:, symbol:)` to `register(name, backend_type, **config)`
  - This enables proper separation of tree-sitter and Citrus configurations
  - Users should update to use `TreeHaver.register_language` instead of calling `LanguageRegistry.register` directly
- Updated `TreeHaver.register_language` to support both tree-sitter and Citrus grammars in single call or separate calls
  - Can now register: `register_language(:toml, path: "...", symbol: "...", grammar_module: TomlRB::Document)`
  - **INTENTIONAL DESIGN**: Uses separate `if` statements (not `elsif`) to allow registering both backends simultaneously
  - Enables maximum flexibility: runtime backend switching, performance benchmarking, fallback scenarios
  - Multiple registrations for same language now merge instead of overwrite

### Improved

#### Code Quality and Documentation

- **Uniform backend API**: All backends now implement `reset!` method for consistent testing interface
  - Eliminates need for tests to manipulate private instance variables
  - Provides clean way to reset backend state between tests
- **Documented design decisions** with inline rationale
  - FFI Tree finalizer behavior and why Parser doesn't use finalizers
  - `resolve_backend_module` early-return pattern with comprehensive comments
  - `register_language` multi-backend registration capability extensively documented
- **Enhanced YARD documentation**
  - All Citrus examples now include `gem_name` parameter (matches actual usage patterns)
  - Added complete examples showing both single-backend and multi-backend registration
  - Documented backend precedence chain and thread-safety guarantees
- **Comprehensive test coverage** for thread-safe backend selection
  - Thread-local context tests
  - Parser backend parameter tests
  - Language backend parameter tests
  - Concurrent parsing tests with multiple backends
  - Backend-aware cache isolation tests
  - Nested block behavior tests (inner blocks override outer blocks)
  - Exception safety tests (context restored even on errors)
  - Explicit parameter precedence tests
- Updated `Language.method_missing` to automatically select appropriate grammar based on active backend
  - tree-sitter backends (MRI, Rust, FFI, Java) query `:tree_sitter` registry key
  - Citrus backend queries `:citrus` registry key
  - Provides clear error messages when requested backend has no registered grammar
- Improved `TreeHaver::Backends::Citrus::Node#type` to use dynamic Citrus grammar introspection
  - Uses event `.name` method and Symbol events for accurate type extraction
  - Works with any Citrus grammar without language-specific code
  - Handles compound rules (Repeat, Choice, Optional) intelligently

### Fixed

#### Thread-Safety and Backend Selection

- Fixed `resolve_backend_module` to properly handle mocked backends without `available?` method
  - Assumes modules without `available?` are available (for test compatibility and backward compatibility)
  - Only rejects if module explicitly has `available?` method and returns false
  - Makes code more defensive and test-friendly
- Fixed Language cache to include backend in cache key
  - Prevents returning wrong backend's Language object when switching backends
  - Essential for correctness with multiple backends in use
  - Cache key now: `"#{path}:#{symbol}:#{backend}"` instead of just `"#{path}:#{symbol}"`
- Fixed `TreeHaver.register_language` to properly support multi-backend registration
  - Documented intentional design: uses `if` not `elsif` to allow both backends in one call
  - Added comprehensive inline comments explaining why no early return
  - Added extensive YARD documentation with examples

#### Backend Bug Fixes

- Fixed critical double-wrapping bug in ALL backends (MRI, Rust, FFI, Java, Citrus)
  - Backend `Parser#parse` and `parse_string` methods now return raw backend trees
  - TreeHaver::Parser wraps the raw tree in TreeHaver::Tree (single wrapping)
  - Previously backends were returning TreeHaver::Tree, then TreeHaver::Parser wrapped it again (double wrapping)
  - This caused `@inner_tree` to be a TreeHaver::Tree instead of raw backend tree, leading to nil errors
- Fixed TreeHaver::Parser to pass source parameter when wrapping backend trees
  - Enables `Node#text` to work correctly by providing source for text extraction
  - Fixes all parse and parse_string methods to include `source: source` parameter
- Fixed MRI backend to properly use ruby_tree_sitter API
  - Fixed `require "tree_sitter"` (gem name is `ruby_tree_sitter` but requires `tree_sitter`)
  - Fixed `Language.load` to use correct argument order: `(symbol_name, path)`
  - Fixed `Parser#parse` to use `parse_string(nil, source)` instead of creating Input objects
  - Fixed `Language.from_library` to implement the expected signature matching other backends
- Fixed FFI backend missing essential node methods
  - Added `ts_node_start_byte`, `ts_node_end_byte`, `ts_node_start_point`, `ts_node_end_point`
  - Added `ts_node_is_null`, `ts_node_is_named`
  - These methods are required for accessing node byte positions and metadata
  - Fixes `NoMethodError` when using FFI backend to traverse AST nodes
- Fixed GrammarFinder error messages for environment variable validation
  - Detects leading/trailing whitespace in paths and provides correction suggestions
  - Shows when TREE_SITTER_*_PATH is set but points to nonexistent file
  - Provides helpful guidance for setting environment variables correctly
- Fixed registry conflicts when registering multiple backend types for the same language
- Fixed `CitrusGrammarFinder` to properly handle gems with non-standard require paths (e.g., `toml-rb.rb` vs `toml/rb.rb`)
- Fixed Citrus backend infinite recursion in `Node#extract_type_from_event`
  - Added cycle detection to prevent stack overflow when traversing recursive grammar structures

### Known Issues

- **MRI backend + Bash grammar**: ABI/symbol loading incompatibility
  - The ruby_tree_sitter gem cannot load tree-sitter-bash grammar (symbol not found)
  - Workaround: Use FFI backend instead (works perfectly)
  - This is documented in examples and test runner
- **Rust backend + Bash grammar**: Version mismatch due to static linking
  - tree_stump statically links tree-sitter at compile time
  - System bash.so may be compiled with different tree-sitter version
  - Workaround: Use FFI backend (dynamic linking avoids version conflicts)
  - This is documented in examples with detailed explanations

### Notes on Backward Compatibility

Despite the major version bump to 3.0.0 (following semver due to the breaking `LanguageRegistry.register` signature change), **most users will experience NO BREAKING CHANGES**:

#### Why 3.0.0?

- `LanguageRegistry.register` signature changed to support multi-backend registration
- However, most users should use `TreeHaver.register_language` (which remains backward compatible)
- Direct calls to `LanguageRegistry.register` are rare in practice

#### What Stays the Same?

- **Global backend setting**: `TreeHaver.backend = :ffi` works unchanged
- **Parser creation**: `Parser.new` without parameters works as before
- **Language loading**: `Language.from_library(path)` works as before
- **Auto-detection**: Backend auto-selection still works when backend is `:auto`
- **All existing code** continues to work without modifications

#### What's New (All Optional)?

- Thread-safe block API: `TreeHaver.with_backend(:ffi) { ... }`
- Explicit backend parameters: `Parser.new(backend: :mri)`
- Backend introspection: `parser.backend`
- Multi-backend language registration

**Migration Path**: Existing codebases can upgrade to 3.0.0 and gain access to new thread-safe features without changing any existing code. The new features are purely additive and opt-in.

[3.0.0]: https://github.com/kettle-rb/tree_haver/compare/v2.0.0...v3.0.0
[3.0.0t]: https://github.com/kettle-rb/tree_haver/releases/tag/v3.0.0

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
