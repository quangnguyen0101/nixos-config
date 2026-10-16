---
tags: [nixos, tools, mcp, vision]
---

# vision — OCR & mô tả ảnh

MCP server **local** (`uvx opencode-vision[paddle]==2.1.0`) — đọc ảnh: OCR và mô tả nội dung ảnh. Chạy **PaddleOCR ngay trên máy** (mặc định); khi cần thì fallback sang **Gemini free** (`gemini.key`).

## Cách dùng (trong opencode chat)

- `vision_vision_analyze` — đầy đủ nhất: metadata file + mô tả nội dung + trích text (OCR). Dùng khi muốn "hiểu toàn diện" một ảnh.
- `vision_vision_ocr` — **chỉ** trích text (PaddleOCR, fallback Gemini cho chữ viết tay/ảnh mờ).
- `vision_vision_describe` — mô tả ảnh theo `prompt` tuỳ chọn (hỏi cụ thể về ảnh).

Tham số chính là `image_path` (đường dẫn tuyệt đối tới file ảnh).

## Khi nào dùng

- Đọc ảnh/screenshot/scan → lấy text (thay vì tự đoán nội dung).
- Mô tả ảnh, hỏi chi tiết trong ảnh (form, biểu đồ, UI…).

## Cấu hình & tắt

- Khai báo: `modules/home/opencode.nix` → `mcp.vision` (local, `timeout = 120000` vì lần đầu cold-download PaddleOCR ~2 phút).
- Key Gemini: `{file:~/.config/opencode/gemini.key}` (file ngoài repo, mode 600 — không commit).
- **Wrapper** `pkgs/opencode/vision-mcp-wrapper.py` (chạy chèn trước `main()`):
  - patch transport: server gốc hand-roll JSON-RPC theo `Content-Length`, opencode chỉ hiểu **newline-delimited** → nếu không patch sẽ treo `initialize`.
  - trả `protocolVersion "2024-11-05"` cho `initialize`.
  - đổi model Gemini fallback (`gemini-2.5-flash` bị retire) → patch cả `GEMINI_MODEL` + `GEMINI_URL`.
  - **Sync khi bump** `opencode-vision`.
- Tắt MCP: xóa/`enabled = false` khối `vision` → `update` → mở lại opencode.

## Liên quan

- [[MCP]] — bảng đầy đủ 9 MCP server + wiring chung
- [[jupyter]] — xử lý ảnh/data bằng Python (PaddleOCR, PIL…)
- [[_index]] — map of content
