#!/bin/bash
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🚁 dji-mac-viewer installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Homebrew
if ! command -v brew &>/dev/null; then
  echo "❌ Homebrew not found. Install it first: https://brew.sh"
  exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
brew install node ffmpeg mpv 2>/dev/null || true

# Create server directory
SERVER_DIR="$HOME/rtmp-server"
mkdir -p "$SERVER_DIR"

# Copy project files
echo "📁 Copying files..."
cp server.js "$SERVER_DIR/server.js"
cp start-stream.sh "$SERVER_DIR/start-stream.sh"
chmod +x "$SERVER_DIR/start-stream.sh"

# Install node dependencies
echo "📦 Installing node packages..."
cd "$SERVER_DIR"
npm install node-media-server --save 2>/dev/null

# Create the .app
echo "🔨 Creating DroneStream.app..."
bash "$(dirname "$0")/create-drone-app.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Done! DroneStream.app is on your Desktop."
echo ""
echo "  Double-click it to start streaming."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
