#!/usr/bin/env bash
set -euo pipefail

cd /var/home/pboling/src/peterboling.com
mise exec -- ruby scripts/check_new_releases.rb