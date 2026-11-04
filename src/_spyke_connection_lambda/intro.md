---
layout: post
title: Introducing spyke-connection_lambda
date: 2026-02-25
tags: ["introduction", "spyke-connection_lambda"]
---

Spyke ConnectionLambda decorates the connection supplied by a Spyke model. A configured callable receives the inherited connection and returns the connection to use. This provides a small integration point for tenant-specific routing, instrumentation, or connection choices in tests.

Read the [upstream README](https://github.com/galtzo-floss/spyke-connection_lambda/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/galtzo-floss/spyke-connection_lambda).
