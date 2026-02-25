---
layout: post
title: Introducing resque-lonely_job
date: 2026-02-25
tags: ["introduction", "resque-lonely_job"]
---


A [semanticaly versioned](http://semver.org/)
[Resque](https://github.com/resque/resque) plugin which ensures for a given
queue, that only one worker is working on a job at any given time.

Resque::LonelyJob differs from [resque-queue-lock](https://github.com/mashion/resque-queue-lock), [resque-lock](https://github.com/defunkt/resque-lock) and
[resque-loner](http://github.com/jayniz/resque-loner) in that the same job may
be queued multiple times but you're guaranteed that first job queued will run to
completion before subsequent jobs are run.

### Getting Started

For more information and detailed examples, please visit the [documentation](https://github.com/resque/resque-lonely_job).


### Supporting this Project
- [OpenCollective](https://opencollective.com/resque)

