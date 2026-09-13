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

## Cập nhật version

1. Tải wheel mới: `pip download ouroboros-ai==<version> --no-deps`
2. Trích xuất `ouroboros/opencode/plugin/ouroboros-bridge.ts` từ wheel
3. Copy vào `pkgs/ouroboros/ouroboros-bridge.ts`
4. Cập nhật version trong `modules/home/opencode.nix` (args MCP)
