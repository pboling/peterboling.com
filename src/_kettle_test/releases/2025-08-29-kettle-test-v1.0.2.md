---
layout: post
title: "kettle-test v1.0.2 released!"
date: "2025-08-29T21:43:36Z"
tags: ["release", "kettle-test", "v1.0.2"]
---

## [1.0.2] - 2025-08-29
- TAG: [v1.0.2][1.0.2t]
- COVERAGE: 100.00% -- 81/81 lines in 13 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 13 files
- 94.44% documented
### Removed
- checksums from packaged gem
### Fixed
- gem packaged without checksums
  - can't be in the packaged gem, since they would change the checksum of the gem itself
### Security
- corrected checksums for the next release (not packaged, only tracked in VCS)

[1.0.2]: https://github.com/kettle-rb/kettle-test/compare/v1.0.1...v1.0.2
[1.0.2t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.2

