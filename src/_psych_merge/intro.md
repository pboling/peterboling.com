---
layout: post
title: Introducing psych-merge
date: 2026-02-19
tags: ["introduction", "psych-merge"]
---

Psych::Merge supplies a Psych-backed provider for StructuredMerge’s YAML family. It validates and projects YAML syntax into the shared source-preserving merge behavior. The README directs targeted insertions, replacements, and deletions through `ast-crispr`, preserving document structure instead of round-tripping through Ruby hashes.

Read the [upstream README](https://github.com/structuredmerge/structuredmerge-ruby/blob/main/gems/psych-merge/README.md) for installation and usage, or browse the [project repository](https://github.com/structuredmerge/structuredmerge-ruby).
