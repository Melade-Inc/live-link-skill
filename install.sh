#!/usr/bin/env sh
# Installs the pinned Live.link CLI globally and runs its diagnostics.
# Requires Node 22.12 or newer; without one, publish over the HTTP API: https://live.link/start
set -eu
PIN="0.1.0"
if ! command -v node >/dev/null 2>&1; then
  echo "Node 22.12 or newer is required: https://nodejs.org" >&2
  exit 1
fi
VERSION="$(node -p 'process.versions.node')"
MAJOR="${VERSION%%.*}"
REST="${VERSION#*.}"
MINOR="${REST%%.*}"
if [ "$MAJOR" -lt 22 ] || { [ "$MAJOR" -eq 22 ] && [ "$MINOR" -lt 12 ]; }; then
  echo "Node $VERSION found; Live.link needs 22.12 or newer. Without a newer Node, publish over the HTTP API: https://live.link/start" >&2
  exit 1
fi
npm install -g "live-link@$PIN"
live-link doctor
