---
tags: [nixos, cheatsheet, docs]
---

# USAGE — Cách dùng từng thứ trong hệ thống

> [!info] Obsidian
> Vault này = repo `~/nixos-config`. Mở nó trong **Obsidian** để có trải nghiệm đầy đủ: wikilink `[[...]]` click-nhảy, graph view, backlinks. GitHub render được phần lớn (callout OK) — chỉ wikilink hiện thành text thường.

> [!note]
> Cheatsheet hằng ngày cho máy `nixos-btw`. Trạng thái bật/tắt từng module xem [[INVENTORY]]. Mỗi mục nhỏ (tool/MCP) có note riêng trong [[_index|docs/tools]].

## Hệ thống

| Lệnh     | Làm gì |
|----------|--------|
| `update` | Rebuild hệ thống + home-manager (`sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw`) |
| `nx`     | `cd ~/nixos-config` |
| `op`     | `opencode` |

## Zsh / Tmux

- Zsh: Oh-My-Zsh (theme robbyrussell), autosuggestion + syntax highlighting, plugin `git sudo docker history-substring-search`.
- Tmux:
  - Mỗi lần mở terminal là `tmux new-session -A -s main` → mọi phiên gom vào session `main`.
  - **resurrect**: `Ctrl-b + Ctrl-s` save / `Ctrl-b + Ctrl-r` restore.
  - **continuum**: auto-save mỗi 10 phút, tự restore khi tmux khởi động lại.
- Prompt mới (vd icon ⚡) không hiện trong terminal/tmux pane mở từ trước → `exec zsh`.

## Tool nhỏ — click để xem chi tiết

| Tool | Lệnh nhanh | Note đầy đủ |
|------|------------|-------------|
| Giữ máy awake | `keep-awake` (menu 1–8) | [[keep-awake]] |
| Độ sáng | `brt` | [[brt]] |
| Nghe nhạc | `rmpc` / `rmpc update` / `ru` | [[rmpc]] |
| Gắn skill AI lên project | `cd <project> && autoskills` | [[autoskills]] |

## AI stack — 8 MCP servers

Danh sách + cách dùng từng server: xem **[[_index]]** (hoặc từng note):

| MCP | Khi nào dùng | Note |
|-----|--------------|------|
| [[arxiv]] | Tra/đọc paper, trích dẫn BibTeX | tìm → abstract → download → section |
| [[context7]] | Tra docs thư viện, cho code mẫu | tối đa 3 lần/câu hỏi |
| [[docker]] | Containers/compose/DB containers | destructive cần `# CONFIRMED-DESTRUCTIVE` |
| [[github]] | Repos/issues/PRs/code search | PAT ở `~/.config/opencode/github.token` |
| [[jupyter]] | Notebook + kernel data science | luồng chuẩn: [data-science skill](../../pkgs/opencode/skills/data-science/SKILL.md) |
| [[openviking]] | Long-term memory, virtual FS `viking://` | cũng có CLI `ov` |
| [[ouroboros]] | Task end-to-end: interview→seed→execute | theo dõi bằng job_status/job_wait |
| [[postgres]] | SQL data science trên `postgres-ds` | DS nằm ở /data/postgres |

## Terminal / Editor

- **Ghostty** — terminal mặc định (Catppuccin).
- **Neovim** — `nvim` (LazyVim; config là git submodule `modules/home/nvim-config`).
- **Zathura** — PDF viewer cho vimtex (forward search với nvim).

## Opencode (AI) — quy tắc chung

- Sau rebuild phải **thoát & mở lại** opencode để nạp config/skill mới (không hot-reload).
- `opencode mcp list` — kiểm tra MCP. Ngay sau reboot lần chạy đầu có thể báo fail transient (cold start `uvx`) — chạy lần 2 là OK.
- Services nền: `systemctl --user status` (jupyterlab, openviking-server, rclone-gdrive, keep-awake…) — chi tiết khai báo ở `modules/home/opencode.nix`, `modules/system/postgres-docker.nix`.

## Ổ đĩa / Cloud

- **Google Drive**: systemd-user `rclone-gdrive` → `~/GoogleDrive` (vfs cache 30G). Check: `systemctl --user status rclone-gdrive`.
- **Nhạc/lyrics**: `~/MEGA/` (ngoài nixos-config).

## Mẹo nhanh

- Cấu hình Home Manager chỉ có hiệu lực sau `update`. Không sửa tay `~/.config/` — sửa module rồi rebuild.
- Muốn biết cái gì đang chạy/tắt và cách tắt cho đỡ phí: xem [[INVENTORY]].