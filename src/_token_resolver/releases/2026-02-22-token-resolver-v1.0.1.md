---
layout: post
title: "token-resolver v1.0.1 released!"
date: "2026-02-22T10:23:06Z"
tags: ["release", "token-resolver", "v1.0.1"]
---

## [1.0.1] - 2026-02-22

- TAG: [v1.0.1][1.0.1t]
- COVERAGE: 98.13% -- 263/268 lines in 10 files
- BRANCH COVERAGE: 91.18% -- 62/68 branches in 10 files
- 96.77% documented

### Added

- `Config#segment_pattern` option — a parslet character class constraining which characters
  are valid inside token segments (default: `"[A-Za-z0-9_]"`). This prevents false positive
  token matches against Ruby block parameters (`{ |x| expr }`), shell variable expansion
  (`${VAR:+val}`), and other syntax that structurally resembles tokens but contains spaces
  or punctuation in the "segments".
- `Resolve#resolve` now validates replacement keys against the config's `segment_pattern` and
  raises `ArgumentError` if a key contains characters that the grammar would never parse.

### Fixed

- **False positive token matches** — the grammar previously used `any` (match any character)
  for segment content, which allowed spaces, operators, and punctuation inside token segments.
  This caused Ruby block syntax like `{ |fp| File.exist?(fp) }` and shell expansion like
  `${CLASSPATH:+:$CLASSPATH}` to be incorrectly parsed as tokens. With multi-separator configs
  (`["|", ":"]`), the second `|` was reconstructed as `:` during `on_missing: :keep`
  roundtripping, silently corrupting source files. The grammar now uses
  `match(segment_pattern)` instead of `any`, limiting segments to word characters by default.

[1.0.1]: https://github.com/kettle-rb/token-resolver/compare/v1.0.0...v1.0.1
[1.0.1t]: https://github.com/kettle-rb/token-resolver/releases/tag/v1.0.1

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
