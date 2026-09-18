#!/usr/bin/env sh
# Runs the pinned Live.link CLI without a global install. Requires Node 22.12 or newer.
set -eu
exec npx -y live-link@0.1.2 connect "$@"
