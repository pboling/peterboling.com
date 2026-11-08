---
layout: post
title: "month-serializer v1.0.3 released!"
date: "2026-10-01T11:14:19Z"
tags: ["release", "month-serializer", "v1.0.3"]
---

- TAG: [v1.0.3][1.0.3t]
- COVERAGE: 90.00% -- 36/40 lines in 2 files
- BRANCH COVERAGE: 60.00% -- 6/10 branches in 2 files
- 36.36% documented

### Changed

- [kc] kettle-jem/prepare: updated 25 project files:
  - dependencies (25)
- [kc] kettle-jem/template: updated 48 project files:
  - code and tests (3)
  - dependencies (12)
  - other (3)
  - workflows (30)

### Added

- kettle-jem-template-20260913-001 - Templating now also surfaces a review
  entry in `dependency_conflicts.resolve` when a direct development
  dependency doesn't support one or more of this project's declared
  `engines:` and has no template-managed modular home (e.g. `sqlite3` on
  `jruby`). Review each entry and pick a resolution per the project's own
  engine support needs.

[1.0.3t]: https://github.com/galtzo-floss/month-serializer/releases/tag/v1.0.3
