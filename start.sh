#!/bin/bash
# =============================================================================
#  TerraPortal - one-click launcher for Linux
#  Run:  ./start.sh          (or double-click in a file manager that supports it)
#
#  Each runtime is tested by running it, not just by finding a name.
# =============================================================================
cd "$(dirname "$0")" || exit 1
PORT=${1:-8731}

open_url() {
  if command -v xdg-open >/dev/null 2>&1; then xdg-open "$1" >/dev/null 2>&1 &
  elif command -v sensible-browser >/dev/null 2>&1; then sensible-browser "$1" >/dev/null 2>&1 &
  fi
}

if command -v node >/dev/null 2>&1 && node --version >/dev/null 2>&1; then
  echo "  TerraPortal: starting with Node..."
  exec node serve.js "$PORT"
fi

if command -v python3 >/dev/null 2>&1 && python3 -c "import sys" >/dev/null 2>&1; then
  echo "  TerraPortal: starting with Python..."
  ( sleep 2; open_url "http://127.0.0.1:$PORT/" ) &
  exec python3 -m http.server "$PORT" --bind 127.0.0.1
fi

echo "  Neither Node.js nor Python3 is available. Open index.html with your browser."
