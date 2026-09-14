---
name: data-science
description: Use when the user asks for data analysis, notebooks, pandas/numpy/scipy computations, machine learning, data visualization, ETL, or anything running Python against datasets. Covers the full workflow: creating an analysis notebook on the Jupyter MCP server, computing server-side, exploring data via the Postgres MCP, looking up literature on arXiv, and producing reproducible plots and artifacts.
license: MIT
compatibility:
  - opencode
metadata:
  author: sh4d0wph4nt0m
  version: 1.0.0
---

# Data Science workflow

Môi trường data science của máy này là **hỗn hợp MCP trên NixOS**: có Jupyter server local (`127.0.0.1:8888`), Postgres (`postgres-ds`) qua Docker, và thư viện arXiv. Không bao giờ chạy compute nặng trong bash tiện lợi — chạy **bên trong notebook / kernel**.

## 1. Khởi tạo phiên

1. Nếu chưa có notebook, bắt đầu bằng Jupyter MCP:
   - `jupyter_use_notebook` (name + path, mode `connect` để mở, `create` để tạo mới).
   - Mở rồi mới thao tác cell (`read_notebook` / `insert_cell` / `execute_cell`).
2. Không bao giờ sửa file `.ipynb` trực tiếp bằng `Write`/`Edit` — mọi thay đổi phải qua API notebook.

## 2. Compute server-side

- Debug nhanh / inspect biến: `jupyter_execute_code` (chạy thẳng trong kernel, không lưu vào notebook).
- Chạy cell thực sự: `jupyter_execute_cell` — tương tác qua `cell_index` hoặc `cell_id`. Cell dài nên truyền `timeout` và `stream=true` để theo dõi tiến độ.
- Env đã có: python314 với jupyterlab, ipykernel, pip, **numpy, pandas, scipy, scikit-learn, matplotlib, mutagen, requests**.
- Thiếu gói → `jupyter_execute_code` với `%pip install --quiet <pkg>`.

## 3. Data

- Dữ liệu dạng Excel/CSV → đọc bằng pandas trên kernel; để file ở đâu thì đường dẫn được resolve trên máy chạy Jupyter server (local).
- Quan hệ (Postgres container `postgres-ds`) → dùng Docker MCP: `docker_docker_db` (query/status) rồi `docker_docker_exec` cho psql, hoặc đọc trực tiếp bằng pandas + `psycopg` nếu kernel truy cập được container.
- Không include secret/DSN vào output; nếu cần connect string, tham chiếu từ config chứ không in ra.

## 4. Tài liệu tham khảo

- Tra cứu paper: arXiv MCP `arxiv_search_papers` theo `ti:`/`abs:`/`cat:`; đọc abstract với `arxiv_get_abstract` trước khi download.
- Đọc sâu: `arxiv_download_paper` → `arxiv_get_paper_outline` → `arxiv_read_paper_section`.
- Trích dẫn: `arxiv_export_citations` để lấy BibTeX chuẩn từ metadata.

## 5. Output & tái hiện

- Plot: xuất file (`.png`/`.svg`) bằng matplotlib trên kernel; khi render kết quả cho user, dùng `ALLOW_IMG_OUTPUT` để đính ảnh tự động resize.
- Ghi kết quả số liệu tóm tắt thành khối markdown rõ ràng kèm số đẹp; kèm theo notebook path để user tự mở.
- Reproducibility: nếu tạo pipeline, pin version (ghi trong cell đầu notebook), cache nặng đầu rồi dùng lại, và đảm bảo chạy đầy đủ từ đầu tới cuối ít nhất một lần trước khi báo xong.