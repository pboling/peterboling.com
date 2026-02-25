---
layout: post
title: "prism-merge v1.1.5 released!"
date: "2025-12-05T07:04:10Z"
tags: ["release", "prism-merge", "v1.1.5"]
---

## [1.1.5] - 2025-12-04

- TAG: [v1.1.5][1.1.5t]
- COVERAGE: 98.26% -- 906/922 lines in 9 files
- BRANCH COVERAGE: 87.27% -- 384/440 branches in 9 files
- 100.00% documented

### Changed

- **Recursive merge now preserves freeze blocks**: When recursively merging nested block bodies (e.g., `Gem::Specification.new do ... end`), freeze blocks inside the body are now properly preserved. Previously, nested mergers were created with `freeze_token: nil`, causing freeze blocks to be lost.

### Fixed

- **Fixed freeze blocks lost in nested block bodies**: Freeze blocks inside class, module, or call-with-block bodies were being lost during recursive merge. The fix passes `freeze_token` to nested mergers and ensures `extract_node_body` includes leading comments/freeze markers that appear between the node's opening line and the first statement.
- **Fixed duplicate freeze markers in output**: Freeze/unfreeze marker comments were incorrectly attached as leading comments to subsequent nodes, causing duplicate markers in merged output. These markers are now filtered from leading comments since they belong to FreezeNode boundaries.

[1.1.5]: https://github.com/kettle-rb/prism-merge/compare/v1.1.4...v1.1.5
[1.1.5t]: https://github.com/kettle-rb/prism-merge/releases/tag/v1.1.5

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
