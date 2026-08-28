# DSH Agent Capabilities

Tổng quan năng lực agent trong DeepSeek Harness (DSH) profile "web".

## Tổng quan

| Thành phần | Số lượng | Ghi chú |
|---|---|---|
| Skills (quy trình làm việc) | **26** | Sẵn sàng |
| Tools khai báo | **68** | 53 built-in + 15 OpenViking |
| Vision tools tiềm ẩn | **+10** | Kích hoạt qua skill `vision-skills` |
| Agency Experts | **271** | 18 phân hệ — mặc định TẮT |
| MCP Servers | **1** | OpenViking |

---

## Skills (26)

Skill là **bộ hướng dẫn quy trình có thể tái sử dụng**, chỉ được nạp khi tên task khớp mô tả hoặc người dùng gọi trực tiếp. Skill KHÔNG phải chương trình chạy trực tiếp — nó nạp chỉ dẫn để agent thực hiện đúng quy trình.

### Aegis bundle (22 skills)

| # | Skill | Kích hoạt khi nào |
|---|-------|-------------------|
| 1 | `using-aegis` | Đầu mỗi turn / kiểm tra routing skill Aegis *(alwaysApply)* |
| 2 | `brainstorming` | Định nghĩa tính năng mơ hồ/phức tạp cao, hành vi sản phẩm, thiết kế UI/component, lựa chọn kiến trúc, thay đổi contract; "grill"/thử thách kế hoạch |
| 3 | `first-principles-review` | Review từ nguyên lý đầu tiên / nguyên lý Occam; quyết định rủi ro cao có ràng buộc cạnh tranh, fallback phình to, owner trùng |
| 4 | `update-aegis` | `aegis:update`, nâng cấp method-pack Aegis đã cài, kiểm tra phiên bản mới nhất |
| 5 | `receiving-code-review` | Nhận feedback code review trước khi triển khai — nhất là feedback mơ hồ, rủi ro, tranh cãi, nghi vấn kỹ thuật |
| 6 | `verification-before-completion` | Trước khi tuyên bố hoàn thành/fixed/passing/verified/release-ready/sẵn sàng commit/merge/publish/handoff |
| 7 | `goal-framing` | User đặt goal Aegis (`/aegis-goal`, `Aegis goal:`) hoặc muốn định nghĩa goal, bằng chứng thành công, điều kiện dừng, biên task |
| 8 | `long-task-continuation` | Task nhiều bước, có thể vượt context reset/nhiều phiên, dùng subagent, dễ mất trạng thái |
| 9 | `dispatching-parallel-agents` | ≥2 task độc lập, chưa có plan viết sẵn, không chia sẻ trạng thái → delegate song song tốt hơn làm inline |
| 10 | `test-driven-development` | User yêu cầu TDD nghiêm ngặt/test-first, hoặc hội thoại đã có quyết định `TDD Route: strict` từ workflow Aegis khác |
| 11 | `writing-plans` | Đã có spec/yêu cầu được duyệt cho task nhiều bước, cần plan document bền vững trước khi đụng code; task nhỏ/nhanh thì không cần |
| 12 | `writing-skills` | Tạo skill mới, sửa skill cũ, xác minh skill hoạt động trước khi deploy |
| 13 | `using-git-worktrees` | Task cần checkout đồng thời, dirty state cản trở đổi nhánh an toàn, repo/user yêu cầu worktree |
| 14 | `executing-plans` | Thực thi plan triển khai viết sẵn qua nhiều phiên hoặc có checkpoint review |
| 15 | `subagent-driven-development` | Thực thi plan với các task độc lập TRONG phiên hiện tại, delegate rẻ hơn phối hợp inline; task ad-hoc không plan thì dùng dispatching-parallel-agents |
| 16 | `establishing-project-context` | Thiết lập ngôn ngữ dự án chung; thuật ngữ domain xung đột/đổi tên/bị deprecated cần mô hình hóa ngữ nghĩa chủ động |
| 17 | `anti-entropy-governance` | Thu hồi logic cũ, gộp owner trùng lặp, bỏ fallback, ranh giới schema/persistence/nguồn chân lý; thi hành phá hủy cần xác nhận rõ ràng |
| 18 | `requesting-code-review` | Xin review độc lập: sau implementation slice, trước merge work rủi ro cao, khi verification bộc lộ bất định về evidence/baseline/architecture |
| 19 | `communicating-concisely` | Người dùng yêu cầu "caveman mode", ít token, trả lời ngắn gọn |
| 20 | `recording-architecture-decisions` | Tạo/viết/cập nhật/amend/supersede ADR (architecture decision record), decision log, baseline sync sau work đổi kiến trúc |
| 21 | `systematic-debugging` | Gặp bug, test fail, hành vi bất thường — bắt buộc trước khi đề xuất fix |
| 22 | `finishing-a-development-branch` | Tích hợp/dọn dẹp branch/worktree do task tạo ra; user yêu cầu merge/PR/quản lý vòng đời nhánh |

