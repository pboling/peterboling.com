---
layout: "post"
title: "kettle-jem-appraisals 0.1.5: Security floors in generated appraisals"
date: "2026-09-19"
tags: ["release", "kettle-jem-appraisals", "0.1.5"]
source_release: "https://github.com/appraisal-rb/kettle-jem-appraisals/releases/tag/v0.1.5"
coverage_review: "2026-11-04"
---

Version 0.1.5 incorporates Kettle::Rb security floors into generated dependency requirements and warns about versions below those floors. It also makes --resolve fail when appraisal generation fails, so automation cannot report successful resolution after an earlier command error.

Read the [upstream release notes](https://github.com/appraisal-rb/kettle-jem-appraisals/releases/tag/v0.1.5) for the complete changes and see the [project repository](https://github.com/appraisal-rb/kettle-jem-appraisals) for usage and installation.
