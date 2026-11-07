---
layout: post
title: Introducing namespaced-gem
date: 2026-03-08
tags: ["introduction", "namespaced-gem"]
---

Namespaced Gem is a RubyGems plugin that lets gemspec dependencies be declared as full URIs pointing at namespaced gem sources such as gem.coop namespaces, for example `https://beta.gem.coop/@myspace/my-gem`. Once installed it patches both RubyGems’ resolver (`gem install`) and Bundler’s (`bundle install`) to parse URI dependency names, route them to the right namespace source, and remap transitive dependencies on the fly, so `gem install @kaspth/oaken` and URI dependencies in gemspecs both work.

The original discussion is [gem-coop/gem.coop#12](https://github.com/gem-coop/gem.coop/issues/12).

Browse the [project repository](https://gitlab.com/galtzo-floss/namespaced-gem).
