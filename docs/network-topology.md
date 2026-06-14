# Home Network Topology

Full map of Jimmy's home network — devices, IPs, services, and how everything connects.

Last updated: 2026-06-13

---

## Network Diagram

```
                          ┌─────────────────────┐
                          │     INTERNET         │
                          │  ISP: Spectrum       │
                          │  Dynamic IP          │
                          │  DDNS: jkhomenetwork │
                          │   .tplinkdns.com     │
                          └─────────┬────────────┘
                                    │
                          ┌─────────▼────────────┐
                          │  TP-Link Deco W4500   │
                          │  "CATBOX_DECO"        │
                          │  192.168.68.1         │
                          │  AX1500 Mesh Router   │
                          │  DHCP: 192.168.68.x   │
                          │                       │
                          │  Satellites:           │
                          │   - Loft              │
                          │   - Basement          │
                          │   - Living Room       │
                          └───┬──────────┬────────┘
                              │          │
                    ┌─────────┘          └──────────┐
                    │ WIRED                    WIFI │
        ┌───────────▼───────────┐    ┌──────────────▼──────────────┐
        │                       │    │                              │
        │  ┌─────────────────┐  │    │  ┌────────────────────────┐ │
        │  │  jkhomeserver   │  │    │  │  Surface Laptop SB2    │ │
        │  │  .68.124        │  │    │  │  .68.128 (wifi 5GHz)   │ │
        │  │  (see below)    │  │    │  │  (see below)           │ │
        │  └─────────────────┘  │    │  └────────────────────────┘ │
        │                       │    │                              │
        │  ┌─────────────────┐  │    │  ┌────────────────────────┐ │
        │  │  ALFREDSCAVE    │  │    │  │  MacBook Pro 2011      │ │
        │  │  Gaming PC      │  │    │  │  .68.125 (wifi 5GHz)   │ │
        │  │  .68.109        │  │    │  │  Tailscale: ...236.43  │ │
        │  └─────────────────┘  │    │  └────────────────────────┘ │
        │                       │    │                              │
        │  ┌─────────────────┐  │    │  ┌────────────────────────┐ │
        │  │  Living Room PC │  │    │  │  Galaxy S22 Ultra      │ │
        │  │  HP All-in-One  │  │    │  │  .68.xxx (wifi)        │ │
        │  │  .68.121        │  │    │  │  (see below)           │ │
        │  │  (decomm soon)  │  │    │  └────────────────────────┘ │
        │  └─────────────────┘  │    │                              │
        │                       │    │  ┌────────────────────────┐ │
        │  ┌─────────────────┐  │    │  │  Backyard Camera       │ │
        │  │  Dad's PC       │  │    │  │  .68.126 (wifi 2.4GHz) │ │
        │  │  GMKtec M5 Ultra│  │    │  │  CloudPlus / PPSL      │ │
        │  │  .68.129        │  │    │  └────────────────────────┘ │
        │  └─────────────────┘  │    │                              │
        │                       │    │  Blink Cameras (wifi):      │
        │  ┌─────────────────┐  │    │   - Hallway: .68.107        │
        │  │  Driveway IPCAM │  │    │   - Loft: .68.106           │
        │  │  .68.118        │  │    │                              │
        │  │  CamHi          │  │    │  Other wifi devices:        │
        │  └─────────────────┘  │    │   - Fire Sticks             │
        │                       │    │   - Roku TV                  │
        └───────────────────────┘    │   - Echo devices             │
                                     │   - Smart lamps              │
                                     │   - Nintendo Switch          │
                                     └──────────────────────────────┘
```

---

## Managed Switches

```
┌──────────────────────────────────────┐
│  NETGEAR GS308EP    .68.55           │
│  Location: Living Room               │
├──────────────────────────────────────┤
│  TL-SG105E          .68.66           │
│  Location: Loft                      │
├──────────────────────────────────────┤
│  TL-SG105E          .68.116          │
│  Location: Studio                    │
├──────────────────────────────────────┤
│  TL-SG105E          .68.113          │
│  Location: Basement                  │
└──────────────────────────────────────┘
```

---

## Tailscale Overlay Network (Mesh VPN)

