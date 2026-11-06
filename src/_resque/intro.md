---
layout: post
title: Introducing resque
date: 2024-05-17
tags: ["introduction", "resque"]
---

Resque uses Redis to queue background work. Jobs expose a `perform` method, workers consume named queues, and a web interface helps inspect queues and failures. This lets a Ruby application move work out of a request while retaining explicit control over which workers process which queues.

Read the [upstream README](https://github.com/resque/resque/blob/master/README.markdown) for installation and usage, or browse the [project repository](https://github.com/resque/resque).
