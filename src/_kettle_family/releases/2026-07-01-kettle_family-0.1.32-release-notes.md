---
layout: "post"
title: "kettle-family 0.1.32: Avoid a TruffleRuby release-thread crash"
date: "2026-07-01"
tags: ["release", "kettle-family", "0.1.32"]
source_release: "https://github.com/kettle-dev/kettle-family/releases/tag/v0.1.32"
coverage_review: "2026-11-04"
---

Version 0.1.32 executes release members sequentially on TruffleRuby. This works around the documented ENV.replace crash in parallel release threads until environment handling is made safe.

Read the [upstream release notes](https://github.com/kettle-dev/kettle-family/releases/tag/v0.1.32) for the complete changes and see the [project repository](https://github.com/kettle-dev/kettle-family) for usage and installation.
