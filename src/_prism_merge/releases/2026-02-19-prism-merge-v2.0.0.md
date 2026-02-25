---
layout: post
title: "prism-merge v2.0.0 released!"
date: "2026-02-19T12:48:14Z"
tags: ["release", "prism-merge", "v2.0.0"]
---

## [2.0.0] - 2026-02-19

- TAG: [v2.0.0][2.0.0t]
- COVERAGE: 97.26% -- 780/802 lines in 12 files
- BRANCH COVERAGE: 82.07% -- 412/502 branches in 12 files
- 93.59% documented

### Added

- Many new features inherited from `ast-merge`, and updated behaviors.
- **FileAnalysis**: Added `#errors` method for compatibility with SmartMergerBase
  - Returns `@parse_result.errors` for consistency with other FileAnalysis classes
  - Enables SmartMergerBase to properly create parse errors when `valid?` is false
- AGENTS.md

### Changed

- appraisal2 v3.0.6
- kettle-test v1.0.10
- stone_checksums v1.0.3
- ast-merge v4.0.6
- tree_haver v5.0.5
- tree_stump v0.2.0
  - fork no longer required, updates all applied upstream
- **SmartMerger**: Added `**options` for forward compatibility
  - Now passes `node_typing` explicitly to `SmartMergerBase` instead of storing locally
  - Accepts additional options that may be added to base class in future
- **FileAnalysis**: Added `**options` for forward compatibility
  - Accepts additional options that may be added in future
  - Consistent with other `*-merge` gems' FileAnalysis classes
- **MergeResult**: Added `**options` for forward compatibility
- **ParseError**: Updated constructor to accept base class signature
  - Now accepts optional `message`, `errors:`, `content:`, and `parse_result:` keywords
  - Compatible with `Ast::Merge::ParseError` signature while preserving `parse_result` attribute
  - Enables SmartMergerBase to create parse errors without Prism-specific knowledge
- Updated documentation on hostile takeover of RubyGems
  - https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo
- **BREAKING**: Error classes now inherit from `Ast::Merge` base classes:
  - `Prism::Merge::Error` now inherits from `Ast::Merge::Error` (was `StandardError`)
  - `Prism::Merge::ParseError` now inherits from `Ast::Merge::ParseError` (was `Prism::Merge::Error`)
  - `ParseError#errors` attribute added (array of error objects from `parse_result.errors`)
  - Code using `e.parse_result.errors` should now use `e.errors` directly
  - `parse_result` attribute is still available for Prism-specific access

[2.0.0]: https://github.com/kettle-rb/prism-merge/compare/v1.1.6...v2.0.0
[2.0.0t]: https://github.com/kettle-rb/prism-merge/releases/tag/v2.0.0

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
