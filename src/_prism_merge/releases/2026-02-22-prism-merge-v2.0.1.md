---
layout: post
title: "prism-merge v2.0.1 released!"
date: "2026-02-22T12:19:30Z"
tags: ["release", "prism-merge", "v2.0.1"]
---

## [2.0.1] - 2026-02-22

- TAG: [v2.0.1][2.0.1t]
- COVERAGE: 98.80% -- 820/830 lines in 12 files
- BRANCH COVERAGE: 85.55% -- 450/526 branches in 12 files
- 93.51% documented

### Added

- `SmartMerger#emit_dest_prefix_lines` preserves magic comments (e.g., `# frozen_string_literal: true`)
  and blank lines that appear before the first AST node in the destination file
- `SmartMerger#emit_dest_gap_lines` preserves blank lines between consecutive top-level blocks
  in the destination, preventing them from being silently stripped during merge

### Changed

- `SmartMerger#merge_with_debug` now uses `merge_result` (returns `MergeResult` object)
  instead of `merge` (returns `String`), so `statistics` and `decision_summary` are accessible
- `SmartMerger#build_result` now passes `template_analysis` and `dest_analysis` to
  `MergeResult.new` for consistency with `SmartMergerBase` API

### Removed

- Removed redundant `attr_reader :node_typing` from `SmartMerger` — already provided
  by `SmartMergerBase`

### Fixed

- Inter-node blank line stripping: blank lines between top-level blocks (e.g., between
  `appraise` blocks in Appraisals, between `gem` calls in Gemfiles) are now preserved
  from the destination source during merge
- Prefix line stripping: magic comments and blank lines before the first AST statement
  (e.g., `# frozen_string_literal: true` in Appraisal.root.gemfile) are now preserved

[2.0.1]: https://github.com/kettle-rb/prism-merge/compare/v2.0.0...v2.0.1
[2.0.1t]: https://github.com/kettle-rb/prism-merge/releases/tag/v2.0.1

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
