---
tags: [nixos, tools, tui]
---

# brt — điều khiển độ sáng màn hình

Menu TUI điều chỉnh độ sáng cho cả laptop lẫn màn ngoài.

## Cách dùng

```bash
brt
```

Chiến lược tự động theo thiết bị:

- **Laptop**: `brightnessctl` (backlight intel — cần udev rule + group `video`).
- **Màn ngoài**: `ddcutil` qua DDC/CI (VCP 10) nếu monitor hỗ trợ.
- **Fallback**: `wlsunset` giảm sáng phần mềm khi màn ngoài không hỗ trợ DDC.

Bước điều chỉnh mặc định `STEP=5`.

## Cấu hình & tắt

- Script nguồn đơn: `modules/home/brt-config/brt`; module `modules/home/brt.nix` chỉ đóng gói `writeShellScriptBin "brt"`.
- Tắt: bỏ import `brt.nix` khỏi `home.nix`.

## Liên quan

- [[keep-awake]] — tool TUI cùng nhóm
- [[_index]] — map of content