# nixos-config

## 📖 Giới thiệu

**NixOS** cấu hình cá nhân được quản lý bằng **Nix Flake** và **Home Manager**. Đây là một *single-host* setup (máy `nixos-btw`) với kiến trúc **modular**: phần hệ thống và phần người dùng được tách riêng, dễ bảo trì và mở rộng.

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
    └─ lanzaboote/                    # Secure Boot (lanzaboote) integration
```

### 📦 Danh sách các module chi tiết

#### Modules hệ thống (`modules/system/`)
| Module | Mô tả ngắn |
|--------|------------|
| `hyprland.nix` | Hyprland (Wayland compositor) + XDG portal |
| `steam.nix` | Steam, hỗ trợ 32-bit graphics, mở firewall cho RemotePlay |
| `fonts.nix` | Nerd Fonts (JetBrains Mono, Fira Code, Hack, 0xProto) |
| `networking.nix` | NetworkManager, DHCP, DNS, Wi-Fi, VPN, tắt IPv6 |
| `bluetooth.nix` | Bluetooth stack |
| `i18n.nix` | Locale, layout, fcitx5-lotus (Vietnamese) |
| `gc.nix` | Garbage collector tự động (`nix.gc.automatic = true`) |
| `greeter.nix` | greetd + regreet (giao diện đăng nhập) |
| `printing.nix` | CUPS để in ấn |
| `systemPackages.nix` | Gói hệ thống chung (git, curl, vim, …) |
| `lanzaboote.nix` | Secure Boot bằng lanzaboote |
| `fcitx5-lotus.nix` | Bộ gõ Vietnamese dựa trên Lotus Input Method |
| `nix-ld.nix` | nix-ld + libraries (libstdc++, zlib, openssl) cho binary/wheel ngoài nix |

#### Modules người dùng (`modules/home/`)
| Module | Mô tả ngắn |
|--------|------------|
| `zsh.nix` | Zsh + Oh-My-Zsh, alias `update`, tự động khởi chạy tmux |
| `nvim.nix` | Neovim — symlink `nvim-config/` vào `~/.config/nvim` |
| `nvim-config/` | Cấu hình Neovim (LazyVim) với >30 plugin (LSP, Treesitter, Telescope, …) |
| `tmux.nix` | Tmux, plugin `resurrect`/`continuum` để giữ session |
| `ghostty.nix` | Terminal GPU-accelerated Ghostty, theme Catppuccin |
| `caelestia.nix` | Caelestia shell (Wayland Hyprland shell) |
| `opencode.nix` | Opencode declarative + Ollama AI stack (systemd-user) |
| `openviking-server.nix` | OpenViking context database server + CLI (systemd-user) |
| `python.nix` | Python và các gói pip tùy chỉnh |
| `cava.nix` | CAVA (audio visualizer) |
| `easyeffects.nix` | EasyEffects presets (audio processing) |
| `rmpc-config/` | Music Player Client (rmpc) — config + themes |
| `userPackages.nix` | Gói người dùng chung (dsh, pnpm, uv, ollama, …) |
| `dsh-plugins.nix` | Declarative plugin management cho DSH profile "web" |
| `dsh-profile/` | Manifests vendored (package.json, lockfile, cordis.patch.yml) |

## 🚀 Các thành phần chính (tóm tắt)
| Thành phần | Mô tả |
|-----------|------|
| **Window manager** | Hyprland + Caelestia shell |
| **Shell** | Zsh + Oh-My-Zsh, alias `update` |
| **Terminal** | Ghostty (Catppuccin theme) |
| **Editor** | Neovim (LazyVim) với hơn 30 plugin |
| **Multiplexer** | Tmux với `resurrect/continuum` |
| **Login** | greetd + regreet (Rosé Pine) |
| **Input** | fcitx5-lotus + bamboo (Vietnamese) |
| **AI stack** | Opencode + Ollama + DSH (DeepSeek Harness) + Ouroboros MCP |
| **Gaming** | Steam (32-bit, RemotePlay) |
| **Fonts** | JetBrains Mono, Fira Code, Hack, 0xProto Nerd Fonts |
| **Secure boot** | lanzaboote (PKI bundle `/var/lib/sbctl`) |

## 🛠️ Cách rebuild hệ thống
```bash
# Alias được định nghĩa trong zsh: `update`
sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw
```
Lệnh này đọc `flake.nix`, biên dịch lại toàn bộ hệ thống và Home Manager, sau đó áp dụng ngay.

## 🤖 AI stack chi tiết

### Opencode
Khai báo trong `modules/home/opencode.nix`. Provider mặc định là Ollama (`http://localhost:11434/v1`). Chạy dưới `systemd --user`.

