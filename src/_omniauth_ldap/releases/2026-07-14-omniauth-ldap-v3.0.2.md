---
layout: post
title: "omniauth-ldap v3.0.2 released!"
date: "2026-07-14T20:03:11Z"
tags: ["release", "omniauth-ldap", "v3.0.2"]
---

- TAG: [v3.0.2][3.0.2t]
- COVERAGE: 97.50% -- 312/320 lines in 6 files
- BRANCH COVERAGE: 79.41% -- 108/136 branches in 6 files
- 89.19% documented

### Added

- Added support for JRuby 10.1 and TruffleRuby 34.0.

### Changed

- Retemplated generated project metadata, support documentation, CI workflows,
  binstubs, and development dependency floors with `kettle-jem` v7.0.0.
- Raised the `anonymous_loader` runtime dependency floor to `>= 0.1.2`.
- Raised the `auth-sanitizer` runtime dependency floor to `>= 0.2.2` and
  switched isolated sanitizer loading to the released `anonymous_loader` gem.

### Fixed

- Package configured license files in gem release file lists.

[3.0.2t]: https://github.com/omniauth/omniauth-ldap/releases/tag/v3.0.2

