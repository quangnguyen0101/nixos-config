# nixos-config

## 📖 Giới thiệu

**NixOS** cấu hình cá nhân được quản lý bằng **Nix Flake** và **Home Manager**. Đây là một *single-host* setup (máy `nixos-btw`) với kiến trúc **modular**: phần hệ thống và phần người dùng được tách riêng, dễ bảo trì và mở rộng.

## 📚 Tài liệu

> [!tip] Obsidian
> Docs viết theo chuẩn **Obsidian** (wikilink + callout + frontmatter). Mở `~/nixos-config` làm vault trong Obsidian để có trải nghiệm đầy đủ (click-nhảy qua `[[...]]`, graph view, backlinks). GitHub render được phần lớn — chỉ wikilink hiện thành text thường.

- [`docs/USAGE.md`](docs/USAGE.md) — cheatsheet cách dùng từng công cụ hằng ngày (update, tmux, keep-awake, brt, rmpc, autoskills, …)
- [`docs/INVENTORY.md`](docs/INVENTORY.md) — trạng thái từng module (đang chạy / đã tắt) + cách bật/tắt, đỡ cài phí không dùng
- [`docs/tools/_index.md`](docs/tools/_index.md) — **Map of Content**: 1 note/tool click-nhảy (9 MCP servers + autoskills, keep-awake, brt, rmpc)

## 🗂️ Cấu trúc dự án

```
flake.nix                     # Entry point – khai báo inputs, outputs và các module
└─ nixosConfigurations.nixos-btw
    ├─ hosts/nixos-btw/               # Cấu hình máy cụ thể (hardware, hostname, locale…)
    │   ├─ configuration.nix           # Tổng hợp các module hệ thống
    │   └─ hardware-configuration.nix # Tự động sinh bởi nixos-generate-config
    ├─ modules/system/                # Các module NixOS tái sử dụng
    ├─ modules/home/ → home/          # Home Manager – cấu hình người dùng
    ├─ pkgs/                          # Package & asset tùy chỉnh (opencode skills, openviking, ouroboros, ponytail)
    ├─ docs/                          # Tài liệu (USAGE, INVENTORY, sơ đồ kiến trúc, note từng tool)
    └─ (Secure Boot)                  # lanzaboote bật trực tiếp trong flake.nix, không có module riêng
```

### 📦 Danh sách các module chi tiết

#### Modules hệ thống (`modules/system/`)
| Module | Mô tả ngắn |
|--------|------------|
| `hyprland.nix` | Hyprland (Wayland compositor) + XDG portal |
| `steam.nix` | Steam, hỗ trợ 32-bit graphics, mở firewall cho RemotePlay |
| `fonts.nix` | Nerd Fonts (JetBrains Mono, Fira Code, Hack, 0xProto) |
| `networking.nix` | NetworkManager, DHCP, DNS, Wi-Fi, VPN, tắt IPv6, pin CDN Steam |
| `bluetooth.nix` | Bluetooth stack |
| `i18n.nix` | Locale, layout, fcitx5-lotus (Vietnamese) |
| `gc.nix` | Garbage collector tự động (`nix.gc.automatic = true`) |
| `greeter.nix` | greetd + regreet (giao diện đăng nhập) |
| `printing.nix` | CUPS để in ấn |
| `systemPackages.nix` | Gói hệ thống chung (git, curl, vim, …) |
| `fcitx5-lotus.nix` | Bộ gõ Vietnamese dựa trên Lotus Input Method |
| `nix-ld.nix` | nix-ld + libraries (libstdc++, zlib, openssl) cho binary/wheel ngoài nix |
| `postgres-docker.nix` | Container PostgreSQL declarative (oci-containers, `postgres:17-alpine`, bind mount `/home/sh4d0wph4nt0m/data/postgres`) |
| `clamav.nix` | Antivirus ClamAV — `freshclam.conf` trỏ DB về `~/.local/share/clamav` (quét bằng hàm `cs`) |
| `backlight.nix` | Udev rule cấp quyền `video` cho `intel_backlight` + DDC/CI (`i2c-dev`) để ddcutil chỉnh sáng màn ngoài |
| `rclone-fuse.nix` | Bật FUSE (`programs.fuse`) cho rclone mount |

