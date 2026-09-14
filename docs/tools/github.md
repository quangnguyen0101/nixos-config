---
tags: [nixos, tools, mcp, github]
---

# github — GitHub API trong opencode

MCP server **remote** trỏ `https://api.githubcopilot.com/mcp/` — repos, issues, PRs, code search, releases. Xác thực bằng **PAT** (không dùng OAuth).

## Cấu hình

- `modules/home/opencode.nix` → `mcp.github`:
  - `oauth = false` vì GitHub không hỗ trợ DCR.
  - Token đọc từ file `~/.config/opencode/github.token` (header `Authorization: Bearer`) — file này **không nằm trong git**.
- Muốn đổi quyền: sửa token trong file đó (repo public giữ scope hẹp).

## Cách dùng (trong opencode chat)

- **Repo**: `github_search_repositories`, `github_get_file_contents`, `github_create_or_update_file`…
- **Issues**: `github_search_issues` (search ngữ nghĩa), `github_issue_read/write`.
- **PRs**: `github_list_pull_requests`, `github_pull_request_read` (diff/files/reviews), `github_request_copilot_review`, `github_merge_pull_request`.
- **Tìm code**: `github_search_code` (exact symbol/pattern, filter `repo:`, `language:`).
- **Bảo mật**: `github_run_secret_scanning` quét nội dung/diff trước khi push (không gửi file ngoài codebase).

## Lưu ý

- Code search không phải semantic — đúng chuỗi là chính xác nhất.
- Khi làm việc trong repo này (`~/nixos-config`) thường tự động quyện vào owner `quangnguyen0101` nhưng vẫn phải truyền đủ `owner`/`repo` từng call.

## Tắt

- Xóa/`enabled = false` khối `mcp.github`, `update`, mở lại opencode.

## Liên quan

- [[context7]] — docs thư viện (thay vì đọc source)
- [[_index]] — map of content