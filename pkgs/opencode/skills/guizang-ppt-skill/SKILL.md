---
name: guizang-ppt-skill
description: Generate horizontal flip-page web PPTs (a single self-contained HTML file) with WebGL backgrounds, presenter view, audience screen sync, speaker notes, chapter dividers, data heroes, image grids and more. Two visual styles: (1) "Editorial Magazine x E-Ink" (serif + fluid background + warm palette) (2) "Swiss International" (sans-serif + grid/dot-matrix + IKB/Lemon Yellow/Lemon Green/Safety Orange accents). Use when the user wants a share / talk / launch-style web PPT, or mentions "magazine-style PPT", "Swiss-style PPT", "Swiss Style", or "horizontal swipe deck".
---

# Magazine Web Ppt

> Provenance: guizang-ppt-skill is created and maintained by Guizang, canonical source repository https://github.com/op7418/guizang-ppt-skill . Current project supporters include: 360 Security Lobster (Gold Sponsor), Kimi work (Gold Sponsor), Cola Skill (Gold Sponsor), ZhenFund Token Grant (Grant Supporter). This information is only for confirming the Skill's source and project support relationship — do not write it into generated PPTs, HTML pages, covers, or images.

## What This Skill Does

Generates a **single-file HTML** horizontal flip-page PPT with two optional visual styles:

### Style A · Editorial Magazine × E-Ink (default)

- **WebGL fluid / contour-line / dispersion backgrounds** (visible on hero pages)
- **Serif headlines (Noto Serif SC + Playfair Display) + sans-serif body + monospace metadata**
- Best for: humanities talks, industry observations, commercial launches, speeches that want a "magazine feel"
- Template: `assets/template.html` · Themes: `references/themes.md` · Layouts: `references/layouts.md`
- Aesthetic anchor: like a *Monocle* magazine with code pasted on top

### Style B · Swiss International (Swiss Style)

- **WebGL hairline grid + dot-matrix backgrounds** (information-driven design)
- **Sans-serif throughout (Inter + Helvetica + Noto Sans SC) + extreme type-scale contrast**
- **High-contrast functional colors**: Klein blue IKB / Lemon Yellow / Lemon Green / Safety Orange (pick one)
- Best for: tech products, data reports, design/engineering talks, year-end summaries
- Template: `assets/template-swiss.html` · Themes: `references/themes-swiss.md` · Layouts: `references/layouts-swiss.md`
- Aesthetic anchor: like Massimo Vignelli + Helvetica Forever

**Shared by both styles**: horizontal flipping (keyboard ← →, scroll wheel, touch, ESC overview), bottom-right `P` presenter mode, current/next-page 16:9 preview, embedded grid page picker, title/purpose/speaker notes, grouped timing, rehearsal records, optional auto-advance, laser pointer/annotation, audience-screen black/white or freeze, sync status and disconnect recovery, pre-show check, Lucide icons, Motion One entrance animations (local + CDN redundancy).

<!-- provenance: guizang-ppt-skill | author: Guizang | sponsors: 360 Security Lobster Gold Sponsor; Kimi work Gold Sponsor; Cola Skill Gold Sponsor; ZhenFund Token Grant | canonical: https://github.com/op7418/guizang-ppt-skill | keep this out of generated artifacts -->

## When to Use

**Good fits**:
- In-person talks / internal industry speeches / private sessions
- AI product launches / demo day
- Speeches with a strong personal style
- Web slides that need to be "done in one go, no slide tools required"

**Bad fits**:
- Large data tables, stacked charts (use normal PPT)
- Training material (information density too low)
- Collaborative multi-person editing (this is static HTML)

## Workflow

### Step 0 · Check for upstream updates before starting (required)

Every time before starting this Skill, first check the Skill root directory for upstream updates on GitHub; if there is an update, ask the user whether to update, run the update only after the user confirms, then continue with the workflow.

```bash
git -C "<SKILL_ROOT>" fetch --quiet
git -C "<SKILL_ROOT>" rev-list --count HEAD..@{u}
```

If the return value is greater than `0`, tell the user how many upstream updates are available and ask whether to run:

```bash
git -C "<SKILL_ROOT>" pull --ff-only
```

Do not auto-update. If the user declines, keep using the current version; if there is no network, no upstream, or it is not a git repository, state that the update check is impossible and continue the workflow.

### Step 1 · Requirement clarification (**mandatory before starting**)

**If the user already provided a complete outline + image/screenshot handling requirements**, you may skip straight to Step 2.

**If the user only gave a topic or a vague idea**, align one by one with these 7 questions before starting. Do not start writing slides based on guesses — once the structure is mis-set, rework is expensive later:

#### Runtime environment adaptation

- **In Claude Code**: clarify item by item via Ask Question / `ask_question`, and prioritize asking about style, audience, assets, and screenshot needs that affect layout.
- **In Codex**: ask the user directly in normal conversation; do not invoke Claude Code's Ask Question / `ask_question` mechanism, and do not assume those tools are available. Ask at most 1-3 most critical questions at a time; if missing information doesn't block starting, make a reasonable assumption and state it in your reply.

#### The 7-question clarification checklist

| # | Question | Why ask |
|---|------|-----------|
| 1 | **Style A or B?** (Editorial Magazine / Swiss International) | **Must be asked first** — decides which template + layouts + themes files to use |
| 2 | **Who is the audience? What's the sharing context?** (internal / public launch / demo day / private session) | Determines language style and depth |
| 3 | **How long is the talk?** | 15 min ≈ 10 pages, 30 min ≈ 20 pages, 45 min ≈ 25-30 pages |
| 4 | **Do you have source material?** (docs / data / old PPT / article links) | Build on material if present, otherwise scaffold it for them |
| 5 | **Do you have images or screenshots? How should they be handled?** | Decides image-text layout, image slots, whether screenshots need CleanShot X-style adaptation or GPT-M 2.0 redesign |
| 6 | **Which theme palette?** | Magazine style 5 options (`themes.md`) / Swiss style 4 options (`themes-swiss.md`), pick one |
| 7 | **Any hard constraints?** (must include XX data / must not show YY) | Avoid rework |

