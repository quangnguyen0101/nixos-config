# keep-awake

Giữ máy awake — không bị **khóa màn hình / sleep / suspend khi đóng lid** trong lúc treo máy, bằng menu TUI đơn giản.

Hoạt động trên **NixOS + Hyprland + caelestia-shell** (Quickshell).

## Cách dùng

Chạy một lần duy nhất, không cần nhớ cờ:

```bash
keep-awake
```

| Option | Mô tả |
|:------:|:------|
| `1`–`5` | Giữ trong 10 phút / 30 phút / 1 giờ / 2 giờ / 6 giờ |
| `6` | Tùy chỉnh (vd: `90m`, `2h`, `45s`) |
| `7` | Vô thời hạn (tắt bằng option 8) |
| `8` | TẮT giữ-awake (máy lock/sleep bình thường trở lại) |
| `0` | Thoát menu (không tắt giữ-awake) |

## Cách hoạt động

File | Vai trò
-----|--------
`keep-awake` | Menu TUI — ghi trạng thái vào `~/.local/state/keep-awake/` rồi restart service
`keep-awake-daemon` | Daemon bật bởi service — giữ máy awake
`keep-awake.nix` | Module home-manager: packages + 2 systemd user services + substitute store paths

Daemon làm **2 việc song song**:

1. **Jiggle input** — tự nhấn/nhả phím `Left Shift` mỗi 60s qua `ydotoold` (uinput), reset idle timer của Hyprland/caelestia. Đây là cơ chế chính chặn khóa màn hình, vì caelestia không expose `IdleInhibitor` qua IPC để shell biết "đang có chương trình giữ awake".
2. **`systemd-inhibit --what=idle:sleep:handle-lid-switch --mode=block`** — chặn logind suspend / IdleAction / đóng lid trong thời gian giữ.

Trạng thái (ghi bởi menu, đọc bởi daemon):

```
~/.local/state/keep-awake/duration   # số giây hoặc "inf"
~/.local/state/keep-awake/start      # epoch timestamp lúc bật
```

### Services (systemd --user)

- `ydotoold.service` — daemon ydotool (socket `%t/.ydotool_socket`), tự khởi động cùng graphical session.
- `keep-awake.service` — daemon chính; `SuccessExitStatus` cho phép `systemctl --user stop` bình thường trả về `inactive` thay vì `failed`.

### Thông báo + trạng thái prompt

- **Toast**: bật/tắt/hết giờ → `notify-send` (góc trên phải caelestia, vài giây, hover chuột để giữ).
- **Icon ⚡**: khi đang giữ awake, zsh prompt hiện ⚡ xanh ở RPROMPT (được thêm ở `modules/home/zsh.nix`).

## Cài đặt — home-manager

Import `keep-awake.nix` trong home-manager — sau khi `switch` 1 lần, script đã đóng gói store paths (ydotool, systemd-inhibit, notify-send), dùng mãi không cần rebuild lại.

## Gỡ lỗi

```bash
systemctl --user is-active keep-awake ydotoold   # active + active
systemctl --user status keep-awake               # log daemon
systemd-inhibit --list                            # inhibitor đang giữ
pgrep -f keep-awake-daemon                        # process daemon
```

Nếu icon ⚡ không hiện sau khi bật: shell đang chạy từ trước khi update config (vd gắn vào tmux session cũ) → `exec zsh` hoặc mở terminal mới.