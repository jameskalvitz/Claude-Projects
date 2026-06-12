# Phone Backup Project

Syncthing auto-backup from Galaxy S22 Ultra to jkhomeserver when connected to home WiFi.

## Phone Storage (as of 2026-06-12)

- **123.8 GB / 128 GB used (96%)** — critical, need to backup and wipe
- Images (1.58 GB): Camera (159), Screenshots (195), Messages (96), AlfredsCave (22), Download (6), Pictures (1)
- Also: Audio, Videos, Docs, Install files, Downloads (Chrome, Claude, Gmail, Capital One, Other)

## Planned Server Folder Structure

```
/mnt/rdisk/backups/jimmys-phone/
├── DCIM/Camera/
├── DCIM/Screenshots/
├── Pictures/Messages/
├── Pictures/AlfredsCave/
├── Pictures/Other/
├── Videos/
├── Audio/Music/
├── Audio/Recordings/
├── Downloads/
└── Documents/
```

## photos/

Screenshots from phone uploaded here for reference during setup.

## Status

- [x] Review phone file structure (2026-06-12)
- [x] Syncthing installed and paired on phone + server
- [x] WiFi-only sync enabled on phone
- [ ] Fix SSH access to jkhomeserver from Surface
- [ ] Create destination folders on jkhomeserver
- [ ] Configure Syncthing folders on phone
- [ ] Configure Syncthing folders on jkhomeserver
- [ ] First full sync + verify
- [ ] Wipe phone
