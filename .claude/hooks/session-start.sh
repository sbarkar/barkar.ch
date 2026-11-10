#!/bin/bash
# Install dependencies in Claude Code cloud sessions so build/lint work immediately.
# Local sessions are left alone — run `yarn install --frozen-lockfile` yourself there.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"
# --ignore-scripts: build and lint work without dependency install scripts, so do not
# run third-party lifecycle scripts automatically at session start.
yarn install --frozen-lockfile --non-interactive --ignore-scripts >/dev/null
