---
layout: post
title: "Comprehensive Code Coverage for Ruby Projects"
date: 2024-09-28 11:15:00 +0000
---

Achieve comprehensive code coverage in your Ruby projects with kettle-soup-cover.

## What is kettle-soup-cover?

A collection of utilities to help you achieve and maintain high code coverage in Ruby projects.

## Setup

Add to your Gemfile:

```ruby
group :test do
  gem 'kettle-soup-cover'
end
```

## Configuration

```ruby
# spec/spec_helper.rb
require 'kettle_soup_cover'

KettleSoupCover.configure do |config|
  config.coverage_threshold = 95
  config.minimum_coverage = 90
  config.exclude_patterns = [
    'vendor/',
    'spec/'
  ]
end

KettleSoupCover.start
```

## Features

- Multiple coverage metrics
- Threshold enforcement
- Beautiful HTML reports
- CI/CD integration
- Branch coverage tracking

## CI Integration

Fail your builds if coverage drops:

```yaml
# .github/workflows/test.yml
- name: Run tests with coverage
  run: bundle exec rspec
- name: Check coverage
  run: bundle exec kettle-soup-cover check
```

Keep your codebase well-tested!
