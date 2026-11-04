---
layout: post
title: Introducing stone_checksums
date: 2026-02-25
tags: ["introduction", "stone_checksums"]
---

Stone Checksums generates SHA-256 and SHA-512 digests for built Ruby gems so the checksums can be kept with the release source. The README exposes both `build:generate_checksums` as a Rake task and a `bin/generate_checksums` entry point. This makes release artifact verification part of the project workflow.

Read the [upstream README](https://github.com/galtzo-floss/stone_checksums/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/galtzo-floss/stone_checksums).