### Ollama
Chạy dưới `systemd --user` (`systemctl --user enable --now ollama`). Khi thêm/bớt model, cập nhật `programs.opencode.settings.provider.ollama.models` rồi rebuild.

### CodeCompanion & Minuet
Plugin Neovim để tương tác với các model AI trong editor.

### DeepSeek Harness (DSH)
Plugin-based AI agent CLI. Package tùy chỉnh trong `pkgs/deepseek-harness/` (xem `README.md` trong thư mục đó).

- **Binary**: `dsh` (Node.js + `--expose-internals` cho HMR)
- **Profile "web"**: managed declaratively trong `modules/home/dsh-profile/`
- **14 community plugins**: vision toolkit, memory, web UI aggregate, agent teams, ouroboros, …
- **Plugin management**: `pnpm install --frozen-lockfile` chạy qua Home Manager activation script
- **User patch layer**: `cordis.patch.yml` — override loader entries (ouroboros config, disable skin center)

### Ouroboros MCP
MCP server tích hợp trong DSH, chạy qua `uvx`:

- **Backend**: `litellm` → Ollama cloud (`ollama/gpt-oss:120b-cloud`)
- **Runtime agent**: `opencode`
- **36 tools**: execute seed, interview, evolve, QA, drift measure, …
- **Config**: `~/.ouroboros/config.yaml`

### Vision Toolkit
Plugin `@anionex/dsh-vision-toolkit` — image analysis miễn phí (service shared của Anionex, 100 ảnh/máy/ngày, không cần API key).

- Dùng Python bundled (`python-build-standalone`) thay vì system python3
- `VISION_SSL_VERIFY=false` cần thiết vì plugin spawn subprocess với custom env

## 📦 Các package tùy chỉnh

| Package | Đường dẫn | Mô tả |
|---------|-----------|-------|
| `deepseek-harness` | `pkgs/deepseek-harness/` | DSH CLI binary — bundle npm tarball với peer deps promoted thành direct deps. Xem README.md trong thư mục. |
| `openviking` | `pkgs/openviking/` | Context database server + CLI — SDK cho bộ nhớ lâu dài, dùng bởi plugin `openviking-memory` trong DSH profile. |

### nix-ld
`modules/system/nix-ld.nix` kích hoạt `programs.nix-ld` với `libstdc++`, `zlib`, `openssl` — cần thiết cho C-extension wheels (pillow, numpy, greenlet, …) dựng ngoài nix.

## 📜 Lưu ý phiên bản NixOS
```nix
system.stateVersion = "26.05";  # Phiên bản NixOS gốc đã được cài đặt
```
Không thay đổi giá trị này trừ khi bạn đã chuẩn bị migration dữ liệu và hiểu rõ tác động.

## 📂 Tài liệu tham khảo
- https://nixos.org/manual/nixos/stable/ (NixOS Manual)
- https://nixos.org/manual/home-manager/stable/ (Home Manager)
- https://github.com/folke/lazy.nvim (LazyVim)
- https://github.com/nix-community/lanzaboote (Lanzaboote)
- https://github.com/deepseek-ai/deepseek-harness (DeepSeek Harness)
- https://github.com/Q00/ouroboros (Ouroboros)
