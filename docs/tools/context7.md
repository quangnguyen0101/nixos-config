---
tags: [nixos, tools, mcp, context7]
---

# context7 — tra docs & code thư viện

MCP server **remote** — lấy tài liệu/code examples mới nhất của thư viện framework, đúng version.

## Cách dùng (trong opencode chat)

Lệnh đúng quy trình: **2 bước**:

1. `context7_resolve-library-id` — tra cứu ID chuẩn của thư viện (`/org/project`, ví dụ `/vercel/next.js`, `/fastapi/fastapi`). Kèm 1 query gợi ý để xếp hạng đúng.
2. `context7_query-docs` — hỏi đúng 1 concept (vd: "How to set up auth with JWT in Express.js").

> [!warning] Giới hạn
> Không gọi quá **3 lần `context7_*` cho 1 câu hỏi**. Nếu không tìm thấy sau 3 lần thì dùng kết quả tốt nhất, đừng tăng thêm.

## Khi nào dùng

- Muốn API chính xác, có version rõ ràng của một thư viện nổi tiếng (Next.js, React, Express, mongodb, supabase, fastapi…).
- Thay vì đoán cú pháp hoặc nhớ code mẫu — context7 trả code mẫu thật từ docs.

## Cấu hình & tắt

- Khai báo: `modules/home/opencode.nix` → `mcp.context7` (type `remote`, url `https://mcp.context7.com/mcp`).
- Tắt: xóa/`enabled = false` khối `context7`, rebuild + mở lại opencode.

## Liên quan

- [[github]] — đọc source thật khi cần hơn docs
- [[docker]] — chạy thử thư viện trong container
- [[_index]] — map of content