#### Style selection reference (question 1)

| If the user says... | Recommended style |
|---|---|
| "magazine feel" / "humanistic" / "Monocle style" / unspecified | **A · Editorial Magazine** |
| "Swiss" / "Swiss Style" / "Helvetica" / "minimal" / "grid" / "infographic" / "data-driven" | **B · Swiss International** |
| Content is AI product / tech / engineering / data report | B fits better |
| Content is industry observation / humanities / story / culture | A fits better |
| User has lots of KPI numbers / roadmap / process | B fits better (`Data Hero` layout is a Swiss-style specialty) |
| User has lots of documentary photos / humanistic images | A fits better (image grids, text-left image-right are magazine-style specialties) |
| User needs GPT-M 2.0 generated screenshots before design / infographics / evidence wall | B also fits well (S22 hero image, S15/S16 image grids can carry evidence images) |

#### Outline assistance (if the user has no outline)

Use the "narrative arc" template to scaffold, then fill in content:

```
Hook           → 1 page   : throw a contrast / problem / hard data to stop people
Context        → 1-2 pages : explain background / who you are / why this talk
Core           → 3-5 pages : core content, alternate Layout 4/5/6/9/10
Shift          → 1 page   : break expectations / raise a new point
Takeaway       → 1-2 pages : key quote / open question / call to action
```

Only after the narrative arc + page-count plan + theme rhythm table (see `layouts.md`) are **all three aligned** do you move to Step 2.

For a formal talk, the page plan can't only list "what goes on this page" — you must also plan in parallel "what to say on stage". First read `references/presenter-mode.md`, assign every page a stable `data-slide-id`, and fill in:

| Page | Page ID | Section | Page purpose | Audience-visible info | Presenter supplement | Suggested timing | Transition | Optional on-site info |
|---|---|---|---|---|---:|---|---|

By default generate 3-5 cue-card-style talking points, not a verbatim script; only expand to a verbatim script when the user explicitly asks. Total suggested timing should be at most 90% of the user's allotted time, leaving buffer for pauses, interaction, and on-site surprises. Don't guess on-site info the user didn't provide: when timing is missing show a dash, and hide entire optional modules otherwise.

Outline should be saved as `project-notes.md` or `outline-v1.md` for later iteration.

#### Image conventions (tell the user)

State these clearly to the user before starting:

- **Folder location**: under `project/XXX/ppt/images/` (same level as `index.html`)
- **Naming convention**: `{page-no}-{semantic}.{ext}`, e.g. `01-cover.jpg` / `03-figma.jpg` / `05-dashboard.png`
  - Zero-padded page number for easy sorting
  - Semantic name in English, short, specific, matching the content
- **Suggested specs**:
  - Single image ≥ 1600px wide (avoid blur on big screens)
  - JPG for photos/screenshots, PNG for transparent UI/charts
  - Keep total size under 10MB (affects page-flip smoothness)
- **How to replace**: keeping the **same name and overwriting** is most stable (no path changes needed in HTML); if a filename changes, remember to globally search `images/old-name` and change to the new name
- **What if there's no image**: align with the user — placeholder color blocks can be used to build the structure first, with images added later; but tell them that image-text layouts like 4/5/10 can't be visually validated without images

#### Screenshot requirements (must ask before starting)

Whenever the user mentions product screenshots, web screenshots, code screenshots, design mockups, dashboards, old PPT screenshots, or "help me polish this screenshot", first confirm:

- **Screenshot location**: which folder are the screenshot files in? Are they named already?
- **Purpose**: faithful display / screenshot beautification / screenshot redesign / UI context shot?
- **Target ratio**: which layout slot will it finally land in? Common `21:9` / `16:10` / `16:9` / `4:3` / `1:1`
- **Content requirements**: must all text, brand, and data be preserved? Is there sensitive info to mask?
- **Visual treatment**: need theme background, margins, center/corner alignment, or splitting into a long-screenshot panel?

Default strategy: first fit content to the template, then handle image ratios. For screenshots needing faithful display, first read `references/screenshot-framing.md`, prefer the built-in background assets in `assets/screenshot-backgrounds/` for procedural CleanShot X-style background canvas adaptation; only use GPT-M 2.0 screenshot redesign when the original screenshot is too messy, too long, too narrow, or needs conceptual expression.

#### Codex image generation (optional)

If the current runtime is **Codex**, after finishing the deck draft, proactively ask the user whether to generate images with GPT-M 2.0 and insert them into the PPT. Do not generate by default.

Recommended way to ask:

> Want me to generate a few images for this PPT? Can be humanistic documentary photos, magazine-style infographics, process/comparison/system relation diagrams, or screenshots redesigned into a unified magazine-style visual.

If the user confirms, ask which image type or style they want; if they have no preference, recommend the 1-3 images most worth generating based on page content.

If the user provides screenshots, first judge whether it's **screenshot beautification** or **screenshot redesign**:

- Beautification: read `references/screenshot-framing.md`, use the built-in theme backgrounds + procedural scaling/margins/alignment, avoid redrawing screenshot content as much as possible
- Redesign: read `references/image-prompts.md`, generate an image at the target ratio for the current layout slot, keeping language, theme color, and margins consistent

Follow these rules when generating images:

