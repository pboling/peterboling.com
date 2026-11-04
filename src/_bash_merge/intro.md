---
layout: post
title: Introducing bash-merge
date: 2026-02-25
tags: ["introduction", "bash-merge"]
---

Bash::Merge combines Bash files using syntax-tree structure. It matches functions and variable assignments, retains surrounding comments and shebangs, and supports marked regions that should remain untouched. Parser support comes through TreeHaver’s registered backends, with merge infrastructure from Ast::Merge.

Read the [upstream README](https://github.com/structuredmerge/structuredmerge-ruby/blob/main/gems/bash-merge/README.md) for installation and usage, or browse the [project repository](https://github.com/structuredmerge/structuredmerge-ruby).
