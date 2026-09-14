---
tags: [nixos, tools, autoskills]
---

# autoskills — gắn skill AI vào project

CLI (midudev/autoskills, **CC-BY-NC-4.0** — chỉ dùng cá nhân). Tự detect stack của project rồi cài skill vào `.agents/skills/<tên>/SKILL.md`. Opencode tự discover `.agents/skills/` (và `.claude/skills/`).

## Cách dùng

```bash
cd ~/du-an/cu-the
autoskills                 # detect → liệt kê skill → xác nhận → cài
autoskills --dry-run       # chỉ xem danh sách, không cài
autoskills -y              # bỏ bước xác nhận
autoskills -a claude-code  # chỉ cài cho 1 agent (mặc định universal → .agents/skills/)
autoskills --clear-cache   # xóa cache ở ~/.cache/autoskills
autoskills -v              # log chi tiết từng skill
```

## Quy tắc chọn skill

> [!warning] 2 skill vercel-labs** phải bỏ khi chọn**: `react-best-practices` và `composition-patterns` — frontmatter `name` không khớp tên thư mục → opencode bỏ qua. Rà sau khi cài:
> ```bash
> for d in .agents/skills/*/; do n=$(basename "$d"); \
>   [ "$n" = "$(sed -n 's/^name: //p' "$d/SKILL.md")" ] || echo "skip: $n"; done
> ```

- `skills-lock.json` ghi lại bản đã cài (giữ trong git để tái hiện).
- Cài xong **phải thoát & mở lại opencode** mới thấy skill.
- Lần đầu chạy cần mạng (skill tải về từ GitHub).

## Cấu hình & tắt

- Khai báo: `modules/home/autoskills.nix` → `home.packages = [ pkgs.autoskills ]`; derivation tại `pkgs/opencode/autoskills/default.nix`.
- **Không chạy service nền** — tắt là bỏ khỏi `home.nix` cho đỡ ~65MB binary trong profile.

## Liên quan

- [[USAGE]] — phần autoskills trong cheatsheet
- [[_index]] — map of content