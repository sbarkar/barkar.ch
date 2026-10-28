#!/bin/bash
# Install dependencies in Claude Code cloud sessions so build/lint work immediately.
# Local sessions are left alone — run `yarn install --frozen-lockfile` yourself there.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"
yarn install --frozen-lockfile --non-interactive >/dev/null
