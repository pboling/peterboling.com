---
layout: post
title: "tree_haver v5.0.3 released!"
date: "2026-02-01T06:58:07Z"
tags: ["release", "tree_haver", "v5.0.3"]
---

## [5.0.3] - 2026-01-30

- TAG: [v5.0.3][5.0.3t]
- COVERAGE: 83.68% -- 2128/2543 lines in 30 files
- BRANCH COVERAGE: 72.50% -- 862/1189 branches in 30 files
- 94.78% documented

### Changed

- test against Prism v1.9.0
- CI updated to use latest version of ore

### Fixed

- **Improved dependency handling and test robustness**:
  - Added missing RSpec backend tags (`:parslet_backend`, `:citrus_backend`, etc.) to ensure tests are skipped when dependencies are unavailable.
  - Enhanced `GrammarFinder` to support both `ENV.key?` and `ENV[var]` checks, fixing issues with environment stubbing in tests.
  - Improved `GrammarFinder` spec reliability by using `allow(File).to receive(:exist?).and_call_original`.
  - Configured RSpec to mark grammar-dependent tests as `pending` with helpful instructions when shared libraries are missing.
  - Renamed `:toml_rb` tag to `:toml_rb_gem` for consistency across the codebase.
- Documentation fixes related to gem family section

[5.0.3]: https://github.com/kettle-rb/tree_haver/compare/v5.0.2...v5.0.3
[5.0.3t]: https://github.com/kettle-rb/tree_haver/releases/tag/v5.0.3

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
