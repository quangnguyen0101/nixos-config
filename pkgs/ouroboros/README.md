# ouroboros

Vendor OpenCode bridge plugin cho [Ouroboros](https://ouroboros.ai) — Agent OS chạy trên NixOS.

## Tổng quan

Đây **không** là Nix package. Thư mục này chứa file `.ts` bridge plugin được vendor từ wheel `ouroboros-ai` và được OpenCode load trực tiếp qua config `plugin`.

## Cấu trúc

```
pkgs/ouroboros/
└── ouroboros-bridge.ts    # Bridge plugin — dispatch _subagent envelope
                             # từ MCP ouroboros → Task panes của OpenCode
```

## Tại sao không dùng `ouroboros setup`?

`ouroboros setup` ghi trực tiếp vào `~/.config/opencode/opencode.json`. Trên NixOS, file đó là symlink vào nix store (read-only) — bị ghi đè sẽ mất sau rebuild. Giải pháp: vendor bridge plugin thủ công, cấu hình MCP server declarative qua Nix.

## Cấu hình

Xem `modules/home/opencode.nix`:

- `programs.opencode.settings.plugin`: trỏ đến file `ouroboros-bridge.ts`
- `programs.opencode.settings.mcp.ouroboros`: chạy MCP server qua `uvx` (pin version `0.54.4`)
- `environment.LD_LIBRARY_PATH`: cần thiết cho `greenlet` trên NixOS (uvx dùng Python cô lập)

## Bridge plugin làm gì?

- Bắt envelope `_subagent` từ MCP `ouroboros_session_signal`
- Dispatch các persona/advisory như Task panes riêng trong OpenCode
- Tránh `MAX_FANOUT = 10` dispatch gây FUD; mỗi persona chạy trong isolated LLM context
- Log tại `~/.config/opencode/plugins/ouroboros-bridge/bridge.log`

## Hướng dẫn sử dụng

### Kiểm tra MCP connection

```bash
opencode mcp list
# Phải thấy: ouroboros connected
```

### Các tool có sẵn (36 tools)

#### Execution

| Tool | Mô tả |
|------|-------|
| `ouroboros_execute_seed` | Chạy seed (task specification) — entry point chính |
| `ouroboros_start_execute_seed` | Chạy seed trong background, trả `job_id` |
| `ouroboros_start_auto` | Auto interview → seed → execute end-to-end |
| `ouroboros_auto` | Phiên bản đầy đủ của auto interview |

#### Evolution & Ralph Loop

| Tool | Mô tả |
|------|-------|
| `ouroboros_ralph` | Ralph loop — evolve liên tục cho đến khi pass QA hoặc convergence |
| `ouroboros_start_ralph` | Ralph loop chạy background |
| `ouroboros_evolve_step` | Chạy đúng 1 generation (Gen 1: seed_content, Gen 2+: auto) |
| `ouroboros_start_evolve_step` | evolve_step chạy background |
| `ouroboros_evolve_rewind` | Rewind lineage về generation cụ thể |

#### QA & Evaluation

| Tool | Mô tả |
|------|-------|
| `ouroboros_qa` | Đánh giá artifact bất kỳ (code/docs/config) theo quality bar |
| `ouroboros_evaluate` | 3-stage evaluation pipeline (mechanical → semantic → consensus) |
| `ouroboros_start_evaluate` | Evaluate chạy background |
| `ouroboros_checklist_verify` | Verify artifact satisfy mọi acceptance criteria trong seed |

#### Seed & Interview

| Tool | Mô tả |
|------|-------|
| `ouroboros_interview` | Socratic interview — clarify requirements trước khi implement |
| `ouroboros_pm_interview` | PM interview — product requirements gathering |
| `ouroboros_generate_seed` | Tạo seed từ interview hoặc session context |

#### Monitoring & Status

| Tool | Mô tả |
|------|-------|
| `ouroboros_project_status` | Trạng thái project (run count, seed stats) |
| `ouroboros_session_status` | Trạng thái session hiện tại |
| `ouroboros_job_status` | Poll background job status |
| `ouroboros_job_wait` | Chờ job state change (long-poll) |
| `ouroboros_job_result` | Lấy kết quả cuối của completed job |
| `ouroboros_query_events` | Query event history |
| `ouroboros_query_projection` | Build read-only Run/Stage/Step projection |
| `ouroboros_lineage_status` | Trạng thái evolutionary lineage |
| `ouroboros_ac_tree_hud` | Live acceptance-criteria tree snapshot |
| `ouroboros_ac_dashboard` | Compliance dashboard per-AC |

#### Cancellation & Control

| Tool | Mô tả |
|------|-------|
| `ouroboros_cancel_execution` | Cancel running/paused execution |
| `ouroboros_cancel_job` | Cancel background job |
| `ouroboros_session_signal` | Gửi signal intent (inform/after_turn) |

#### Advanced

| Tool | Mô tả |
|------|-------|
| `ouroboros_lateral_think` | Lateral thinking personas (hacker/researcher/architect/simplifier/contrarian) |
| `ouroboros_fetch_artifact` | Fetch + verify disposable artifact |
| `ouroboros_submit_fanout_results` | Submit fan-out results back to Ouroboros |
| `ouroboros_record_conductor_decision` | Ghi audit conductor decision |
| `ouroboros_measure_drift` | Đo drift từ seed goal |
| `ouroboros_brownfield` | Manage brownfield repo registrations |

### Ví dụ sử dụng

**Chạy task đơn giản (tự interview):**
> "Use ouroboros to implement a REST API endpoint for user authentication"
→ Tự động interview → generate seed → execute

**Chạy task từ seed có sẵn:**
> "Execute seed at ./my-seed.yaml with ouroboros"

**Đánh giá artifact:**
> "Use ouroboros_qa to evaluate the code at src/auth.py against: all functions must have type hints and tests"

**Ralph loop (evolve cho đến pass):**
> "Start ouroboros ralph loop on lineage my-project with this seed..."
→ Continuously evolve until QA passes or convergence

**Lateral thinking khi stuck:**
> "I'm stuck on this auth issue, use ouroboros_lateral_think with persona hacker"

## Cập nhật version

1. Tải wheel mới: `pip download ouroboros-ai==<version> --no-deps`
2. Trích xuất `ouroboros/opencode/plugin/ouroboros-bridge.ts` từ wheel
3. Copy vào `pkgs/ouroboros/ouroboros-bridge.ts`
4. Cập nhật version trong `modules/home/opencode.nix` (args MCP)
5. Rebuild: `sudo nixos-rebuild switch --flake .#nixos-btw`
