---
layout: post
title: Introducing activesupport-logger
date: 2024-10-10
tags: ["introduction", "activesupport-logger"]
---

This backport makes Rails 8 ActiveSupport logger behavior available to older supported Rails applications. It includes thread-local severity handling and formatter behavior. The README recommends integrating through `activesupport-tagged_logging` or `activesupport-broadcast_logger` so the dependencies load in the required order.

Read the [upstream README](https://github.com/galtzo-floss/activesupport-logger/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/galtzo-floss/activesupport-logger).
