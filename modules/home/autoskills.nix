{ pkgs, ... }:

# autoskills CLI (midudev/autoskills, CC-BY-NC-4.0 — ban chi rieng dung ca nhan).
# Usage: chay `autoskills` trong root project -> cai skill vao .agents/skills/<name>/
# (opencode tu discover .agents/skills/ + .claude/skills/). Can Node >=22.6
# (da co tren he thong). Khoi lenh co ghi skills-lock.json (pin sha256).
#
# LUU Y (compat opencode): opencode require `name` trong frontmatter == ten
# thu muc chua SKILL.md. Mot so bundle registry vi pham (VD vercel-labs:
# react-best-practices name=vercel-react-best-practices, composition-patterns
# name=vercel-composition-patterns) -> opencode se BO QUA cac skill do.
# Check nhanh sau khi install:
#   for d in .agents/skills/*/; do n=$(basename "$d"); \
#     [ "$n" = "$(sed -n 's/^name: //p' "$d/SKILL.md")" ] || echo "skip: $n"; done
# Chi cai skill co name khop (phai manual chon, bo 2 skill tren).

{
  home.packages = [ pkgs.autoskills ];
}