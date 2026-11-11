
#!/bin/bash
set -euo pipefail

APP="$HOME/Applications/Blue Wine.app"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

BASE_URL="https://raw.githubusercontent.com/ZyonUB/BlueWine/main"
SOURCE="$BASE_URL/BlueWineApp.swift"

echo "======================================"
echo "       BLUE WINE macOS INSTALLER"
echo "======================================"
echo

# Check macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Error: This installer requires macOS."
    exit 1
fi

# Check Swift compiler
if ! command -v swiftc >/dev/null 2>&1; then
    echo "Swift compiler not found."
    echo "Run: xcode-select --install"
    exit 1
fi

echo "==> Downloading source..."
if ! curl -fL "$SOURCE" -o "$TMP_DIR/BlueWineApp.swift"; then
    echo "Error: Could not download BlueWineApp.swift."
    exit 1
fi

if ! grep -q "@main" "$TMP_DIR/BlueWineApp.swift"; then
    echo "Error: Downloaded Swift source is missing @main."
    exit 1
fi

echo "==> Preparing application..."
mkdir -p "$HOME/Applications"
mkdir -p "$TMP_DIR/Blue Wine.app/Contents/MacOS"

echo "==> Compiling Blue Wine..."
swiftc \
    -parse-as-library \
    -module-name BlueWine \
    -O \
    -framework SwiftUI \
    -framework AppKit \
    "$TMP_DIR/BlueWineApp.swift" \
    -o "$TMP_DIR/Blue Wine.app/Contents/MacOS/BlueWine"

cat > "$TMP_DIR/Blue Wine.app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>BlueWine</string>
    <key>CFBundleIdentifier</key>
    <string>com.bluewine.desktop</string>
    <key>CFBundleName</key>
    <string>Blue Wine</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
</dict>
</plist>
PLIST

echo "==> Signing application..."
codesign --force --deep --sign - "$TMP_DIR/Blue Wine.app" || true

echo "==> Installing application..."
rm -rf "$APP"
ditto "$TMP_DIR/Blue Wine.app" "$APP"

echo "==> Launching Blue Wine..."
open "$APP"

echo
echo "Blue Wine installed successfully!"
echo "Location: $APP"
