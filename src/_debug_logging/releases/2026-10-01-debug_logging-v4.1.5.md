---
layout: post
title: "debug_logging v4.1.5 released!"
date: "2026-10-01T05:24:45Z"
tags: ["release", "debug_logging", "v4.1.5"]
---

- TAG: [v4.1.5][4.1.5t]
- COVERAGE: 97.46% -- 730/749 lines in 28 files
- BRANCH COVERAGE: 86.34% -- 177/205 branches in 28 files
- 21.99% documented

### Added

- kettle-jem-template-20260913-001 - Templating now also surfaces a review
  entry in `dependency_conflicts.resolve` when a direct development
  dependency doesn't support one or more of this project's declared
  `engines:` and has no template-managed modular home (e.g. `sqlite3` on
  `jruby`). Review each entry and pick a resolution per the project's own
  engine support needs.

### Changed

- [kc] kettle-jem/prepare: updated 19 project files:
  - dependencies (19)
- [kc] kettle-jem/template: updated 29 project files:
  - code and tests (3)
  - dependencies (2)
  - other (3)
  - workflows (21)

[4.1.5t]: https://github.com/galtzo-floss/debug_logging/releases/tag/v4.1.5
