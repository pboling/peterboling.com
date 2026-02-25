---
layout: post
title: "omniauth-openid v2.0.2 released!"
date: "2025-06-08T10:51:42Z"
tags: ["release", "omniauth-openid", "v2.0.2"]
---

## [2.0.2] - 2025-06-08
- TAG: [v2.0.2][2.0.2t]
- COVERAGE: 92.06% -- 348/378 lines in 15 files
- BRANCH COVERAGE: 79.49% -- 62/78 branches in 15 files
- 44.44% documented
### Added
- Github Actions for Continuous Integration by @pboling
  - Test workflows with latest dependencies and more platform and dep HEADs
  - Expanded test suite, covering many more points of the dependency matrix
- More documentation by @pboling, @Aboling0
- 20 year signing cert expires 2045-04-29 by @pboling
- Added CITATION.cff by @pboling
- devcontainer for easier maintenance by @pboling
- Add SECURITY.md policy by @pboling
- CONTRIBUTING.md - Instructions for contributing by @pboling
- Modernized gem structure, and updated dependencies for development by @pboling
- Set `SKIP_GEM_SIGNING` in env to allow `gem build` without cryptographic signing requirement by @pboling
  - Useful for linux distros whose package managers sign packages independently
- Example client / server in `/examples` by @pboling
### Changed
- Updated Code of Conduct to Contributor Covenant v2.1 by @pboling

[2.0.2]: https://github.com/omniauth/omniauth-openid/compare/v2.0.2...v2.0.1
[2.0.2t]: https://github.com/omniauth/omniauth-openid/tags/v2.0.2

## What's Changed
* add option to set trust_root by @btalbot in https://github.com/omniauth/omniauth-openid/pull/31
* Add "nil" to example by @SixArm in https://github.com/omniauth/omniauth-openid/pull/13
* Support another build header of Rack/openid by @DianthuDia in https://github.com/omniauth/omniauth-openid/pull/19
* Bump rexml from 3.2.4 to 3.2.5 by @dependabot in https://github.com/omniauth/omniauth-openid/pull/48
* Bump addressable from 2.7.0 to 2.8.1 by @dependabot in https://github.com/omniauth/omniauth-openid/pull/52
* Bump sinatra from 2.1.0 to 4.1.0 by @dependabot in https://github.com/omniauth/omniauth-openid/pull/57
* Bump rexml from 3.2.5 to 3.3.9 by @dependabot in https://github.com/omniauth/omniauth-openid/pull/56
* Bump yard from 0.9.26 to 0.9.36 by @dependabot in https://github.com/omniauth/omniauth-openid/pull/58
* Bump rack from 3.1.13 to 3.1.14 by @dependabot in https://github.com/omniauth/omniauth-openid/pull/59
* Bump rack-session from 2.1.0 to 2.1.1 by @dependabot in https://github.com/omniauth/omniauth-openid/pull/60
* 📝 Update README by @Aboling0 in https://github.com/omniauth/omniauth-openid/pull/61
* 📝 Update README by @Aboling0 in https://github.com/omniauth/omniauth-openid/pull/62
* Bump rack from 3.1.14 to 3.1.16 by @dependabot in https://github.com/omniauth/omniauth-openid/pull/63
* Modernize Codebase by @pboling in https://github.com/omniauth/omniauth-openid/pull/64
* ✏️ Fixed a typo by @Aboling0 in https://github.com/omniauth/omniauth-openid/pull/66

## New Contributors
* @btalbot made their first contribution in https://github.com/omniauth/omniauth-openid/pull/31
* @SixArm made their first contribution in https://github.com/omniauth/omniauth-openid/pull/13
* @DianthuDia made their first contribution in https://github.com/omniauth/omniauth-openid/pull/19
* @dependabot made their first contribution in https://github.com/omniauth/omniauth-openid/pull/48
* @Aboling0 made their first contribution in https://github.com/omniauth/omniauth-openid/pull/61
* @pboling made their first contribution in https://github.com/omniauth/omniauth-openid/pull/64

**Full Changelog**: https://github.com/omniauth/omniauth-openid/compare/v2.0.1...v2.0.2
