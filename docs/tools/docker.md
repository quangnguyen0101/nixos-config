---
tags: [nixos, tools, mcp, docker]
---

# docker — quản lý containers & DB containers

MCP server local (`npx @hypnosis/docker-mcp-server`) nói chuyện trực tiếp với Docker daemon qua `DOCKER_HOST=unix:///var/run/docker.sock`.

## Cách dùng (trong opencode chat)

- **Trạng thái**: `docker_docker_health` (services/server/profiles), `docker_docker_container list|stats`, `docker_docker_resource images|volumes|networks|disk`.
- **Compose**: `docker_docker_compose config|env` (đọc file khai báo), `docker_docker_compose_control up|down`, `docker_docker_container_control start|stop|restart`.
- **DB trong container**: `docker_docker_db status|query` (Postgres/MySQL/Mongo/Redis/SQLite nói được client của image), `docker_docker_db_admin backup|restore`.
- **Chạy lệnh trong container**: `docker_docker_exec` (nhớ `user`/`workdir` nếu cần), `docker_docker_logs` đọc log theo stream/time.

> [!warning] Phá hủy dữ liệu
> Các thao tác destructive (drop DB, delete volume…) bị chặn cho tới khi câu lệnh kèm `# CONFIRMED-DESTRUCTIVE` — tránh xóa nhầm.

## Container đang có (khai báo bằng Nix)

| Container | Image | Vai trò | Nguồn khai báo |
|-----------|-------|---------|----------------|
| `postgres-ds` | `postgres:17-alpine` | SQL data science | `modules/system/postgres-docker.nix` (xem [[postgres]]) |

Khai báo qua `virtualisation.oci-containers` → `docker` backend → container được **Nix quản lý**, đừng `docker run` tay đè lên.

## Cấu hình & tắt

- Khai báo: `modules/home/opencode.nix` → `mcp.docker` (`npx -y @hypnosis/docker-mcp-server@2.0.1`).
- Tắt MCP: xóa/`enabled = false` khối `docker`. Tắt hẳn container không dùng: bỏ khối `containers.<tên>` trong `postgres-docker.nix` rồi `update`.

## Liên quan

- [[postgres]] — DB datascience
- [[github]] — lấy repo về build trong container
- [[_index]] — map of content