---
layout: post
title: Introducing tree_haver
date: 2026-02-25
tags: ["introduction", "tree_haver"]
---

TreeHaver gives Ruby code a common interface to several parsing backends. Its registry handles parser discovery and capability reporting so callers can select a suitable backend for their runtime. The StructuredMerge libraries build on this layer instead of embedding parser-selection logic in each format package.

Read the [upstream README](https://github.com/structuredmerge/structuredmerge-ruby/blob/main/gems/tree_haver/README.md) for installation and usage, or browse the [project repository](https://github.com/structuredmerge/structuredmerge-ruby).