Works from anywhere — home, work, mobile data. All devices see each other regardless of physical network.

```
┌──────────────────────────────────────────────────────────────────┐
│                        TAILSCALE TAILNET                         │
│                                                                  │
│  ┌──────────────────┐   ┌──────────────────┐                    │
│  │  jkhomeserver    │   │  Surface SB2     │                    │
│  │  100.105.103.112 │◄─►│  100.104.139.84  │                    │
│  └────────▲─────────┘   └──────▲───────────┘                    │
│           │                    │                                 │
│           │    ┌───────────────┘                                 │
│           │    │                                                 │
│  ┌────────▼────▼────┐   ┌──────────────────┐                    │
│  │  Galaxy S22 Ultra│   │  MacBook Pro     │                    │
│  │  100.111.166.80  │   │  100.118.236.43  │                    │
│  └──────────────────┘   │  (usually off)   │                    │
│                         └──────────────────┘                    │
│                                                                  │
│  ┌──────────────────┐                                            │
│  │  Work PC         │  (Windows, Tailscale installed)            │
│  │  IP: dynamic     │  Connects to Surface for remote work      │
│  └──────────────────┘                                            │
└──────────────────────────────────────────────────────────────────┘
```

---

## Device Detail

### jkhomeserver (192.168.68.124 / Tailscale 100.105.103.112)

The brain of the home network. Wired connection. DHCP reservation set.

| Item | Detail |
|---|---|
| Connection | Wired ethernet |
| OS | Ubuntu |
| SSH user | `jkhomeserver` |
| Storage | 5.5 TB RAID array at `/mnt/rdisk` |
| DHCP reserved | Yes |

**Docker Containers:**

| Container | Port | Purpose | Status |
|---|---|---|---|
| `jellyfin` | 8096 | Media streaming (movies, TV, music) | Running |
| `plex` | 32400 | Legacy media server (being phased out) | Running |

**Services (systemd):**

| Service | Purpose | Status |
|---|---|---|
| `syncthing@jkhomeserver` | File sync — receives phone backups | Running, enabled on boot |

**Key Paths:**

```
/mnt/rdisk/
├── backups/jimmys-phone/     ← live Syncthing sync from phone
├── backups/S22-Ultra-backup/ ← full phone backup (2026-06-12)
├── backups/Dads Computer/    ← dad's old PC backup
├── media/movies/             ← 130+ movies (Jellyfin library)
├── media/tv/                 ← TV shows (Jellyfin library)
├── media/music/              ← Music (Jellyfin library)
├── media/home-videos/        ← Home videos (Jellyfin library)
├── media/recipes/            ← Recipe videos
├── docker/jellyfin/          ← Jellyfin config + cache
├── docker/plex/              ← Plex config (legacy)
├── Downloads/
├── personal/
├── projects/
├── software/
├── Games/
└── fun/
```

---

### Surface Laptop SB2 (192.168.68.128 / Tailscale 100.104.139.84)

Jimmy's daily driver. Wifi 5GHz connection.

| Item | Detail |
|---|---|
| Connection | WiFi 5GHz (CATBOX_DECO) |
| OS | Linux Mint |
| SSH user | `jimmy` |

**Services:**

| Service | Port | Purpose | Status |
|---|---|---|---|
| openssh-server | 22 | SSH access (from work PC) | Running, enabled on boot |
| xrdp | 3389 | Remote desktop (from work PC) | Running, enabled on boot |

**Software:**

| App | Purpose |
|---|---|
| Claude Code | AI coding assistant (CLI) |
| ProtonVPN (OpenVPN) | VPN — auto-connects on wifi via Network Manager |
| Tor Browser | Private browsing on top of VPN |
| msmtp + mailx | Email sending via Gmail (gaborarecords@gmail.com) |
| Git + GitHub | Code repos (github.com/jameskalvitz) |