### Community plugins (4 skills)

| # | Skill | Package | Kích hoạt khi nào |
|---|-------|---------|-------------------|
| 23 | `archify` | `@tt-a1i/archify-dsh` | Vẽ sơ đồ kiến trúc, workflow, sequence, data-flow, lifecycle/state dạng HTML độc lập có SVG inline, theme tối/sáng, trace motion, xuất PNG/JPEG/WebP/SVG/WebM; nhận ngôn ngữ tự nhiên hoặc Mermaid |
| 24 | `modsearch` | `@liustack/modsearch` | Tìm kiếm web, X/Twitter search, đọc trang web — dùng khi model không có native web access |
| 25 | `vision-skills` | `@anionex/dsh-vision-toolkit` | 10 vision tools cho text-only agent: mô tả ảnh, OCR, định vị, detect, trace, crop, pixel diff, tách foreground, phân tích màu, HTML screenshot |
| 26 | `openviking-memory` | `@openviking/dsh-memory-plugin` | Làm việc với OpenViking (database ngữ cảnh bền vững): tra cứu phiên cũ, ghi nhớ, đọc URI viking://, chọn đúng kiểu tìm kiếm |

---

## Built-in Tools (53)

Tool là hàm thực thi thật. Agent gọi TRỰC TIẾP duy nhất `run_code`; mọi tool khác được gọi bên trong chương trình TypeScript thông qua đối tượng registry.

### File & code (7)

| Tool | Mô tả | Parameters chính |
|------|-------|-----------------|
| `read` | Đọc file UTF-8 trả về nội dung kèm số dòng | `file_path`, `offset` (dòng bắt đầu), `limit` (mặc định 2000) |
| `write` | Tạo mới hoặc ghi đè toàn bộ file UTF-8 | `file_path`, `content`, `sandbox_permissions`, `justification` |
| `edit` | Thay chuỗi literal chính xác trong file | `file_path`, `old_string`, `new_string`, `replace_all` |
| `glob` | Tìm file theo pattern đường dẫn (tối đa 100) | `pattern`, `path` |
| `grep` | Tìm nội dung bằng regex ripgrep | `pattern`, `include`, `path` |
| `read_image` | Đọc PNG/JPEG/WebP/GIF trả về ảnh cho model đa phương thức | `file_path` |
| `run_code` | **Tool trung tâm** — chạy thân hàm async TypeScript, gọi mọi tool khác qua registry | code body |

### Shell & jobs (4)

| Tool | Mô tả | Parameters chính |
|------|-------|-----------------|
| `bash` | Thực thi lệnh qua `bash -c`. Shell mới mỗi lần — KHÔNG giữ cwd/biến giữa các call | `command`, `workdir`, `timeoutMs`, `run_in_background`, `sandbox_permissions` |
| `job_list` | Liệt kê job nền (đang chạy và đã xong) | — |
| `job_output` | Đọc output job nền (stream hoặc final-output) | `job_id`, `wait`, `timeout_ms` |
| `job_kill` | Yêu cầu hủy job nền | `job_id`, `reason` |

