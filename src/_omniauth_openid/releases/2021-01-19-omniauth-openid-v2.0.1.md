---
layout: post
title: "omniauth-openid v2.0.1 released!"
date: "2021-01-19T18:12:19Z"
tags: ["release", "omniauth-openid", "v2.0.1"]
---

This release relaxes the omniauth version requirement to allow omniauth v2.0.0.

While v2.0.0 of this gem was tagged for a while, it was never pushed to rubygems. It removed the "steam" strategy from the gem, and so was tagged as a breaking change. 

If you need a steam strategy, you can try [omniauth-steam](https://github.com/reu/omniauth-steam), but this is neither a guarantee of functionality nor an official recommendation. 
