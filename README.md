# nixos-config

## 📖 Giới thiệu

**NixOS** cấu hình cá nhân được quản lý bằng **Nix Flake** và **Home Manager**.  Đây là một *single‑host* setup (máy `nixos-btw`) với kiến trúc **modular**: phần hệ thống và phần người dùng được tách riêng, dễ bảo trì và mở rộng.

## 🗂️ Cấu trúc dự án

```
flake.nix                     # Entry point – khai báo inputs, outputs và các module
└─ nixosConfigurations.nixos-btw
    ├─ hosts/nixos-btw/               # Cấu hình máy cụ thể (hardware, hostname, locale…)
    │   ├─ configuration.nix           # Tổng hợp các module hệ thống
    │   └─ hardware-configuration.nix # Tự động sinh bởi nixos-generate-config
    ├─ modules/system/                # Các module NixOS tái sử dụng
    ├─ home-manager → home/           # Home Manager – cấu hình người dùng
    ├─ pkgs/                          # Các package tùy chỉnh
    └─ lanzaboote/                    # Secure Boot (lanzaboote) integration
```

### 📦 Danh sách các module chi tiết

#### Modules hệ thống (`modules/system/`)
| Module | Đường dẫn | Mô tả ngắn |
|--------|-----------|------------|
| `hyprland.nix` | `modules/system/hyprland.nix` | Cài đặt và cấu hình Hyprland (Wayland compositor) + XDG portal |
| `steam.nix` | `modules/system/steam.nix` | Kích hoạt Steam, hỗ trợ 32‑bit graphics, mở firewall cho RemotePlay |
| `fonts.nix` | `modules/system/fonts.nix` | Cài đặt các Nerd Font (JetBrains Mono, Fira Code, Hack, 0xProto) |
| `networking.nix` | `modules/system/networking.nix` | NetworkManager, DHCP, DNS, Wi‑Fi, VPN, tắt IPv6 |
| `bluetooth.nix` | `modules/system/bluetooth.nix` | Hỗ trợ Bluetooth stack |
| `i18n.nix` | `modules/system/i18n.nix` | Locale, layout, cấu hình `fcitx5‑lotus` (Vietnamese) |
| `gc.nix` | `modules/system/gc.nix` | Cấu hình garbage collector tự động (`nix.gc.automatic = true`) |
| `greeter.nix` | `modules/system/greeter.nix` | Cấu hình greetd + regreet (giao diện đăng nhập) |
| `printing.nix` | `modules/system/printing.nix` | Cài đặt CUPS để in ấn |
| `systemPackages.nix` | `modules/system/systemPackages.nix` | Các gói hệ thống chung (git, curl, vim, …) |
| `lanzaboote.nix` | `modules/system/lanzaboote.nix` | Tích hợp Secure Boot bằng lanzaboote |
| `fcitx5-lotus.nix` | `modules/system/fcitx5-lotus.nix` | Bộ gõ Vietnamese dựa trên Lotus Input Method |
| `...` | … | Các module khác (greeter, printing, …)

#### Modules người dùng (`modules/home/`)
| Module | Đường dẫn | Mô tả ngắn |
|--------|-----------|------------|
| `zsh.nix` | `modules/home/zsh.nix` | Zsh + Oh‑My‑Zsh, alias (`update`), tự động khởi chạy tmux |
| `nvim-config/` | `modules/home/nvim-config/` | Cấu hình Neovim (LazyVim) với >30 plugin (LSP, Treesitter, Lualine, Telescope, …) |
| `tmux.nix` | `modules/home/tmux.nix` | Cấu hình Tmux, plugin `resurrect`/`continuum` để giữ session |
| `ghostty.nix` | `modules/home/ghostty.nix` | Terminal GPU‑accelerated Ghostty, theme Catppuccin |
| `opencode.nix` | `modules/home/opencode.nix` | Opencode declarative + Ollama AI stack (chạy dưới systemd‑user) |
| `python.nix` | `modules/home/python.nix` | Cài đặt Python và các gói pip tùy chỉnh |
| `cava.nix` | `modules/home/cava.nix` | Cài đặt CAVA (audio visualizer) |
| `rmpc-config/` | `modules/home/rmpc-config/` | Cấu hình Music Player Client (rmpc) |
| `dsh-profile.nix` | `modules/home/dsh-profile.nix` | Cấu hình DSH workspace, pnpm‑workspace.yaml |
| `...` | … | Các module khác (zsh, ghostty, tmux, …)

## 🚀 Các thành phần chính (tóm tắt)
| Thành phần | Mô tả |
|-----------|------|
| **Window manager** | Hyprland + Caelestia shell |
| **Shell** | Zsh + Oh‑My‑Zsh, alias `update` |
| **Terminal** | Ghostty (Catppuccin theme) |
| **Editor** | Neovim (lazy‑vim) với hơn 30 plugin |
| **Multiplexer** | Tmux với `resurrect/continuum` |
| **Login** | greetd + regreet (Rosé Pine) |
| **Input** | fcitx5‑lotus + bamboo (Vietnamese) |
| **AI stack** | Opencode (declarative) + Ollama (systemd‑user) |
| **Gaming** | Steam (32‑bit, RemotePlay) |
| **Fonts** | JetBrains Mono, Fira Code, Hack, 0xProto Nerd Fonts |
| **Secure boot** | lanzaboote (PKI bundle `/var/lib/sbctl`) |

## 🛠️ Cách rebuild hệ thống
```bash
# Alias được định nghĩa trong zsh: `update`
sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw
```
Lệnh này đọc `flake.nix`, biên dịch lại toàn bộ hệ thống và Home Manager, sau đó áp dụng ngay.

## 🤖 AI stack chi tiết
- **Opencode**: khai báo trong `modules/home/opencode.nix`.  Provider mặc định là Ollama (`http://localhost:11434/v1`).
- **Ollama**: chạy dưới `systemd --user` (`systemctl --user enable --now ollama`).  Khi thêm/bớt model, cập nhật `programs.opencode.settings.provider.ollama.models` rồi rebuild.
- **CodeCompanion** và **Minuet**: plugin Neovim để tương tác với các model AI trong editor.

## 📦 Các package tùy chỉnh
- `deepseek-harness` – bản build của DeepSeek Harness, dùng cho phát triển DSH.
- `openviking` – SDK và server cho bộ nhớ lâu dài (được sử dụng bởi skill `openviking‑memory`).

## 📜 Lưu ý phiên bản NixOS
```nix
system.stateVersion = "26.05";  # Phiên bản NixOS gốc đã được cài đặt
```
Không thay đổi giá trị này trừ khi bạn đã chuẩn bị migration dữ liệu và hiểu rõ tác động.

## 📂 Tài liệu tham khảo
- https://nixos.org/manual/nixos/stable/ (Manual)
- https://nixos.org/manual/home-manager/stable/ (Home Manager)
- https://github.com/folke/lazy.nvim (LazyVim)
- https://github.com/nix-community/lanzaboote (Lanzaboote)

---

*README này đã được mở rộng để cung cấp **danh sách chi tiết các module** cùng mô tả ngắn gọn, giúp bạn nhanh chóng nắm bắt cấu trúc và các thành phần của cấu hình NixOS.*