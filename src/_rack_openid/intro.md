---
layout: post
title: Introducing rack-openid
date: 2024-09-04
tags: ["introduction", "rack-openid"]
---

Rack::OpenID exposes legacy OpenID authentication through Rack responses and environment data. An application initiates authentication with a 401 response and an OpenID `WWW-Authenticate` header, then reads the verified response from `env["rack.openid.response"]`. The catalog’s older repository README now directs installation to `rack-openid2`.

Read the [upstream README](https://github.com/ruby-openid/rack-openid/blob/master/README.md) for installation and usage, or browse the [project repository](https://github.com/ruby-openid/rack-openid).
