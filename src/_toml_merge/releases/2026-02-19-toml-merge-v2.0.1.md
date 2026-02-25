---
layout: post
title: "toml-merge v2.0.1 released!"
date: "2026-02-19T13:48:52Z"
tags: ["release", "toml-merge", "v2.0.1"]
---

## [2.0.1] - 2026-02-19

- TAG: [v2.0.1][2.0.1t]
- COVERAGE: 89.42% -- 575/643 lines in 11 files
- BRANCH COVERAGE: 65.23% -- 182/279 branches in 11 files
- 97.03% documented

### Added

- AGENTS.md

### Changed

- appraisal2 v3.0.6
- kettle-test v1.0.10
- stone_checksums v1.0.3
- [ast-merge v4.0.6](https://github.com/kettle-rb/ast-merge/releases/tag/v4.0.6)
- [tree_haver v5.0.5](https://github.com/kettle-rb/tree_haver/releases/tag/v5.0.5)
  - FFI Backend improvements
  - Error handling improvements
  - Many new features, and more bug fixes
- tree_stump v0.2.0
  - fork no longer required, updates all applied upstream
- **Simplified dependency_tags.rb**: Removed redundant debug code
  - Removed `TOML_MERGE_DEBUG` env var handling (use `TREE_HAVER_DEBUG` instead)
  - tree_haver's debug output now respects blocked backends via `compute_blocked_backends`
  - Avoids accidentally loading MRI backend during FFI-only test runs
- Updated documentation on hostile takeover of RubyGems
  - https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo

[2.0.1]: https://github.com/kettle-rb/toml-merge/compare/v1.0.0...v2.0.1
[2.0.1t]: https://github.com/kettle-rb/toml-merge/releases/tag/v2.0.1

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
