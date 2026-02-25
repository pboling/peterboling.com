---
layout: post
title: "activesupport-broadcast_logger v2.0.4 released!"
date: "2025-02-25T01:58:37Z"
tags: ["release", "activesupport-broadcast_logger", "v2.0.4"]
---

## What's Changed
* Rails 5.2 fixes by @pboling in https://github.com/pboling/activesupport-broadcast_logger/pull/6

## [2.0.4] - 2025-02-24
- COVERAGE:  97.06% -- 66/68 lines in 3 files
- BRANCH COVERAGE:  90.00% -- 9/10 branches in 3 files
- 73.68% documented
### Added
- `stone_checksums` for gem release checksums
### Changed
- upgrade `version_gem` v1.1.6
### Fixed
- Rails v5.2 compatibility
  - Define `ActiveSupport::Logger.broadcast` as a NoOp
  - Fix circular require
- Use `Kernel.load` in gemspec instead of RubyGems' monkey patched `load`

**Full Changelog**: https://github.com/pboling/activesupport-broadcast_logger/compare/v2.0.3...v2.0.4
