# deepseek-harness

Nix package cho **DeepSeek Harness (dsh)** — plugin-based AI agent CLI. Bundle upstream npm `@deepseek-ai/dsh` vào Nix store bằng `buildNpmPackage` với manifest đã được vá sẵn.

## Tại sao cần package riêng?

Upstream `@deepseek-ai/dsh` sử dụng cấu trúc `peerDependencies` phức tạp (80+ `@deepseek-ai/dsh-*` packages). `buildNpmPackage` với `--legacy-peer-deps` không thể cài peers đúng cách vì dsh import chúng trực tiếp lúc runtime. Package này giải quyết bằng cách **promote tất cả peerDependencies thành direct dependencies** trong manifest trước khi build.

## Cách hoạt động

```
fetchurl (npm tarball)
    ↓
runCommand: giải nén + thay thế package.json & package-lock.json
    ↓
buildNpmPackage: npm install --legacy-peer-deps
    ↓
postInstall: tạo wrapper script (node --expose-internals bin.js)
```

### Các file trong thư mục

| File | Vai trò |
|------|---------|
| `default.nix` | Nix derivation — fetch, patch, build, wrap |
| `package.json` | Manifest đã vá: mọi peer → direct dependencies |
| `package-lock.json` | Lockfile tương ứng với manifest đã vá |

### Peer dependency trick

Upstream `package.json` gốc khai báo peers:

```json
{
  "peerDependencies": {
    "@deepseek-ai/dsh-base": "^0.1.1-rc.2",
    "@deepseek-ai/dsh-web-app": "^0.1.1-rc.2",
    ...
  }
}
```

Manifest trong thư mục này chuyển thành:

```json
{
  "dependencies": {
    "@deepseek-ai/dsh-base": "^0.1.1-rc.2",
    "@deepseek-ai/dsh-web-app": "^0.1.1-rc.2",
    ...
  }
}
```

Điều này đảm bảo cả `fetchNpmDeps` (phase fetch) lẫn `install phase` đều thấy cùng một cây dependency.

### Wrapper script

`postInstall` tạo binary `dsh` bằng `makeWrapper`:

```bash
node --expose-internals $out/lib/node_modules/@deepseek-ai/dsh/lib/bin.js
```

`--expose-internals` bắt buộc vì `cordis-plugin-hmr` (Hot Module Reload) cần truy cập Node.js internals.

## Cài đặt

Được cài qua `modules/home/userPackages.nix`:

```nix
(pkgs.callPackage ../../pkgs/deepseek-harness { })
```

Yêu cầu `nodejs` được truyền vào derivation (thông qua `pkgs`).

## Plugins

DSH hoạt động theo mô hình "everything is a plugin". CLI boot từ `dsh-base` bundle, sau đó load thêm plugins từ profile.

### Profile "web" (default)

Managed declaratively trong `modules/home/dsh-profile/`:

| Plugin | Nguồn | Phiên bản | Ghi chú |
|--------|-------|-----------|---------|
| `@dsh-external/dsh-visualize` | GitHub | — | Visualization tools |
| `@anionex/dsh-vision-toolkit` | npm | 0.1.39 | Image analysis (free service) |
| `@linxin666/dsh-web-ui-all` | npm | 0.3.2 | Aggregate web UI plugins |
| `@liustack/modsearch` | npm | 5.8.0 | Module search |
| `@michengai/dsh-agency-agents` | npm | 0.1.20 | Agency agent presets |
| `@nanmicoder/dsh-agent-teams` | npm | 0.1.13 | Multi-agent teams |
| `@openviking/dsh-memory-plugin` | npm | ^0.2.1 | Long-term memory (via `openviking`) |
| `@tt-a1i/archify-dsh` | npm | 0.1.0 | Archiving |
| `aegis` | GitHub | pinned commit | — |
| `dsh-context` | npm | 0.25.3 | Context management |
| `dsh-kimino-theme` | GitHub | — | UI theme |
| `dsh-ouroboros` | GitHub | pinned commit | MCP server (Ollama cloud) |
| `dsh-plugin-writing-guard` | npm | 1.6.1 | Write safety guard |
| `upstream-radar` | npm | 0.36.0 | Upstream monitoring |

