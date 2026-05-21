# 🚁 dji-mac-viewer

**One-click DJI Goggles 3 video stream viewer for macOS.**  
No subscriptions. No cloud. No heavy apps. Just your drone feed on your MacBook.

![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

---

## Why this exists

DJI Goggles 3 can stream video via RTMP through the DJI Fly app — but there's no simple, free way to view that stream on a MacBook, especially in the field without internet. This project fixes that.

**One double-click → drone feed on your screen.**

---

## Features

- ✅ Works completely **offline** — local network only
- ✅ **Auto-detects your Mac's IP** — no manual configuration in the field
- ✅ Opens video **fullscreen** automatically
- ✅ Works at **home** (your WiFi) and **in the field** (Mac as hotspot)
- ✅ No Electron, no browser, no subscriptions — just shell scripts
- ✅ Packages as a native **macOS .app** with custom icon

---

## Requirements

- macOS 12+
- [Homebrew](https://brew.sh)
- DJI Goggles 3 + DJI Fly app on your phone
- Phone and Mac on the **same WiFi network**

---

## Quick Install

```bash
# 1. Clone
git clone https://github.com/YOUR_USERNAME/dji-mac-viewer.git
cd dji-mac-viewer

# 2. Install dependencies and create the app
bash install.sh
```

That's it. A `DroneStream.app` will appear on your Desktop.

---

## Usage

### At home
1. Connect your phone and Mac to the same WiFi
2. Double-click **DroneStream.app**
3. The terminal shows your Mac's IP and the exact URL to enter in DJI Fly
4. In **DJI Fly** → Live Streaming → RTMP → enter the URL
5. Video opens fullscreen automatically

### In the field (no WiFi)
**Option A — Mac as hotspot (recommended):**
1. System Settings → General → Sharing → Internet Sharing → enable WiFi hotspot
2. Connect your phone to the Mac's hotspot
3. Double-click **DroneStream.app** — IP is always `192.168.2.1`

**Option B — Phone as hotspot:**
1. Enable Personal Hotspot on your phone
2. Connect Mac to phone's hotspot
3. Launch **DroneStream.app** — it will show the current IP automatically

### DJI Fly settings
| Field | Value |
|-------|-------|
| RTMP Address | `rtmp://<YOUR_MAC_IP>/` |
| Stream Key | `live/drone` |

---

## How it works

```
DJI Goggles 3
     ↓ (O3 link)
DJI RC / Phone (DJI Fly app)
     ↓ (RTMP push via WiFi)
node-media-server on Mac (port 1935)
     ↓
ffmpeg (H.264 cleanup: ultrafast + zerolatency)
     ↓
ffplay (fullscreen display)
```

The ffmpeg step re-encodes the stream with `-preset ultrafast -tune zerolatency` to strip DJI-specific filler NAL units that cause decoder errors in standard players.

---

## Project structure

```
dji-mac-viewer/
├── server.js           # RTMP server (node-media-server)
├── start-stream.sh     # Main launch logic
├── create-drone-app.sh # Creates DroneStream.app
├── install.sh          # One-command setup
└── README.md
```

---

## Troubleshooting

**Video doesn't appear:**
- Make sure phone and Mac are on the same network
- Check that DJI Fly is actually streaming (look for the live indicator)
- Try restarting the stream in DJI Fly

**"Connection refused" error:**
- The server isn't running — relaunch DroneStream.app

**High latency:**
- Switch from WiFi to Mac hotspot (fewer network hops)
- Lower the bitrate in DJI Fly settings (try 4–8 Mbps)

---

## Compared to alternatives

| | dji-mac-viewer | djifly-viewer | OBS + Nginx |
|---|---|---|---|
| Install size | ~5 MB | ~200 MB (Electron) | ~500 MB |
| One-click launch | ✅ | ✅ | ❌ |
| Auto IP detection | ✅ | ❌ | ❌ |
| Works offline | ✅ | ✅ | ✅ |
| macOS native .app | ✅ | ✅ | ❌ |
| Open source | ✅ | ✅ | ✅ |
| Free | ✅ | ✅ | ✅ |

---

## License

MIT

---

---

# 🚁 dji-mac-viewer (Українська)

**Перегляд відео з DJI Goggles 3 на MacBook одним кліком.**  
Без підписок. Без хмар. Без важких програм.

---

## Навіщо це

DJI Goggles 3 може транслювати відео через RTMP за допомогою додатку DJI Fly — але немає простого безкоштовного способу переглядати цей потік на MacBook, особливо в полі без інтернету. Цей проект вирішує цю проблему.

**Один подвійний клік → відео з дрона на екрані.**

---

## Встановлення

```bash
git clone https://github.com/mykhailo-bot/dji-mac-viewer.git
cd dji-mac-viewer
bash install.sh
```

На робочому столі з'явиться `DroneStream.app`.

---

## Використання

### Вдома
1. Підключи телефон і Mac до однієї WiFi мережі
2. Двічі клікни **DroneStream.app**
3. Термінал покаже IP твого Mac і точну URL для DJI Fly
4. В **DJI Fly** → Пряма трансляція → RTMP → введи URL
5. Відео відкриється на весь екран автоматично

### В полі (без WiFi)
**Варіант А — Mac як точка доступу (рекомендовано):**
1. Системні налаштування → Загальні → Спільний доступ → Інтернет → увімкни WiFi
2. Підключи телефон до мережі Mac
3. Запусти **DroneStream.app** — IP завжди `192.168.2.1`

**Варіант Б — Телефон як хотспот:**
1. Увімкни точку доступу на телефоні
2. Підключи Mac до хотспоту
3. Запусти **DroneStream.app** — IP визначиться автоматично

### Налаштування DJI Fly
| Поле | Значення |
|------|----------|
| Адрес RTMP | `rtmp://<IP_ТВОГО_MAC>/` |
| Ключ потоку | `live/drone` |
