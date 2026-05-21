#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP="$HOME/Desktop/DroneStream.app"

echo "🔨 Створюю DroneStream.app..."

# Структура .app
mkdir -p "$APP/Contents/MacOS"
mkdir -p "$APP/Contents/Resources"

# Виконуваний файл .app — відкриває термінал зі скриптом
cat > "$APP/Contents/MacOS/DroneStream" << 'EOF'
#!/bin/bash
open -a Terminal "$HOME/rtmp-server/start-stream.sh"
EOF
chmod +x "$APP/Contents/MacOS/DroneStream"

# Info.plist
cat > "$APP/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>DroneStream</string>
    <key>CFBundleIdentifier</key>
    <string>com.drone.stream</string>
    <key>CFBundleName</key>
    <string>DroneStream</string>
    <key>CFBundleDisplayName</key>
    <string>Drone Stream</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
</dict>
</plist>
EOF

# Застосувати іконку якщо є icon.png
ICON_SRC="$SCRIPT_DIR/icon.png"
if [ -f "$ICON_SRC" ]; then
  echo "🎨 Застосовую іконку..."
  ICONSET="$TMPDIR/DroneStream.iconset"
  mkdir -p "$ICONSET"
  sips -z 16 16     "$ICON_SRC" --out "$ICONSET/icon_16x16.png"      &>/dev/null
  sips -z 32 32     "$ICON_SRC" --out "$ICONSET/icon_16x16@2x.png"   &>/dev/null
  sips -z 32 32     "$ICON_SRC" --out "$ICONSET/icon_32x32.png"      &>/dev/null
  sips -z 64 64     "$ICON_SRC" --out "$ICONSET/icon_32x32@2x.png"   &>/dev/null
  sips -z 128 128   "$ICON_SRC" --out "$ICONSET/icon_128x128.png"    &>/dev/null
  sips -z 256 256   "$ICON_SRC" --out "$ICONSET/icon_128x128@2x.png" &>/dev/null
  sips -z 256 256   "$ICON_SRC" --out "$ICONSET/icon_256x256.png"    &>/dev/null
  sips -z 512 512   "$ICON_SRC" --out "$ICONSET/icon_256x256@2x.png" &>/dev/null
  sips -z 512 512   "$ICON_SRC" --out "$ICONSET/icon_512x512.png"    &>/dev/null
  sips -z 1024 1024 "$ICON_SRC" --out "$ICONSET/icon_512x512@2x.png" &>/dev/null
  iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns" 2>/dev/null
  rm -rf "$ICONSET"
  /usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string AppIcon" \
    "$APP/Contents/Info.plist" &>/dev/null || true
  echo "✅ Іконку застосовано!"
fi

echo ""
echo "✅ DroneStream.app готовий на робочому столі!"
echo "   Двічі клікни щоб запустити."
