---
layout: post
title: "tree_haver v5.0.0 released!"
date: "2026-01-11T10:30:16Z"
tags: ["release", "tree_haver", "v5.0.0"]
---

## [5.0.0] - 2026-01-11

- TAG: [v5.0.0][5.0.0t]
- COVERAGE: 92.04% -- 2289/2487 lines in 30 files
- BRANCH COVERAGE: 79.33% -- 929/1171 branches in 30 files
- 96.21% documented

### Added

- **Shared Example Groups for Backend API Compliance Testing**
  - `node_api_examples.rb` - Tests for Node API compliance:
    - `"node api compliance"` - Core Node interface (type, start_byte, end_byte, children)
    - `"node position api"` - Position API (start_point, end_point, start_line, end_line, source_position)
    - `"node children api"` - Children traversal (#child, #first_child, #last_child)
    - `"node enumerable behavior"` - Enumerable methods (#each, #map, #select, #find)
    - `"node comparison behavior"` - Comparison and equality (#==, #<=>, #hash)
    - `"node text extraction"` - Text content (#text, #to_s)
    - `"node inspection"` - Debug output (#inspect)
  - `tree_api_examples.rb` - Tests for Tree API compliance:
    - `"tree api compliance"` - Core Tree interface (root_node, source, errors, warnings, comments)
    - `"tree error handling"` - Error detection (#has_error?, #errors)
    - `"tree traversal"` - Depth-first traversal via root_node
  - `parser_api_examples.rb` - Tests for Parser API compliance:
    - `"parser api compliance"` - Core Parser interface (#parse, #parse_string, #language=)
    - `"parser incremental parsing"` - Incremental parsing support
    - `"parser error handling"` - Error recovery behavior
  - `language_api_examples.rb` - Tests for Language API compliance:
    - `"language api compliance"` - Core Language interface (#backend, #name/#language_name)
    - `"language comparison"` - Comparison and equality
    - `"language factory methods"` - Factory methods (.from_library, .from_path)
  - `backend_api_examples.rb` - Tests for Backend module API compliance:
    - `"backend module api"` - Backend availability and capabilities
    - `"backend class structure"` - Nested class verification
    - `"backend integration"` - Full parse cycle testing
  - `spec/support/shared_examples.rb` - Master loader for all shared examples
  - `spec/integration/backend_api_compliance_spec.rb` - Integration tests using all shared examples
- **Parslet Backend**: New pure Ruby PEG parser backend (`TreeHaver::Backends::Parslet`)
  - Wraps Parslet-based parsers (like the `toml` gem) to provide a pure Ruby alternative to tree-sitter
  - `Parslet.available?` - Check if parslet gem is available
  - `Parslet.capabilities` - Returns `{ backend: :parslet, query: false, bytes_field: true, incremental: false, pure_ruby: true }`
  - `Parslet::Language` - Wrapper for Parslet grammar classes
    - `Language.new(grammar_class)` - Create from a Parslet::Parser subclass
    - `Language.from_library(path, symbol:, name:)` - API-compatible lookup via LanguageRegistry
    - `#language_name` / `#name` - Derive language name from grammar class
  - `Parslet::Parser` - Wrapper that creates parser instances from grammar classes
    - Accepts both raw grammar class and Language wrapper (normalized API)
  - `Parslet::Tree` - Wraps Parslet parse results, inherits from `Base::Tree`
  - `Parslet::Node` - Unified node interface, inherits from `Base::Node`
    - Supports both Hash nodes (with named children) and Array nodes (with indexed children)
    - `#type` - Returns the node type (key name or "array"/"document")
    - `#children` - Returns child nodes
    - `#child_by_field_name(name)` - Access named children in Hash nodes
    - `#text` - Returns the matched text from Parslet::Slice
    - `#start_byte`, `#end_byte` - Byte positions from Parslet::Slice
    - `#start_point`, `#end_point` - Line/column positions (computed from source)
  - Registered with `BackendRegistry.register_availability_checker(:parslet)`
- **RSpec Dependency Tags**: Added `parslet_available?` method
  - Checks if parslet gem is installed via `BackendRegistry.available?(:parslet)`
  - `:parslet_backend` tag for specs requiring Parslet
  - `:not_parslet_backend` negated tag for specs that should skip when Parslet is available
- **RSpec Dependency Tags**: Added `toml_gem_available?` method and updated `any_toml_backend_available?`
  - `:toml_gem` tag for specs requiring the `toml` gem to be available
  - `:not_toml_gem` negated tag for specs that should skip when the `toml` gem is not available
- **ParsletGrammarFinder**: Utility for discovering and registering Parslet grammar gems
  - `ParsletGrammarFinder.new(language:, gem_name:, grammar_const:, require_path:)` - Find Parslet grammars
  - `#available?` - Check if the Parslet grammar gem is installed and functional
  - `#grammar_class` - Get the resolved Parslet::Parser subclass
  - `#register!` - Register the grammar with TreeHaver
  - Auto-loads via `TreeHaver::PARSLET_DEFAULTS` for known languages (toml)
- **TreeHaver.register_language**: Extended with `grammar_class:` parameter for Parslet grammars
- **TreeHaver.parser_for**: Extended with `parslet_config:` parameter for explicit Parslet configuration
- `MRI::Language#language_name` / `#name` - Derive language name from symbol or path
- `FFI::Language#language_name` / `#name` - Derive language name from symbol or path
- **spec_helper.rb**: Added `require "toml"` to load the toml gem for Parslet backend tests

### Changed

- **BREAKING: `TreeHaver::Language` converted from class to module**
  - Previously `TreeHaver::Language` was a class that wrapped backend language objects
  - Now `TreeHaver::Language` is a module providing factory methods (`method_missing` for dynamic language loading)
  - Backend-specific language classes (e.g., `TreeHaver::Backends::MRI::Language`) are now the concrete implementations
  - Code that instantiated `TreeHaver::Language.new(...)` directly must be updated to use backend-specific classes or the factory methods
- **BREAKING: `TreeHaver::Tree` now inherits from `TreeHaver::Base::Tree`**
  - `TreeHaver::Tree` is now a proper subclass of `TreeHaver::Base::Tree`
  - Inherits `inner_tree`, `source`, `lines` attributes from base class
  - Base class provides default implementations; subclass documents divergence
- **BREAKING: `TreeHaver::Node` now inherits from `TreeHaver::Base::Node`**
  - `TreeHaver::Node` is now a proper subclass of `TreeHaver::Base::Node`
  - Inherits `inner_node`, `source`, `lines` attributes from base class
  - Base class documents the API contract; subclass documents divergence
- **BREAKING: `Citrus::Node` and `Citrus::Tree` now inherit from Base classes**
  - `Citrus::Node` now inherits from `TreeHaver::Base::Node`
  - `Citrus::Tree` now inherits from `TreeHaver::Base::Tree`
  - Removes duplicated methods, uses inherited implementations
  - Adds `#language_name` / `#name` methods for API compliance
- **BREAKING: `Parslet::Node` and `Parslet::Tree` now inherit from Base classes**
  - `Parslet::Node` now inherits from `TreeHaver::Base::Node`
  - `Parslet::Tree` now inherits from `TreeHaver::Base::Tree`
  - Removes duplicated methods, uses inherited implementations
- **Base::Node#child now returns nil for negative indices** (tree-sitter API compatibility)
- **Citrus::Parser#language= now accepts Language wrapper or raw grammar module**
  - Both patterns now work: `parser.language = TomlRB::Document` or `parser.language = Citrus::Language.new(TomlRB::Document)`
- **Parslet::Parser#language= now accepts Language wrapper or raw grammar class**
  - Both patterns now work: `parser.language = TOML::Parslet` or `parser.language = Parslet::Language.new(TOML::Parslet)`
- **TreeHaver::Parser#unwrap_language** now passes Language wrappers directly to Citrus/Parslet backends
  - Previously unwrapped to raw grammar; now backends handle their own Language wrappers
- **Language.method_missing**: Now recognizes `:parslet` backend type and creates `Parslet::Language` instances
- **Parser**: Updated to recognize Parslet languages and switch to Parslet parser automatically
  - `#backend` now returns `:parslet` for Parslet-based parsers
  - `#language=` detects `Parslet::Language` and switches implementation
  - `handle_parser_creation_failure` tries Parslet as fallback after Citrus
  - `unwrap_language` extracts `grammar_class` for Parslet languages

### Fixed

- **FFI Backend Compliance Tests**: Fixed tests to use `TreeHaver::Parser` wrapper instead of raw `FFI::Parser`
  - Raw FFI classes (`FFI::Tree`, `FFI::Node`) don't have full API (missing `#children`, `#text`, `#source`, etc.)
  - TreeHaver wrapper classes (`TreeHaver::Tree`, `TreeHaver::Node`) provide the complete unified API
  - Tests now properly test the wrapped API that users actually interact with
- **Parslet TOML Sources**: Fixed test sources to be valid for the `toml` gem's Parslet grammar
  - Grammar requires table sections (not bare key-value pairs at root)
  - Grammar requires trailing newlines
- **Examples**: Fixed broken markdown examples that referenced non-existent TreeHaver backends
  - `commonmarker_markdown.rb` - Rewrote to use commonmarker gem directly (not a TreeHaver backend)
  - `markly_markdown.rb` - Rewrote to use markly gem directly with correct `source_position` API
  - `commonmarker_merge_example.rb` - Fixed to use `commonmarker/merge` gem properly
  - `markly_merge_example.rb` - Fixed to use `markly/merge` gem properly
  - `parslet_toml.rb` - Rewrote to properly use TreeHaver's Parslet backend with language registration
- **Examples**: Fixed `run_all.rb` test runner
  - Added parslet example to the test list
  - Changed markdown examples to use `backend: "standalone"` (they're not TreeHaver backends)
  - Added MRI+TOML to known incompatibilities (parse returns nil)
  - Added proper skip reason messages for all known incompatibilities
- **Examples**: Updated `examples/README.md` documentation
  - Added Parslet backend section with usage examples
  - Renamed "Commonmarker Backend" and "Markly Backend" to "Commonmarker (Standalone)" and "Markly (Standalone)"
  - Clarified that commonmarker and markly are standalone parsers, not TreeHaver backends
- **Duplicate Constants**: Removed duplicate `CITRUS_DEFAULTS` and `PARSLET_DEFAULTS` definitions
  - Constants were defined twice in `tree_haver.rb` (lines 170 and 315)
  - This was causing "already initialized constant" warnings on every require

[5.0.0]: https://github.com/kettle-rb/tree_haver/compare/v4.0.5...v5.0.0
[5.0.0t]: https://github.com/kettle-rb/tree_haver/releases/tag/v5.0.0

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
