---
tags: [nixos, tools, mcp, postgres]
---

# postgres — SQL data science

MCP server local (`uvx postgres-mcp`) kết nối database `datascience` trên container `postgres-ds` (PostgreSQL 17).

## Kết nối thật (từ config)

- DSN: `postgresql://dsuser:dssecret@127.0.0.1:5432/datascience`
- Container: `postgres-ds` (khai báo `modules/system/postgres-docker.nix`) — dữ liệu bind mount `/home/sh4d0wph4nt0m/data/postgres`.
- Chỉ nghe trên loopback (`127.0.0.1:5432:5432`) — không lộ ra mạng ngoài.

> [!warning] DSN là secret local
> `dsuser`/`dssecret` đứng trong config Nix (repo private-use). Không in DSN ra output / không commit kèm vào báo cáo.

## Cách dùng (trong opencode chat)

- `postgres_list_schemas`, `postgres_list_objects`, `postgres_get_object_details` — xem cấu trúc.
- `postgres_execute_sql` — chạy truy vấn bất kỳ.
- `postgres_explain_query` — plan + thử index hypothetic (`hypothetical_indexes`).
- `postgres_get_top_queries`, `postgres_analyze_db_health`, `postgres_analyze_workload_indexes` — bảo trì/tối ưu.
- Trong phân tích: thao tác qua MCP docker nếu cần psql/dump: [[docker]].

## Cấu hình & tắt

- Khai báo: `modules/home/opencode.nix` → `mcp.postgres` — pin `postgres-mcp==0.3.0`, cần `LD_LIBRARY_PATH` trỏ `stdenv.cc.cc.lib` (greenlet trên NixOS).
- Tắt: bỏ `mcp.postgres` hoặc tắt luôn container ở `postgres-docker.nix`.

## Liên quan

- [[jupyter]] — pandas đọc số liệu từ DB này
- [[arxiv]] — lấy dataset/paper kèm số liệu
- [[_index]] — map of content