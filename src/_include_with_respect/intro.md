---
layout: post
title: Introducing include_with_respect
date: 2026-02-25
tags: ["introduction", "include_with_respect"]
---

*Find out if your include/extend hooks are misbehaving!*

Modules have hooks on `include` and `extend`, among others. These will run every time a module is included or extended into another module or class. If the hooks should only run once, (think shared state), then running them multiple times can cause difficult to trace bugs. This gem allows developers to trace modules that are re-included multiple times into other objects.

### Getting Started

For more information and detailed examples, please visit the [documentation](https://github.com/galtzo-floss/include_with_respect).


### Supporting this Project
- [OpenCollective](https://opencollective.com/galtzo-floss)
- [SourceHut](https://git.sr.ht/~galtzo/include_with_respect)

