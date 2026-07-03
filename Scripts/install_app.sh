#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
APP="$ROOT/GeoShift.app"
DESTINATION="/Applications/GeoShift.app"

"$ROOT/Scripts/package_app.sh" release
rm -rf "$DESTINATION"
cp -R "$APP" "$DESTINATION"
open "$DESTINATION"

echo "Installed $DESTINATION"
