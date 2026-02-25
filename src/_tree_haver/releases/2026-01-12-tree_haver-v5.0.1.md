---
layout: post
title: "tree_haver v5.0.1 released!"
date: "2026-01-12T04:54:14Z"
tags: ["release", "tree_haver", "v5.0.1"]
---

## [5.0.1] - 2026-01-11

- TAG: [v5.0.1][5.0.1t]
- COVERAGE: 90.79% -- 2308/2542 lines in 30 files
- BRANCH COVERAGE: 78.09% -- 930/1191 branches in 30 files
- 94.76% documented

### Added

- `TreeHaver::RSpec::TestableNode` - A testable node class for creating mock TreeHaver::Node instances
  in tests without requiring an actual parser backend. Available via `require "tree_haver/rspec/testable_node"`
  or automatically when using `require "tree_haver/rspec"`.
  - `TestableNode.create(type:, text:, ...)` - Create a single test node
  - `TestableNode.create_list(...)` - Create multiple test nodes
  - `MockInnerNode` - The underlying mock that simulates backend-specific nodes
  - Top-level `TestableNode` constant for convenience in specs
- **Fully Dynamic Tag Registration** in `TreeHaver::BackendRegistry`:
  - `register_tag(tag_name, category:, backend_name:, require_path:)` - Register a complete dependency tag
    with lazy loading support. External gems can now get full RSpec tag support without any hardcoded
    knowledge in tree_haver.
  - `tag_available?(tag_name)` - Check if a tag's dependency is available, with automatic lazy loading
    via the registered `require_path`
  - `registered_tags` - Get all registered tag names
  - `tags_by_category(category)` - Get tags filtered by category (:backend, :gem, :parsing, :grammar, :engine, :other)
  - `tag_metadata(tag_name)` - Get full metadata for a registered tag
  - `tag_summary` - Get availability status of all registered tags

### Changed

- **Fully Dynamic Backend Availability** in `BackendRegistry` and `DependencyTags`:
  - `register_tag` now dynamically defines `*_available?` methods on `DependencyTags` at registration time
  - External gems automatically get availability methods when they call `register_tag`
  - No changes to tree_haver are needed for new external backend gems
  - Built-in backends (prism, psych, citrus, parslet) retain explicit methods
  - `summary` method dynamically includes registered backends from BackendRegistry
  - `backend_availability_methods` and `backend_tags` hashes are built dynamically
- RSpec exclusion filters for backend tags are configured dynamically from BackendRegistry

### Fixed

- **`TreeHaver::Parser#unwrap_language` bug fix for MRI and Rust backends**
  - `:mri` and `:rust` cases were not returning the unwrapped language value
  - The code called `lang.to_language` / `lang.inner_language` / `lang.name` but didn't `return` the result
  - Now properly returns the unwrapped language for all backend types
- `any_markdown_backend_available?` now uses `BackendRegistry.tag_available?` instead of calling
  `markly_available?` and `commonmarker_available?` directly. This fixes `NoMethodError` when
  the external markdown backend gems haven't registered their tags yet.

[5.0.1]: https://github.com/kettle-rb/tree_haver/compare/v5.0.0...v5.0.1
[5.0.1t]: https://github.com/kettle-rb/tree_haver/releases/tag/v5.0.1

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
