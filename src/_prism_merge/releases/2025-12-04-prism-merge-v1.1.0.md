---
layout: post
title: "prism-merge v1.1.0 released!"
date: "2025-12-04T12:21:40Z"
tags: ["release", "prism-merge", "v1.1.0"]
---

## [1.1.0] - 2025-12-04

- TAG: [v1.1.0][1.1.0t]
- COVERAGE: 95.65% -- 770/805 lines in 9 files
- BRANCH COVERAGE: 81.13% -- 245/302 branches in 9 files
- 100.00% documented

### Added

- Recursive merge support for class and module bodies - nested structures are now merged intelligently
- Conditional signature matching for `if`/`unless` blocks based on condition expression
- Freeze block validation for partial/incomplete nodes and freeze blocks inside non-class/module contexts
- Freeze blocks now match by position/order when both files have multiple freeze blocks
- `add_template_only_nodes` option now properly respected in recursive merges and boundary processing
- `DebugLogger`, controlled by `ENV["PRISM_MERGE_DEBUG"]` set to true or false
- more specs

### Changed

- Migrated to Prism v1.6.0 native comment attachment (removed custom comment association logic)
- Simplified FileAnalysis implementation using Prism's built-in features
- Improved node lookup to handle anchors with leading comments (e.g., magic comments)

### Fixed

- Template-only nodes are now correctly excluded in all contexts when `add_template_only_nodes: false`
- Freeze blocks inside methods now properly raise InvalidStructureError (only class/module-level freeze blocks allowed)
- Freeze block matching now works correctly with multiple consecutive freeze blocks (matches by index/order)
- Duplicate freeze blocks from template no longer appear when destination has matching freeze blocks
- Magic comments at file top no longer prevent node lookup in recursive merges

[1.1.0]: https://github.com/kettle-rb/prism-merge/compare/v1.0.3...v1.1.0
[1.1.0t]: https://github.com/kettle-rb/prism-merge/releases/tag/v1.1.0

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
