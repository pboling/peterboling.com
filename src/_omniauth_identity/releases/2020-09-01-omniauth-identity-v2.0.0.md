---
layout: post
title: "omniauth-identity v2.0.0 released!"
date: "2020-09-01T18:59:33Z"
tags: ["release", "omniauth-identity", "v2.0.0"]
---

Note: The only potential breaking change is the removal of MongoMapper integration.

### Added 
- CHANGELOG to maintain a history of changes.
- Include mongoid-rspec gem.

### Changed
- Fix failing Specs
- Update Spec syntax to RSpec 3
- Fix deprecation Warnings
- Updated mongoid_spec.rb to leverage mongoid-rspec features.
- Fix security warning about missing secret in session cookie.
- Dependency version limits so that the most up-to-date gem dependencies are used. (rspec 3+, mongo 2+, mongoid 7+, rake 13+, rack 2+, json 2+)
- Updated copyright information.
- Updated MongoMapper section of README to reflect its discontinued support.

### Removed
- Gemfile.lock file
- MongoMapper support; unable to satisfy dependencies of both MongoMapper and Mongoig now that MongoMapper is no longer actively maintained.
