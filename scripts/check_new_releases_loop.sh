#!/usr/bin/env bash
set -euo pipefail

cd /var/home/pboling/src/peterboling.com
# Load .env.local if present in the project root
if [ -f .env.local ]; then
  set -a
  source .env.local
  set +a
fi
mise exec -- ruby scripts/check_new_releases.rb