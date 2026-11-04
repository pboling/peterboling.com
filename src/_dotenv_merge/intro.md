---
layout: post
title: Introducing dotenv-merge
date: 2026-02-25
tags: ["introduction", "dotenv-merge"]
---

Dotenv::Merge combines `.env` files by variable name instead of treating every line as unrelated text. It accounts for comments, blank lines, exports, and protected regions. Its parser is registered through TreeHaver’s line backend, making it part of the same merge pipeline as the other StructuredMerge formats.

Read the [upstream README](https://github.com/structuredmerge/structuredmerge-ruby/blob/main/gems/dotenv-merge/README.md) for installation and usage, or browse the [project repository](https://github.com/structuredmerge/structuredmerge-ruby).
