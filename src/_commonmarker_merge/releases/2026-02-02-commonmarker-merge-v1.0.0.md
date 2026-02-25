---
layout: post
title: "commonmarker-merge v1.0.0 released!"
date: "2026-02-02T02:31:47Z"
tags: ["release", "commonmarker-merge", "v1.0.0"]
---

## [1.0.0] - 2026-02-01

- TAG: [v1.0.0][1.0.0t]
- COVERAGE: 86.52% -- 154/178 lines in 7 files
- BRANCH COVERAGE: 47.73% -- 21/44 branches in 7 files
- 86.44% documented

### Added

- [tree_haver v5.0.3](https://github.com/kettle-rb/tree_haver/releases/tag/v5.0.3)
- [ast-merge v4.0.5](https://github.com/kettle-rb/ast-merge/releases/tag/v4.0.5)
- [markdown-merge v1.0.2](https://github.com/kettle-rb/markdown-merge/releases/tag/v1.0.2)
- Thin wrapper around `markdown-merge` for Commonmarker backend
- `Commonmarker::Merge::SmartMerger` - smart merging with commonmarker defaults
  - Default freeze token: `"commonmarker-merge"`
  - Default `inner_merge_code_blocks: false`
- `Commonmarker::Merge::FileAnalysis` - file analysis with commonmarker backend
- `Commonmarker::Merge::FreezeNode` - freeze block support
- Commonmarker-specific parse options via `options:` parameter
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
- **Backend Specs**: Migrated backend specs from `tree_haver` to this gem
  - Comprehensive tests for `Commonmarker::Merge::Backend` module
  - Tests for `Language`, `Parser`, `Tree`, `Node`, and `Point` classes
  - Integration tests for `BackendRegistry` availability checking
- **MergeGemRegistry Integration**: Registers with `Ast::Merge::RSpec::MergeGemRegistry`
  - Enables automatic RSpec dependency tag support
  - Registers as category `:markdown`
- **BackendRegistry Integration**: Now uses `register_tag` instead of `register_availability_checker`
  - Registers with `require_path: "commonmarker/merge"` enabling lazy loading
  - Tree_haver can now detect and load this backend without hardcoded knowledge
  - Supports fully dynamic tag system in tree_haver
- **SmartMerger**: Added `**extra_options` for forward compatibility
  - Accepts additional options that may be added to base class in future
  - Passes all options through to `Markdown::Merge::SmartMerger`

#### Dependencies

- `commonmarker` (~> 2.0) - Comrak Rust parser
- `markdown-merge` (~> 1.0) - central merge infrastructure for markdown
- `version_gem` (~> 1.1)

### Security

[Unreleased]: https://github.com/kettle-rb/commonmarker-merge/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/kettle-rb/commonmarker-merge/compare/12d4e9fff5bbe6a9b29e81c6643b4dd705f8e80a...v1.0.0
[1.0.0t]: https://github.com/kettle-rb/commonmarker-merge/tags/v1.0.0

[1.0.0]: https://github.com/kettle-rb/commonmarker-merge/compare/12d4e9fff5bbe6a9b29e81c6643b4dd705f8e80a...v1.0.0
[1.0.0t]: https://github.com/kettle-rb/commonmarker-merge/tags/v1.0.0

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
