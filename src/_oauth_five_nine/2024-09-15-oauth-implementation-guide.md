---
layout: post
title: "OAuth 2.0 Implementation Guide"
date: 2024-09-15 10:00:00 +0000
---

This guide will walk you through implementing OAuth 2.0 authentication using oauth-five-nine.

## Getting Started

Add the gem to your Gemfile:

```ruby
gem 'oauth-five-nine'
```

## Basic Setup

Configure your OAuth provider:

```ruby
OauthFiveNine.configure do |config|
  config.client_id = ENV['OAUTH_CLIENT_ID']
  config.client_secret = ENV['OAUTH_CLIENT_SECRET']
  config.redirect_uri = 'http://localhost:3000/callback'
end
```

## Authorization Flow

The OAuth 2.0 authorization code flow:

1. Redirect user to authorization endpoint
2. User grants permission
3. Receive authorization code
4. Exchange code for access token
5. Use access token to access protected resources

## Next Steps

Check out our examples repository for more advanced use cases!
