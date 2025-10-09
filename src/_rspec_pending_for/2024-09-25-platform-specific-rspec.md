---
layout: post
title: "Platform-Specific RSpec Examples"
date: 2024-09-25 09:30:00 +0000
---

Sometimes you need to mark specs as pending for specific Ruby versions or platforms. Here's how to do it with rspec-pending_for.

## Installation

```ruby
gem 'rspec-pending_for'
```

## Usage

Mark specs as pending for specific Ruby versions:

```ruby
it "uses advanced Ruby 3.2 features", pending_for: { ruby: "2.7" } do
  # This will be pending on Ruby 2.7
  expect(some_ruby_32_feature).to work
end
```

Mark specs as pending for specific platforms:

```ruby
it "uses Linux-specific features", pending_for: { platform: :windows } do
  # This will be pending on Windows
  expect(linux_feature).to work
end
```

## Why Use This?

- Document platform/version-specific behavior
- Keep specs green across different environments
- Make compatibility issues visible
- Maintain a comprehensive test suite

Great for maintaining gems across multiple Ruby versions!
