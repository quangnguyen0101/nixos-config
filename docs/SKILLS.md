---
tags: [nixos, docs, skills]
---

# SKILLS — Lệnh cụ thể của từng skill

> [!info] Obsidian
> Vault này = repo `~/nixos-config`. Mở trong **Obsidian** để dùng wikilink `[[...]]`, graph view, backlinks — GitHub render phần lớn (chỉ wikilink thành text).

> [!note]
> Bề mặt lệnh của 13 skill opencode đang cài (vendored trong `pkgs/opencode/skills/`). Bảng name/nguồn/mô tả ở [[README|README § Opencode]]; note này bổ sung **lệnh cụ thể**. Trạng thái module: [[INVENTORY]]. Cheatsheet tool khác: [[USAGE]].

- `<SKILL_ROOT>` / `<skill>` = thư mục skill, vd `pkgs/opencode/skills/<name>/`.
- `<TOOLS_DIR>` = `pkgs/opencode/skills/manim-skill/tools`.
- Các CLI `defuddle`, `knap`, `obsidian` (và `manim`, `ffmpeg`, `bash`, `python3`) phải có sẵn trong `PATH`.

## Nhóm 1 — skill có lệnh chạy

### archify
`node bin/archify.mjs <cmd>` — type: `architecture | workflow | sequence | dataflow | lifecycle`.

```bash
node bin/archify.mjs render    <type> <in.json> [out.html] [--quality standard|showcase] [--repo-root p]
node bin/archify.mjs compare   architecture <base.json> <head.json> [out.html] [--receipt p] [--json]
node bin/archify.mjs deliver   <type> <in.json> [out.html] [--json] [--open] [--quality standard|showcase]
node bin/archify.mjs preview   <type> <in.json> [out.html] [--no-open] [--quality standard|showcase]
node bin/archify.mjs validate  <type> <in.json> [--json] [--layout-json] [--quality standard|showcase]
node bin/archify.mjs migrate   workflow <old.json> <new.json> --to-schema 2 [--json]
node bin/archify.mjs inspect   <type> <in.json>
node bin/archify.mjs check     <out.html>
node bin/archify.mjs visual-check <out.html> [--json]
node bin/archify.mjs guide     [scenario] [--json] [--lang en|zh]
node bin/archify.mjs brands    [name|alias|domain|category] [--json]
node bin/archify.mjs brands capture <url> [--json]
node bin/archify.mjs examples
node bin/archify.mjs doctor
node bin/archify.mjs demo [outdir]
```

Script phụ: `scripts/check-update.mjs`, `scripts/render-examples.mjs`, `delta/architecture-delta.mjs`.

### manim-skill

```bash
python "<TOOLS_DIR>/tts-generate.py" --narration narration.txt   # TTS Kokoro local (default) + subtitle
python "<TOOLS_DIR>/tts-generate.py" --narration narration.txt --engine edge-tts --voice vi-VN-HoaiMyNeural   # TTS online (cần mạng)
python "<TOOLS_DIR>/lint-subtitles.py" script.py
python3 <TOOLS_DIR>/video_viewer.py    video.mp4 --order concat.txt --script script.py
manim script.py Scene1 Scene2 ...
ffmpeg -y -f concat -safe 0 -i concat.txt -c copy -movflags +faststart video_silent.mp4
ffmpeg -y -i video_silent.mp4 -i voiceover.mp3 ...
```

### manimce-best-practices

```bash
manim -pql scene.py Scene     # preview low quality
manim -pqh scene.py Scene     # preview high quality
manim --format gif scene.py
manim checkhealth
manim plugins -l
```

### guizang-ppt-skill

```bash
node <SKILL_ROOT>/scripts/validate-presenter-mode.mjs index.html [--target-minutes 30]
node <SKILL_ROOT>/scripts/check-presenter-runtime-sync.mjs
node <SKILL_ROOT>/scripts/validate-swiss-deck.mjs index.html
```

### latex-document-skill