### Thêm plugin mới

```bash
cd modules/home/dsh-profile
# 1. Sửa package.json: thêm vào "dependencies" VÀ mảng "dsh.profile.bundles"
# 2. Cập nhật lockfile:
nix shell nixpkgs#pnpm -c pnpm install --lockfile-only
# 3. Rebuild
sudo nixos-rebuild switch
```

### Cordis patch layer

`cordis.patch.yml` trong `modules/home/dsh-profile/` là **nguồn sự thật** cho user-level overrides. Activation script sync file này vào `~/.dsh/profiles/web/` mỗi rebuild (ngoài hash guard — không cần `pnpm install` lại).

Hiện tại patch:
- Enable `openviking-memory`
- Disable `web-ui-skin-center` (unwanted panel)
- Override `mcp-ouroboros` config (Ollama cloud backend)

## MCP integration (Ouroboros)

DSH tích hợp Ouroboros qua MCP (Model Context Protocol). Server chạy qua `uvx` với config trong `cordis.patch.yml`:

- Backend: `litellm` → Ollama cloud (`ollama/gpt-oss:120b-cloud`)
- Runtime agent: `opencode`
- Tools: 36 registered (execute seed, interview, evolve, QA, ...)
- Config location: `~/.ouroboros/config.yaml`

## Vấn đề NixOS

### nix-ld

Binary/wheel dựng ngoài nix cần `/lib64/ld-linux-x86-64.so.2`. `programs.nix-ld` trong `modules/system/nix-ld.nix` cung cấp:

```nix
programs.nix-ld.libraries = with pkgs; [
  stdenv.cc.cc.lib  # libstdc++
  zlib
  openssl
];
```

### Python bundled (vision toolkit)

Plugin `dsh-vision-toolkit` dùng Python bundled (`python-build-standalone`) thay vì system python3. Lý do: nixpkgs python dùng loader riêng (`/nix/store/.../ld-linux-x86-64.so.2`), bypass nix-ld → C-extension wheels (pillow, numpy) không load được.

Environment variables cần thiết (set trong `dsh-plugins.nix`):

```nix
home.sessionVariables.SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
home.sessionVariables.VISION_SSL_VERIFY = "false";  # plugin custom env, SSL_CERT_FILE không đến subprocess
```

## Sử dụng

```bash
# Khởi chạy web UI
dsh web

# Khởi chạy với port cụ thể
dsh web --port 3000

# Dùng trong terminal
dsh
```

## Agent Capabilities

DSH có 26 skills, 104 tools (53 built-in + 15 OpenViking + 36 Ouroboros), 271 agency experts, và 10 vision tools tiềm ẩn. Xem chi tiết tại [`docs/agent-capabilities.md`](docs/agent-capabilities.md).

###僕 Commands hữu ích

| Command | Mô tả |
|---------|-------|
| `dsh web` | Khởi chạy web UI |
| `dsh --help` | Xem tất cả options |
| `dsh --profile <name>` | Dùng profile cụ thể |

## Cập nhật phiên bản

1. Sửa `version` trong `default.nix`
2. Cập nhật `hash` tarball mới (để nix tự báo hash sai rồi copy hash đúng)
3. Cập nhật `npmDepsHash` nếu lockfile thay đổi
4. Rebuild và test

```bash
# Sau khi đổi hash, nix sẽ báo:
# error: hash mismatch in fixed-output derivation
# Copy hash mới từ error message vào default.nix
sudo nixos-rebuild switch
```

## Lưu ý

- Chỉ hỗ trợ Linux (`platforms = lib.platforms.linux`)
- Phiên bản hiện tại: `0.1.1-rc.2` (release candidate)
- Upstream repo: https://github.com/deepseek-ai/deepseek-harness
- License: MIT
