---
layout: post
title: "tree_haver v5.0.2 released!"
date: "2026-01-14T03:06:13Z"
tags: ["release", "tree_haver", "v5.0.2"]
---

## [5.0.2] - 2026-01-13

- TAG: [v5.0.2][5.0.2t]
- COVERAGE: 90.79% -- 2308/2542 lines in 30 files
- BRANCH COVERAGE: 78.09% -- 930/1191 branches in 30 files
- 94.78% documented

### Added

- More documentation about the Merge Gem Family
- **`:json_parsing` and `:jsonc_parsing` RSpec dependency tags**: Added missing parsing capability tags
  for JSON and JSONC (JSON with Comments) languages
  - `any_json_backend_available?` - Checks if tree-sitter-json is available
  - `any_jsonc_backend_available?` - Checks if tree-sitter-jsonc is available
  - Tests tagged with `:jsonc_parsing` will now be properly skipped on TruffleRuby and other
    platforms where tree-sitter backends are not available
  - Fixes issue where jsonc-merge specs were running on TruffleRuby and failing because
    the tag was undefined and therefore not excluded

### Changed

- Restored README.md (was accidentally corrupted during the last release)

[5.0.2]: https://github.com/kettle-rb/tree_haver/compare/v5.0.1...v5.0.2
[5.0.2t]: https://github.com/kettle-rb/tree_haver/releases/tag/v5.0.2

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
