#!/bin/bash
SERVER_DIR="$HOME/rtmp-server"
LOG="$SERVER_DIR/server.log"
STREAM="rtmp://localhost/live/drone"

# Знаходимо активний IP (WiFi, хотспот або будь-який інший)
get_ip() {
  for iface in en0 en1 en2 bridge100 utun0; do
    IP=$(ipconfig getifaddr $iface 2>/dev/null)
    if [ -n "$IP" ]; then
      echo "$IP"
      return
    fi
  done
  echo "не знайдено"
}

MY_IP=$(get_ip)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🚁 DRONE STREAM LAUNCHER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  📍 IP цього Mac:  $MY_IP"
echo ""
echo "  📡 В DJI Fly вбий:"
echo "     Адрес RTMP: rtmp://$MY_IP/"
echo "     Ключ:       live/drone"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "🚀 Запускаю сервер..."
pkill -f "node server.js" 2>/dev/null
sleep 1
> "$LOG"
cd "$SERVER_DIR"
nohup node server.js > "$LOG" 2>&1 &

echo "✅ Сервер запущено"
echo ""
echo "⏳ Чекаю на підключення DJI Fly..."

for i in $(seq 1 60); do
  if grep -q "start push /live/drone" "$LOG" 2>/dev/null; then
    echo ""
    echo "🎥 Сигнал є! Відкриваю відео..."
    sleep 1
    ffmpeg -fflags nobuffer+genpts \
           -i "$STREAM" \
           -c:v libx264 -preset ultrafast -tune zerolatency \
           -crf 28 -maxrate 4M -bufsize 1M -g 30 -r 30 \
           -c:a aac -b:a 64k \
           -f flv rtmp://localhost/live/clean 2>/dev/null &
    sleep 5
    ffplay -fflags nobuffer -flags low_delay -framedrop -fs \
           rtmp://localhost/live/clean &
    sleep 2
    osascript -e 'tell application "System Events"
        set theProcess to first process whose name contains "ffplay"
        set frontmost of theProcess to true
    end tell' 2>/dev/null
    echo ""
    echo "✅ Готово! Закрий це вікно коли захочеш зупинити."
    break
  fi
  echo -n "."
  sleep 1
done

if ! grep -q "start push /live/drone" "$LOG" 2>/dev/null; then
  echo ""
  echo "⚠️  DJI Fly не підключився за 60 секунд."
  echo "   IP цього Mac: $MY_IP"
  echo "   Перевір що телефон в тій самій мережі."
fi

echo ""
echo "── Лог сервера ─────────────────────────────────────"
tail -f "$LOG"