- Keep prompts short; only frame subject, purpose, style, and ratio — no long photography essays
- Image style must match the current deck style: Style A uses "Editorial Magazine x E-Ink"; Style B uses "Swiss International / Swiss Style"
- Text language inside infographics, charts, and screenshot redesigns must follow the user's language; Chinese deck uses Chinese, English deck uses English
- First look at `references/image-prompts.md` to choose image type and base prompt
- When handling the user's original screenshots, first look at `references/screenshot-framing.md`: prefer the built-in `assets/screenshot-backgrounds/` backgrounds and procedural CleanShot X-style screenshot adaptation; only use GPT-M 2.0 to redraw when information reconstruction is needed
- Image ratio must match the final slot: hero visual 16:9, text-left image-right 16:10 / 4:3, infographic 16:9 / 16:10, screenshot redesign 16:10, small mixed-layout images 3:2 / 3:4, grid images cropped to a uniform height
- Generated images go in `images/`, named per `{page-no}-{semantic}.{ext}`

### Step 2 · Copy the template

**Copy the template matching the style chosen in Step 1** to the target location (usually `project/XXX/ppt/index.html`), and create an `images/` folder at the same level ready to receive images.

```bash
mkdir -p "project/XXX/ppt/images"

# Style A · Editorial Magazine
cp "<SKILL_ROOT>/assets/template.html" "project/XXX/ppt/index.html"

# or Style B · Swiss International
cp "<SKILL_ROOT>/assets/template-swiss.html" "project/XXX/ppt/index.html"
```

Both `template*.html` files are **fully runnable** — CSS, WebGL shader, flip JS, presenter mode, audience screen sync, font/icon CDN are all preset; only the `<!-- SLIDES_HERE -->` placeholder and `SPEAKER_NOTES` await your filling.

**Note**: Style A and B **cannot be mixed**. Classes in layouts.md (like the `.h-hero` serif headline, `.display-zh`, etc.) are only defined in template.html; classes in layouts-swiss.md (like `.kpi-hero`, `.accent-block`, `.span-N`, `.dots`, etc.) are only defined in template-swiss.html. One deck uses exactly one set.

#### 2.1 · Required placeholders to fix (**easy to miss**)

Right after copying, fix the following placeholders, otherwise the browser tab shows awkward text like "[required] replace with PPT title":

| Location | Original | Change to |
|------|------|--------|
| `<title>` | `[required] replace with PPT title · Deck Title` | the actual deck title (e.g. `A new way of working · Luke Wroblewski`) |

The first thing after every template.html copy: grep for "[required]" to confirm everything is replaced.

#### 2.2 · Choose a theme palette (5 presets · no custom colors)

This skill **only allows picking one of the 5 carefully tuned presets**, and does not accept user custom hex values — wrong color pairings turn a deck ugly instantly; protecting the aesthetic matters more than granting freedom.

| # | Theme | Best for |
|---|------|------|
| 1 | 🖋 Ink Classic | General / commercial launch / default when unsure |
| 2 | 🌊 Indigo Porcelain | Tech / research / data / tech launch |
| 3 | 🌿 Forest Ink | Nature / sustainability / culture / non-fiction |
| 4 | 🍂 Kraft Paper | Nostalgia / humanities / literature / indie magazines |
| 5 | 🌙 Dune | Art / design / creative / gallery |

**How to**:
1. Recommend one based on the content topic, or just ask the user which to pick
2. Open `references/themes.md` and find the `:root` block of the matching theme
3. **Replace wholesale** (in the copied `assets/template.html`) the lines marked with the "theme colors" comment in the leading `:root{` block (`--ink` / `--ink-rgb` / `--paper` / `--paper-rgb` / `--paper-tint` / `--ink-tint`)
4. All other CSS goes through `var(--...)`; no other changes needed

**Hard rules**:
- One deck uses only one theme; don't switch colors mid-deck
- Don't accept arbitrary hex values from the user — politely decline and show the 5 presets to pick from
- Don't mix (e.g. ink from Ink Classic, paper from Dune) — it breaks the harmony

### Step 3 · Fill in content

#### 3.P · Generate speaker notes in sync (required for formal talks)

First read `references/presenter-mode.md`. Every `<section class="slide ...">` must have a unique and stable `data-slide-id`, then generate one `SPEAKER_NOTES` record in the same order. Store notes by page ID, not by array index or page number as the persistence key — otherwise notes the user edited in presenter view will drift across pages after reordering.

Division of duties:

- The slide only holds the conclusion, structure, and evidence the audience must see right now.
- `purpose` states this page's job within the whole narrative.
- `talk` adds background, examples, reasoning, and tone; it doesn't re-read the slide verbatim.
- `transition` explains why the next page follows immediately.
- `section` is filled only when the outline already gives sections or consecutive pages clearly belong to one section.
- `minutes` is the delivery plan; `autoAdvanceSeconds` is playback behavior — the two must stay separate, and the latter is filled in only when the user explicitly asks.
- `cue / interaction / delivery / advance / fallback / pronunciation` only record stage actions, interaction, expression, paging, backup, and pronunciation info that the outline or the user explicitly provided.

Facts without a supporting source cannot go into the notes; missing info that affects content correctness gets marked “to be filled” or asked of the user; optional presentation info that doesn't affect content is omitted outright.

#### 3.0 · Pre-flight: every class must be defined in the template's `<style>` (**most important**)

**This is the source of all generation problems**. The layouts skeleton uses many classes; if the template's `<style>` has no matching definition, the browser falls back to default styling — wrong headline fonts, cards squashed together, pipeline flattened to one line, images stacked at the page bottom.

**Class names are not interchangeable between the two styles** (reiterated):
- Style A template has `h-hero` (serif), `stat-card`, `grid-2-7-5`, `frame`, etc.
- Style B template has `h-hero` (sans-serif), `kpi-hero`, `accent-block`, `span-N`, `dots`, `grid-12`, etc.
- The same class name renders **completely differently** across the two templates (e.g. Style A's `h-hero` is Noto Serif SC serif; Style B's `h-hero` is Inter sans-serif)

**Before writing any slide code:**

1. **First Read the template currently in use** (at least up to the end of the `<style>` block):
   - Style A → `assets/template.html`
   - Style B → `assets/template-swiss.html`
