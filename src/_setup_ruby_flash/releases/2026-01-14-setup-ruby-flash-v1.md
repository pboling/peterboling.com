---
layout: post
title: "setup-ruby-flash v1 released!"
date: "2026-01-14T11:48:32Z"
tags: ["release", "setup-ruby-flash", "v1"]
---

# ⚡️ setup-ruby-flash

A _fast_ GitHub Action for fast Ruby environment setup using [rv](https://github.com/spinel-coop/rv) for Ruby installation and [ore](https://github.com/contriboss/ore-light) for gem management.

**⚡ Install Ruby in under 2 seconds** — no compilation required!

**⚡ Install Gems 50% faster** — using ORE ✅️!

## Features

- 🚀 **Lightning-fast Ruby installation** via prebuilt binaries from rv
- 📦 **Rapid gem installation** with ore (Bundler-compatible, ~50% faster)
- 💾 **Intelligent caching** for both Ruby and gems
- 🔒 **Security auditing** via `ore audit`
- 🐧 **Linux & macOS support** (x86_64 and ARM64)

## Requirements

- **Operating Systems**: Ubuntu 22.04+, macOS 14+
- **Architectures**: x86_64, ARM64
- **Ruby Versions**: 3.2, 3.3, 3.4, 4.0

> **Note**: Windows is not supported. For Windows CI, use [ruby/setup-ruby](https://github.com/ruby/setup-ruby).