**VPN Config:**
- Connection: `us-free-2.protonvpn.udp` (US-FREE#2, Los Angeles)
- Auto-starts when CATBOX_DECO wifi connects (linked as secondary connection)
- Account: gaboraa@proton.me

---

### Galaxy S22 Ultra (Tailscale 100.111.166.80)

Jimmy's phone. WiFi at home, mobile data when out.

| Item | Detail |
|---|---|
| Model | SM-S908U1 |
| OS | Android 16 / One UI 8.0 |
| Storage | 128 GB (was 96% full, backed up and being cleaned) |

**Apps for Infrastructure:**

| App | Purpose | Connects to |
|---|---|---|
| Tailscale | VPN mesh — access everything from anywhere | Entire Tailnet |
| Syncthing | Auto-backup to server on home WiFi | jkhomeserver (receive-only) |
| Termius | SSH terminal | jkhomeserver, Surface |
| Jellyfin | Stream movies/TV/music | jkhomeserver:8096 via Tailscale |

---

### Dad's PC — GMKtec M5 Ultra (192.168.68.129)

| Item | Detail |
|---|---|
| CPU | Ryzen 7 7730U (8C/16T) |
| Connection | Wired |
| Use case | Basic browsing (Facebook, email, YouTube, chess) |
| Backup | Old PC backed up to `/mnt/rdisk/backups/Dads Computer/` |
| Status | Needs initial setup |

---

### ALFREDSCAVE Gaming PC (192.168.68.109)

| Item | Detail |
|---|---|
| Connection | Wired |
| DHCP reserved | Yes |

---

### Cameras

| Camera | IP | Connection | App | Notes |
|---|---|---|---|---|
| Driveway IPCAM | .68.118 | Wired | CamHi | DHCP reserved, future Frigate NVR |
| Backyard Solar | .68.126 | WiFi 2.4GHz | CloudPlus | PPSL brand B411B |
| Hallway Blink | .68.107 | WiFi | Blink | — |
| Loft Blink | .68.106 | WiFi | Blink | — |

---

### Living Room PC (192.168.68.121) — DECOMMISSION PENDING

Old HP all-in-one. Was running Plex, no longer needed. Can be removed from network.

---

### MacBook Pro 2011 (192.168.68.125 / Tailscale 100.118.236.43)

Secondary machine, usually off. WiFi 5GHz. Being replaced by ACEMAGIC for LLM work.

---

## Lab Network (Isolated)

Separate network behind a GL.iNet Opal firewall. Not on the main 192.168.68.x network.

| Device | IP | Purpose |
|---|---|---|
| Cisco SG300-52 | — | Managed switch with VLANs (1, 10, 20, 30, 99) |
| Raspberry Pi 3 | 10.20.20.2 | Pi-hole DNS ad blocking |
| OptiPlex 380 | — | Lab management |

Network: 192.168.8.0/24

---

## DHCP Reservations (Deco App)

| Device | Reserved |
|---|---|
| jkhomeserver | Yes |
| ALFREDSCAVE | Yes |
| Driveway IPCAM | Yes |
| Living Room PC | Yes |
| TL-SG105E Basement | Yes |
| TL-SG105E Loft | Yes |
| TL-SG105E Studio | Yes |

---

## Port Forwards (Router)

| Port | Protocol | Destination | Purpose | Status |
|---|---|---|---|---|
| 32400 | TCP | jkhomeserver (.68.124) | Plex remote access | Active (legacy) |
| 8096 | TCP | jkhomeserver (.68.124) | Jellyfin remote access | TODO |

---

## Connection Flows

```
Phone (anywhere) ──Tailscale──► jkhomeserver:8096 ──► Jellyfin (movies/TV/music)
Phone (anywhere) ──Tailscale──► jkhomeserver:22   ──► SSH (Termius)
Phone (home wifi) ─Syncthing──► jkhomeserver      ──► Auto-backup photos/files

Work PC ──────────Tailscale──► Surface:22          ──► SSH
Work PC ──────────Tailscale──► Surface:3389        ──► Remote Desktop (xrdp)

Surface ──────────SSH────────► jkhomeserver:22     ──► Server management
Surface ──────────Browser────► jkhomeserver:8096   ──► Jellyfin web UI

Fire Sticks ──────LAN────────► jkhomeserver:8096   ──► Jellyfin app
Roku TV ──────────LAN────────► jkhomeserver:8096   ──► Jellyfin app
```