2. **Check against the corresponding layouts file's Pre-flight list** to confirm every class you use is defined in `<style>`
3. If a class is missing: **add it to the template's `<style>`**, don't inline-override it in every slide
4. **The template is the single source of class names** — don't invent new ones; for customization use inline `style="..."`

**Style A classes commonly missed**:
`h-hero` / `h-xl` / `h-sub` / `h-md` / `lead` / `kicker` / `meta-row` / `stat-card` / `stat-label` / `stat-nb` / `stat-unit` / `stat-note` / `pipeline-section` / `pipeline-label` / `pipeline` / `step` / `step-nb` / `step-title` / `step-desc` / `grid-2-7-5` / `grid-2-6-6` / `grid-2-8-4` / `grid-3-3` / `grid-6` / `grid-3` / `grid-4` / `frame` / `frame-img` / `img-cap` / `callout` / `callout-src` / `chrome` / `foot`

**Style B classes commonly missed** (after the 2026-05 refactor):
- Canvas: `canvas-card` / `chrome-min`
- Typography: `h-hero` (sans-serif 7.4vw weight 200) / `h-statement` (9.6vw) / `h-xl` / `h-md` / `t-cat` (SemiBold 600 small label) / `t-meta` (mono uppercase) / `lead` / `num-mega` / `mono`
- Cards (four mutually exclusive types): `card-ink` / `card-accent` / `card-fill` / `card-outlined`
- Grid: `grid-12` / `grid-2-9` / `grid-2-9-5` / `span-N`
- Timeline: `timeline-v` + `tl-node` + `tl-axis` + `dot` / `timeline-h` + `tl-h-node` + `tl-h-axis`
- Charts: `kpi-tower-row` + `bar-tower` / `h-bar-chart` + `bar-row` + `bar-fill` / `spec-bars` + `bar-vert`
- Decoration: `dot-mat` (SVG mask solid dots) / `ring-mat` (stroked circles) / `cross-mat` (× grid) / `hr-hairline`
- Layout-specific: `cover-split` / `closing-split` / `duo-compare` + `vrule` / `manifesto-top` + `ink-banner-full` / `three-forces` / `loop-diagram` / `matrix-fill` + `matrix-cell` / `brief-grid` + `brief-card` / `system-diagram` / `why-now-grid` / `four-cards` / `stacked-ledger` + `ledger-row` / `tech-spec` / `image-hero` + `hero-img-wrap` + `hero-overlay-block` + `hero-stats`
- Image mixing: `frame-img` / `fit-contain` / `r-21x9` / `r-16x9` / `r-16x10` / `h-22` / `h-26` / `swiss-img-split` / `swiss-img-grid` / `swiss-img-caption` / `swiss-keyline` / `swiss-lined`
- Spacing tokens: `--sp-3`...`--sp-13` (8/12/16/24/32/40/48/64/80/96/160 px)

#### 3.0.5 · Plan the theme rhythm (**as important as the class pre-flight**)

**Before picking layouts**, you must first list the theme class of every page (`hero dark` / `hero light` / `light` / `dark`) and write it into a document or draft to align on. Detailed rules are in the "Theme rhythm planning" section at the top of `references/layouts.md`.

**Mandatory rules**:

- Every page section must carry one of `light` / `dark` / `hero light` / `hero dark`; don't write only `hero`
- 3+ consecutive pages of the same theme = visual fatigue, not allowed
- Decks 8+ pages must have ≥1 `hero dark` + ≥1 `hero light`
- A whole deck can't be all `light` content pages; there must be `dark` content pages to create breathing room
- Insert 1 hero page per 3-4 pages (cover / chapter divider / problem / big quote)

**Post-generation self-check**: `grep 'class="slide' index.html` lists all themes; confirm the rhythm is reasonable by eye before delivering.

#### 3.1 · Pick layouts

**Don't write slides from scratch**. Open the matching layouts file — it has 10 ready-made layout skeletons, each a complete copy-pasteable `<section>` block.

**Style A** → `references/layouts.md`:

| Layout | Purpose |
|---|---|
| 1. Opening cover | Page 1 |
| 2. Chapter divider | Each act opening |
| 3. Data hero | Throw hard data |
| 4. Text-left image-right (Quote + Image) | Identity contrast / story |
| 5. Image grid | Multi-image comparison / screenshot evidence |
| 6. Two-column pipeline | Workflow |
| 7. Suspense close / question page | End of act / closing |
| 8. Big Quote | Serif golden line / takeaway |
| 9. Side-by-side comparison (Before / After) | Old mode vs new mode |
| 10. Lead Image + Side Text | Info-dense image-text pages |

**Style B** → first read `references/swiss-layout-lock.md`, then read `references/layouts-swiss.md`.

Swiss theme defaults into **Swiss locked mode**:

- Content pages may only use the 22 layouts `S01-S22` registered from the original reference PPT; new cover/closing pages may only use the Skill-provided `SWISS-COVER-ASCII` / `SWISS-CLOSING-ASCII`.
- Every `<section class="slide">` must write `data-layout="Sxx"`. No `data-layout` = treated as an unregistered layout.
- Inventing `P23/P24`, `Swiss Image Split`, `Evidence Grid`, or other content structures beyond the original 22P is not allowed, unless the user explicitly requests experimental layouts.
- The top Chinese title defaults to left-aligned on the top-left content axis. Don't push the subtitle into the left column and the big title into the right column, creating visual centering; only the original statement/split layouts allow strong centered narrative.
- SVG is only for geometric shapes. No text labels inside SVG — all labels use HTML grids/cards/captions.
- Geography/history/city-route/place-relation pages use `S08 + Swiss Map Component`: first read `references/swiss-map-component.md`, keeping `data-layout="S08"`.

The original 22 content layouts:

