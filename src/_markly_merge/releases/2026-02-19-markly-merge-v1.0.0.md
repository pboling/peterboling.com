---
layout: post
title: "markly-merge v1.0.0 released!"
date: "2026-02-19T14:29:13Z"
tags: ["release", "markly-merge", "v1.0.0"]
---

## [1.0.0] - 2026-02-19

- TAG: [v1.0.0][1.0.0t]
- COVERAGE: 83.82% -- 171/204 lines in 7 files
- BRANCH COVERAGE: 41.30% -- 19/46 branches in 7 files
- 78.87% documented

### Added

- AGENTS.md
- Initial release of markly-merge
- Thin wrapper around `markdown-merge` for Markly backend
- `Markly::Merge::SmartMerger` - smart merging with markly defaults
  - Default freeze token: `"markly-merge"`
  - Default `inner_merge_code_blocks: true` (enabled by default)
- `Markly::Merge::FileAnalysis` - file analysis with markly backend
- `Markly::Merge::FreezeNode` - freeze block support
- Markly-specific parse options:
  - `flags:` - Markly parse flags (e.g., `Markly::FOOTNOTES`, `Markly::SMART`)
  - `extensions:` - GFM extensions (`:table`, `:strikethrough`, `:autolink`, `:tagfilter`, `:tasklist`)
- Error classes: `Error`, `ParseError`, `TemplateParseError`, `DestinationParseError`
- Re-exports shared classes from markdown-merge:
  - `FileAligner`, `ConflictResolver`, `MergeResult`
  - `TableMatchAlgorithm`, `TableMatchRefiner`, `CodeBlockMerger`
  - `NodeTypeNormalizer`
- FFI backend isolation for test suite
  - Added `bin/rspec-ffi` script to run FFI specs in isolation (before MRI backend loads)
  - Added `spec/spec_ffi_helper.rb` for FFI-specific test configuration
  - Updated Rakefile with `ffi_specs` and `remaining_specs` tasks
  - The `:test` task now runs FFI specs first, then remaining specs
- **MergeGemRegistry Integration**: Registers with `Ast::Merge::RSpec::MergeGemRegistry`
  - Enables automatic RSpec dependency tag support
  - Registers as category `:markdown`
- Documentation on hostile takeover of RubyGems
  - https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo

### Security

#### Dependencies

- appraisal2 (v3.0.6)
- kettle-test (v1.0.10)
- stone_checksums (v1.0.3)
- [ast-merge (v4.0.6)](https://github.com/kettle-rb/ast-merge/releases/tag/v4.0.6) - shared merge infrastructure
- [tree_haver (v5.0.5)](https://github.com/kettle-rb/tree_haver/releases/tag/v5.0.5) - normalized AST conventions
- [markdown-merge (v1.0.3)](https://github.com/kettle-rb/markdown-merge/releases/tag/v1.0.3) - central merge infrastructure for markdown
- tree_stump (v0.2.0)
- markly (~> 0.15) - cmark-gfm C library
- version_gem (~> 1.1) - smart versions for libraries

### Security

[Unreleased]: https://github.com/kettle-rb/markly-merge/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/kettle-rb/markly-merge/compare/3dcd8b855b8a773f175ff34d31e3885a28a3e70b...v1.0.0
[1.0.0t]: https://github.com/kettle-rb/markly-merge/tags/v1.0.0

[1.0.0]: https://github.com/kettle-rb/markly-merge/compare/3dcd8b855b8a773f175ff34d31e3885a28a3e70b...v1.0.0
[1.0.0t]: https://github.com/kettle-rb/markly-merge/tags/v1.0.0

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
