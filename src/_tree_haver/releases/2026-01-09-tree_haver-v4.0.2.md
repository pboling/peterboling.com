---
layout: post
title: "tree_haver v4.0.2 released!"
date: "2026-01-09T01:36:16Z"
tags: ["release", "tree_haver", "v4.0.2"]
---

## [4.0.2] - 2026-01-08

- TAG: [v4.0.2][4.0.2t]
- COVERAGE: 95.27% -- 2033/2134 lines in 28 files
- BRANCH COVERAGE: 84.07% -- 802/954 branches in 28 files
- 95.49% documented

### Added

- **FFI Backend**: Implemented `missing?` method on `TreeHaver::Backends::FFI::Node`
  - Added `ts_node_is_missing` FFI function attachment
  - This method was missing entirely, causing `NoMethodError` when checking for MISSING nodes

### Changed

- **TreeHaver::Node**: Removed defensive `respond_to?` checks from `has_error?` and `missing?` methods
  - All tree-sitter backends (MRI, Rust, FFI, Java) must implement these methods on their inner nodes
  - This enforces proper backend API compliance rather than silently masking missing implementations

### Fixed

- **FFI Backend**: Added explicit boolean conversion (`!!`) to `has_error?` return value
  - FFI `:bool` return type may behave inconsistently across Ruby versions and platforms
  - Ensures `has_error?` always returns `true` or `false`, not truthy/falsy values

[4.0.2]: https://github.com/kettle-rb/tree_haver/compare/v4.0.1...v4.0.2
[4.0.2t]: https://github.com/kettle-rb/tree_haver/releases/tag/v4.0.2

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
