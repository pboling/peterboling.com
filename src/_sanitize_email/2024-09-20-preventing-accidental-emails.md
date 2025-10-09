---
layout: post
title: "Preventing Accidental Emails in Development"
date: 2024-09-20 14:00:00 +0000
---

Learn how to use sanitize_email to prevent accidentally sending emails to real users during development.

## The Problem

During development, you might accidentally send emails to real users. This can be embarrassing and potentially harmful.

## The Solution

sanitize_email intercepts and sanitizes all emails in non-production environments.

```ruby
# config/initializers/sanitize_email.rb
SanitizeEmail::Config.configure do |config|
  config[:sanitized_to] = 'dev@example.com'
  config[:sanitized_cc] = 'dev@example.com'
  config[:sanitized_bcc] = nil
  
  config[:use_actual_email_prepended_to_subject] = true
  config[:use_actual_environment_prepended_to_subject] = true
  
  config[:activation_proc] = proc { !Rails.env.production? }
end
```

## Features

- Redirects all emails to specified addresses
- Preserves original recipients in subject/body
- Environment-aware activation
- Easy to configure and use

Now you can develop with confidence!
