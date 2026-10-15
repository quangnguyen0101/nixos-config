#!/usr/bin/env python3
"""Sinh bang "Skills" trong README.md tu pkgs/opencode/skills/*/SKILL.md.

    python3 scripts/gen-skills-table.py            # ghi lai bang
    python3 scripts/gen-skills-table.py --check    # exit 1 neu README lech
    python3 scripts/gen-skills-table.py --selftest # kiem tra ham parse

Chong lech: script doc danh sach skill tu thu muc that. Them skill moi ->
phai them ten vao ORDER (va nguon vao PROVENANCE), neu khong script bao loi.
Khong phu thuoc thu vien ngoai (parse frontmatter thu cong).
"""
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS_DIR = ROOT / "pkgs/opencode/skills"
README = ROOT / "README.md"
BEGIN = "<!-- BEGIN SKILLS-TABLE -->"
END = "<!-- END SKILLS-TABLE -->"

# Thu tu hien thi trong bang. Phai khop dung tap skill trong SKILLS_DIR.
ORDER = [
    "data-science",
    "archify",
    "guizang-ppt-skill",
    "latex-document-skill",
    "manim-composer",
    "manimce-best-practices",
    "manim-skill",
    "defuddle",
    "json-canvas",
    "knap",
    "obsidian-bases",
    "obsidian-cli",
    "obsidian-markdown",
]

# Cot "Nguon": xuat xu / license cua tung skill (khong suy ra duoc tu SKILL.md).
PROVENANCE = {
    "data-science": "repo",
    "archify": "vendored `tt-a1i/archify` (MIT)",
    "guizang-ppt-skill": "vendored `op7418/guizang-ppt-skill` (AGPLv3)",
    "latex-document-skill": "vendored `ndpvt-web/latex-document-skill` (MIT)",
    "manim-composer": "vendored `adithya-s-k/manim_skill` (MIT)",
    "manimce-best-practices": "vendored `adithya-s-k/manim_skill` (MIT)",
    "manim-skill": "vendored `Yusuke710/manim-skill` (MIT)",
    "defuddle": "vendored `kepano/obsidian-skills` (MIT)",
    "json-canvas": "vendored `kepano/obsidian-skills` (MIT)",
    "knap": "vendored `kepano/obsidian-skills` (MIT)",
    "obsidian-bases": "vendored `kepano/obsidian-skills` (MIT)",
    "obsidian-cli": "vendored `kepano/obsidian-skills` (MIT)",
    "obsidian-markdown": "vendored `kepano/obsidian-skills` (MIT)",
}

# Mo ta tieng Viet cho cot "Mo ta". Skill khong co o day -> lay cau dau
# cua `description` trong frontmatter SKILL.md.
DESC_MAP = {
    "data-science": "Workflow data science: notebook trên Jupyter MCP, compute server-side, Postgres/Docker, tra cứu arXiv, xuất plot + BibTeX",
    "archify": "Render mô hình hệ thống (architecture/workflow/sequence/dataflow/lifecycle) → HTML/SVG tương tác từ JSON IR; cần `node >=18`",
    "guizang-ppt-skill": "Web PPT 1-file dạng swipe ngang (2 style: *Magazine x E-Ink* / *Swiss*) + image prompt + cover mạng xã hội",
    "latex-document-skill": "Compile LaTeX → PDF + preview PNG, 28 template + CV ATS, chart/mermaid/graphviz, mail-merge, fill/extract PDF",
    "manim-composer": "Lập kế hoạch scene-by-scene cho video Manim (ra `scenes.md`) trước khi viết code",
    "manimce-best-practices": "Best practices ManimCE: 24 rule + example + template (Scene, MathTex, 3D, camera, …)",
    "manim-skill": "Render video ManimCE + TTS voiceover (Kokoro local, hoặc `edge-tts` online) + subtitle đồng bộ; tools gọi `python` (kokoro/soundfile/edge-tts nằm trong `jupyterEnv`)",
    "defuddle": "Trích Markdown sạch từ trang HTML",
    "json-canvas": "Tạo/sửa file `.canvas` (node / edge / group)",
    "knap": "Render Markdown từ template + data (JSON/CSV)",
    "obsidian-bases": "Tạo/sửa file `.base` (view / filter / formula)",
    "obsidian-cli": "Thao tác vault Obsidian qua CLI (đọc/tạo/search note, plugin & theme dev)",
    "obsidian-markdown": "Obsidian Flavored Markdown (wikilink, callout, embed, frontmatter)",
}


