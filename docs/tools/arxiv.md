---
tags: [nixos, tools, mcp, arxiv]
---

# arxiv — tìm & đọc paper học thuật

MCP server local (uvx) để tìm kiếm trên arXiv, đọc abstract, download + parse bài, xuất BibTeX.

> [!tip] Luồng chuẩn
> `arxiv_search_papers` (tiêu đề/abstract/category) → `arxiv_get_abstract` xem abstract ngắn → `arxiv_download_paper` → `arxiv_get_paper_outline` → `arxiv_read_paper_section`. Cần trích dẫn: `arxiv_export_citations`.

## Cách dùng (trong opencode chat)

- **Tìm kiếm**: `arxiv_search_papers` — gõ cụm hoặc field-prefix:
  ```text
  "diffusion models" AND ti:"video generation"   # match title
  au:"LeCun" AND cs.LG                            # tác giả + nhóm ngành
  ```
  Filter bằng `categories` (cs.LG, cs.AI, quant-ph…), `date_from/date_to`, `sort_by: relevance|date`.
- **Đọc**: `arxiv_download_paper` lấy text bài (ưu tiên HTML, fallback PDF). Bài lớn trả theo chunk — dùng `start`/`is_truncated` để lấy tiếp. Đã tải thì dùng `arxiv_read_paper` (đọc lại không tốn mạng).
- **Tham khảo chéo**: `arxiv_citation_graph` (Semantic Scholar) — bài này cite ai / ai cite mình.
- **Trích dẫn**: `arxiv_export_citations "2401.12345" "2404.19756"` → BibTeX chuẩn từ metadata arXiv (không phải model guess).
- **Theo dõi mới**: `arxiv_watch_topic` lưu "watch" rồi `arxiv_check_alerts` để nhận paper mới theo topic; `arxiv_list_watches`/`arxiv_unwatch_topic` xem/xóa.

## Lưu ý

- arXiv ~3s giữa các request (server-side); rate-limit mạnh trả `status=rate_limited` — chờ rồi chạy lại.
- Paper đã download lưu local (cache) — `arxiv_list_papers` xem danh sách, `arxiv_reindex` nếu cần dựng lại index ngữ nghĩa.
- `arxiv_semantic_search` chỉ tìm trong bộ đã tải về local (không quét toàn arXiv).

## Cấu hình & tắt

- Khai báo: `modules/home/opencode.nix` → `mcp.arxiv` (`uvx --from arxiv-mcp-server[pdf]==0.7.2`).
- Tắt: xóa hoặc `enabled = false` khối `arxiv` trong `mcp`, rồi `update` + thoát/mở lại opencode.

## Liên quan

- [[jupyter]] — chạy phân tích dữ liệu lấy từ paper
- [[postgres]] — tải dataset về DB để phân tích
- [[_index]] — map of content