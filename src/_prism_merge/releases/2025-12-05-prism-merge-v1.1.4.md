---
layout: post
title: "prism-merge v1.1.4 released!"
date: "2025-12-05T04:58:06Z"
tags: ["release", "prism-merge", "v1.1.4"]
---

## [1.1.4] - 2025-12-04

- TAG: [v1.1.4][1.1.4t]
- COVERAGE: 98.26% -- 902/918 lines in 9 files
- BRANCH COVERAGE: 87.59% -- 381/435 branches in 9 files
- 100.00% documented

### Added

- **Custom signature generator fallthrough support**: Custom signature generators can now return a `Prism::Node` or `FreezeNode` to fall through to the default signature computation. This allows custom generators to only override specific node types while delegating others to the built-in logic. Previously, returning `nil` was the only way to skip custom handling, but that prevented proper matching for unhandled node types.
- **Variable assignment node signatures**: Added signature support for all variable write node types:
  - `LocalVariableWriteNode` → `[:local_var, name]`
  - `InstanceVariableWriteNode` → `[:ivar, name]`
  - `ClassVariableWriteNode` → `[:cvar, name]`
  - `GlobalVariableWriteNode` → `[:gvar, name]`
  - `MultiWriteNode` → `[:multi_write, [target_names]]`

### Removed

- Removed pre-prism code in `ConflictResolver` that compared template node line numbers against destination freeze block line numbers (cross-file line comparison makes no sense)

### Fixed

- **Fixed template-only nodes not being added when destination has freeze blocks**: When `add_template_only_nodes: true`, template nodes with no matching signature in destination were incorrectly skipped if the destination contained freeze blocks. The bug was caused by comparing template node line numbers against destination freeze block line numbers, which is a meaningless cross-file comparison. Template-only nodes are now correctly added regardless of freeze block presence.

[1.1.4]: https://github.com/kettle-rb/prism-merge/compare/v1.1.3...v1.1.4
[1.1.4t]: https://github.com/kettle-rb/prism-merge/releases/tag/v1.1.4

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
