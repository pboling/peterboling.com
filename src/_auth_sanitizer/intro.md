---
layout: "post"
title: "Introducing auth-sanitizer"
date: "2026-05-15"
tags: ["introduction", "auth-sanitizer", "rubygems"]
source_readme: "https://github.com/ruby-oauth/auth-sanitizer/blob/main/README.md"
---

Auth Sanitizer offers two places to redact authentication secrets: Ruby object inspection and string messages sent through a wrapped logger. It includes defaults for common OAuth token and credential keys. Applications opt into these surfaces explicitly; the library does not rewrite requests or stored credentials.

Read the [upstream README](https://github.com/ruby-oauth/auth-sanitizer/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/ruby-oauth/auth-sanitizer).
