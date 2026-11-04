---
layout: "post"
title: "sanitize_email 2.0.1: Handle frozen email subjects"
date: "2018-03-07"
tags: ["release", "sanitize_email", "2.0.1"]
source_release: "https://github.com/galtzo-floss/sanitize_email/blob/main/CHANGELOG.md"
coverage_review: "2026-11-04"
---

Version 2.0.1 corrects subject handling when the original subject is frozen. Email interception can modify its output without requiring the caller to provide a mutable subject string.

Read the [upstream release notes](https://github.com/galtzo-floss/sanitize_email/blob/main/CHANGELOG.md) for the complete changes and see the [project repository](https://github.com/galtzo-floss/sanitize_email) for usage and installation.
