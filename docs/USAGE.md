---
tags: [nixos, cheatsheet, docs]
---

# USAGE — Cách dùng từng thứ trong hệ thống

> [!note]
> Cheatsheet hằng ngày cho máy `nixos-btw`. Trạng thái bật/tắt của từng module xem [INVENTORY.md](INVENTORY.md). Mỗi mục ghi câu lệnh dùng ngay được, không cần đọc config.

## Hệ thống

| Lệnh    | Làm gì |
|---------|--------|
| `update`| Rebuild hệ thống + home-manager (`sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw`) |
| `nx`    | `cd ~/nixos-config` |
| `op`    | `opencode` |

## Zsh / Tmux

- Zsh: Oh-My-Zsh (theme robbyrussell), autosuggestion + syntax highlighting, plugin `git sudo docker history-substring-search`.
- Tmux:
  - Mỗi lần mở terminal là `tmux new-session -A -s main` → mọi phiên gom vào session `main`.
  - **resurrect**: `Ctrl-b + Ctrl-s` save / `Ctrl-b + Ctrl-r` restore.
  - **continuum**: auto-save mỗi 10 phút, tự restore khi tmux khởi động lại.
- Prompt mới (vd icon ⚡) không xuất hiện trong terminal/tmux pane mở từ trước → `exec zsh` hoặc mở terminal mới.

## Giữ máy awake

```bash
keep-awake
```

Menu TUI, không cần cờ:

| Option | Ý nghĩa |
|:------:|---------|
| `1`–`5` | Giữ 10p / 30p / 1h / 2h / 6h |
| `6`     | Tùy chỉnh (`90m`, `2h`, `45s`) |
| `7`     | Vô thời hạn (tắt bằng option 8) |
| `8`     | TẮT — máy lock/sleep bình thường trở lại |
| `0`     | Thoát menu không tắt |

- Cơ chế: ydotool jiggle phím mỗi 60s chặn khóa màn hình Caelestia + `systemd-inhibit` chặn idle/sleep/lid.
- Prompt hiện ⚡ xanh bên phải khi đang giữ.
- Debug: `systemctl --user is-active keep-awake ydotoold`, `systemd-inhibit --list`, `pgrep -f keep-awake-daemon`.

## Độ sáng màn hình

```bash
brt
```

Menu TUI: laptop qua `brightnessctl`, màn ngoài qua DDC/CI (`ddcutil`), fallback `wlsunset` nếu màn không hỗ trợ DDC.

## Nghe nhạc — rmpc (MPD client)

```bash
rmpc          # mở player (kết nối MPD 127.0.0.1:6600)
rmpc update   # quét lại thư viện nhạc
ru            # zsh function: rmpc update xong tự mở lại rmpc
```

- Nhạc & lyrics ở `~/MEGA/Music/`. Phím tắt: `q` thoát, `?` help, `:` command mode.
- Config `modules/home/rmpc-config/config.ron` (theme `nord`, config hot-reload).

## Terminal / Editor

- **Ghostty** — terminal mặc định (Catppuccin).
- **Neovim** — `nvim` (LazyVim; config là git submodule `modules/home/nvim-config`).
- **Zathura** — PDF viewer cho vimtex (forward search với nvim).

## Opencode (AI)

- Sau rebuild phải **thoát & mở lại** opencode để nạp config/skill mới (không hot-reload).
- `opencode mcp list` — kiểm tra 8 MCP servers. Ngay sau reboot lần chạy đầu có thể báo fail transient (cold start `uvx`) — chạy lần 2 là OK.
- Services nền: `systemctl --user status` (ollama, jupyterlab, openviking, rclone-gdrive + docker db) — danh sách đầy đủ ở `modules/home/opencode.nix` và `modules/system/postgres-docker.nix`.

## autoskills (gắn skill AI vào project)

```bash
cd ~/du-an/cu-the
autoskills          # tự detect stack → liệt kê skill → confirm install
autoskills --dry-run   # chỉ xem danh sách
autoskills -y          # bỏ bước xác nhận
```

- Skill cài vào `.agents/skills/<tên>/SKILL.md` **trong project** — opencode tự đọc khi mở project đó, cài xong mở lại opencode.
- Nhớ `skills-lock.json`: chạy lại sau này để refresh skill bản mới.
- Lần đầu cần network (skill tải từ GitHub về `~/.cache/autoskills/`).
- Bỏ khi chọn cài: `react-best-practices` + `composition-patterns` (name của vercel-labs không khớp tên thư mục → opencode bỏ qua). Rà nhanh:
  ```bash
  for d in .agents/skills/*/; do n=$(basename "$d"); \
    [ "$n" = "$(sed -n 's/^name: //p' "$d/SKILL.md")" ] || echo "skip: $n"; done
  ```

## Ổ đĩa / Cloud

- **Google Drive**: mount qua systemd-user `rclone-gdrive` → `~/GoogleDrive` (vfs cache 30G). Check: `systemctl --user status rclone-gdrive`.
- **Nhạc/lyrics**: `~/MEGA/` (ngoài nixos-config).

## Mẹo nhanh

- Cấu hình Home Manager chỉ có hiệu lực sau `update`. Không sửa tay `~/.config/` — sửa module rồi rebuild.
- File MD này đọc được cả trên GitHub lẫn Obsidian (dùng callout + link chuẩn, chưa dùng wikilink).