---
layout: post
title: "omniauth-identity v3.2.1 released!"
date: "2026-07-15T00:57:19Z"
tags: ["release", "omniauth-identity", "v3.2.1"]
---

- TAG: [v3.2.1][3.2.1t]
- COVERAGE: 22.91% -- 93/406 lines in 12 files
- BRANCH COVERAGE: 20.75% -- 22/106 branches in 12 files
- 85.26% documented

### Added

- Added support for JRuby 10.1 and TruffleRuby 34.0.

### Changed

- Retemplated generated project metadata, support documentation, CI workflows,
  binstubs, and development dependency floors with `kettle-jem` v7.0.0.
- Raised the `anonymous_loader` runtime dependency floor to `>= 0.1.3`.
- Raised the runtime dependency floor for `auth-sanitizer` to `>= 0.2.3`, so
  OmniAuth Identity consumers get hash and nested-attribute inspect redaction
  fixes plus downstream RBS duplicate-declaration fixes, and switched isolated
  sanitizer loading to the released `anonymous_loader` gem.
- Raised generated `version_gem` and `appraisal2` dependency floors to
  `version_gem` >= 1.1.14 and `appraisal2` >= 3.1.4.
- Refreshed generated Rakefile metadata from the current kettle-jem template.

### Fixed

- Restored ORM-specific spec rake tasks and made optional ORM spec files avoid
  loading unavailable adapter gems when the matching appraisal does not include them.

- Package configured license files in gem release file lists.

[3.2.1t]: https://github.com/omniauth/omniauth-identity/releases/tag/v3.2.1
