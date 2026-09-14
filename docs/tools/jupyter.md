---
tags: [nixos, tools, mcp, jupyter]
---

# jupyter — notebook & kernel data science

MCP server local (`uvx jupyter-mcp-server`) điều khiển JupyterLab đang chạy nền ở `127.0.0.1:8888` (systemd-user service `jupyterlab`).

## Nền tảng

- Env: **python314 unified** (JupyterLab + ipykernel + numpy, pandas, scipy, scikit-learn, matplotlib, mutagen, requests, pip) — khai báo `modules/home/jupyter.nix`.
- Config màn che khớp nhau: `JUPYTER_URL=http://127.0.0.1:8888`, `JUPYTER_TOKEN=jupylocal-ds`, `ALLOW_IMG_OUTPUT=true` (opencode hiển thị plot).
- Check service: `systemctl --user status jupyterlab`.

## Cách dùng (trong opencode chat)

Luồng chuẩn (chi tiết trong skill [[data-science]]):

1. **Mở notebook**: `jupyter_use_notebook` (mode `connect` để mở có sẵn, `create` tạo mới).
2. **Thao tác cell**: `jupyter_read_notebook` (brief/detailed) → `jupyter_insert_cell` / `jupyter_overwrite_cell_source` / `jupyter_edit_cell_source` → `jupyter_execute_cell` (cell dài nhớ truyền `timeout` + `stream=true`).
3. **Code tạm không lưu**: `jupyter_execute_code` (chạy trong kernel, không ghi notebook). Cấm dùng để import module/khai biến mà phiên sau cần.
4. **Cài gói thiếu**: `jupyter_execute_code` với `%pip install --quiet <pkg>`.

> [!warning] Cấm sửa `.ipynb` trực tiếp bằng Write/Edit — mọi thay đổi phải qua MCP notebook.

## Cấu hình & tắt

- Tắt MCP: bỏ/`enabled = false` khối `mcp.jupyter` trong `modules/home/opencode.nix`. Tắt hẳn server: comment import `jupyter.nix` trong `home.nix` rồi `update`.

## Liên quan

- [data-science skill](../../pkgs/opencode/skills/data-science/SKILL.md) — workflow đầy đủ
- [[postgres]] — nguồn dữ liệu quan hệ
- [[arxiv]] — literature review trước khi phân tích
- [[_index]] — map of content