### Web (3)

| Tool | Mô tả | Parameters chính |
|------|-------|-----------------|
| `web_search` | Tìm kiếm web thông tin hiện tại | `queries` (1–4 query) |
| `read_page` | Đọc 1 trang web qua modsearch bridge | `url`, `query` |
| `x_search` | Tìm bài đăng X/Twitter qua modsearch | `query`, `max_results` |

### Subagent (5)

| Tool | Mô tả | Parameters chính |
|------|-------|-----------------|
| `subagent` | Giao task khép kín cho agent riêng (context riêng). Mặc định chạy nền | `task`, `run_in_background`, `label` |
| `subagent_fork` | Như subagent nhưng child thừa kế toàn bộ completed turns | `task`, `label` |
| `send_message` | Gửi tin cho subagent nền theo id | `agent_id`, `message` |
| `interrupt_agent` | Yêu cầu hủy turn hiện tại của agent nền | `agent_id` |
| `list_agents` | Liệt kê subagent continuable theo durable id | `scope`, `depth` |

### AgentTeams — đội multi-agent (10)

| Tool | Mô tả |
|------|-------|
| `agent_teams_create` | Tạo team: name + description/goal |
| `agent_teams_add_member` | Thêm member theo vai (researcher/engineer/reviewer...) |
| `agent_teams_remove_member` | Xóa member an toàn: thu hồi attempt, hoàn tất task |
| `agent_teams_create_task` | Tạo task: subject, description, dependencies, assignee |
| `agent_teams_claim_task` | Claim 1 task ready cho member |
| `agent_teams_update_task` | Cập nhật status + output (cần attempt_id hiện hành) |
| `agent_teams_reassign_task` | Retry/reassign/captain-takeover task chưa xong |
| `agent_teams_send_message` | Nhắn captain↔member, member↔member thẳng mailbox |
| `agent_teams_status` | Snapshot team: members + tasks + mailbox |
| `agent_teams_delete` | Kết thúc team: interrupt mọi member + xóa state dir |

### Agency — chuyên gia domain (3)

| Tool | Mô tả |
|------|-------|
| `list_experts` | Liệt kê expert đang bật (tên, slug, description) |
| `summon_expert` | Triệu hồi 1 chuyên gia: specialist subagent chạy với persona đầy đủ |
| `summon_experts` | Triệu hồi NHIỀU chuyên gia song song (tối đa 8, concurrency 4) |

### Goals — mục tiêu dài hạn (3)

| Tool | Mô tả |
|------|-------|
| `create_goal` | Tạo goal persist: objective, max_goal_rounds |
| `get_goal` | Đọc goal hiện tại kèm id/revision chính xác |
| `update_goal` | Update revision hiện hành: edit, pause, resume, complete, blocked |

### Orchestration quy mô lớn (2)

| Tool | Mô tả |
|------|-------|
| `workflow` | Viết script JavaScript orchestrate subagent quy mô lớn: audit, migration, research, verification |
| `ralph` | Vòng lặp Ralph foreground fresh-agent hướng 1 objective bất biến |

### Phiên & UI (6)

| Tool | Mô tả |
|------|-------|
| `ask_user_question` | Hỏi user khi cần xác nhận/lựa chọn/thông tin thiếu |
| `todo_write` | Danh sách việc có cấu trúc (REPLACE mỗi lần) |
| `exit_plan_mode` | Trình COMPLETE plan dạng markdown, user approve → thoát plan mode |
| `skill` | Nạp TOÀN VĂN instructions của skill theo tên chính xác |
| `visualize` | Render thẻ HTML tương tác LIVE trong hội thoại |
| `vision_toolkit_activate` | Kích hoạt bộ vision execution tools (biến mất sau khi kích hoạt) |

