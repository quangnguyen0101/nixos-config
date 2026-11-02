---
tags: [nixos, docs, mcp]
---

# MCP — các MCP server của opencode

> [!info] Obsidian
> Vault này = repo `~/nixos-config`. Mở trong **Obsidian** để dùng wikilink `[[...]]`, graph view, backlinks — GitHub render phần lớn (chỉ wikilink thành text).

> [!warning] Danh sách viết tay
> Bảng dưới đây gõ tay, không auto-gen. **Thêm/bớt MCP server → phải sửa note này** (và bảng ở [[README|README § MCP servers]]), nếu không sẽ lệch như vụ `vision` từng bị thiếu.

> [!note]
> 5 MCP server khai báo trong `modules/home/opencode.nix` → `mcp.*`. Bảng name/nguồn/mô tả ngắn ở [[README|README § MCP servers]]; note này bổ sung **transport, lệnh chạy thật, cách wiring + bật/tắt**. Cách dùng chi tiết từng server: [[_index|docs/tools]].

## Bảng 5 server

| MCP | Transport | Lệnh chạy (rút từ `opencode.nix`) | Note |
|-----|-----------|-----------------------------------|------|
| `context7` | remote | `https://mcp.context7.com/mcp` | [[context7]] |
| `github` | remote | `https://api.githubcopilot.com/mcp/` (PAT `{file:...github.token}`) | [[github]] |
| `docker` | local | `npx -y @hypnosis/docker-mcp-server@2.0.1` | [[docker]] |
| `postgres` | local | `uvx --from 'postgres-mcp==0.3.0' --with 'mcp<2' postgres-mcp <dsn>` | [[postgres]] |
| `jupyter` | local | `uvx --from 'jupyter-mcp-server==2.1.15' jupyter-mcp-server` | [[jupyter]] |

## Wiring chung

- **`remote`** — opencode nối thẳng URL; không cần process nền.
- **`local`** (`uvx`/`npx`) — opencode tự spawn. Cold start lần đầu chậm → `opencode mcp list` có thể báo fail transient, **chạy lại là OK**.
- `LD_LIBRARY_PATH = stdenv.cc.cc.lib/lib` cho các server local (greenlet/biopython trên NixOS cần libstdc++).
- Version **pin trong `command`** (comment `# pin version`) — nâng version = sửa `opencode.nix` rồi `update`.
- Secret ngoài repo qua `{file:...}` (file mode 600, không commit): github → `~/.config/opencode/github.token`.
- `jupyter`: trỏ JupyterLab chạy nền `http://127.0.0.1:8888` (`systemctl --user status jupyterlab`).

## Bật / tắt

1. Sửa khối `mcp.<name>` trong `modules/home/opencode.nix` → đặt `enabled = false` (hoặc xóa khối).
2. `update` (rebuild) rồi **thoát & mở lại** opencode.
3. Kiểm tra: `opencode mcp list`.

## Liên quan

- [[_index|docs/tools]] — map of content mọi tool/MCP
- [[USAGE]] — cheatsheet hằng ngày
- [[SKILLS]] — lệnh cụ thể của từng skill
- [[INVENTORY]] — trạng thái bật/tắt từng module
