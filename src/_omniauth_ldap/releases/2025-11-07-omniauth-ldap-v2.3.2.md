---
layout: post
title: "omniauth-ldap v2.3.2 released!"
date: "2025-11-07T21:37:24Z"
tags: ["release", "omniauth-ldap", "v2.3.2"]
---

## [2.3.2] - 2025-11-06

- TAG: [v2.3.2][2.3.2t]
- COVERAGE: 97.64% -- 290/297 lines in 4 files
- BRANCH COVERAGE: 79.69% -- 102/128 branches in 4 files
- 44.12% documented

### Added

- Support for SCRIPT_NAME for proper URL generation
  - behind certain proxies/load balancers, or
  - under a subdirectory
- Password Policy for LDAP Directories
  - password_policy: true|false (default: false)
  - on authentication failure, if the server returns password policy controls, the info will be included in the failure message
  - https://datatracker.ietf.org/doc/html/draft-behera-ldap-password-policy-11
- Support for JSON bodies
- Support custom LDAP attributes mapping
- Documentation of TLS verification options

### Changed

- Make support for OmniAuth v1.2+ explicit
  - Versions < 1.2 do not support SCRIPT_NAME properly, and may cause other issues
- Raise a distinct error when LDAP server is unreachable
  - Previously raised an invalid credentials authentication failure error, which is technically incorrect

[2.3.2]: https://github.com/omniauth/omniauth-ldap/compare/v2.3.1...v2.3.2
[2.3.2t]: https://github.com/omniauth/omniauth-ldap/releases/tag/v2.3.2

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
