#!/usr/bin/env sh
# Runs the pinned live.link CLI without a global install. Requires Node 22.12 or newer.
set -eu
exec npx -y live-link@0.1.4 connect "$@"
