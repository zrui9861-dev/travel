#!/bin/bash
# =============================================================================
#  TerraPortal - one-click launcher for macOS
#  Double-click in Finder. First time only: right-click > Open, because the file
#  is not signed. Close Terminal or press Ctrl+C to stop.
#
#  Each runtime is tested by running it, not just by finding a name.
# =============================================================================
cd "$(dirname "$0")" || exit 1
PORT=${1:-8731}

if command -v node >/dev/null 2>&1 && node --version >/dev/null 2>&1; then
  echo "  TerraPortal: starting with Node..."
  exec node serve.js "$PORT"
fi

if command -v python3 >/dev/null 2>&1 && python3 -c "import sys" >/dev/null 2>&1; then
  echo "  TerraPortal: starting with Python..."
  ( sleep 2; open "http://127.0.0.1:$PORT/" ) &
  exec python3 -m http.server "$PORT" --bind 127.0.0.1
fi

echo "  Neither Node.js nor Python3 is available. Opening index.html directly."
open "index.html"