```bash
# compile & convert
bash <skill>/scripts/compile_latex.sh doc.tex [--preview] [--preview-dir d] [--engine pdflatex|xelatex|lualatex] [--use-latexmk] [--pdfa] [--verbose|--quiet] [--clean]
bash <skill>/scripts/convert_document.sh ...        # Pandoc wrapper (md/docx/html <-> tex)
bash <skill>/scripts/install_deps.sh
python3 <skill>/scripts/validate_latex.py doc.tex

# chart / diagram
python3 <skill>/scripts/generate_chart.py           # bar chart từ JSON data
python3 <skill>/scripts/csv_to_latex.py             # CSV -> bảng booktabs
bash <skill>/scripts/graphviz_to_pdf.sh
bash <skill>/scripts/mermaid_to_image.sh
bash <skill>/scripts/plantuml_to_pdf.sh

# phân tích / trích dẫn / so khớp
bash <skill>/scripts/latex_analyze.sh
bash <skill>/scripts/latex_lint.sh
bash <skill>/scripts/latex_wordcount.sh
bash <skill>/scripts/latex_citation_extract.sh
bash <skill>/scripts/latex_package_check.sh
bash <skill>/scripts/latex_diff.sh                  # latexdiff highlight
bash <skill>/scripts/fetch_bibtex.sh
python3 <skill>/scripts/mail_merge.py

# PDF
bash <skill>/scripts/pdf_extract_pages.sh
bash <skill>/scripts/pdf_merge.sh
bash <skill>/scripts/pdf_optimize.sh
bash <skill>/scripts/pdf_to_images.sh
bash <skill>/scripts/pdf_encrypt.sh
python3 <skill>/scripts/pdf_check_form.py form.pdf
python3 <skill>/scripts/pdf_extract_fields.py form.pdf field_info.json
python3 <skill>/scripts/pdf_fill_form.py form.pdf values.json out.pdf
python3 <skill>/scripts/pdf_fill_annotations.py form.pdf fields.json out.pdf
python3 <skill>/scripts/pdf_validate_boxes.py fields.json --image page_1.png --output validation.png --page 1
```

### defuddle

```bash
defuddle parse <url> --md              # markdown (lựa chọn mặc định)
defuddle parse <url> --md -o content.md
defuddle parse <url> -p title|description|domain
# flag: --md | --json | (none = HTML) | -p <name>
```

### knap

```bash
knap help syntax|filters|filter date|tags|tag for
knap render template.md --data article.json -o note.md
knap render -t '# {{ title | trim }}' --data-json '{"title":"Hello"}'
knap render template.md --data article.json --set 'title=Custom title'
knap validate template.md
knap batch template.md --data articles.csv --output-dir notes
```

### obsidian-cli
`obsidian <cmd>`:

```bash
obsidian create name="My Note" content="Hello" [silent] [overwrite] [template="T"]
obsidian read file="My Note"
obsidian append file="My Note" content="New line"
obsidian search query="term" [limit=10]
obsidian vault="My Vault" search query="term"
obsidian daily:read
obsidian daily:append content="- [ ] New task"
obsidian property:set name="status" value="done" file="My Note"
obsidian tasks daily todo
obsidian tags sort=count counts
obsidian backlinks file="My Note"
obsidian plugin:reload id=my-plugin
obsidian dev:errors
obsidian dev:console level=error
obsidian dev:screenshot path=screenshot.png
obsidian dev:dom selector=".workspace-leaf" text
obsidian dev:css selector=".workspace-leaf" prop=background-color
obsidian eval code="app.vault.getFiles().length"
obsidian dev:mobile on
```

## Nhóm 2 — không có CLI (thuần hướng dẫn / workflow)

| Skill | Cách dùng |
|-------|-----------|
| `data-science` | Chạy notebook trên Jupyter MCP, compute server-side, Postgres/Docker, tra arXiv, xuất plot/BibTeX |
| `json-canvas` | Tạo/sửa `.canvas` (node / edge / group) — không có lệnh |
| `obsidian-bases` | Tạo/sửa `.base` (view / filter / formula) — không có lệnh |
| `obsidian-markdown` | Viết Obsidian Flavored Markdown (wikilink, callout, embed, frontmatter) |
| `manim-composer` | Lập kế hoạch scene-by-scene ra `scenes.md` trước khi viết code — không chạy gì |