| Layout | Purpose |
|---|---|
| S01 Index Cover | Original index cover |
| S02 Vertical Timeline + KPI | Evolution contrast / era change |
| S03 Split Statement | Core thesis / split screen |
| S04 Six Cells | 6 concept definitions |
| S05 Three Layers | Three-layer architecture |
| S06 KPI Tower | 4 data visualizations with height contrast |
| S07 H-Bar Chart | 5-10 item ranking comparison |
| S08 Duo Compare | Before/After contrast |
| S09 Dot Matrix Statement | Big quote / statement |
| S10 Split Closing | Closing page |
| S11 Horizontal Timeline | 4-7 step process |
| S12 Manifesto + Ink Banner | Stage conclusion |
| S13 Three Forces | 3 equal-weight concepts deepened |
| S14 Loop Form | Self-learning loop / automation |
| S15 Matrix + Hero Stat | 8-12 item matrix + headline number |
| S16 Multi-card Brief | 6-item news brief cards |
| S17 System Diagram | Three-layer architecture / ecosystem map |
| S18 Why Now | Three points + data support |
| S19 Four Cards | 4 equal-weight features |
| S20 Stacked KPI Ledger | Vertical ledger data |
| S21 Tech Spec Sheet | Product specs / benchmark |
| S22 Image Hero | 21:9 hero image + title block + three-column KPI |

**Registered extension**: `S08 + Swiss Map Component` is for places, people's residences, routes, and city relations. It is not a new layout; it's the MapLibre map component in S08's right-hand slot; implement it per `references/swiss-map-component.md`'s points, connections, cards, and top-right zoom/drag controls.

Pick the layout, paste it, change the copy and image paths. **Always complete the 3.0 pre-flight first**.

**Style B layout diversity hard rules**:
- A 7-8 page deck must use at least **6 different S-numbered layouts**; 10+ pages at least 8 different layouts.
- If the user says "test the template / see the effect / want more variety", you must cover: one cover, one closing, at least 1 comparison or timeline (S08/S11/S02), at least 1 structure diagram (S14/S17/S15), at least 1 image layout (S22 or image grid built from S15/S16).
- No 3 consecutive pages with the same body structure, e.g. three `head + grid + card` pages in a row.
- Image pages can't invent lazy new structures. For 2-3 images, rebuild the original S15/S16 grid skeleton into an image grid; a single large image uses S22.
- Before writing HTML, draft a `page → data-layout → reason chosen → image slot` list; before delivery run `node <SKILL_ROOT>/scripts/validate-swiss-deck.mjs index.html`. The validator does static structure checks first; if Playwright is resolvable in the environment, it also measures real-rendered visible bounds, bottom whitespace, nav-safe line, and title spacing.

#### 3.2 · Image ratio rules

Always use **standard ratios**, never the source image's odd ratio (e.g. `2592/1798`):

| Scene | Recommended ratio |
|------|---------|
| S22 top hero image | **21:9**; keep the photo's key subject in the center safe area |
| S15/S16 multi-image grid | All 21:9 or all 16:10, don't mix |
| Left-text right-image main image (Style A) | 16:10 or 4:3 + `max-height:56vh` |
| Image grid (Style A) | **Fixed `height:26vh`**, no aspect-ratio |
| Left small image + right text | 1:1 or 3:2 |
| Fullscreen hero visual | 16:9 + `max-height:64vh` |
| Image-text mixed small illustration | 3:2 or 3:4 |

**Don't default images to `align-self:end`** — they'll slide to the page bottom and easily collide with the pager component. Use the grid container + `align-items:start` (preset in the template) to pin images to the top; if you truly need bottom alignment of image and text, cap the image height first, then use the template's existing safe-area classes `.nav-safe-bottom` / `.nav-safe-bottom-tight`, and never let the lowest point touch the pager component.

**Style B Swiss extra rules**:
- Single large image uses S22; multi-image tests rebuild the original S15/S16 card grid, don't use unregistered P23/P24
- Before generating images write `data-image-slot`: e.g. `s22-hero-21x9` / `s15-grid-21x9` / `s16-brief-21x9`
- S22 images default to 21:9; the prompt must include `subject centered in the safe middle area`; the photo container uses `object-position:center 35%`, not `top center`
- Image containers must be right-angle, no shadow, no rounded corners; default background is white `var(--paper)`, don't wrap a white infographic in a gray background
- White-background GPT infographics/flowcharts/UI images default to no outer border; don't casually add `.swiss-keyline`; when emphasis is needed use only the `.swiss-lined` top accent line
- Use `.fit-contain` only for the user's original screenshots or text-dense images; if already regenerated to S15/S16 slots, use `.frame-img.r-21x9` / `.frame-img.r-16x10` to fill the container, don't fix `height:18vh` and shrink the image
- A group of multiple images must share the same slot, ratio, and height; don't mix
- GPT-M 2.0 generated images follow `image-prompts.md`'s "Style B: Swiss International image rules"
- The lowest point of any image, caption, timeline label, or footnote must not enter the bottom pager area; when flush to bottom is needed use `.nav-safe-bottom` / `.nav-safe-bottom-tight`, don't hand-write `bottom:2vh`

#### 3.2.0 · Image-text mixing decision tree (migrated from the social card rules)

First decide the image's role on the page, then choose the container, ratio, and crop:

- **Evidence screenshot / UI / code / dashboard**: fidelity first; first read `references/screenshot-framing.md`; key text and data must not be cropped. When a uniform ratio is needed, prefer procedural background canvas + `.fit-contain`, don't crop UI content to fill.
- **Infographic / illustration already regenerated to a slot**: fill the target slot, e.g. S22 uses `21:9`, S15/S16 use uniform `21:9` or `16:10`; don't shrink the image into a small sticker with a short height.
- **Photo / product image / person image**: use standard ratio + explicit `object-position`; the subject, face, product, and key evidence must not be covered by titles, captions, or crop.
- **Text-over-image / fullscreen hero visual**: do a quiet-zone check first, the image must have at least ~30% low-detail area to carry text; if it fails, swap the image, change the crop, or switch to an image-text split column. Add a local tint only when necessary, don't slap a full-page black/white overlay.
- **Multi-image group**: same group shares ratio, height, container treatment, and caption density; don't have one `contain` and another `cover`.
- **A generated image is material, not a whole slide**: the image itself must not carry page headers, footers, page numbers, logos, main titles, decorative borders, or bylines, to avoid duplication with the deck chrome.
- **Image-text breathing**: titles, images, captions, and body must each keep spacing; after generation use the validator's `M1/M2` checks for visible bounds, bottom whitespace, nav-safe line, and title spacing.

