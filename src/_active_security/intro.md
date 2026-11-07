---
layout: post
title: Introducing active_security
date: 2024-05-30
tags: ["introduction", "active_security"]
---

ActiveSecurity adds checks around ActiveRecord queries. Models can reject unscoped lookups, require an owning association such as a tenant, and detect query predicates that were not handled. Configure protections per model with `active_security`, or establish shared defaults with `ActiveSecurity.defaults`.

Read the [upstream README](https://github.com/galtzo-floss/active_security/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/galtzo-floss/active_security).
