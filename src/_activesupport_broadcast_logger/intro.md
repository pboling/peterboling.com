---
layout: post
title: Introducing activesupport-broadcast_logger
date: 2024-11-20
tags: ["introduction", "activesupport-broadcast_logger"]
---

This gem brings the Rails 8 BroadcastLogger API to older supported Rails versions. One logger can forward calls to several destinations and report their combined severity state. The README recommends loading it through `activesupport-tagged_logging`, which arranges the related logging components and their load order.

Read the [upstream README](https://github.com/galtzo-floss/activesupport-broadcast_logger/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/galtzo-floss/activesupport-broadcast_logger).