### SSH — cụm máy chủ từ xa (6)

| Tool | Mô tả |
|------|-------|
| `ssh_list` | Liệt kê host SSH cấu hình |
| `ssh_exec` | Chạy shell trên remote host theo alias |
| `ssh_cluster` | Chạy 1 lệnh đồng thời nhiều SSH host |
| `ssh_upload` | Chuyển file từ máy này đến remote host |
| `ssh_download` | Tải file từ remote host về máy này |
| `ssh_tunnel` | Quản lý port-forward cục bộ tới service nội bộ qua SSH host |

### Writing-guard — kỷ luật văn phong học thuật (4)

| Tool | Mô tả |
|------|-------|
| `writing_rules` | Cheat-sheet kỷ luật viết luận văn: calibration claim, rhetoric pattern, LLM connectives |
| `writing_audit` | Quét kỷ luật viết: phát hiện hedge density, strong claim thiếu evidence, rhetoric pattern, academic style |
| `writing_style_profile` | Học Author Style Profile từ paper history: sentence-length, paragraph-length, dash/hedge/connective density |
| `writing_journal_profile` | Distill Journal Profile từ nhiều representative papers |

---

## MCP: OpenViking — bộ nhớ tri thức dài hạn (15 tools)

Database ngữ cảnh bền vững phía sau trí nhớ của agent. Không gian địa chỉ URI `viking://`.

### Không gian URI

| Scope | Mô tả |
|-------|-------|
| `resources/` | Kho tài nguyên chia sẻ global theo project/topic |
| `user/{user_id}/memories/` | Preferences, entities, events |
| `user/default/skills` | Kỹ năng categorized theo tags |
| `user/{user_id}/peers/{workspace}/` | Trí nhớ theo peer/workspace |
| Scoped READONLY | `skills/`, `peers/`, `privacy/`, `sessions/` |

### Tools

| Tool | Mô tả | Parameters chính |
|------|-------|-----------------|
| `remember` | Lưu thông tin vào long-term memory (messages role user/assistant) | messages |
| `search` | Deep semantic retrieval CÓ session context + phân tích intent. mode=list: ranked memories. mode=context: block ngữ cảnh injection-ready | query, mode, target_uri, limit |
| `find` | Fast semantic retrieval KHÔNG cần session context | query, target_uri, limit, min_score |
| `read` | Đọc toàn văn 1 hoặc batch nhiều file URI | uris (mảng) |
| `write` | Ghi text vào virtual file. Mode: replace/create/append | file_path, content, mode |
| `edit` | Thay chuỗi literal trong virtual file hiện có | file_path, old_string, new_string |
| `glob` | Tìm virtual file theo filename pattern | pattern, uri_root |
| `grep` | Regex content search — nhận nhiều pattern chạy song song | patterns, case_insensitive |
| `tree` | Cây thư mục đệ quy dưới URI | uri, level_limit, node_limit |
| `list` | Liệt kê files + subdirectories một cấp | uri, recursive |
| `health` | Health check server OpenViking | — |
| `add_resource` | Nuốt tài nguyên vào knowledge base (async) — URL, file, git repo | url/file_path, site, watch_interval |
| `forget` | Xóa vĩnh viễn URI — IRREVERSIBLE, recursive tùy chọn | uri, confirm |
| `list_watches` | Liệt kê watch tasks (subscription auto-refresh) | — |
| `cancel_watch` | Hủy watch theo target URI | target_uri |

---

## Vision Tools (+10, tiềm ẩn)

Kích hoạt qua skill `vision-skills` hoặc tool `vision_toolkit_activate`. Dùng Python bundled (`python-build-standalone`) với free service `vision.anionex.me`.

