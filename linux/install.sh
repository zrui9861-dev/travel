#!/usr/bin/env bash
# ---------------------------------------------------------------------------
#  TerraPortal — install as a Linux desktop application
#
#    ./install.sh            add it to your application menu (+ a Desktop shortcut)
#    ./install.sh --remove   undo everything it did
#    ./install.sh --no-desktop   menu entry only, no Desktop shortcut
#
#  Nothing is copied out of this folder except the icon: the launcher points at
#  start.sh where it lives, so updating the app is just updating this checkout.
# ---------------------------------------------------------------------------
set -eu

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$HERE")"

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
APPS_DIR="$DATA_HOME/applications"
ICON_DIR="$DATA_HOME/icons/hicolor/256x256/apps"
DESKTOP_FILE="$APPS_DIR/terraportal.desktop"
ICON_FILE="$ICON_DIR/terraportal.png"
DESKTOP_SHORTCUT="$HOME/Desktop/terraportal.desktop"

say() { printf '  %s\n' "$*"; }
fail() { printf '\n  %s\n\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------- uninstall
if [ "${1:-}" = "--remove" ]; then
  rm -f "$DESKTOP_FILE" "$ICON_FILE" "$DESKTOP_SHORTCUT"
  command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$APPS_DIR" 2>/dev/null || true
  say "Removed the menu entry, the icon and the Desktop shortcut."
  say "The application itself is untouched — it is just this folder."
  exit 0
fi

# ------------------------------------------------------------------- checks
[ -f "$ROOT/index.html" ] || fail "index.html not found — install.sh must stay inside the TerraPortal folder."
[ -f "$ROOT/start.sh" ] || fail "start.sh not found — is this a complete checkout?"

chmod +x "$ROOT/start.sh" 2>/dev/null || true
command -v node >/dev/null 2>&1 || command -v python3 >/dev/null 2>&1 || {
  say "Warning: neither Node.js nor Python 3 was found."
  say "         Install one of them, or the launcher will fall back to opening"
  say "         index.html directly."
}

# ------------------------------------------------------------------ install
mkdir -p "$APPS_DIR" "$ICON_DIR"
install -m 644 "$HERE/terraportal.png" "$ICON_FILE"

# Exec needs quoting if the path has spaces
EXEC_PATH="$ROOT/start.sh"
case "$EXEC_PATH" in
  *" "*) EXEC_LINE="\"$EXEC_PATH\"" ;;
  *)     EXEC_LINE="$EXEC_PATH" ;;
esac

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=TerraPortal
GenericName=Travel atlas
Comment=An immersive travel atlas with a footprint globe
Exec=$EXEC_LINE
Path=$ROOT
Icon=terraportal
Terminal=true
Categories=Education;Geography;Travel;
Keywords=travel;map;globe;footprint;atlas;
StartupNotify=true
EOF
chmod 755 "$DESKTOP_FILE"
say "Menu entry: $DESKTOP_FILE"

if [ "${1:-}" != "--no-desktop" ]; then
  if [ -d "$HOME/Desktop" ]; then
    cp -f "$DESKTOP_FILE" "$DESKTOP_SHORTCUT"
    chmod 755 "$DESKTOP_SHORTCUT"
    # GNOME only launches desktop files it considers trusted
    if command -v gio >/dev/null 2>&1; then
      gio set "$DESKTOP_SHORTCUT" metadata::trusted true 2>/dev/null || true
    fi
    say "Desktop shortcut: $DESKTOP_SHORTCUT"
  else
    say "No ~/Desktop folder — menu entry only."
  fi
fi

command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$APPS_DIR" 2>/dev/null || true
command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -f -t "$DATA_HOME/icons/hicolor" 2>/dev/null || true

echo
say "Done. Look for TerraPortal in your application menu."
say "To undo: $HERE/install.sh --remove"
echo
