---
layout: post
title: Introducing library_tree
date: 2025-08-12
tags: ["introduction", "library_tree"]
---

LibraryTree tracks where a Ruby module is included. Adding `LibraryTree::Watcher` to a module gives you a way to inspect its inclusion tree, useful when tracing how a library spreads through a larger application. The README’s minimal integration adds the watcher inside the module definition.

Read the [upstream README](https://github.com/galtzo-floss/library_tree/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/galtzo-floss/library_tree).
