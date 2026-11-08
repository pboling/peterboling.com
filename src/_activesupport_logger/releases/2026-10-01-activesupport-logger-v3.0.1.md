---
layout: post
title: "activesupport-logger v3.0.1 released!"
date: "2026-10-01T18:47:03Z"
tags: ["release", "activesupport-logger", "v3.0.1"]
---

- TAG: [v3.0.1][3.0.1t]
- COVERAGE: 96.09% -- 123/128 lines in 7 files
- BRANCH COVERAGE: 86.21% -- 25/29 branches in 7 files
- 53.57% documented

### Added

- kettle-jem-template-20260913-001 - Templating now also surfaces a review
  entry in `dependency_conflicts.resolve` when a direct development
  dependency doesn't support one or more of this project's declared
  `engines:` and has no template-managed modular home (e.g. `sqlite3` on
  `jruby`). Review each entry and pick a resolution per the project's own
  engine support needs.

### Changed

- [kc] kettle-jem/prepare: updated 14 project files:
  - dependencies (14)

- [kc] kettle-jem/template: updated 32 project files:
  - code and tests (1)
  - dependencies (6)
  - documentation (1)
  - other (3)
  - workflows (21)

### Fixed

- Load the ActiveSupport::Logger version namespace before applying VersionGem enhancements.

[3.0.1t]: https://github.com/galtzo-floss/activesupport-logger/releases/tag/v3.0.1
