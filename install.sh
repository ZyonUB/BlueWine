#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
APP="$HOME/Applications/Blue Wine.app"

echo "======================================"
echo "       BLUE WINE macOS INSTALLER"
echo "======================================"
echo "Installing the standalone Blue Wine UI demo."
echo "This does not patch Roblox or inject into a game."
echo

if ! command -v swiftc >/dev/null 2>&1; then
  echo "Swift compiler missing. Install it with:"
  echo "  xcode-select --install"
  exit 1
fi

mkdir -p "$HOME/Applications"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"

echo "==> Compiling..."
swiftc -O -framework SwiftUI -framework AppKit \
  "$ROOT/BlueWineApp.swift" -o "$APP/Contents/MacOS/BlueWine"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>BlueWine</string>
<key>CFBundleIdentifier</key><string>com.bluewine.desktop</string>
<key>CFBundleName</key><string>Blue Wine</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>LSMinimumSystemVersion</key><string>13.0</string>
</dict></plist>
PLIST

codesign --force --deep --sign - "$APP" >/dev/null 2>&1 || true
echo "==> Installed to $APP"
open "$APP"
echo "Installation complete."
