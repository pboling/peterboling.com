---
layout: post
title: "dotenv-merge v1.0.1 released!"
date: "2026-01-01T22:42:08Z"
tags: ["release", "dotenv-merge", "v1.0.1"]
---

## [1.0.1] - 2026-01-01

- TAG: [v1.0.1][1.0.1t]
- COVERAGE: 97.72% -- 343/351 lines in 8 files
- BRANCH COVERAGE: 83.61% -- 102/122 branches in 8 files
- 96.83% documented

### Added

- `node_typing` parameter for per-node-type merge preferences
  - Enables `preference: { default: :destination, special_type: :template }` pattern
  - Works with custom merge_types assigned via node_typing lambdas
- `match_refiner` parameter for fuzzy matching support
- `regions` and `region_placeholder` parameters for nested content merging
- `EnvLine#type` method returning `"env_line"` for TreeHaver::Node protocol compatibility

### Changed

- **SmartMerger**: Added `**options` for forward compatibility
  - Accepts additional options that may be added to base class in future
  - Passes all options through to `SmartMergerBase`
- **MergeResult**: Added `**options` for forward compatibility
- **BREAKING**: `SmartMerger` now inherits from `Ast::Merge::SmartMergerBase`
  - Provides standardized options API consistent with all other `*-merge` gems
  - All keyword arguments are now explicit (no more positional-only arguments)
  - Gains automatic support for new SmartMergerBase features
- Renamed `EnvLine#type` attribute to `EnvLine#line_type` to avoid conflict with TreeHaver::Node protocol

[1.0.1]: https://github.com/kettle-rb/dotenv-merge/compare/v1.0.0...v1.0.1
[1.0.1t]: https://github.com/kettle-rb/dotenv-merge/releases/tag/v1.0.1

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
