---
layout: post
title: Introducing omniauth-jwt
date: 2026-02-25
tags: ["introduction", "omniauth-jwt"]
---


[JSON Web Token](http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html) (JWT) is a simple
way to send verified information between two parties online. This can be useful as a mechanism for
providing Single Sign-On (SSO) to an application by allowing an authentication server to send a validated
claim and log the user in. This is how [Zendesk does SSO](https://support.zendesk.com/hc/en-us/articles/4408845838874-Enabling-JWT-JSON-Web-Token-single-sign-on),
for example.

OmniAuth::JWT provides a clean, simple wrapper on top of JWT so that you can easily implement this kind
of SSO either between your own applications or allow third parties to delegate authentication.

### Getting Started

For more information and detailed examples, please visit the [documentation](https://github.com/omniauth/omniauth-jwt).

