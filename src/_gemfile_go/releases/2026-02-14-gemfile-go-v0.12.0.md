---
layout: post
title: "gemfile-go v0.12.0 released!"
date: "2026-02-14T01:46:36Z"
tags: ["release", "gemfile-go", "v0.12.0"]
---

## [0.12.0](https://github.com/contriboss/gemfile-go/compare/v0.11.0...v0.12.0) (2026-02-14)


### Features

* Enhance Ruby logic support in Gemfiles ([1808d5e](https://github.com/contriboss/gemfile-go/commit/1808d5e7689fc6eb340d74538151bd3444a7c481))
* improve if/unless detection to avoid false positives from comments/strings ([415474f](https://github.com/contriboss/gemfile-go/commit/415474f59ebbf74238e5dc5a3f0c523fd3521662))
* make filePath parameter optional for backwards compatibility ([fd0fd76](https://github.com/contriboss/gemfile-go/commit/fd0fd76bfd0efc3bea657a4e1995a84c8ac78cbd))
* normalize relative path sources in tree-sitter parser ([aa71e54](https://github.com/contriboss/gemfile-go/commit/aa71e5474363e05aa9983ff10685445a36b4c777))
* raise error on RUBY_VERSION/RUBY_ENGINE conditions instead of logging ([8961a14](https://github.com/contriboss/gemfile-go/commit/8961a14ddb9e35b9140317a212ad917ccbd71cc6))


### Bug Fixes

* correct indentation in test function ([14a4030](https://github.com/contriboss/gemfile-go/commit/14a403071a763580a3545f97a6991b063b4cbc60))
* relative path resolution in eval_gemfile to match Bundler behavior ([4b3be71](https://github.com/contriboss/gemfile-go/commit/4b3be71cf7038ddfbf3730affdaf850e45108a10))
* Remove ENV value logging to prevent secret leakage in CI logs ([ea3e573](https://github.com/contriboss/gemfile-go/commit/ea3e57340535b874504240fbca2b823f488b44f2))
