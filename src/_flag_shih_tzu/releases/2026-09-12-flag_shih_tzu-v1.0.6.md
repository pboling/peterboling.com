---
layout: post
title: "flag_shih_tzu v1.0.6 released!"
date: "2026-09-12T01:55:47Z"
tags: ["release", "flag_shih_tzu", "v1.0.6"]
---

- TAG: [v1.0.6][1.0.6t]
- COVERAGE: 90.75% -- 412/454 lines in 3 files
- BRANCH COVERAGE: 76.76% -- 142/185 branches in 3 files
- 30.00% documented

### Changed

- kettle-jem-template-20260801-001 - Generated README gem dashboard links now
  use ClickGems instead of BestGems.

- [kc] kettle-jem/prepare: updated 8 project files:
  - dependencies (8)

- [kc] kettle-jem/template: updated 4 project files:
  - code and tests (1)
  - dependencies (2)
  - other (1)

### Fixed

- kettle-jem-template-20260801-002 - Generated RSpec helpers now normalize
  managed configuration block bindings structurally, preventing mixed block
  parameter names from producing invalid configuration after a merge.
- kettle-jem-template-20260801-003 - Generated project metadata and
  documentation now normalize configured underscore hostnames to valid
  hyphenated hostnames.
- kettle-jem-template-20260801-004 - Generated organization README logos now
  use GitHub's stable organization avatar endpoint instead of assuming a
  matching Galtzo-hosted asset exists.

- kettle-jem-template-20260802-001 - Devcontainer JSON files now merge as JSONC,
  preserving comments and trailing commas during template updates.

- Restore the ActiveRecord test dependencies required by the default development bundle.

- Restore README link definitions required by the pre-release Markdown reference validator.

- Restore the ActiveRecord test bundle removed by an earlier template pass.

[1.0.6t]: https://github.com/galtzo-floss/flag_shih_tzu/releases/tag/v1.0.6

