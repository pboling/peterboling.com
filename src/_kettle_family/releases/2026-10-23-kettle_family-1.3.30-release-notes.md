---
layout: "post"
title: "kettle-family 1.3.30: Templating without an available mise executable"
date: "2026-10-23"
tags: ["release", "kettle-family", "1.3.30"]
source_release: "https://github.com/kettle-dev/kettle-family/releases/tag/v1.3.30"
coverage_review: "2026-11-04"
---

Version 1.3.30 makes mise optional throughout template execution. It resolves an absolute executable when available and avoids the wrapper and trust step when absent, preventing ENOENT failures in stripped subprocess environments.

Read the [upstream release notes](https://github.com/kettle-dev/kettle-family/releases/tag/v1.3.30) for the complete changes and see the [project repository](https://github.com/kettle-dev/kettle-family) for usage and installation.
