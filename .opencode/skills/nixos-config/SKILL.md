---
name: nixos-config
description: Use when working inside this repo (NixOS/home-manager config). Covers the rebuild/switch workflow, flake checks, formatting, module layout, secrets handling, and how opencode config (MCP servers, plugins, skills) integrates — so changes are validated and applied the Nix way instead of ad-hoc.
license: MIT
compatibility:
  - opencode
metadata:
  author: sh4d0wph4nt0m
  version: 1.0.0
---

# NixOS config conventions

Repo này là **flake NixOS + home-manager** (host `nixos-btw`). Mọi config phải declarative và tái hiện được — không sửa file trong store hay ~/.config theo kiểu thủ công rồi bỏ quên.

## Build & rebuild

- Build thử (không cần root, không áp dụng):
  `nix flake check --no-build`
  `nixos-rebuild build --flake .#nixos-btw`
- Áp dụng (user chạy, cần password → `sudo -n` sẽ fail nhanh nếu không có quyền, báo user):
  `sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw`
- Không bao giờ ping sudo bằng password trong shell không interactive; dùng `sudo -n`, nếu fail thì dừng và báo user tự chạy lệnh.

## Format & lint

- Toàn bộ `.nix` format bằng **nixfmt** trước khi commit: `nix fmt` (chạy từ root repo).
- Validate cấu trúc: `nix flake check` (pass cả module + nixpkgs-fmt nếu có).

## Cấu trúc module

- `modules/home/` — home-manager: `opencode.nix` (MCP servers, plugins, instructions, skills), `jupyter.nix` (python314 env, service jupyterlab), ...
- `home/<user>/home.nix` — imports module home-manager vào host.
- `pkgs/ouroboros/ouroboros-bridge.ts` — opencode plugin (referenced qua `./...` path → Nix copy vào `/nix/store`, store path thay đổi mỗi lần sửa → phải rebuild để opencode thấy bản mới).
- Thay đổi ở module chỉ có hiệu lực sau khi user chạy `nixos-rebuild switch`. Config opencode không hot-reload → sau rebuild phải **thoát & mở lại opencode**.

## Git

- Conventional commits: `fix:`, `feat:`, `docs:`, `refactor:`; message tiếng Việt ngắn gọn.
- File mới phải `git add` trước khi `nix flake check` (flake không thấy file untracked).
- Không commit secret. Quy tắc mặc định: tham chiếu `github.tokenFile`, `dssecret` từ chỗ khác, không hardcode vào repo.

## opencode integration

- Config mở rộng qua `modules/home/opencode.nix` → `programs.opencode.settings`.
- 8 MCP servers khai báo ở đó (arxiv, context7, docker, github, jupyter, openviking, ouroboros, postgres).
- Skills trong repo:
  - project skill (repo-scope): `.opencode/skills/nixos-config/SKILL.md` — tự dùng khi đang ở repo.
  - global skill `data-science`: source ở `pkgs/opencode/skills/data-science/SKILL.md`, home-manager copy sang `~/.config/opencode/skills/`.
- Lần đầu `opencode mcp list` ngay sau reboot có thể báo transient fail (cold start uvx) — chạy lại lần 2 là OK, đừng kết luận vội config sai.