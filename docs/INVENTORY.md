---
tags: [nixos, docs, inventory]
---

# INVENTORY — Trạng thái & cách bật/tắt từng module

> [!info] Obsidian
> Vault này = repo `~/nixos-config`. Mở trong **Obsidian** để dùng wikilink `[[...]]`, graph view, backlinks — GitHub render phần lớn (chỉ wikilink thành text). Mỗi tool/MCP có note chi tiết tại [[_index]].

> [!note]
> Mục tiêu: biết rõ cái gì đang chạy, cái gì tắt, và *tắt như thế nào* để không cài phí. Module home eager import từ `home/sh4d0wph4nt0m/home.nix`, module system từ `hosts/nixos-btw/configuration.nix`. Cheatsheet dùng tool: [[USAGE]].

## Legend

| Ký hiệu | Ý nghĩa |
|:-------:|---------|
| 🟢 | Đang chạy / đang import |
| ⏸️ | Đã gỡ khỏi import nhưng file còn giữ trong repo |
| 🔴 | Chưa dùng nhưng vẫn cài (tốt / đè) |

## Modules home (`modules/home/`)

| Module | Trạng thái | Cách bật/tắt | Ghi chú |
|--------|:----------:|--------------|---------|
| `zsh.nix` | 🟢 | import trong `home.nix` | alias `update`, `nx`, `op`; auto tmux |
| `tmux.nix` | 🟢 | import | resurrect/continuum giữ session |
| `nvim.nix` + `nvim-config/` | 🟢 | import; config là git submodule | LazyVim >30 plugin |
| `cava.nix` | 🟢 | import | audio visualizer |
| `ghostty.nix` | 🟢 | import | terminal mặc định |
| `opencode.nix` | 🟢 | import | MCP servers, skills, plugin |
| `autoskills.nix` | 🟢 | import | **không chạy service** — cài theo project, để nguyên cũng không tốn gì |
| `caelestia.nix` | 🟢 | import | Wayland shell |
| `userPackages.nix` | 🟢 | import | giỏ packages chung — **nơi muốn gỡ bớt thì sửa danh sách ở đây** |
| `rmpc-config/rmpc.nix` | 🟢 | import | MPD client + config/themes |
| `easyeffects.nix` | 🟢 | import | audio processing |
| `openviking-server.nix` | 🟢 | import | context database server (MCP) |
| `keep-awake/keep-awake.nix` | 🟢 | import | 2 systemd-user service: `ydotoold`, `keep-awake` |
| `rclone-gdrive.nix` | 🟢 | import | systemd-user `rclone-gdrive` → `~/GoogleDrive` |
| `brt.nix` | 🟢 | import | menu độ sáng (brightnessctl/ddcutil) |
| `jupyter.nix` | 🟢 | import | systemd-user `jupyterlab` (127.0.0.1:8888) |
| `dms.nix` | ⏸️ | comment dòng import trong `home.nix` | Dank Material Shell — đã tắt (2025-09) |
| `noctalia.nix` | ⏸️ | comment dòng import | Noctalia shell — đã tắt |
| `dsh-plugins.nix` + `dsh-profile/` | ⏸️ | không được import; giữ để dùng lại sau | Plugin DSH profile "web" (2025-09 tắt cùng DeepSeek Harness) |

## Modules system (`modules/system/`)

| Module | Trạng thái | Cách bật/tắt | Ghi chú |
|--------|:----------:|--------------|---------|
| `hyprland.nix` | 🟢 | import trong `configuration.nix` hoặc comment | compositor + XDG portal |
| `steam.nix` | 🟢 | import | Steam 32-bit + RemotePlay — nặng, ko chơi thì comment |
| `fonts.nix` | 🟢 | import | Nerd Fonts (4 bộ) |
| `networking.nix` | 🟢 | import | NetworkManager, Wi-Fi, VPN |
| `bluetooth.nix` | 🟢 | import | bluetooth stack |
| `i18n.nix` | 🟢 | import | locale + fcitx5-lotus (Tiếng Việt) |
| `gc.nix` | 🟢 | import | nix garbage collector tự động |
| `greeter.nix` | 🟢 | import | greetd + regreet |
| `printing.nix` | 🟢 | import | CUPS |
| `systemPackages.nix` | 🟢 | import | gói hệ thống chung |
| `fcitx5-lotus.nix` | 🟢 | import | bộ gõ Vietnamese Lotus |
| `nix-ld.nix` | 🟢 | import | thư viện cho binary/wheel ngoài nix |
| `postgres-docker.nix` | 🟢 | import | container PostgreSQL 17 (`postgres-ds`, bind `/data/postgres`) |
| `backlight.nix` | 🟢 | import | udev rule backlight |
| `rclone-fuse.nix` | 🟢 | import | fuse/rclone hệ thống |

> lanzaboote (Secure Boot) khai báo inline trong `flake.nix`, không phải file module.

## Packages tự xây (`pkgs/`)

| Package | Trạng thái | Ghi chú |
|---------|:----------:|---------|
| `deepseek-harness` | ⏸️ | binary `dsh` vẫn cài (ở `userPackages.nix`) nhưng không có service/plugin — xem README |
| `openviking` | 🟢 | server + CLI — nền MCP `openviking` |
| `ouroboros` | 🟢 | bridge plugin `.ts` cho MCP `ouroboros` |
| `opencode/autoskills` | 🟢 | CLI cài skill theo project (CC-BY-NC-4.0) |
| `opencode/skills/*` | 🟢 | skill copy vào `~/.config/opencode/skills/` |

## Gợi ý giảm nặng máy

> [!tip]
> Nếu sợ "cài phí": thứ thực sự nặng là **Steam** (`steam.nix`), **WPS/texlive-wpsoffice** (trong `userPackages.nix`), **postgres-docker** (container chạy nền). Còn autoskills, brt, keep-awake, rclone... đều nhẹ hoặc chạy theo nhu cầu — giữ.