def die(msg):
    print("loi: " + msg, file=sys.stderr)
    sys.exit(2)


def parse_frontmatter(text):
    """Tra ve dict cac key trong khoi ---...--- dau file (khong can PyYAML)."""
    if not text.startswith("---"):
        return {}
    nl = text.find("\n")
    end = text.find("\n---", nl)
    if nl == -1 or end == -1:
        return {}
    lines = text[nl + 1:end].split("\n")
    fm = {}
    i = 0
    while i < len(lines):
        line = lines[i]
        if not line.strip() or line.lstrip().startswith("#") or ":" not in line:
            i += 1
            continue
        key, _, val = line.partition(":")
        key, val = key.strip(), val.strip()
        if val in (">", ">-", "|", "|-"):
            buf = []
            i += 1
            while i < len(lines) and (lines[i][:1] in (" ", "\t") or not lines[i].strip()):
                buf.append(lines[i].strip())
                i += 1
            fm[key] = " ".join(x for x in buf if x)
            continue
        fm[key] = val
        i += 1
    return fm


def first_sentence(s):
    s = " ".join(s.split())
    if not s:
        return ""
    head = s.split(". ")[0].strip()
    return head if head.endswith((".", "!", "?")) else head + "."


def cell(s):
    return s.replace("|", "\\|").strip()


def build_block():
    dirs = sorted(d.name for d in SKILLS_DIR.iterdir() if (d / "SKILL.md").is_file())
    extra = [d for d in dirs if d not in ORDER]
    gone = [s for s in ORDER if s not in dirs]
    if extra:
        die("skill chua co trong ORDER (them ten + nguon vao script): " + ", ".join(extra))
    if gone:
        die("ORDER tro toi skill khong ton tai: " + ", ".join(gone))
    rows = ["| Skill | Nguồn | Mô tả |", "|-------|-------|-------|"]
    for name in ORDER:
        fm = parse_frontmatter((SKILLS_DIR / name / "SKILL.md").read_text(encoding="utf-8"))
        desc = DESC_MAP.get(name) or first_sentence(fm.get("description", ""))
        rows.append(f"| `{name}` | {cell(PROVENANCE.get(name, '?'))} | {cell(desc)} |")
    return "\n".join(rows)


def selftest():
    assert first_sentence("Use when A. Covers B.") == "Use when A."
    assert first_sentence("One sentence") == "One sentence."
    assert parse_frontmatter("---\nname: x\ndescription: >-\n  hello\n  world\n---\nbody")["description"] == "hello world"
    assert parse_frontmatter("---\nname: x\ndescription: plain value\n---\n")["description"] == "plain value"
    print("selftest ok")


def main():
    if "--selftest" in sys.argv:
        return selftest()
    text = README.read_text(encoding="utf-8")
    if BEGIN not in text or END not in text:
        die(f"README thieu marker:\n  {BEGIN}\n  {END}")
    pre, rest = text.split(BEGIN, 1)
    _, post = rest.split(END, 1)
    new = pre + BEGIN + "\n" + build_block() + "\n" + END + post
    if "--check" in sys.argv:
        if new != text:
            die("README lech. Chay: python3 scripts/gen-skills-table.py")
        print("README khop.")
        return
    if new == text:
        print("README da dung, khong doi.")
        return
    README.write_text(new, encoding="utf-8")
    print("Da cap nhat bang skill trong README.md")


if __name__ == "__main__":
    main()
