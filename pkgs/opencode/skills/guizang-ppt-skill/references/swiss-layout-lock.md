# Swiss Layout Lock

This file is the Swiss theme's hard constraint. Its purpose is not to add inspiration, but to prevent output that "looks like Swiss, yet has drifted from the original template".

## Golden Source

The layout baseline is `assets/template-swiss.html` in the repo (derived from the author's original reference PPT; the original file is not distributed with the repo, and the S01-S22 layouts registered in this file are its layout snapshot).

When generating with the Swiss theme, only choose from the 22 registered layouts below, unless the user explicitly asks for experimental layouts. New cover/back-cover pages may use the IKB ASCII versions from the Skill, but content pages must come from these 22 layouts.

## Hard Rules Before Generation

1. Every content page must first pick a registered layout and write `data-layout="Sxx"` on its `<section>`.
2. Do not improvise content structures like `P23/P24` that do not appear in the original 22P. When an image is needed, prefer `S22 Image Hero`; for multiple images, adapt the original grid skeleton of `S15/S16` into image cells — do not invent new evidence walls. The only registered interactive extension is `S08 + Swiss Map Component`; see `references/swiss-map-component.md`.
3. The top Chinese title is left-aligned by default and hugs the top-left content axis. Except for statement/split layouts like the original `S03/S09/S10`, do not place the main title at the horizontal center of the page.
4. SVG is only for geometric lines, circles, arrows, and paths. Do not write visible text in SVG; put all text labels in HTML, inside grids, cards, or captions.
5. Image slots and image generation aspect ratios must be bound together. Decide the layout and slot first, then generate the image.

## Registered Layouts

| ID | Original Page | Name | Skeleton That Must Be Preserved | Image Rules |
|---|---:|---|---|---|
| S01 | 01 | Index Cover | Three-row `cover-row`, huge number on the left, big title on the right | None |
| S02 | 02 | Vertical Timeline + KPI | Top-left aligned title, `.timeline-v` in the middle, `.kpi-row-4` at the bottom | None |
| S03 | 03 | Split Statement | `.slide.split` two half screens, huge type on the left, gray-backed explanation on the right | None |
| S04 | 04 | Six Cells | Top-left aligned title, `.sub-grid-3-2` six cards below | Card interiors may swap in small icons; no large images |
| S05 | 05 | Three Layers | Top-left aligned title, `.stack-row` three blocks below | None |
| S06 | 06 | KPI Tower | Title left + note right, uneven-height KPI tower below | None |
| S07 | 07 | Horizontal Bar | Left-aligned title, horizontal bar chart | None |
| S08 | 08 | Duo Compare | `.duo-compare` two columns + center divider | None; for place/route content, `S08 + Swiss Map Component` may replace the right slot |
| S09 | 09 | Dot Matrix Statement | Large statement + dot-matrix decoration | None |
| S10 | 10 | Split Closing | `.slide.split`, huge type on the left, list on the right | None |
| S11 | 11 | Horizontal Timeline | Original `grid-template-columns:auto 1fr` header + `.timeline-h` | None |
| S12 | 12 | Manifesto + Ink Banner | Large statement + full-width ink bar at the bottom | None |
| S13 | 13 | Three Forces | Ink hero block on the left + 3 cards on the right | None |
| S14 | 14 | Loop Form | 4-step list on the left + geometric loop on the right | No text in SVG; put labels in HTML |
| S15 | 15 | Matrix + Hero Stat | Top-left aligned title, 6×2 matrix in the middle, huge number at the bottom | Matrix cells can be repurposed for images; keep one `21:9` ratio per group |
| S16 | 16 | Multi-card Brief | Top-left aligned title, 3×2 mini-cards below | Card content can be repurposed for images; keep one `21:9` ratio per group |
| S17 | 17 | System Diagram | Small title top-left + paragraph right, geometric system diagram in the middle, three-column explanation at the bottom | No text in SVG; put labels in HTML |
| S18 | 18 | Why Now | Three-column progression + huge number at the bottom | None |
| S19 | 19 | Four Cards | Blue rule at the top + four equal columns | None |
| S20 | 20 | Stacked KPI Ledger | Vertical ledger-style huge numbers | None |
| S21 | 21 | Tech Spec Sheet | Big title + three KPIs + vertical-rule matrix at the bottom right | None |
| S22 | 22 | Image Hero | Full-width image at the top + white-block title at the top left + three-column KPIs below | Generate the hero image at `21:9`; keep the key subject in the central safe area |

## Registered Extended Components

### S08 + Swiss Map Component

- Use cases: geography, history, city routes, store/campus/event locations, and people's residences.
- Layout identity: still `data-layout="S08"`, not a new content page.
- Page structure: top-left aligned title + relationship/explanation card on the left + MapLibre map card on the right.
- Marker structure: points + connection lines + HTML cards; SVG only draws fallback relationship lines, never text.
- Interaction controls: `+` / `-` / `DRAG` must appear in the top-right corner; wheel zoom and drag are disabled by default to avoid triggering PPT page turns.
- Full code and the data contract live in `references/swiss-map-component.md`.

## Image Slot Rules

### S22 · Hero Strip

- Generation ratio: `21:9`
- Image use: photograph-style scenes, product shots, UI scenarios.
- The prompt must include: `21:9 ultra-wide strip`, `subject centered in the safe middle area`, `no title, no footer, no page chrome, no logo, no border`.
- The HTML container must use the original S22 full-width top image skeleton; do not turn it into a plain centered large image.
- Photos use `object-fit:cover;object-position:center 35%`. For portrait/meeting scenes, do not use `top center`.
- Infographics/UI screenshots placed in S22 must be regenerated near `21:9` and use `object-fit:contain`, or keep the core content in the central 70% safe area.

### S15/S16 · Multi Image Grid

- Generation ratio: one `21:9` or one `16:10` for the whole group — never mix.
- Images in one group must share height, width, and container background.
- Image cells must snap to the original card grid; the image never decides its own width/height.
- If an image was regenerated for the slot as `s15-grid-21x9` / `s16-brief-21x9`, the container must fill the slot with `.frame-img.r-21x9`; do not add `.fit-contain` back, and do not shrink a wide image with short-slot fixed heights like `height:18vh`.
- `.fit-contain` is only for user screenshots that must keep their original ratio or text-dense images; once you decide to regenerate, regenerate at the slot ratio and fill it.
- If the original screenshot's ratio is out of your control, first do programmatic ratio adaptation per `references/screenshot-framing.md`; only for tall/very-narrow screenshots or when the information must be restructured, regenerate a “screenshot redesign” with GPT-M 2.0.

## Prohibited

- Never apply `text-align:center` to the top Chinese large title.
- Never put the top title inside the right 7.8fr column, which makes it look centered.
- No unregistered content pages: e.g. ad-hoc `Swiss Image Split`, `Evidence Grid`, or hand-drawn three-circle pages.
- Never wrap a white-backed infographic in a gray-backed image container.
- No visible labels as `<text>` inside SVG.
- Never default `object-position:top center` for photos.
