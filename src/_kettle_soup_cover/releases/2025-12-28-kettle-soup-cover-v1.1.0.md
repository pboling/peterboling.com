---
layout: post
title: "kettle-soup-cover v1.1.0 released!"
date: "2025-12-28T21:07:01Z"
tags: ["release", "kettle-soup-cover", "v1.1.0"]
---

## [1.1.0] - 2025-12-28

- TAG: [v1.1.0][1.1.0t]
- COVERAGE: 93.62% -- 132/141 lines in 10 files
- BRANCH COVERAGE: 53.33% -- 16/30 branches in 10 files
- 15.56% documented

### Added

- When `ENV["MAX_ROWS"] == "0"`, explicitly, skip simplecov-console TTY output.
- Script `exe/kettle-soup-cover` generates coverage report
  - defaults to reading `$K_SOUP_COV_DIR/coverage.json`
  - prints a summarized report
  - accepts `-p/--path` or a positional path to coverage.json
  - requires the `json` formatter be configured in `$K_SOUP_COV_FORMATTERS` (or an explicit JSON path as above).

### Changed

- **Coverage merging is now enabled by default** - `USE_MERGING` defaults to `true`
  - Essential for projects that split tests into multiple rake tasks
  - Set `K_SOUP_COV_USE_MERGING=false` to disable
  - Aggregate coverage from multiple test runs (e.g., FFI specs, integration specs, unit specs) when uniquely named:
  - ```rake

    # Matrix checks will run in between FFI and MRI

    desc("Run Backend Matrix Specs")
    RSpec::Core::RakeTask.new(:backend_matrix_specs) do |t|
    t.pattern = "./spec_matrix/**/*_spec.rb"
    end
    desc("Set SimpleCov command name for backend matrix specs")
    task(:set_matrix_command_name) do
    ENV["K_SOUP_COV_COMMAND_NAME"] = "Backend Matrix Specs"
    end
    Rake::Task[:backend_matrix_specs].enhance([:set_matrix_command_name])
    ```
- **Merge timeout** - `MERGE_TIMEOUT` defaults to 3600 seconds (1 hour)
  - Sufficient for most test suites to complete all split tasks
  - Set `K_SOUP_COV_MERGE_TIMEOUT` to override

[1.1.0]: https://github.com/kettle-rb/kettle-soup-cover/compare/v1.0.10...v1.1.0
[1.1.0t]: https://github.com/kettle-rb/kettle-soup-cover/releases/tag/v1.1.0

Official Discord 👉️ [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite]

Many paths lead to being a sponsor or a backer of this project. Are you on such a path?

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal]

[![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS efforts using Patreon][🖇patreon-img]][🖇patreon]

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-backers]: https://opencollective.com/kettle-rb#backer
[🖇osc-backers-i]: https://opencollective.com/kettle-rb/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/kettle-rb#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/kettle-rb/sponsors/badge.svg?style=flat
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/O5O86SNP4
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-a51611.svg?style=flat
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-%E2%9C%93-a51611.svg?style=flat
[🖇buyme]: https://www.buymeacoffee.com/pboling
[🖇paypal-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=flat&logo=paypal
[🖇paypal]: https://www.paypal.com/paypalme/peterboling
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img]: https://img.shields.io/discord/1373797679469170758?style=flat
