---
layout: post
title: Introducing rack-openid2
date: 2024-09-04
tags: ["introduction", "rack-openid2"]
---

Rack OpenID2 wraps `ruby-openid2` as middleware. It handles the provider round trip and puts the verified result in the Rack environment. Applications can also use `Rack::OpenID::SimpleAuth` to protect a route for a fixed identifier; the README includes integration examples for legacy OpenID.

Read the [upstream README](https://github.com/ruby-openid/rack-openid2/blob/main/README.md) for installation and usage, or browse the [project repository](https://github.com/ruby-openid/rack-openid2).
