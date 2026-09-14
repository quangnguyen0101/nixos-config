---
tags: [nixos, tools, tui]
---

# keep-awake — giữ máy awake (chặn khóa/lid)

Menu TUI giữ máy **không lock / không sleep / không suspend khi đóng lid**. Chỉ chạy khi bạn gọi — không bật thường trực.

## Cách dùng

```bash
keep-awake
```

| Option | Ý nghĩa |
|:------:|---------|
| `1`–`5` | Giữ 10p / 30p / 1h / 2h / 6h |
| `6`     | Tùy chỉnh (vd `90m`, `2h`, `45s`) |
| `7`     | Vô thời hạn — tắt bằng option 8 |
| `8`     | TẮT, máy lock/sleep bình thường lại |
| `0`     | Thoát menu không tắt |

## Cơ chế & trạng thái

- Daemon làm 2 việc: **jiggle input** (ydotool nhấn/nhả phím mỗi 60s → reset idle timer, vì Caelestia không expose IdleInhibitor) + `systemd-inhibit --what=idle:sleep:handle-lid-switch --mode=block`.
- Trạng thái ghi ở `~/.local/state/keep-awake/{duration,start}`.
- Prompt zsh hiện **⚡ xanh** bên phải khi đang giữ (RPROMPT).
- Debug:
  ```bash
  systemctl --user is-active keep-awake ydotoold
  systemd-inhibit --list
  pgrep -f keep-awake-daemon
  ```

> [!note] Icon ⚡ không hiện trong terminal/tmux pane mở trước đó → `exec zsh`.

## Cấu hình & tắt

- Module: `modules/home/keep-awake/keep-awake.nix` (packages + 2 systemd-user service `ydotoold`, `keep-awake`). README đầy đủ trong thư mục đó.
- Tắt: bỏ import `keep-awake.nix` khỏi `home.nix`.

## Liên quan

- [[brt]] — tool TUI cùng nhóm (độ sáng)
- [[USAGE]] — cheatsheet
- [[_index]] — map of content