#### 3.2.1 · Chinese headline font-size tiers (required for Style B)

Chinese square characters have large visual area; don't directly reuse the English hero's 6.8-7vw. Tier before writing Chinese headlines:

| Headline shape | Recommended font-size |
|---|---|
| 1 line, ≤ 8 Chinese characters | `min(6.4vw,11.2vh)` |
| 2 lines, each ≤ 8 Chinese characters | `min(5.8vw,10.2vh)` |
| 2 lines, any line with 9-12 Chinese characters | `min(5.2vw,9.2vh)` |
| 3 lines or longer | Prefer rewriting the headline; if unavoidable use `min(4.6vw,8.2vh)` |

If the headline crowds the image or body area, first compress the headline copy, then lower font-size; don't force it by shoving the content below to the bottom.

#### 3.2.2 · Swiss-style minimum font sizes and weight ladder (required for Style B)

When Swiss style is used for on-screen presentation, small text must not follow web-commentary 10-12px. Default to the following floor:

| Text type | Minimum font-size |
|---|---|
| Body paragraph / main description | `18px` |
| Card description / list / timeline description / caption / figure note | `16px` |
| meta / kicker / mono label / chart label | `14px` |

If the content doesn't fit, trim the copy, split into two pages, or switch to a more suitable Sxx layout — don't squeeze font-size down to 10/11/12/13px. Especially for Chinese decks, don't shrink `body-sm`, caption, or timeline labels to stuff in three lines of explanation.

**Font-size and weight ladder (Swiss core)** — "bigger is lighter, smaller is bolder" isn't a vibe description; it's a concrete mapping:

| Font-size range | Recommended weight | Typical use |
|---|---|---|
| ≥ 8vw | 200 (ExtraLight) | Cover big type, mega KPI, h-statement |
| 4-7.9vw | 200-300 | Section titles (h-xl/h-xl-zh), big numbers |
| 1.8-3.9vw | 300-400 | Mid-size titles, takeaway titles (≈1.8vw), medium numbers |
| 1-1.7vw / 16-20px | 400-500 | Body paragraph, card description, supporting text |
| 13-15px (small text) | 500-600 | meta, kicker, corner marks, chart labels, caption emphasis |

**Hard rules:**
- Within a page, a smaller element's weight must be ≥ a larger element's weight (16px body at 300 plus a 1.8vw title at 500 is not allowed)
- Small text around 16px refuses weight 300 (too thin to read); minimum 400, recommended 500
- Emphasized words inside cover/IKB inverted big titles use `italic + weight 300`, not accent color (blue on blue is invisible)

Component details (fonts, colors, grid, icons, callout, stat-card, etc.) are in `references/components.md`.

### Step 4 · Self-check against the checklist

After generating, you must open `references/checklist.md` and go through it item by item. It summarizes **every pitfall hit during real iteration**; all P0-level issues (emoji, image overflow, title line breaks, font division of labor) must pass.

Every formal-talk deck first runs the presenter-mode validation; if the user gave a target duration, also pass the minutes:

```bash
node <SKILL_ROOT>/scripts/validate-presenter-mode.mjs path/to/index.html
node <SKILL_ROOT>/scripts/validate-presenter-mode.mjs path/to/index.html --target-minutes 30
node <SKILL_ROOT>/scripts/check-presenter-runtime-sync.mjs
```

The first script blocks missing/duplicate page IDs, notes misaligned with pages, required-field or optional-field type errors, a full timing plan exceeding the 90% budget, and missing timing/rehearsal/auto-advance/annotation/pre-show-check/audience-screen-recovery controls. The second script blocks CSS/JS drift in the presenter mode between the two templates.

#### 4.0.1 · Measure before changing: overflow / whitespace / title gap

When a page overflows or looks huge-empty, don't heavily edit on feel first. First run:

```bash
node <SKILL_ROOT>/scripts/validate-swiss-deck.mjs path/to/index.html
```

Look at the measurement items in the validator output:

- `M1 DOM/visual overflow`: exactly how many px overflow, plus the lowest/highest problem elements
- `M1 bottom whitespace`: how many px of bottom whitespace, and what share of the active content height
- `M1 nav-safe`: whether the lowest content enters the bottom pager safe line
- `M2 title gap`: the actual distance between the title and the next content block

Fix ladder:

- `1-40px` over: only fine-tune — move the content group up or tighten one gap/padding; don't delete content.
- `40-90px` over: locally compress spacing or module height; still prefer keeping content.
- `90-160px` over: slightly compress the title or one body paragraph; split the page if necessary.
- `160px+` over: only then consider changing layouts, merging modules, or deleting content.

Run the validator again after fixing. If `M1 bottom whitespace` grew, you over-fixed; restore some spacing, enlarge the last block, or nudge the content group back down.

#### 4.0 · Not just code: open the page for a visual check

Code only proves class names and structure exist, not that the layout feels good. After generating, you must open the page and look at every slide:

1. Open the current template (golden source snapshot) or generated page AND the test PPT being iterated, page by page side by side.
2. Wait for entrance animations to settle before screenshoting (about 1-2 seconds); don't mistake a mid-animation state for a layout issue.
3. Look at visuals first: headline weight, title-to-content spacing, whether images align with body, whether images/captions touch the bottom pager component.
4. Then look at the code: confirm the chosen layout matches the content shape — no data-only layout speaking for concepts, no optional components stacked as decoration.
5. When comparing against the original reference template, judge by actual page usage, not just the CSS helper definitions; the original pages' big type is mostly 200/300, don't be misled by raw CSS values like 700/800/900.
6. If a page feels off, first decide whether it's a wrong layout choice, a missing required component, over-used optional components, or a spacing/safe-area problem; don't rescue with added margins.

