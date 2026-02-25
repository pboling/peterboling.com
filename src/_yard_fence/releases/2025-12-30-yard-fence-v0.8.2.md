---
layout: post
title: "yard-fence v0.8.2 released!"
date: "2025-12-30T12:54:00Z"
tags: ["release", "yard-fence", "v0.8.2"]
---

## [0.8.2] - 2025-12-30

- TAG: [v0.8.2][0.8.2t]
- COVERAGE: 100.00% -- 130/130 lines in 4 files
- BRANCH COVERAGE: 100.00% -- 40/40 branches in 4 files
- 50.00% documented

### Added

- `Yard::Fence::RakeTask` - New rake task class that provides `yard:fence:prepare` and `yard:fence:clean` tasks
  - Automatically enhances the `:yard` task when defined
  - Auto-registers when Rake is available at gem load time
- `Yard::Fence.prepare_for_yard` - New method to prepare for YARD documentation generation
  - Combines `clean_docs_directory` and `prepare_tmp_files` into a single call
  - Intended to be called from rake tasks, not at load time

### Deprecated

- `Yard::Fence.at_load_hook` - Now does nothing; use `prepare_for_yard` via rake task instead

### Removed

- **BREAKING**: Removed load-time execution of `clean_docs_directory` and `prepare_tmp_files`
  - Previously, these ran when yard-fence was loaded, causing `docs/` to be cleared during unrelated rake tasks like `build` and `release`
  - Now all preparation happens via the `yard:fence:prepare` rake task, which runs as a prerequisite to the `:yard` task

### Fixed

- Fixed `docs/` directory being cleared during `rake build` and `rake release` commands
  - The root cause was `at_load_hook` running at gem load time instead of only when generating documentation
  - Now docs cleanup and tmp file preparation only occur when the `yard` task actually runs

[0.8.2]: https://github.com/galtzo-floss/yard-fence/compare/v0.8.1...v0.8.2
[0.8.2t]: https://github.com/galtzo-floss/yard-fence/releases/tag/v0.8.2

Official Discord 👉️ [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite]

Many paths lead to being a sponsor or a backer of this project. Are you on such a path?

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal]

[![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS efforts using Patreon][🖇patreon-img]][🖇patreon]

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-backers]: https://opencollective.com/galtzo-floss#backer
[🖇osc-backers-i]: https://opencollective.com/galtzo-floss/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/galtzo-floss#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/galtzo-floss/sponsors/badge.svg?style=flat
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
