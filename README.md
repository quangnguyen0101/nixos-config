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
| **AI stack** | Opencode + Ollama + DSH (DeepSeek Harness) |
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
  - **15 community plugins**: vision toolkit, memory, web UI aggregate, agent teams, aegis, web search, …
  - **Web search**: `dsh-free-search` (keyless, multi-engine DDG/Bing/SearXNG, auto-failover) — thay thế `modsearch` (Firecrawl keyless 403, Antigravity capacity 503). `antigravity-cli` (agy) cũng đã gỡ theo.
- **Plugin management**: `pnpm install --frozen-lockfile` chạy qua Home Manager activation script
- **User patch layer**: `cordis.patch.yml` — override loader entries (openviking-memory enable, disable skin center)

### Vision Toolkit
Plugin `@anionex/dsh-vision-toolkit` — image analysis miễn phí (service shared của Anionex, 100 ảnh/máy/ngày, không cần API key).

- Dùng Python bundled (`python-build-standalone`) thay vì system python3
- `VISION_SSL_VERIFY=false` cần thiết vì plugin spawn subprocess với custom env

---

## 🧠 DSH Agent Capabilities

Tổng quan năng lực agent trong DSH profile "web". Chi tiết đầy đủ: `~/MEGA/DSH/README.md`.

### Tổng quan

| Thành phần | Số lượng | Ghi chú |
|---|---|---|
| Skills (quy trình làm việc) | **26** | Sẵn sàng |
| Tools khai báo | **68** | 53 built-in + 15 OpenViking |
| Vision tools tiềm ẩn | **+10** | Kích hoạt qua skill `vision-skills` |
| Agency Experts | **271** | 18 phân hệ — mặc định TẮT |
| MCP Servers | **1** | OpenViking |

### Skills (26)

| Nhóm | Skills |
|------|--------|
| **Kiến trúc** | `anti-entropy-governance`, `archify`, `establishing-project-context`, `first-principles-review`, `recording-architecture-decisions` |
| **Lập kế hoạch** | `brainstorming`, `executing-plans`, `writing-plans` |
| **Debug / QA** | `systematic-debugging`, `test-driven-development`, `verification-before-completion` |
| **Review** | `receiving-code-review`, `requesting-code-review` |
| **Đa agent** | `dispatching-parallel-agents`, `subagent-driven-development` |
| **Git** | `finishing-a-development-branch`, `using-git-worktrees` |
| **Mục tiêu** | `goal-framing`, `long-task-continuation` |
| **Bộ nhớ** | `openviking-memory` |
| **Trực quan** | `vision-skills`, `visualize` |
| **Giao tiếp** | `communicating-concisely` |
| **Routing** | `using-aegis` |
| **Bảo trì** | `update-aegis`, `writing-skills` |

### Built-in Tools (53)

| Nhóm | Tools |
|------|-------|
| **File & code (7)** | `read`, `write`, `edit`, `glob`, `grep`, `read_image`, `run_code` |
| **Shell & jobs (4)** | `bash`, `job_list`, `job_output`, `job_kill` |
| **Web** | `web_search` — keyless qua `dsh-free-search` (DuckDuckGo/Bing/SearXNG + auto-failover), thay thế `modsearch` (Firecrawl/Antigravity). `x_search` (X/Twitter) đã gỡ cùng `modsearch` |
| **Subagent (5)** | `subagent`, `subagent_fork`, `send_message`, `interrupt_agent`, `list_agents` |
| **AgentTeams (10)** | `create`, `add_member`, `remove_member`, `create_task`, `claim_task`, `update_task`, `reassign_task`, `send_message`, `status`, `delete` |
| **Agency (3)** | `list_experts`, `summon_expert`, `summon_experts` |
| **Goals (3)** | `create_goal`, `get_goal`, `update_goal` |
| **Orchestration (2)** | `workflow`, `ralph` |
| **Phiên & UI (6)** | `ask_user_question`, `todo_write`, `exit_plan_mode`, `skill`, `visualize`, `vision_toolkit_activate` |
| **SSH (6)** | `ssh_list`, `ssh_exec`, `ssh_cluster`, `ssh_upload`, `ssh_download`, `ssh_tunnel` |
| **Writing-guard (4)** | `writing_rules`, `writing_audit`, `writing_style_profile`, `writing_journal_profile` |

### MCP: OpenViking — bộ nhớ tri thức dài hạn (15 tools)

Database ngữ cảnh bền vững. Không gian URI `viking://`.

| Tool | Mô tả |
|------|-------|
| `remember` | Lưu thông tin vào long-term memory |
| `search` | Deep semantic retrieval với session context |
| `find` | Fast semantic retrieval không cần session context |
| `read` | Đọc file URI (batch support) |
| `write` | Ghi text vào virtual file |
| `edit` | Thay chuỗi literal trong virtual file |
| `glob` | Tìm file theo filename pattern |
| `grep` | Regex content search |
| `tree` | Cây thư mục đệ quy |
| `list` | Liệt kê files + subdirectories một cấp |
| `health` | Health check server |
| `add_resource` | Nuốt tài nguyên vào knowledge base (async) |
| `forget` | Xóa vĩnh viễn URI (irreversible) |
| `list_watches` | Liệt kê watch tasks |
| `cancel_watch` | Hủy watch theo target URI |

### Vision Tools (+10, tiềm ẩn)

| Tool | Chức năng |
|------|-----------|
| `vision_glance` | Nhìn nhanh tổng quát nội dung ảnh |
| `vision_ground` | Định vị vùng theo mô tả ngôn ngữ tự nhiên |
| `vision_detect` | Phát hiện/liệt kê đối tượng kèm bounding box |
| `vision_trace` | SVG tracing từ hình ảnh |
| `vision_crop` | Cắt vùng ảnh theo tọa độ |
| `vision_pixel_diff` | So sánh pixel hai ảnh |
| `vision_long_screenshot_ocr` | OCR screenshot dài / chat log |
| `vision_extract_foreground` | Tách foreground khỏi nền |
| `vision_dominant_colors` | Trích bảng màu chủ đạo |
| `vision_html_screenshot` | HTML → screenshot |

### Agency Experts (271)

- **18 phân hệ**: engineering, security, marketing, design, finance, research, …
- **Trạng thái**: ⚠️ TẤT CẢ TẮT (mặc định). Bật qua Web GUI → Agency settings.
- **Workflow**: `list_experts` → `summon_expert` / `summon_experts` (tối đa 8, concurrency 4)

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
