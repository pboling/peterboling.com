---
layout: post
title: "prism-merge v2.0.2 released!"
date: "2026-02-22T15:09:00Z"
tags: ["release", "prism-merge", "v2.0.2"]
---

## [2.0.2] - 2026-02-22

- TAG: [v2.0.2][2.0.2t]
- COVERAGE: 98.80% -- 823/833 lines in 12 files
- BRANCH COVERAGE: 85.61% -- 452/528 branches in 12 files
- 93.51% documented

### Fixed

- Fix node duplication when merging files with inline trailing comments (e.g.,
  gemspec `add_dependency` lines with `# ruby >= 3.2.0`). `add_node_to_result`
  output the full source line (which already includes inline comments via
  `analysis.line_at`), then also iterated `trailing_comments` and re-emitted any
  comment on the same line — duplicating the entire line. Now skips trailing
  comments whose `start_line` falls within the node's own line range. This was the
  root cause of every `add_dependency` / `add_development_dependency` being
  duplicated in gemspec and gemfile merges when inline comments were present.
- Prevent potential double-wrapping in `merge_node_body_recursively` — store the
  raw (unwrapped) `signature_generator` as `@raw_signature_generator` and pass it
  (instead of the already-effective generator) to inner `SmartMerger` instances.
  This ensures `build_effective_signature_generator` wraps it only once when
  `node_typing` is also configured.

[2.0.2]: https://github.com/kettle-rb/prism-merge/compare/v2.0.1...v2.0.2
[2.0.2t]: https://github.com/kettle-rb/prism-merge/releases/tag/v2.0.2

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
