#!/usr/bin/env bash
set -euo pipefail

CONF=${1:-release}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

EXECUTABLE_NAME="GeoShift"
APP_DISPLAY_NAME="GeoShift"
BUNDLE_ID="com.lemelson.geoshift"
MACOS_MIN_VERSION="14.0"
ARCH=${ARCH:-$(uname -m)}

source "$ROOT/version.env"

swift build -c "$CONF" --arch "$ARCH"

APP="$ROOT/${APP_DISPLAY_NAME}.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>${APP_DISPLAY_NAME}</string>
    <key>CFBundleDisplayName</key><string>${APP_DISPLAY_NAME}</string>
    <key>CFBundleIdentifier</key><string>${BUNDLE_ID}</string>
    <key>CFBundleExecutable</key><string>${EXECUTABLE_NAME}</string>
    <key>CFBundleIconFile</key><string>AppIcon</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>${MARKETING_VERSION}</string>
    <key>CFBundleVersion</key><string>${BUILD_NUMBER}</string>
    <key>LSMinimumSystemVersion</key><string>${MACOS_MIN_VERSION}</string>
    <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST

BINARY="$ROOT/.build/${ARCH}-apple-macosx/$CONF/$EXECUTABLE_NAME"
if [[ ! -f "$BINARY" ]]; then
    BINARY="$ROOT/.build/$CONF/$EXECUTABLE_NAME"
fi

cp "$BINARY" "$APP/Contents/MacOS/$EXECUTABLE_NAME"
chmod +x "$APP/Contents/MacOS/$EXECUTABLE_NAME"
cp "$ROOT/Sources/GeoShift/Resources/keeper.py" "$APP/Contents/Resources/keeper.py"
if [[ -f "$ROOT/Assets/AppIcon.icns" ]]; then
    cp "$ROOT/Assets/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"
fi

chmod -R u+w "$APP"
xattr -cr "$APP"
find "$APP" -name '._*' -delete
codesign --force --sign - "$APP"

echo "Created $APP"
