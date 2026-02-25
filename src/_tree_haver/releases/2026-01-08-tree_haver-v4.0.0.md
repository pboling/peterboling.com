---
layout: post
title: "tree_haver v4.0.0 released!"
date: "2026-01-08T11:12:48Z"
tags: ["release", "tree_haver", "v4.0.0"]
---

## [4.0.0] - 2026-01-08

- TAG: [v4.0.0][4.0.0t]
- COVERAGE: 95.31% -- 2031/2131 lines in 28 files
- BRANCH COVERAGE: 84.21% -- 805/956 branches in 28 files
- 95.48% documented

### Added

- **BackendRegistry**: New `TreeHaver::BackendRegistry` module for registering backend availability checkers
  - Allows external gems (like `commonmarker-merge`, `markly-merge`, `rbs-merge`) to register their availability checkers
  - `register_availability_checker(backend_name, &block)` - Register a callable that returns true if backend is available
  - `available?(backend_name)` - Check if a backend is available (results are cached)
  - `registered?(backend_name)` - Check if a checker is registered
  - `registered_backends` - Get all registered backend names
  - Used by `TreeHaver::RSpec::DependencyTags` for dynamic backend detection
- **Plugin System**: `commonmarker-merge` and `markly-merge` now provide their own backends via `TreeHaver`'s registry system, removing them from `TreeHaver` core.
- **Backend Architecture Documentation**: Added comprehensive documentation to base classes and all tree-sitter backends explaining the two backend categories:
  - Tree-sitter backends (MRI, Rust, FFI, Java): Use `TreeHaver::Tree` and `TreeHaver::Node` wrappers for raw tree-sitter objects
  - Pure-Ruby/Plugin backends (Citrus, Prism, Psych, Commonmarker, Markly): Define own `Backend::X::Tree` and `Backend::X::Node` classes

### Changed

- **Base Class Inheritance**: `TreeHaver::Tree` and `TreeHaver::Node` now properly inherit from their respective `Base::` classes
  - `TreeHaver::Tree < Base::Tree` - inherits `inner_tree`, `source`, `lines` attributes and default implementations
  - `TreeHaver::Node < Base::Node` - inherits `inner_node`, `source`, `lines` attributes and API contract
  - Base classes document the API contract; subclasses document divergence
- **Base::Node#initialize**: Now accepts keyword arguments `source:` and `lines:` instead of positional for consistency with subclasses
- **DependencyTags**: Now uses `BackendRegistry.available?(:backend_name)` instead of hardcoded `TreeHaver::Backends::*` checks
- **TreeHaver**: `commonmarker` and `markly` backends are no longer built-in. Use `commonmarker-merge` and `markly-merge` gems which register themselves.
- **All backends**: Now register their availability checkers with `BackendRegistry` when loaded (MRI, Rust, FFI, Java, Prism, Psych, Citrus)

### Removed

- **TreeHaver**: Removed `TreeHaver::Backends::Commonmarker` and `TreeHaver::Backends::Markly` modules. These implementations have moved to their respective gems.

[4.0.0]: https://github.com/kettle-rb/tree_haver/compare/v3.2.6...v4.0.0
[4.0.0t]: https://github.com/kettle-rb/tree_haver/releases/tag/v4.0.0

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
