---
layout: post
title: "omniauth-ldap v2.3.1 released!"
date: "2025-11-05T11:57:39Z"
tags: ["release", "omniauth-ldap", "v2.3.1"]
---

## [2.3.1] - 2025-11-05

- TAG: [v2.3.1][2.3.1t]
- COVERAGE: 97.85% -- 228/233 lines in 4 files
- BRANCH COVERAGE: 81.58% -- 62/76 branches in 4 files
- 37.50% documented

### Added

- Added RBS types
- Upgraded RSpec tests to v3 syntax
- Improved code coverage to 98% lines and 78% branches
- Added integration tests with a complete Roda-based demo app for specs
- Well tested support for all versions of OmniAuth >= v1 and Rack >= v1 via appraisals
- Document why auth.uid == dn
- Support for LDAP-based SSO identity via HTTP Header
- Document how to use filter option
- All fixes and updates from the GitLab fork since up to v2.3.0
    - https://github.com/omniauth/omniauth-ldap/pull/100
    - https://gitlab.com/gitlab-org/gitlab-ce/issues/13280

### Changed

- Make support for Ruby v2.0 explicit
- Make support for OmniAuth v1+ explicit
- Make support for Rack v1+ explicit
- Modernize codebase to use more recent Ruby syntax (upgrade from Ruby v1 to v2 syntax) and conventions

### Fixed

- Prevent key duplication in symbolize_hash_keys

[2.3.1]: https://github.com/omniauth/omniauth-ldap/compare/v2.0.0...v2.3.1
[2.3.1t]: https://github.com/omniauth/omniauth-ldap/releases/tag/v2.3.1

Official Discord 👉️ [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite]

Many paths lead to being a sponsor or a backer of this project. Are you on such a path?

[![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal]

[![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS or refugee efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS or refugee efforts using Patreon][🖇patreon-img]][🖇patreon]

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay]: https://liberapay.com/pboling/donate
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
