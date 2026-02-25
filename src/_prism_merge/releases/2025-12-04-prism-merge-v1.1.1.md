---
layout: post
title: "prism-merge v1.1.1 released!"
date: "2025-12-04T22:48:48Z"
tags: ["release", "prism-merge", "v1.1.1"]
---

## [1.1.1] - 2025-12-04

- TAG: [v1.1.1][1.1.1t]
- COVERAGE: 96.62% -- 857/887 lines in 9 files
- BRANCH COVERAGE: 82.75% -- 331/400 branches in 9 files
- 100.00% documented

### Added

- Documented comparison of this tool, git-merge, and IDE "Smart Merge" in README.md
- Comprehensive node signature support for all Prism node types with nested content:
  - `SingletonClassNode` - singleton class definitions (`class << self`)
  - `CaseNode` / `CaseMatchNode` - case statements and pattern matching
  - `WhileNode` / `UntilNode` / `ForNode` - loop constructs
  - `BeginNode` - exception handling blocks
  - `SuperNode` / `ForwardingSuperNode` - super calls with blocks
  - `LambdaNode` - lambda expressions
  - `PreExecutionNode` / `PostExecutionNode` - BEGIN/END blocks
  - `ParenthesesNode` / `EmbeddedStatementsNode` - parenthesized expressions
- Smart signature matching for assignment method calls (`config.setting = value`) now matches by receiver and method name, not by value, enabling proper merging of configuration blocks

### Changed

- Improved boundary ordering in merge timeline - destination-only content appearing after all template content now correctly appears at the end of merged output (was incorrectly appearing at the beginning)
- Extended recursive merge support to handle `SingletonClassNode` and `BeginNode` in addition to existing `ClassNode`, `ModuleNode`, and `CallNode` types
- **Freeze block validation expanded** - freeze blocks can now be placed inside more container node types:
  - `SingletonClassNode` (`class << self ... end`)
  - `DefNode` (method definitions)
  - `LambdaNode` (lambda/proc definitions)
  - `CallNode` with blocks (e.g., RSpec `describe`/`context` blocks)
  - This allows protecting portions of method implementations or DSL block contents
- Added README documentation comparing Prism::Merge algorithm to git merge and IDE smart merge strategies
- Added RBS type definitions for `FreezeNode` class

### Fixed

- Documentation of freeze blocks, and configuration to customize the freeze token

[1.1.1]: https://github.com/kettle-rb/prism-merge/compare/v1.1.0...v1.1.1
[1.1.1t]: https://github.com/kettle-rb/prism-merge/releases/tag/v1.1.1

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