| Tool | Mô tả | Parameters chính |
|------|-------|-----------------|
| `vision_glance` | Nhìn nhanh tổng quát nội dung ảnh — mô tả, hỏi đáp, OCR, so sánh | `images[]`, `query`, `ocr` |
| `vision_ground` | Định vị 1 target theo mô tả ngôn ngữ tự nhiên, trả pixel boxes | `image`, `target`, `preview` |
| `vision_detect` | Phát hiện/liệt kê MỌI đối tượng trong 1 category kèm bounding box | `image`, `category`, `preview` |
| `vision_trace` | Trace flat high-contrast raster → editable SVG (vtracer pipeline) | `image`, `scale` (1-16), `color`, `polygon` |
| `vision_crop` | Cắt pixel box thành PNG/JPEG (local, không cần vision credential) | `image`, `region` (required), `scale` (1-8) |
| `vision_pixel_diff` | So sánh pixel 2 ảnh, rank worst grid regions, heatmap PNG + JSON report | `original`, `rebuilt`, `grid` (1-32), `top` |
| `vision_long_screenshot_ocr` | Chia tall screenshot, OCR chunks, merge overlaps, Markdown + artifacts | `image`, `mode` (general/chat), `splitOnly` |
| `vision_extract_foreground` | Tách icon/logo foreground thành transparent PNG | `image`, `region`, `mode` (color/dark) |
| `vision_dominant_colors` | Trích bảng màu chủ đạo hoặc score candidate palette | `image`, `region`, `candidates[]` |
| `vision_html_screenshot` | Render file .html local → PNG (Chrome-family adapter) | `source`, `width`, `height`, `fullPage` |

---

## Agency Experts (271)

Roster chuyên gia 18 phân hệ domain, bật/tắt TỪNG expert. Mặc định **TẤT CẢ TẮT**.

### Phân hệ (18 divisions)

| # | Phân hệ | Số expert | Ví dụ |
|---|---------|-----------|-------|
| 1 | **academic** | 6 | anthropologist, historian, psychologist, statistician |
| 2 | **design** | 10 | ui-designer, ux-architect, ux-researcher, visual-storyteller |
| 3 | **engineering** | 59 | ai-engineer, backend-architect, code-reviewer, devops-automator, sre, prompt-engineer |
| 4 | **finance** | 5 | financial-analyst, fpa-analyst, tax-strategist |
| 5 | **game-development** | 11 | game-designer, level-designer, technical-artist (subdirs: godot, unity, unreal-engine) |
| 6 | **gis** | 13 | cartography-designer, geoai-ml-engineer, spatial-data-engineer |
| 7 | **healthcare** | 3 | clinical-evidence-agent, innovation-strategist |
| 8 | **integrations** | 1 | mcp-memory |
| 9 | **marketing** | 36 | seo-specialist, content-creator, growth-hacker, social-media-strategist |
| 10 | **paid-media** | 7 | ppc-strategist, paid-social-strategist, tracking-specialist |
| 11 | **product** | 5 | product-manager, sprint-prioritizer, trend-researcher |
| 12 | **project-management** | 7 | project-manager-senior, meeting-notes-specialist |
| 13 | **sales** | 9 | account-strategist, deal-strategist, proposal-strategist |
| 14 | **security** | 12 | appsec-engineer, penetration-tester, threat-detection-engineer |
| 15 | **spatial-computing** | 6 | visionos-spatial-engineer, xr-interface-architect |
| 16 | **specialized** | 57 | business-strategist, legal-document-review, supply-chain-strategist |
| 17 | **support** | 6 | analytics-reporter, infrastructure-maintainer |
| 18 | **testing** | 9 | test-automation-engineer, performance-benchmarker, accessibility-auditor |

### Workflow

```bash
# 1. Liệt kê expert đang bật
list_experts

# 2. Lấy slug chính xác theo division
list_experts(division="engineering")

# 3. Triệu hồi
summon_expert(expert="backend-architect", task="...")

# Hoặc triệu hồi nhiều chuyên gia song song
summon_experts(experts=["backend-architect", "security-architect"], mission="...")
```
