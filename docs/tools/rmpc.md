---
tags: [nixos, tools, tui, mpc]
---

# rmpc — nghe nhạc (MPD client)

Client MPD terminal (Rust) — kết nối `127.0.0.1:6600`, theme `nord`, config hot-reload.

## Cách dùng

```bash
rmpc          # mở player (đã có MPD daemon phía sau)
rmpc update   # quét lại thư viện nhạc
ru            # zsh function: rmpc update xong tự mở lại rmpc
```

- Nhạc & lyrics ở `~/MEGA/Music/` (lyrics_dir đặt trong config).
- Phím tắt: `q` thoát, `?` help, `:` command mode. Volume step `5`, keep-state on song change.

## Cấu hình & tắt

- Config + themes: `modules/home/rmpc-config/` (`config.ron` + `themes/nord.ron`); module import `rmpc-config/rmpc.nix`.
- Tắt: bỏ import `rmpc-config/rmpc.nix` khỏi `home.nix`.

## Liên quan

- [[USAGE]] — cheatsheet
- [[_index]] — map of content