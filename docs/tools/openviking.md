---
tags: [nixos, tools, mcp, openviking]
---

# openviking — context database (long-term memory)

MCP server **remote** trỏ tới server OpenViking chạy nền ở `127.0.0.1:1933` (systemd-user `openviking-server`). Lưu tri thức bền vững dạng **virtual filesystem** `viking://`.

> [!note] Có 2 chiều dùng
> **Qua MCP** (trong chat opencode) hoặc **qua CLI `ov`** (trong shell). Cùng một bộ dữ liệu.

## Cách dùng (MCP, trong opencode chat)

- **Ghi nhớ**: `openviking_remember` — bảo user "nhớ giùm cái này" là lưu thẳng.
- **Tìm lại**: `openviking_search` (sâu, có session context) / `openviking_find` (nhanh, không session).
- **Filesystem**: `openviking_read`, `openviking_write`, `openviking_edit`, `openviking_list`, `openviking_tree`, `openviking_glob`, `openviking_grep`.
- **Nuốt tài nguyên**: `openviking_add_resource` (URL/file → knowledge base, async).
- **Quản lý**: `openviking_health`, `openviking_forget` ⚠️ xóa vĩnh viễn, `openviking_list_watches`/`openviking_cancel_watch`.

## Cách dùng (CLI `ov`)

```bash
ov health / ov status           # server + components
ov add-resource https://...     # nuốt URL/file vào KB
ov find "query ngữ nghĩa"       # semantic search
ov read <uri>                   # đọc content
ov export > backup.ovpack       # backup / khôi phục: ov import ...
```

## Cấu hình & tắt

- Server: `modules/home/openviking-server.nix` — config trong `~/.openviking/ov.conf` (embedding gemini, environment file `~/.openviking/gemini.env`).
- Package nguồn: `pkgs/openviking/` (README trong đó).
- Check/tắt: `systemctl --user status openviking-server`; bỏ import module trong `home.nix` để tắt hẳn.

## Liên quan

- [[ouroboros]] — dùng OpenViking làm memory cho agent (mô-đun dsh cũ đã tắt)
- [[docker]] — database backing khác nếu cần quan hệ
- [[_index]] — map of content