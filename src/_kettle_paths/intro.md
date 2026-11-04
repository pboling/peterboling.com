---
layout: post
title: Introducing kettle-paths
date: 2026-11-04
tags: ["introduction", "kettle_paths"]
---

Kettle::Paths compares filesystem paths by identity — inode and file index — rather than by string, so a directory spelled two valid ways still compares equal: symlinked ancestors (`/home/x` vs `/var/home/x`) and Windows 8.3 short names (`RUNNER~1` vs `runneradmin`). The public API covers `canonical`, `same?`, `identical?`, `within?`, `relative`, `relative_from`, `glob`, `local_path_remote?`, and `path_parts`. It is pure Ruby with no dependencies, requires Ruby 2.4+, and is MIT-licensed so it can be shared across MIT and AGPL tooling.

Read the [upstream README](https://github.com/kettle-dev/kettle-paths/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/kettle-dev/kettle-paths).