#### Style A · Editorial Magazine must-checks

1. **Big headlines must be serif** — if it renders non-serif, 99% chance Step 3.0 pre-flight was skipped and the `h-hero` class is missing from template.html
2. **Image grids use only `height:Nvh`, not `aspect-ratio`** (will break/overflow)
3. **Images must not pile up at the page bottom** — don't use `align-self:end`; use grid + `align-items:start` (see Step 3.2)
4. **Images use only standard ratios** (16:10 / 4:3 / 3:2 / 1:1 / 16:9), don't copy the source image's odd ratio
5. **Chinese headlines ≤ 5 characters and `nowrap`** (avoid one-character-per-line)
6. **Use Lucide, not emoji**
7. **Headlines serif, body sans-serif, metadata monospace**

#### Style B · Swiss International must-checks

1. **Sans-serif the whole way** — any serif appearing is wrong (check `font-family` doesn't use a `--serif` class variable)
2. **Only one accent color** — a deck can't show IKB blue + lemon yellow + safety orange and other highlight colors at once
3. **No gradients / shadows / rounded corners** — all color blocks right-angle solid; any `box-shadow` / `linear-gradient` / `border-radius` > 0 must be cut (the rule hairline excepted)
4. **Extreme type-scale contrast** — main title to body ratio ≥ 8:1
5. **Big type must be double-constrained** — `font-size:min(Xvw, Yvh)`; using only vw overflows standard 16:9 screens (lesson from P15/P20/P22)
6. **Big type weight 200** (ExtraLight) — the bigger the type, the lighter; that's the soul of Swiss; **600/700/800 big type forbidden**
7. **Card fill types are mutually exclusive** — `card-ink` / `card-accent` / `card-fill` / `card-outlined` can't be mixed (no "blue fill + blue outline", "gray fill + outline", etc.)
8. **Multiple cards side by side use one style** — 3-12 cards use the same class (prefer `card-fill` gray); highlight only one with `card-accent`, and **only one allowed**
9. **Right angles all the way** — no `border-radius` at all; decoration uses 8×8 right-angle small squares, **not** 9px circular dots
10. **Icons use lucide, don't draw your own SVG** — `<i data-lucide="name"></i>` + `lucide.createIcons()`, pick angular styles (avoid round/chunky)
11. **Timeline alignment** — axis column fixed 12px + dot absolutely positioned, **not** grid `justify-self` (will misalign with the dashed line)
12. **Section-level title to content gap ≥ 9vh** — avoid crowding (lessons from P15/P16)
13. **One semantic motion recipe per page** — not a uniform fade-up; numbers scale-pop, bars scaleY pull up, SVG strokes draw in, nodes light in sequence, etc.; **forbidden** to use the same generic recipe on all pages
14. **playSlide entry reveals containers** — `[data-anim]` containers are forced `opacity:1` first, then overridden inside the recipe with motion `{opacity:[0,1]}`; otherwise some pages appear "invisible"
15. **ESC index page visibility** — cloned slides need a CSS override so `[data-anim]` is `opacity:1` in the thumbnails
16. **Helvetica/Inter fallback for Chinese** — Windows users don't have "PingFang"; must fall back to `"Microsoft YaHei UI", "Noto Sans SC"`
17. **Font weight system**: big type 200 / body 300 / `t-cat` SemiBold 600 / `t-meta` mono uppercase
18. **Keep the low-power shortcut** — the bottom-right must show `B static`; pressing `B` toggles `body.low-power`, stopping WebGL/ASCII canvas RAF and Motion entrance animations
19. **Decorative elements strictly inside the grid** — bars matrices, dot matrices, ring-mat can't hug the edge or overflow the page
20. **Bottom content reserves nav space** — nav sits at ~97vh, content should end before 93vh (lesson from P22 KPI big-type overflow)
21. **Image containers right-angle, no shadow** — `.frame-img` gets no `border-radius` / `box-shadow`; borders only use hairline
22. **S15/S16/S22 image groups consistent** — a group of images shares uniform ratio, height, margins, line weight; infographic/UI images add `.fit-contain`
23. **Component roles must be correct** — S15/S16 image grids need caption info anchors; S22's KPI/notes are required; data-only layouts must have real data, not copy forced in
24. **Generic vs specialized layouts** — S03/S08/S11/S19 are more generic; S06/S07/S20/S21/S22 are data/case-specific; S14/S15/S17 are structure-specific

### Step 5 · Local preview

Just open `index.html` in the browser. On macOS:

```bash
open "project/XXX/ppt/index.html"
```

No local server needed. Images use relative paths `images/xxx.png`.

During preview you can't only look at the normal page. Press `P` for presenter mode, allow the browser to open the audience window, and actually test at least once: forward/back paging, embedded grid page picker and return to preview, first/last page, restart from last page, timer start/pause/reset, rehearsal records, auto-advance pause/resume, laser pointer, area select, black/white screen, freeze, settings panels, pre-show check, note saving, state change after closing the audience window, and whether "reopen audience screen" restores the current page.

### Step 6 · Iterate

Modify based on user feedback — the template's CSS is already highly parameterized, so 90% of adjustments are inline style changes (font-size `font-size:Xvw` / height `height:Yvh` / gap `gap:Zvh`).

---

## Resource Files Overview

```
guizang-ppt-skill/
├── SKILL.md                  ← you are reading this
├── assets/
│   ├── template.html         ← Style A · Editorial Magazine template (seed file)
│   ├── template-swiss.html   ← Style B · Swiss International template (seed file)
│   ├── screenshot-backgrounds/ ← built-in screenshot-beautification backgrounds (WebP): style-A 5 sets / style-B 4 sets
│   └── motion.min.js         ← local copy of Motion One (offline fallback, ~64KB, shared)
├── scripts/
│   ├── validate-swiss-deck.mjs ← Style B static validation: registered layouts, image slots, SVG text, title alignment
│   └── validate-presenter-mode.mjs ← shared by both styles: page IDs, speaker notes, timing, presenter runtime validation
└── references/
    ├── components.md         ← component manual (fonts, colors, grid, icons, callout, stat, pipeline, motion... Style A applies)
    ├── layouts.md            ← Style A · 10 page layout skeletons (directly pasteable, with motion markers)
    ├── swiss-layout-lock.md  ← Style B · original 22P layout lock; content pages must be registered here
    ├── layouts-swiss.md      ← Style B · original 22P skeleton docs + a few clearly marked experimental areas
    ├── swiss-map-component.md ← Style B · S08 map extension component (MapLibre points/lines/cards/controls)
    ├── themes.md             ← Style A · 5 theme color presets (pick only, no custom)
    ├── themes-swiss.md       ← Style B · 4 Swiss theme color presets (IKB / Lemon Yellow / Lemon Green / Safety Orange)
    ├── image-prompts.md      ← GPT-M 2.0 image types, ratios, and base prompts
    ├── screenshot-framing.md ← CleanShot X-style screenshot adaptation semantics + built-in background asset mapping
    ├── presenter-mode.md     ← presenter UI, AI note structure, audience screen sync & recovery contract
    └── checklist.md          ← quality checklist (P0/P1/P2/P3 tiers)
```

**Suggested load order**:
1. First read all of `SKILL.md` (this file) to understand the whole
2. Step 1 clarification's **first question** settles Style A or B, then:
   - Style A: read `themes.md` to help the user pick a theme palette
   - Style B: read `themes-swiss.md` to help the user pick a theme palette
3. **Before starting, Read the matching template's `<style>` block** — it's the single source of class names; missing classes break whole-page styles
   - Style A → `assets/template.html`
   - Style B → `assets/template-swiss.html`
4. Read the matching layouts file to pick layouts:
   - Style A → `layouts.md` (top has the Pre-flight class list, theme rhythm planning, motion recipe decision tree)
   - Style B → **first read `swiss-layout-lock.md`**, then `layouts-swiss.md`; content pages must be chosen from S01-S22, every page writes `data-layout`
5. If Style B needs place, route, residence, or city-relation maps, read `swiss-map-component.md`
6. If generating images in Codex, read `image-prompts.md` to pick type, ratio, base prompt; for user's original screenshots first read `screenshot-framing.md`, prefer the built-in `assets/screenshot-backgrounds/` assets
7. For detail adjustments read `components.md` for components (includes the Motion system chapter, mainly serving Style A; Style B component details are in the `layouts-swiss.md` appendix)
8. For formal talks read `presenter-mode.md` first, generate stable page IDs and `SPEAKER_NOTES`
9. After generating first run `validate-presenter-mode.mjs`; Style B then also runs `validate-swiss-deck.mjs`; finally read `checklist.md` for self-check

**Motion**: the template already inlines Motion One loading and recipe logic in the bottom module script. You don't need to change JS — just add `data-anim` / `data-animate` in the HTML per the `layouts.md` / `layouts-swiss.md` skeletons. Offline presentation relies on `assets/motion.min.js`; without network it degrades to "no animation but readable content". Style B templates must keep the `B` key low-power mode: after switching, stop WebGL/ASCII canvas RAF, cancel running Web Animations, and reveal the current page's content directly to its static final state.

## Core Design Principles (philosophy)

### Style A · Editorial Magazine (summary of 5 iterations)

> Violate any one of these and the magazine feel collapses.

1. **Restraint beats flashiness** — WebGL backgrounds only show through on hero pages; regular pages barely show them
2. **Structure beats decoration** — no shadows, no floating cards, no padding boxes; all information rides on **large type + font contrast + grid whitespace**
3. **Content hierarchy is defined by type size AND font together** — largest serif = main title, mid serif = subtitle, large sans = lead, small sans = body, monospace = metadata
4. **Images are first-class citizens** — crop images only at the bottom, keeping top and sides intact; grids use fixed `height:Nvh`, don't stretch with `aspect-ratio`
5. **Rhythm runs on hero pages** — hero and non-hero must alternate so the eyes don't tire
6. **Keep terms consistent** — Skills is Skills; don't produce a Chinese-English hybrid translation

### Style B · Swiss International

> Violate any one of these and the look drops instantly from Swiss to PowerPoint.

1. **One anchor color** — one deck uses one accent, no multi-color highlight collage
2. **Extreme type-scale contrast** — title to body ratio ≥ 8:1; KPI must be a "Data Hero" (18-22% of screen width)
3. **Sans-serif only** — Inter / Helvetica / Noto Sans SC; any serif is wrong
4. **Right-angle solid colors** — no gradients / shadows / rounded corners (the rule hairline excepted)
5. **Grid above all** — every element snaps to the 12-col grid; left-aligned + generous whitespace for asymmetrical aesthetics
6. **Hairline is the scalpel** — a 1px hairline divider is enough; don't thicken it, don't shadow it
7. **Dot-matrix decoration only on hero pages** — content pages stay clean solid backgrounds

## Reference Works

This skill's two styles each reference:

**Style A · Editorial Magazine**:
- Guizang's "One-Person Company: An Organization Folded by AI" talk (2026-04-22, 27 pages)
- *Monocle* magazine's layout
- The demo from YC president Garry Tan's "Thin Harness, Fat Skills" post

**Style B · Swiss International**:
- Massimo Vignelli's NYC Subway / Unimark system
- The typographic design language of *Helvetica Forever*
- Josef Müller-Brockmann's classic grid system works
- Contemporary design: Acne Studios / Off-White / IKEA / Beck Design

You can use these as style anchors.
