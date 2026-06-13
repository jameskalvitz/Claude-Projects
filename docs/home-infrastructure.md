# Home Infrastructure Guide

How everything connects — Tailscale, SSH, Syncthing, phone backups, and remote access.

---

## Network Overview

All devices are connected via **Tailscale**, a mesh VPN that lets them talk to each other securely regardless of physical network. No port forwarding or firewall rules needed.

### Devices on the Tailnet

| Device | Hostname | Tailscale IP | Role |
|---|---|---|---|
| Surface Laptop (Linux Mint) | linux-mint-sb2 | 100.104.139.84 | Daily driver / workstation |
| Home Server | jkhomeserver | 100.105.103.112 | File storage, Syncthing, Plex (planned) |
| Galaxy S22 Ultra | gaboras-s22-ultra | 100.111.166.80 | Phone — auto-syncs to server |
| MacBook | — | 100.118.236.43 | Secondary machine |

---

## SSH Access

### Surface → Server

```bash
ssh jkhomeserver@100.105.103.112
```

- Username is `jkhomeserver` (not `jimmy`)
- SSH key auth is set up — no password needed from the Surface
- Also reachable on LAN at `192.168.68.124`

### Work PC → Surface (Remote Access)

From a Windows PC at work (with Tailscale installed):

- **SSH:** `ssh jimmy@100.104.139.84`
- **Remote Desktop (xrdp):** Open `mstsc`, connect to `100.104.139.84`

Both `openssh-server` and `xrdp` are enabled and start on boot on the Surface.

### Phone → Server

Use **Termius** (SSH app on phone) with Tailscale running:

```
Host: 100.105.103.112
User: jkhomeserver
```

---

## Server Storage (jkhomeserver)

The server has a **5.5 TB RAID array** mounted at `/mnt/rdisk`.

### Folder Structure

```
/mnt/rdisk/
├── backups/
│   ├── jimmys-phone/          ← live Syncthing sync from phone
│   ├── S22-Ultra-backup-06-12-2026/  ← one-time full phone backup
│   └── SamsungPhone/          ← older phone backup
├── Downloads/
├── media/
│   ├── movies/
│   ├── tv/
│   ├── music/
│   ├── photos/
│   ├── home-videos/
│   └── recipes/
├── personal/
├── projects/
├── software/
├── Games/
└── fun/
```

### Checking Disk Space

```bash
ssh jkhomeserver@100.105.103.112 "df -h /mnt/rdisk"
```

---

## Syncthing (Phone → Server Auto-Backup)

Syncthing keeps the phone backed up to the server automatically over WiFi. No manual steps needed.

### How It Works

1. Phone connects to home WiFi
2. Syncthing on the phone detects the server on the Tailnet
3. New files (photos, screenshots, downloads, etc.) sync automatically
4. Server receives files into `/mnt/rdisk/backups/jimmys-phone/`

### Key Details

| Setting | Value |
|---|---|
| Server Syncthing version | v1.18.0 |
| Server systemd service | `syncthing@jkhomeserver` (enabled on boot) |
| Server folder path | `/mnt/rdisk/backups/jimmys-phone/` |
| Server folder mode | Receive-only |
| Sync folder ID | `ekddf-x7021` |
| Phone sync mode | WiFi-only (no mobile data) |
| Phone shares | `/storage/emulated/0/` (entire internal storage) |

### Device IDs

- **Server:** `KU52ZKF-YG62GMD-WFDGF2B-BI4ECXU-CUIMZND-HA5V2LB-6BJ5HTR-I7G7WAW`
- **Phone:** `AWVG2DF-7FQ4KPJ-HPEI4XB-O42ZM2D-5OJD3YP-E24U76R-YCXBTRN-G6RXMQ4`

### What Syncs

The phone mirrors its folder structure to the server:

```
/mnt/rdisk/backups/jimmys-phone/
├── DCIM/Camera/          ← photos you take
├── DCIM/Screenshots/     ← screenshots
├── Pictures/Messages/    ← images from texts
├── Download/             ← browser downloads
├── Documents/            ← saved documents
├── Music/                ← music files
└── ...                   ← any other phone folders
```

### Checking Sync Status

From the Surface:

```bash
# Check if Syncthing service is running
ssh jkhomeserver@100.105.103.112 "systemctl status syncthing@jkhomeserver"

# Check folder status via API
ssh jkhomeserver@100.105.103.112 "curl -s -H 'X-API-Key: FLGNEpbawFDTzsfEqPbYZm6vvccm27vR' http://localhost:8384/rest/db/status?folder=ekddf-x7021" | python3 -m json.tool

# See what's in the sync folder
ssh jkhomeserver@100.105.103.112 "ls -la /mnt/rdisk/backups/jimmys-phone/"
```

### Troubleshooting

- **Not syncing?** Make sure Syncthing is open on the phone (check notification tray) and you're on home WiFi.
- **Folder paused?** Unpause via API:
  ```bash
  ssh jkhomeserver@100.105.103.112 "curl -s -X PATCH -H 'X-API-Key: FLGNEpbawFDTzsfEqPbYZm6vvccm27vR' -H 'Content-Type: application/json' -d '{\"paused\": false}' 'http://localhost:8384/rest/config/folders/ekddf-x7021'"
  ```
- **Service not running?** Restart it:
  ```bash
  ssh jkhomeserver@100.105.103.112 "sudo systemctl restart syncthing@jkhomeserver"
  ```

---

## Email Alerts (msmtp)

The Surface is configured to send emails via Gmail using `msmtp + mailx`.

- Gmail account: `gaborarecords@gmail.com`
- Config file: `~/.msmtprc`
- Server (jkhomeserver) still needs this set up

### Test It

```bash
echo "Test from Surface" | mailx -s "Test" your-email@example.com
```

---

## Phone Apps for Infrastructure

These apps on the Galaxy S22 Ultra make everything work:

| App | Purpose |
|---|---|
| **Syncthing** | Auto-syncs files to server over WiFi |
| **Tailscale** | VPN mesh — connects phone to server/Surface from anywhere |
| **Termius** | SSH client — terminal access to server from phone |

---

## Common Tasks

### Back up phone manually
Just connect to home WiFi. Syncthing handles it. Check the server folder to confirm:
```bash
ssh jkhomeserver@100.105.103.112 "ls -lrt /mnt/rdisk/backups/jimmys-phone/DCIM/Camera/ | tail -5"
```

### Access server files from phone
Open Termius, connect to `jkhomeserver@100.105.103.112`, browse with `ls` and `cd`.

### Access Surface from work
Install Tailscale on your work PC, then SSH or Remote Desktop to `100.104.139.84`.

### Check server health
```bash
ssh jkhomeserver@100.105.103.112 "df -h /mnt/rdisk; uptime; systemctl status syncthing@jkhomeserver --no-pager"
```
