---
layout: post
title: "activesupport-tagged_logging v2.0.0 released!"
date: "2024-11-21T18:01:05Z"
tags: ["release", "activesupport-tagged_logging", "v2.0.0"]
---

## [2.0.0] - 2024-11-21

- COVERAGE:  98.11% -- 104/106 lines in 5 files
- BRANCH COVERAGE:  81.82% -- 18/22 branches in 5 files
- 36.36% documented

### Changed

- `ActiveSupport::FixPr53105` => `Activesupport::FixPr53105`
  - **BREAKING CHANGE**: change `ActiveSupport::FixPr53105.init` to `Activesupport::FixPr53105.init`
  - This is to keep the code of this gem in a consistent namespace separate from the standard Rails `ActiveSupport`.
- Upgrade to `activesupport-logger` v2.0.0

### Fixed

- Compatibility with Rails v5.2, v6.0, v6.1, v7.0, v7.1, and v8

### Added

- Dependency on `activesupport-broadcast_logger` v2.0.0
- Real test suite

**Full Changelog**: https://github.com/pboling/activesupport-tagged_logging/compare/v1.0.0...v2.0.0
