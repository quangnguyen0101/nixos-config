---
tags: [nixos, tools, mcp, ouroboros]
---

# ouroboros — Agent OS (interview → seed → execute)

MCP server local (`uvx ouroboros-ai[mcp]`) biến yêu cầu thành **bounded loop**: phỏng vấn làm rõ → sinh Seed (spec) → thực thi → đánh giá → (tùy chọn) Ralph loop evolve. Bridge plugin `ouroboros-bridge.ts` dispatch các bước con ra **Task pane** riêng trong opencode.

## Cách dùng (trong opencode chat)

- **Task end-to-end**: "dùng ouroboros implement X" → `ouroboros_start_auto` (tự phỏng vấn→seed→chạy, trả `auto_session_id` + `job_id`).
- **Seed có sẵn**: `ouroboros_start_execute_seed` (seed_path yaml hoặc inline). Đừng chạy `ooo` trong shell — gọi MCP.
- **Ralph loop**: `ouroboros_start_ralph` / `ouroboros_ralph` — evolve nhiều generation tới khi pass QA hoặc convergence.
- **Hỏi đáp requirement nhanh**: `ouroboros_interview` (Socratic), `ouroboros_pm_interview` (product), `ouroboros_generate_seed`.
- **Theo dõi**: `ouroboros_job_status` / `ouroboros_job_wait` (long-poll `wait_for: terminal`) / `ouroboros_job_result`.
- **QA**: `ouroboros_checklist_verify`, `ouroboros_qa`, `ouroboros_evaluate` (3-stage).

## Lưu ý

- Plugin mode: nhiều tool trả `job_id=None` + delegate sang Task pane — kết quả nằm ở pane, đừng poll.
- `ouroboros_brownfield` scan `~/` để đăng ký repo làm context PM interview.

## Cấu hình & tắt

- Khai báo: `modules/home/opencode.nix` → `mcp.ouroboros` (pin `0.54.4`, cần `LD_LIBRARY_PATH` cho greenlet).
- Bridge plugin: `pkgs/ouroboros/ouroboros-bridge.ts` (README trong đó, đầy đủ 36 tools).
- Log bridge: `~/.config/opencode/plugins/ouroboros-bridge/bridge.log`.

## Liên quan

- [[openviking]] — memory dài hạn dùng chung
- [[jupyter]] — task data science chạy trên kernel này
- [[_index]] — map of content