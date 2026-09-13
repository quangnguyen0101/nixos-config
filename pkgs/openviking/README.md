# openviking

Package NixOS tùy chỉnh cho [OpenViking](https://openviking.dev) — context database server với long-term memory cho AI agents.

## Cài đặt

```nix
# system-packages.nix
pkgs.openviking
```

## Cấu trúc

```
pkgs/openviking/
├── default.nix       # Overlay: inject custom deps vào python3Packages
├── package.nix       # buildPythonPackage (wheel, manylinux)
└── deps/
    ├── openviking-sdk.nix
    ├── volcengine.nix
    ├── volcengine-python-sdk.nix
    ├── tree-sitter-language-pack.nix
    └── opentelemetry-instrumentation-asyncio.nix
```

## Kỹ thuật

- **Format**: wheel (`cp310-abi3-manylinux_2_31_x86_64`)
- **autoPatchelfHook**: patchelf libc/libstdc++ automatically trên NixOS
- **pythonRemoveDeps**: bỏ 10 tree-sitter-language-* deps (không cần, dùng `tree-sitter-language-pack` bundled)
- **pythonRelaxDeps**: mở version lock cho `urllib3`, `cryptography`, `pathspec`, `opentelemetry-instrumentation-asyncio` để tương thích versions trong nixpkgs

## Hướng dẫn sử dụng

### Server (systemd user service)

Server chạy nền, tự động khởi động cùng session:

```bash
# Kiểm tra trạng thái
systemctl --user status openviking-server

# Khởi động / restart
systemctl --user enable --now openviking-server
systemctl --user restart openviking-server

# Xem log
journalctl --user -u openviking-server -f
```

MCP endpoint: `http://127.0.0.1:1933/mcp` — đã cấu hình trong `modules/home/opencode.nix`.

### CLI (`ov`)

Binary có tên `ov`, cung cấp các nhóm lệnh chính:

```bash
# Health check server
ov health

# Xem trạng thái toàn bộ components
ov status

# Quản lý config (tạo / chỉnh sửa ovcli.conf)
ov config

# Interactive TUI explorer
ov tui
```

#### Core Workflow

```bash
# Thêm resource (URL, file) vào knowledge base
ov add-resource https://example.com/doc.pdf
ov add-resource /path/to/local/file.md

# Semantic search (tìm theo nghĩa, không cần exact keyword)
ov find "tài liệu về authentication"

# Đọc file content (level 0/1/2)
ov abstract <uri>      # Level 0: tóm tắt
ov overview <uri>      # Level 1: overview
ov read <uri>          # Level 2: full content

# Ghi / sửa file
ov write <uri> "nội dung mới"

# Thêm memory (lưu thông tin ngắn hạn)
ov add-memory "Hôm nay đã fix bug auth"
```

#### Filesystem (virtual)

```bash
ov ls <uri>            # Liệt kê thư mục
ov tree <uri>          # Cây thư mục
ov stat <uri>          # Metadata
ov rm <uri>            # Xóa
ov mv <uri> <new-uri>  # Đổi tên / di chuyển
```

#### Import / Export

```bash
ov export > backup.ovpack       # Export knowledge base
ov import backup.ovpack         # Import
ov backup > full-backup.ovpack  # Full backup tất cả public scopes
ov restore full-backup.ovpack   # Restore
```

#### Session & Privacy

```bash
ov session list         # Liệt kê sessions
ov privacy show         # Xem privacy config
```

### OpenCode Integration

OpenCode tự động kết nối OpenViking qua MCP. Trong chat, sử dụng các tool:

| Tool | Mô tả |
|------|-------|
| `openviking_remember` | Lưu thông tin vào long-term memory |
| `openviking_search` | Semantic retrieval (deep, có session context) |
| `openviking_find` | Semantic retrieval (nhanh, không cần session) |
| `openviking_read` | Đọc file từ virtual filesystem |
| `openviking_write` | Ghi file vào virtual filesystem |
| `openviking_add_resource` | Nuốt URL/file vào knowledge base |

Ví dụ trong prompt OpenCode:
> "Remember that my API key prefix is `sk-vk-` and search my knowledge base for all docs about rate limiting"
