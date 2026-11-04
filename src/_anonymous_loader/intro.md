---
layout: "post"
title: "Introducing anonymous_loader"
date: "2026-11-04"
tags: ["introduction", "anonymous_loader", "rubygems"]
source_readme: "https://github.com/ruby-oauth/anonymous_loader/blob/main/README.md"
---

AnonymousLoader evaluates Ruby files inside a fresh anonymous module. Constants declared by the loaded code stay under that returned namespace, reducing collisions with the host process. It can resolve files through RubyGems metadata and fall back to the load path for environments such as standalone Bundler.

Read the [upstream README](https://github.com/ruby-oauth/anonymous_loader/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/ruby-oauth/anonymous_loader).
