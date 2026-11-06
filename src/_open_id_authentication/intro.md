---
layout: post
title: Introducing open_id_authentication
date: 2024-09-05
tags: ["introduction", "open_id_authentication"]
---

OpenID Authentication integrates the Rack OpenID middleware with Rails. A Railtie installs the middleware and controller helpers start and finish authentication; callbacks receive the verified identifier and extension data. It targets applications retaining legacy OpenID support.

Read the [upstream README](https://github.com/ruby-openid/open_id_authentication/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/ruby-openid/open_id_authentication).
