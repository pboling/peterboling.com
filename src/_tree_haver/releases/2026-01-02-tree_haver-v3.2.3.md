---
layout: post
title: "tree_haver v3.2.3 released!"
date: "2026-01-02T12:39:21Z"
tags: ["release", "tree_haver", "v3.2.3"]
---

## [3.2.3] - 2026-01-02

- TAG: [v3.2.3][3.2.3t]
- COVERAGE: 94.91% -- 2088/2200 lines in 22 files
- BRANCH COVERAGE: 81.37% -- 738/907 branches in 22 files
- 90.14% documented

### Fixed

- **`parser_for` now respects explicitly requested non-native backends** - Previously,
  `parser_for` would always try tree-sitter backends first and only fall back to alternative
  backends if tree-sitter was unavailable. Now it checks `effective_backend` and skips
  tree-sitter attempts entirely when a non-native backend is explicitly requested via:
  - `TREE_HAVER_BACKEND=citrus` (or `prism`, `psych`, `commonmarker`, `markly`)
  - `TreeHaver.backend = :citrus`
  - `TreeHaver.with_backend(:citrus) { ... }`

  Native backends (`:mri`, `:rust`, `:ffi`, `:java`) still use tree-sitter grammar discovery.

- **`load_tree_sitter_language` now correctly ignores Citrus registrations** - Previously,
  if a language was registered with Citrus first, `load_tree_sitter_language` would
  incorrectly try to use it even when a native backend was explicitly requested. Now it
  only uses registrations that have a `:tree_sitter` key, allowing proper backend switching
  between Citrus and native tree-sitter backends.

- **`load_tree_sitter_language` now validates registered paths exist** - Previously,
  if a language had a stale/invalid tree-sitter registration with a non-existent path
  (e.g., from a test), the code would try to use it and fail. Now it checks
  `File.exist?(path)` before using a registered path, falling back to auto-discovery
  via `GrammarFinder` if the registered path doesn't exist.

- **`Language.method_missing` no longer falls back to Citrus when native backend explicitly requested** -
  Previously, when tree-sitter loading failed (e.g., .so file missing), the code would
  silently fall back to Citrus even if the user explicitly requested `:mri`, `:rust`,
  `:ffi`, or `:java`. Now fallback to Citrus only happens when `effective_backend` is `:auto`.
  This is a **breaking change** for users who relied on silent fallback behavior.

- **Simplified `parser_for` implementation** - Refactored from complex nested conditionals to
  cleaner helper methods (`load_tree_sitter_language`, `load_citrus_language`). The logic is
  now easier to follow and maintain.

[3.2.3]: https://github.com/kettle-rb/tree_haver/compare/v3.2.2...v3.2.3
[3.2.3t]: https://github.com/kettle-rb/tree_haver/releases/tag/v3.2.3

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
