---
layout: post
title: "snaky_hash v2.0.3 released!"
date: "2025-05-23T03:01:14Z"
tags: ["release", "snaky_hash", "v2.0.3"]
---

## [2.0.3] - 2025-05-23
- TAG: [v2.0.3][2.0.3t]
-  COVERAGE: 100.00% -- 132/132 lines in 7 files
-  BRANCH COVERAGE: 100.00% -- 38/38 branches in 7 files
- 100.00% documented
### Added
- `#dump` instance method injected by `extend SnakyHash::Serializer` (@pboling)
- `dump_hash_extensions` - new feature, analogous to `load_hash_extensions` (@pboling)
- `dump_value_extensions` - alternate name for `dump_extensions` (@pboling)
- `load_value_extensions` - alternate name for `load_extensions` (@pboling)
- Clarifying documentation (@pboling)
### Fixed
- [gh4](https://github.com/oauth-xx/snaky_hash/pull/4) - Serializer extensions dump and load empty values properly (@pboling)
  - Fixed `dump_extensions`, `load_extensions`, `load_hash_extensions`
  - Intended usage is primarily JSON, and oauth2 gem
  - OAuth2 spec can have legitimately empty values (e.g. scopes could be empty)
  - Previous logic was inherited from design decisions made by `serialized_hashie` gem; doesn't apply here

## What's Changed
* Release/v2.0.3 by @pboling in https://github.com/oauth-xx/snaky_hash/pull/4

**Full Changelog**: https://github.com/oauth-xx/snaky_hash/compare/v2.0.2...v2.0.3

[2.0.3]: https://gitlab.com/oauth-xx/snaky_hash/-/compare/v2.0.2...v2.0.3
[2.0.3t]: https://gitlab.com/oauth-xx/snaky_hash/-/releases/tag/v2.0.3

