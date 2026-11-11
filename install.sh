
#!/bin/bash
set -euo pipefail

APP="$HOME/Applications/Blue Wine.app"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

SOURCE="https://raw.githubusercontent.com/ZyonUB/BlueWine/main/BlueWineApp.swift"

echo "======================================"
echo "       BLUE WINE macOS INSTALLER"
echo "======================================"

if ! command -v swiftc >/dev/null 2>&1; then
  echo "Installing Xcode command line tools is required:"
  echo "Run: xcode-select --install"
  exit 1
fi

echo "==> Downloading Blue Wine..."
curl -fsSL "$SOURCE" -o "$TMP_DIR/BlueWineApp.swift"

mkdir -p "$HOME/Applications"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"

echo "==> Compiling..."
swiftc -O -framework SwiftUI -framework AppKit \
  "$TMP_DIR/BlueWineApp.swift" \
  -o "$APP/Contents/MacOS/BlueWine"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>CFBundleExecutable</key><string>BlueWine</string>
<key>CFBundleIdentifier</key><string>com.bluewine.desktop</string>
<key>CFBundleName</key><string>Blue Wine</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>LSMinimumSystemVersion</key><string>13.0</string>
</dict>
</plist>
PLIST

codesign --force --deep --sign - "$APP" >/dev/null 2>&1 || true

echo "==> Opening Blue Wine..."
open "$APP"

echo "Blue Wine installed successfully!"
