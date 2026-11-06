---
layout: post
title: Introducing warden_oauth
date: 2025-10-19
tags: ["introduction", "warden_oauth"]
---

Warden OAuth adds helpers for OAuth strategies in Rack applications using Warden. Applications declare named services on `Warden::Manager` and route authentication through the generated strategy for each service. The README documents the integration points for connecting those services to an application.

See the [upstream README](https://github.com/ruby-oauth/warden_oauth/blob/main/README.md) and [project repository](https://github.com/ruby-oauth/warden_oauth).
