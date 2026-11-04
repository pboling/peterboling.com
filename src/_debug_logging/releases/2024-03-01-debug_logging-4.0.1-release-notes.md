---
layout: "post"
title: "debug_logging 4.0.1: Accept numeric monotonic timestamps"
date: "2024-03-01"
tags: ["release", "debug_logging", "4.0.1"]
source_release: "https://github.com/galtzo-floss/debug_logging/blob/main/CHANGELOG.md"
coverage_review: "2026-11-04"
---

Version 4.0.1 accepts all Numeric timestamp types for ActiveSupport notifications. This fixes an integration assumption that could reject otherwise valid monotonic timing values.

Read the [upstream release notes](https://github.com/galtzo-floss/debug_logging/blob/main/CHANGELOG.md) for the complete changes and see the [project repository](https://github.com/galtzo-floss/debug_logging) for usage and installation.
