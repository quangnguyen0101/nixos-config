# DSH Agent Capabilities

Tổng quan năng lực agent trong DeepSeek Harness (DSH) profile "web".

## Tổng quan

| Thành phần | Số lượng | Ghi chú |
|---|---|---|
| Skills (quy trình làm việc) | **26** | Sẵn sàng |
| Tools khai báo | **104** | 53 built-in + 15 OpenViking + 36 Ouroboros |
| Vision tools tiềm ẩn | **+10** | Kích hoạt qua skill `vision-skills` |
| Agency Experts | **271** | 17 phân hệ — mặc định TẮT |
| MCP Servers | **2** | OpenViking, Ouroboros |

## Skills (26)

Skill là **bộ hướng dẫn quy trình có thể tái sử dụng**, chỉ được nạp khi tên task khớp mô tả hoặc người dùng gọi trực tiếp.

| Nhóm | Skills |
|------|--------|
| **Kiến trúc** | `anti-entropy-governance`, `archify`, `establishing-project-context`, `first-principles-review`, `recording-architecture-decisions` |
| **Lập kế hoạch** | `brainstorming`, `executing-plans`, `writing-plans` |
| **Debug / QA** | `systematic-debugging`, `test-driven-development`, `verification-before-completion` |
| **Review** | `receiving-code-review`, `requesting-code-review` |
| **Đa agent** | `dispatching-parallel-agents`, `subagent-driven-development` |
| **Git** | `finishing-a-development-branch`, `using-git-worktrees` |
| **Mục tiêu** | `goal-framing`, `long-task-continuation` |
| **Bộ nhớ** | `openviking-memory` |
| **Trực quan** | `vision-skills`, `visualize` |
| **Giao tiếp** | `communicating-concisely` |
| **Routing** | `using-aegis` |
| **Bảo trì** | `update-aegis`, `writing-skills` |

## Built-in Tools (53)

| Nhóm | Tools |
|------|-------|
| **File & code (7)** | `read`, `write`, `edit`, `glob`, `grep`, `read_image`, `run_code` |
| **Shell & jobs (4)** | `bash`, `job_list`, `job_output`, `job_kill` |
| **Web (3)** | `web_search`, `read_page`, `x_search` |
| **Subagent (5)** | `subagent`, `subagent_fork`, `send_message`, `interrupt_agent`, `list_agents` |
| **AgentTeams (10)** | `create`, `add_member`, `remove_member`, `create_task`, `claim_task`, `update_task`, `reassign_task`, `send_message`, `status`, `delete` |
| **Agency (3)** | `list_experts`, `summon_expert`, `summon_experts` |
| **Goals (3)** | `create_goal`, `get_goal`, `update_goal` |
| **Orchestration (2)** | `workflow`, `ralph` |
| **Phiên & UI (6)** | `ask_user_question`, `todo_write`, `exit_plan_mode`, `skill`, `visualize`, `vision_toolkit_activate` |
| **SSH (6)** | `ssh_list`, `ssh_exec`, `ssh_cluster`, `ssh_upload`, `ssh_download`, `ssh_tunnel` |
| **Writing-guard (4)** | `writing_rules`, `writing_audit`, `writing_style_profile`, `writing_journal_profile` |

## MCP: OpenViking — bộ nhớ tri thức dài hạn (15 tools)

Database ngữ cảnh bền vững. Không gian URI `viking://`.

| Tool | Mô tả |
|------|-------|
| `remember` | Lưu thông tin vào long-term memory |
| `search` | Deep semantic retrieval với session context |
| `find` | Fast semantic retrieval không cần session context |
| `read` | Đọc file URI (batch support) |
| `write` | Ghi text vào virtual file |
| `edit` | Thay chuỗi literal trong virtual file |
| `glob` | Tìm file theo filename pattern |
| `grep` | Regex content search |
| `tree` | Cây thư mục đệ quy |
| `list` | Liệt kê files + subdirectories một cấp |
| `health` | Health check server |
| `add_resource` | Nuốt tài nguyên vào knowledge base (async) |
| `forget` | Xóa vĩnh viễn URI (irreversible) |
| `list_watches` | Liệt kê watch tasks |
| `cancel_watch` | Hủy watch theo target URI |

## MCP: Ouroboros — pipeline tiến hóa (36 tools)

Pipeline: **yêu cầu → interview → Seed → execute → evaluate 3 tầng → evolve/Ralph loop**.

| Nhóm | Tools |
|------|-------|
| **Khảo sát & brownfield (4)** | `interview`, `pm_interview`, `brownfield`, `generate_seed` |
| **Sinh & chạy Seed (4)** | `execute_seed`, `start_execute_seed`, `auto`, `start_auto` |
| **Đánh giá & lateral (6)** | `evaluate`, `start_evaluate`, `qa`, `checklist_verify`, `measure_drift`, `lateral_think` |
| **Vòng lặp tiến hóa (6)** | `evolve_step`, `start_evolve_step`, `evolve_rewind`, `lineage_status`, `ralph`, `start_ralph` |
| **Job nền (4)** | `job_status`, `job_wait`, `job_result`, `cancel_job` |
| **Phiên & sự kiện (6)** | `session_status`, `query_events`, `query_projection`, `project_status`, `ac_dashboard`, `ac_tree_hud` |
| **Conductor & signal (3)** | `record_conductor_decision`, `session_signal_targets`, `session_signal` |
| **Fan-out & artifact (3)** | `submit_fanout_results`, `fetch_artifact`, `cancel_execution` |

## Vision Tools (+10, tiềm ẩn)

Kích hoạt qua skill `vision-skills` hoặc tool `vision_toolkit_activate`.

| Tool | Chức năng |
|------|-----------|
| `vision_glance` | Nhìn nhanh tổng quát nội dung ảnh |
| `vision_ground` | Định vị vùng theo mô tả ngôn ngữ tự nhiên |
| `vision_detect` | Phát hiện/liệt kê đối tượng kèm bounding box |
| `vision_trace` | SVG tracing từ hình ảnh |
| `vision_crop` | Cắt vùng ảnh theo tọa độ |
| `vision_pixel_diff` | So sánh pixel hai ảnh |
| `vision_long_screenshot_ocr` | OCR screenshot dài / chat log |
| `vision_extract_foreground` | Tách foreground khỏi nền |
| `vision_dominant_colors` | Trích bảng màu chủ đạo |
| `vision_html_screenshot` | HTML → screenshot |

## Agency Experts (271)

- **17 phân hệ**: engineering, security, marketing, design, finance, research, …
- **Trạng thái**: ⚠️ TẤT CẢ TẮT (mặc định). Bật qua Web GUI → Agency settings.
- **Workflow**: `list_experts` → `summon_expert` / `summon_experts` (tối đa 8, concurrency 4)