> 🔐 **Secure Boot**: bật bằng [lanzaboote](https://github.com/nix-community/lanzaboote) trực tiếp trong `flake.nix` (module `lanzaboote.nixosModules.lanzaboote`), không tách thành file riêng trong `modules/system/`.

#### Modules người dùng (`modules/home/`)
| Module | Mô tả ngắn |
|--------|------------|
| `zsh.nix` | Zsh + Oh-My-Zsh, alias `rebuild`, hàm `cs` (quét virus), tự động khởi chạy tmux |
| `nvim.nix` | Neovim — symlink `nvim-config/` vào `~/.config/nvim` |
| `nvim-config/` | Cấu hình Neovim (LazyVim) với >30 plugin (LSP, Treesitter, Telescope, …) |
| `tmux.nix` | Tmux, plugin `resurrect`/`continuum` để giữ session |
| `ghostty.nix` | Terminal GPU-accelerated Ghostty, theme Catppuccin |
| `firefox.nix` | Firefox — tinh chỉnh giảm RAM (giới hạn content-process, unload tab nền), tắt telemetry |
| `caelestia.nix` | Caelestia shell (Wayland Hyprland shell) |
| `opencode.nix` | Opencode declarative + Ollama AI stack (systemd-user) + 9 MCP servers + 13 global skills |
| `llm-agents.nix` | Agent từ `numtide/llm-agents.nix` — OpenCode desktop GUI, `freebuff` CLI; OpenCode TUI dùng CLI ở đây |
| `jupyter.nix` | Python 3.14 unified env (JupyterLab + scripting/libs: pip, requests, mutagen, matplotlib) — kernel cho MCP `jupyter` |
| `openviking-server.nix` | OpenViking context database server + CLI (systemd-user) |
| `cava.nix` | CAVA (audio visualizer) |
| `easyeffects.nix` | EasyEffects presets (audio processing) |
| `rmpc-config/` | Music Player Client (rmpc) — config + themes |
| `userPackages.nix` | Gói người dùng chung (pnpm, uv, ollama, codex, libreoffice, blender, megasync, …) |
| `dms.nix` | ⏸️ Dank Material Shell — đã gỡ khỏi `home.nix` |
| `noctalia.nix` | ⏸️ Noctalia shell — đã gỡ khỏi `home.nix` |
| `autoskills.nix` | autoskills CLI (CC-BY-NC-4.0) — cài skill AI vào `.agents/skills/` theo project (xem `docs/USAGE.md`) |
| `keep-awake/` | Giữ máy awake khi đóng lid — menu TUI `keep-awake` (ydotool + systemd-inhibit) |
| `brt.nix` | Điều khiển độ sáng (brightnessctl / ddcutil / fallback wlsunset) |
| `brt-config/` | Config cho `brt` (thiết bị/logic từng màn hình) |
| `rclone-gdrive.nix` | Mount Google Drive qua systemd-user (`rclone-mount` → `~/GoogleDrive`) |

## 🚀 Các thành phần chính (tóm tắt)
| Thành phần | Mô tả |
|-----------|------|
| **Window manager** | Hyprland + Caelestia shell |
| **Shell** | Zsh + Oh-My-Zsh, alias `rebuild` |
| **Terminal** | Ghostty (Catppuccin theme) |
| **Editor** | Neovim (LazyVim) với hơn 30 plugin |
| **Multiplexer** | Tmux với `resurrect/continuum` |
| **Login** | greetd + regreet (Rosé Pine) |
| **Input** | fcitx5-lotus + bamboo (Vietnamese) |
| **AI stack** | Opencode (Ollama + OpenCode Zen free) + 9 MCP servers (arxiv, context7, docker, github, jupyter, openviking, ouroboros, postgres, vision) |
| **Browser** | Firefox (tối ưu RAM) + Brave/Chromium |
| **Văn phòng & 3D** | LibreOffice, Blender, MeshLab, f3d |
| **LaTeX** | TeX Live + Zathura + TeXstudio (vimtex) |
| **Gaming** | Steam (32-bit, RemotePlay) |
| **Fonts** | JetBrains Mono, Fira Code, Hack, 0xProto Nerd Fonts |
| **Secure boot** | lanzaboote (PKI bundle `/var/lib/sbctl`) |

## 🛠️ Cách rebuild hệ thống
```bash
# Alias được định nghĩa trong zsh: `rebuild`
sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw
```
Lệnh này đọc `flake.nix`, biên dịch lại toàn bộ hệ thống và Home Manager, sau đó áp dụng ngay.

## 🤖 AI stack chi tiết

### Opencode
Khai báo trong `modules/home/opencode.nix`. Provider mặc định là Ollama (`http://localhost:11434/v1`), model mặc định `ollama/gpt-oss:120b-cloud` (bắt buộc cho headless `opencode run`). Ngoài Ollama còn dùng được các model free của **OpenCode Zen** (ID dạng `opencode/<model>`). Config/skill do `modules/home/opencode.nix` + `modules/home/llm-agents.nix` cung cấp. Chạy dưới `systemd --user`.

#### MCP servers (9)

| MCP server | Loại | Mô tả |
|-----------|------|-------|
| `context7` | remote | Tra cứu docs/code examples của thư viện (Context7) |
| `docker` | local (`npx @hypnosis/docker-mcp-server`) | Quản lý containers, images, volumes, logs qua `DOCKER_HOST=unix:///var/run/docker.sock` |
| `github` | remote | GitHub repos, issues, PRs, code search |
| `openviking` | local | OpenViking context database — Xem `pkgs/openviking/README.md` |
| `ouroboros` | local (`uvx ouroboros-ai[mcp]==0.54.4`) | Agent OS — Xem `pkgs/ouroboros/README.md` |
| `postgres` | local (`uvx postgres-mcp==0.3.0`) | SQL data science trên container `postgres-ds` (PostgreSQL 17) |
| `arxiv` | local (`uvx arxiv-mcp-server[pdf]==0.7.2`) | Tìm kiếm / đọc paper arXiv (bao gồm fallback PDF→markdown qua pymupdf) |
| `jupyter` | local (`uvx jupyter-mcp-server==2.1.15`) | Chạy notebook / Python code trên JupyterLab (127.0.0.1:8888) — kernel data science: pandas, numpy, matplotlib, scikit-learn |
| `vision` | local (`uvx opencode-vision[paddle]==2.1.0`) | OCR/vision: PaddleOCR local + Gemini free fallback (`gemini.key`); wrapper `pkgs/opencode/vision-mcp-wrapper.py` |

Các server local dùng `uvx`/`npx` cần `LD_LIBRARY_PATH` trỏ tới `stdenv.cc.cc.lib` (greenlet/biopython trên NixOS cần libstdc++) — cấu hình trong `opencode.nix`. Jupyter MCP server kết nối tới JupyterLab đang chạy nền (`systemctl --user status jupyterlab`).

#### Skills

**Global skills** — symlink từ `pkgs/opencode/skills/` ra `~/.config/opencode/skills/`:

> Bảng dưới **sinh tự động** từ frontmatter `SKILL.md` — sửa bằng `python3 scripts/gen-skills-table.py` (đừng sửa tay; `--check` để phát hiện lệch).

<!-- BEGIN SKILLS-TABLE -->
| Skill | Nguồn | Mô tả |
|-------|-------|-------|
| `data-science` | repo | Workflow data science: notebook trên Jupyter MCP, compute server-side, Postgres/Docker, tra cứu arXiv, xuất plot + BibTeX |
| `archify` | vendored `tt-a1i/archify` (MIT) | Render mô hình hệ thống (architecture/workflow/sequence/dataflow/lifecycle) → HTML/SVG tương tác từ JSON IR; cần `node >=18` |
| `guizang-ppt-skill` | vendored `op7418/guizang-ppt-skill` (AGPLv3) | Web PPT 1-file dạng swipe ngang (2 style: *Magazine x E-Ink* / *Swiss*) + image prompt + cover mạng xã hội |
| `latex-document-skill` | vendored `ndpvt-web/latex-document-skill` (MIT) | Compile LaTeX → PDF + preview PNG, 28 template + CV ATS, chart/mermaid/graphviz, mail-merge, fill/extract PDF |
| `manim-composer` | vendored `adithya-s-k/manim_skill` (MIT) | Lập kế hoạch scene-by-scene cho video Manim (ra `scenes.md`) trước khi viết code |
| `manimce-best-practices` | vendored `adithya-s-k/manim_skill` (MIT) | Best practices ManimCE: 24 rule + example + template (Scene, MathTex, 3D, camera, …) |
| `manim-skill` | vendored `Yusuke710/manim-skill` (MIT) | Render video ManimCE + TTS voiceover (Kokoro local) + subtitle đồng bộ; tools gọi `python` (kokoro/soundfile nằm trong `jupyterEnv`) |
| `defuddle` | vendored `kepano/obsidian-skills` (MIT) | Trích Markdown sạch từ trang HTML |
| `json-canvas` | vendored `kepano/obsidian-skills` (MIT) | Tạo/sửa file `.canvas` (node / edge / group) |
| `knap` | vendored `kepano/obsidian-skills` (MIT) | Render Markdown từ template + data (JSON/CSV) |
| `obsidian-bases` | vendored `kepano/obsidian-skills` (MIT) | Tạo/sửa file `.base` (view / filter / formula) |
| `obsidian-cli` | vendored `kepano/obsidian-skills` (MIT) | Thao tác vault Obsidian qua CLI (đọc/tạo/search note, plugin & theme dev) |
| `obsidian-markdown` | vendored `kepano/obsidian-skills` (MIT) | Obsidian Flavored Markdown (wikilink, callout, embed, frontmatter) |
<!-- END SKILLS-TABLE -->

**Repo-scope skill**: `nixos-config` (`.opencode/skills/nixos-config/`) — rebuild/check, module layout, secrets, tích hợp opencode; chỉ active khi làm việc trong repo này.

**Instructions**: `shell-strategy` (`pkgs/opencode/shell_strategy.md` → `~/.config/opencode/shell_strategy.md`, vendored JRedeker/opencode-shell-strategy) — shell non-interactive: fail-fast `sudo -n`, cấm pager/editor, tránh treo TTY.

**CLI liên quan**: `autoskills` (`modules/home/autoskills.nix` → `pkgs.autoskills`, CC-BY-NC-4.0) — cài skill AI vào `.agents/skills/` theo từng project (xem `docs/USAGE.md`).

**Plugins** (khai báo trong `opencode.nix`): `ouroboros-bridge.ts` (dispatch subagent của MCP ouroboros ra Task pane) và **ponytail** (vendored `DietrichGebert/ponytail`, MIT — chế độ "lazy senior dev", inject ruleset vào system prompt mỗi turn).

Config/skills/plugins chỉ có hiệu lực sau khi **thoát & mở lại opencode** (không hot-reload).

#### Sơ đồ kiến trúc

Sơ đồ kiến trúc AI stack (opencode + 9 MCP servers + backend) render bằng skill `archify`: mở [`docs/nixos-config-architecture.html`](docs/nixos-config-architecture.html).

- Source JSON: `docs/nixos-config.architecture.json` (12 nodes, 3 boundaries, 4 cards)
- Re-render lại (cần `node >= 18`):
  ```bash
  node ~/.config/opencode/skills/archify/bin/archify.mjs render architecture \
    docs/nixos-config.architecture.json docs/nixos-config-architecture.html
  ```
- Validate với `quality_profile=showcase`: `node ... run validate` — thêm `--quality showcase --json` cho báo cáo máy.

### Ollama
Chạy dưới `systemd --user` (`systemctl --user enable --now ollama`). Khi thêm/bớt model, cập nhật `programs.opencode.settings.provider.ollama.models` rồi rebuild.

### CodeCompanion & Minuet
Plugin Neovim để tương tác với các model AI trong editor.

## 📦 Các package tùy chỉnh

| Package | Đường dẫn | Mô tả |
|---------|-----------|-------|
| `openviking` | `pkgs/openviking/` | Context database server + CLI — nền cho MCP `openviking`. Xem README.md trong thư mục. |
| `ouroboros` | `pkgs/ouroboros/` | 🧩 Không phải package — vendor bridge plugin `.ts` cho MCP `ouroboros`. Xem README.md trong thư mục. |
| `opencode` (assets) | `pkgs/opencode/` | 🧩 Không phải package — vendored skills, `shell_strategy.md`, `vision-mcp-wrapper.py`, autoskills. |
| `ponytail` | `pkgs/ponytail/` | 🧩 Plugin opencode (vendored `DietrichGebert/ponytail`, MIT) — lazy senior dev ruleset. |

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
- https://ouroboros.ai (Ouroboros — Agent OS MCP)
- https://openviking.dev (OpenViking — context database)
