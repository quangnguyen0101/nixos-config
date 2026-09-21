# Layouts · Style B Swiss International Style

22 registered original layouts · strictly modular grid · each layout documents its purpose, skeleton, key classes, and dedicated motion.

> ⚠️ These layouts are **not interchangeable** with Style A (digital magazine / e-ink). Class names are the same but semantics differ (e.g. `h-hero` is serif in Style A, but a weight-200 ultra-thin sans in Style B). A deck must pick exactly one style.

---

## Swiss locked mode (must read first)

The golden source of this theme is the repo's `assets/template-swiss.html` (derived from the author's local original reference PPT; the original file is not distributed with the repo, and the S01-S22 registered in `swiss-layout-lock.md` are its layout snapshot).

When generating content pages, don't treat Swiss as a "freely mixed style pack". By default you may only use the `S01-S22` registered in `references/swiss-layout-lock.md`. Every slide must write `data-layout="Sxx"` on its `<section>`.

**Key constraints**:

- The top Chinese title is left-aligned by default on the top-left content axis; don't center the title.
- It is not allowed to invent body structures beyond the original 22P. P23/P24 at the end of this document are a historical experiment zone, disabled by default.
- For a single large image use `S22 Image Hero`; for multiple images adapt the original `S15/S16` matrix / patch-sheet skeletons into an image grid.
- For place, route, residence, city-relationship pages use `S08 + Swiss Map Component`; this is still an extension of S08's right-hand slot, not a new body page. Read `swiss-map-component.md` first.
- SVG draws geometry only, no visible text. Labels go in the HTML.
- After generating, run `node scripts/validate-swiss-deck.mjs index.html`.

---

## Design language baseline

**Colors** (`--accent` is decided by the theme, see `themes-swiss.md`)
- `--paper` paper-white #ffffff (main background)
- `--ink` ink-black #0a0a0a (main text / ink inverted blocks)
- `--accent` single-hue anchor (IKB blue default / yellow / green / orange, four sets)
- `--text-primary / secondary / helper` three-level text grays
- `--border-subtle` 1px hairline #e0e0e0

**Typography**
- Fonts: `var(--sans)` Inter / Helvetica Neue + `var(--mono)` JetBrains Mono
- Weights: **200 (ExtraLight) big type** / **300 (Light) body** / **600 (SemiBold) t-cat small labels**
- Big titles follow the original PPT's actual page usage: main titles `font-weight:200`, emphasis words/numbers `font-weight:300`; don't embolden Swiss big titles just because an old CSS helper still carries 800/900
- Big type tightens: `letter-spacing:-.04em` / `line-height:.9`
- Mono numbers: `font-feature-settings:"tnum","ss01"`

**Chinese big-title size tiers**
Chinese square glyphs carry more visual weight than English, so don't directly reuse the English page's `6.8vw-7vw`. Before generating, step the size down by Chinese title length:

| Chinese title shape | Recommended size |
|---|---|
| 1 line, ≤ 8 Chinese characters | `min(6.4vw,11.2vh)` |
| 2 lines, each ≤ 8 Chinese characters | `min(5.8vw,10.2vh)` |
| 2 lines, any line 9-12 Chinese characters | `min(5.2vw,9.2vh)` |
| 3 lines or longer title | Rewrite the title; if truly impossible use `min(4.6vw,8.2vh)` |

Rule: shorten the Chinese title first, then lower the size; don't let the title crowd out the image/text area below. English/number heroes can be bigger; Chinese methodology pages must be more restrained.

**Minimum presentation size and the weight ladder**
Swiss is not a web spec page — no 10-12px annotation text when projected. Default floors:

| Text type | Minimum size |
|---|---|
| Body paragraphs / main notes | `18px` |
| Card descriptions / lists / timeline notes / captions / figure notes | `16px` |
| meta / kicker / mono label / chart labels | `14px` |

When there's too much content, trim copy, split pages, or switch Sxx layouts first; shrinking small text to fit is forbidden. Figure notes, timeline notes, KPI annotations, and bottom notes must especially hold this floor.

**Size-to-weight ladder (Swiss core)** — "bigger is thinner, smaller is heavier" is not a feeling, it's a rule:

| Size range | Recommended weight | Typical use |
|---|---|---|
| ≥ 8vw | 200 (ExtraLight) | cover big type, mega KPI, h-statement |
| 4-7.9vw | 200-300 | section titles (h-xl/h-xl-zh), big indexes |
| 1.8-3.9vw | 300-400 | mid titles, takeaway titles (≈1.8vw), mid numbers |
| 1-1.7vw / 16-20px | 400-500 | body paragraphs, card descriptions, notes |
| 13-15px (small) | 500-600 | meta, kicker, corner badges, chart labels, caption emphasis |

**Hard rules:**
- Within one page, a smaller element's weight must be ≥ a larger element's weight (16px body at 300 while a 1.8vw title sits at 500 is not allowed)
- 16px-ish small text refuses weight 300 (too thin to read); floor 400, recommend 500
- Emphasis words inside a cover/IKB inverted big title use `italic + weight 300`, not the accent color (blue on blue is invisible)

**Grid** (IBM Carbon 2x Grid adapted)
- 16-column grid: `grid-template-columns:repeat(16,1fr)` + `gap:16px`
- Spacing tokens: `--sp-3` 8 / `--sp-4` 12 / `--sp-5` 16 / `--sp-6` 24 / `--sp-7` 32 / `--sp-8` 40 / `--sp-9` 48 / `--sp-10` 64 / `--sp-11` 80 / `--sp-12` 96 / `--sp-13` 160

**Canvas**
- `.canvas-card`: `100vw × 100vh`, right angles no radius, padding `5.6vh 5vw 4.4vh`
- `body{background:var(--paper)}` — no WebGL background
- Keep the bottom-right `B static` shortcut. Low-power mode uses `body.low-power`, stops the WebGL/ASCII canvas RAF and Motion entrance animations, and keeps the user's choice across refreshes via `localStorage`.

---

### P0 alignment laws (run these 4 before generating every page; violating one = the page is trash)

**1. Don't stack horizontal padding twice** ⚠️ most commonly hit
`.canvas-card` already carries `padding:5.6vh 5vw 4.4vh`.
chrome-min (header), body content, and the bottom footnote are all children of canvas-card, **sharing the same 5vw edge line**.
If you write `padding:5vh 5vw 4vh` on the body layer again, the horizontal becomes `5vw + 5vw = 10vw`, the body indents a whole ring more than chrome-min, and left/right misalign.

```html
<!-- ❌ Wrong: body indents 5vw more -->
<div class="canvas-card">
  <div class="chrome-min">...</div>
  <div style="flex:1;padding:5vh 5vw 4vh;...">body content</div>
</div>

<!-- ✅ Right: body padding 0, vertical spacing via grid gap only -->
<div class="canvas-card">
  <div class="chrome-min">...</div>
  <div style="flex:1;padding:0;display:grid;grid-template-rows:auto 1fr auto;gap:3vh">body content</div>
</div>
```

Exception: `.slide.split .canvas-card{padding:0}` is already overridden in CSS; in split mode the two `.half` control their own padding (commonly `5.6vh 3.6vw 4.4vh`), which does not conflict with this law.

**2. The kicker must sit "above" the big title, not pressed side-by-side**
The small label (`.t-meta` / `.t-cat`) subordinates the big title, so the layout must be **stacked vertically**.

```html
<!-- ❌ Wrong: auto 1fr squeezes kicker and big title into two columns -->
<div data-anim="head" style="display:grid;grid-template-columns:auto 1fr;gap:3vw;align-items:end">
  <div class="t-meta">METHODOLOGY · 03</div>
  <h2 class="h-xl-zh">Why N+1</h2>
</div>

<!-- ✅ Right: flex column stacks them -->
<div data-anim="head" style="display:flex;flex-direction:column;gap:1.4vh">
  <div class="t-meta">METHODOLOGY · 03</div>
  <h2 class="h-xl-zh">Why N+1</h2>
</div>
```

**3. Dual-constraint height cap: in `min(Xvw, Yvh)`, Y ≥ X × 1.6**
On a standard 16:9 screen 1vw : 1vh ≈ 1.78; if Y is too strict (e.g. `min(7vw, 10vh)`), the big type gets clipped by the height cap to 10vh, no longer driven by 7vw, and looks overall smaller.
Experience values:

| Use | Recommended |
|---|---|
| h-hero mega statement | `min(11.6vw, 19vh)` |
| h-xl section title | `min(7vw, 12vh)` ~ `min(7.4vw, 13vh)` |
| big number KPI | `min(8.4vw, 14vh)` |
| mid numbers / indexes | `min(4.6vw, 8.5vh)` ~ `min(5.6vw, 10vh)` |

**4. Between canvas-card children use grid `gap`, don't stack margins/paddings**
`.canvas-card` is `display:flex;flex-direction:column` by default, and chrome-min carries `margin-bottom:48px` (`--sp-9`).
For rows below the header (head / content / footnote), **prefer** `display:grid;grid-template-rows:...;gap:Nvh`, **next** a flex column + gap, **forbidden** to tune spacing by adding `margin-top` / `padding-top` in each child block (it overlaps or tears chrome-min's margin-bottom).

**5. Bottom pager safe zone: the lowest edge of main content must not touch nav**
The bottom pager dots are fixed at `bottom:2vh`, visually occupying everything after about `93vh`. The lowest edge of main content, image captions, chart notes, and timeline labels must stop above the safe zone.

- The template provides `--nav-safe-bottom:8vh`, usable via `.nav-safe-bottom` / `.nav-safe-bottom-tight`
- When P23 uses `.swiss-img-split.align-image-bottom`, the template automatically adds a bottom safe zone so the image caption is not covered by the pager
- If you hand-write `align-items:end` / `margin-top:auto` / `position:absolute;bottom:...` on a page, you must eyeball whether the lowest edge crosses the nav
- Visual self-check: open the page, confirm at least `3vh` breathing room between the lowest content edge and the pager dots

---

**Card fill rules (must comply)**
| Type | Class | Role | Usage |
|---|---|---|---|
| Ink black fill | `.card-ink` | inverted / manifesto | hero blocks, one half of a closing page |
| Accent blue fill | `.card-accent` | single focal point | highlight one item in a group |
| Grey fill | `.card-fill` | default neutral | parallel multi-cards, stat cards |
| Outlined | `.card-outlined` | anchor (non-card) | hairline divider frame |

❌ Mixing fills is forbidden (blue bg + blue outline, grey bg + outline, etc.)

**Decoration minimalism**
- 1px hairline dividers (`hr-hairline` / `border-bottom`)
- 8×8 / 12×12 right-angle squares replace dots
- Dot matrix `dot-mat` / ring `ring-mat` / cross `cross-mat` (SVG masks)

**Image principles (Swiss + GPT-M 2.0)**
- An image is an "evidence block" in the grid, not a decorative background; it must have a clear function: case, documentary evidence, UI screenshot, system diagram, conceptual infographic
- All image containers stay right-angled, no shadows, no radius; by default **no image frame**, let captions or the page grid carry hierarchy
- White-background infographics / flowcharts / UI shots: the container background must be `var(--paper)`, don't wrap a white image in grey, and don't add a `.swiss-keyline` outline
- Only when the image's own edge can't be told apart from the page do you use `.swiss-lined` for a single top accent line; don't frame every image
- Documentary photos use `object-fit:cover` cropping bottom/edges only; raw screenshots or text-dense images use `.fit-contain` so text isn't cut
- If an infographic, flowchart, or UI shot is regenerated for an S15/S16 slot, it must fill the slot with `.frame-img.r-21x9` / `.frame-img.r-16x10`; don't add `.fit-contain` or it becomes a small image floating in a white box
- Preferred Swiss image ratios: S22 top banner `21:9`; S15/S16 multi-image grids uniformly `21:9` or uniformly `16:10`
- When generating 2-3 images, first bind the original layout slots: single large image = S22; multiple = S15/S16 grid adaptation; don't use the unregistered P23/P24
- S22 photo subjects must sit in the central safe zone; in HTML use `object-position:center 35%` or `center center`, never `top center` beheading people
- GPT-M 2.0 generations must obey a single accent color, Helvetica/Inter character, 12/16-column grid, right-angle flat color, no gradient/shadow/radius
- Generations keep only the core graphic itself; never paint headers, footers, titles, page numbers, corner badges, borders, or signatures into the image

**Layout-diversity hard rule**
The Swiss theme has 22 registered layouts; generating should actively show the layout system, not turn everything into `head + grid-reveal + card`:

- A 7-8 page deck uses at least **6 different S-numbered layouts**
- No 3 consecutive pages with the same body structure (e.g. three S19 in a row / plain cards)
- If it's a "template test" or "I want to see the result", it must cover: a cover, a closing, at least 1 compare/timeline (S08/S11/S02), at least 1 structure diagram (S14/S17/S15), at least 1 image layout (S22 or an S15/S16 image grid)
- An image page is not a freshly invented page. Single image → S22, multiple → S15/S16's original grid skeleton adapted
- Before writing code for each page, list `page number → data-layout → why this one → image slot`; check with the validator after generating

**Motion principles (one semantic recipe per page)**
- Not a uniform fade-up but **coupled to the graphic's meaning**: numbers scale-pop in, bars scaleY raise, SVG rings stroke-dashoffset draw, timeline nodes light up in sequence
- Easing: `EASE_PROD` `cubic-bezier(.2,0,.38,.9)` for productive (120-240ms), `EASE_ENTRY` `cubic-bezier(0,0,.3,1)` for expressive (400-700ms)
- The playSlide entry must reveal all `[data-anim]` containers to opacity:1; inside a recipe use motion `{opacity:[0,1]}` to overdrive

---

## Visual + code dual review (mandatory after generating)

Don't only read HTML/CSS. The Swiss template's fidelity has to be judged from **browser visuals** and **code structure** together:

1. Open two pages side by side: the current `template-swiss.html` (golden-source snapshot) and the test PPT being edited; add a previously accepted finished deck as a third comparison if available.
2. Wait for entrance animations to settle (about 1-2s) before screenshotting. Don't mistake an animation intermediate state for "missing content" or "empty layout".
3. Look at visuals first: title weight, header distance, image placement, bottom safe zone, whether a caption is covered by the nav.
4. Compare against the original reference PPT's same layout types, not just the CSS helpers; judge by the actual page structure and visual result.
5. Then return to code and check whether a page misuses components that don't belong to its layout — e.g. jamming P24's three-image evidence wall into P23, or using a P7 chart for a concept list with no real values.
6. On a visual mismatch, first decide whether it's **wrong layout choice**, **missing required component**, **abused optional component**, or **spacing/safe-zone problem**; don't try to brute-force it with `margin`.
7. When editing the template, isolate new capabilities in new classes; never change a global base class because one page has a problem.

### Original PPT visual anchors (check these first when comparing)

| Visual anchor | What the original PPT actually does | Rule when generating |
|---|---|---|
| Big-title weight | Real pages widely use `font-weight:200/300`; even if a raw CSS helper has 700/800/900, that's not a visual standard | Big titles stay light; the larger, the thinner |
| Whitespace | Pages often fill only the upper half or middle; the bottom is left to nav and a little footnote | Don't push content to the bottom just to "fill" it |
| Dividers | 1px hairlines only at section boundaries, evidence walls, card tiers | Don't give every content block a line |
| Title vs content | Clear air between the title area and body/charts | Dense pages use grid `gap`; don't let content touch the title |
| Timeline | Axis in the middle-lower area, but labels don't touch the bottom nav | A horizontal timeline must check both the upper/lower labels and the nav safe zone |
| Image pages | Images are evidence blocks: either S22 hero visual or the original S15/S16 grid | Don't use unregistered image-text structures |

### Components required / optional / omittable

| Component | Rule |
|---|---|
| `.canvas-card` / `.chrome-min` | required on base pages; in split pages each half has its own chrome-min |
| `t-meta` / `t-cat` kicker | required in the head area, but omittable inside body cards; must sit above the big title |
| Big title | required on section/argument pages; list-style small-card pages may use a smaller title, but can't lack the page-level information anchor |
| `lead` intro | optional; if the title already explains itself it can be omitted, but don't glue long body text to the title |
| Image caption | required on S15/S16 multi-image grids; optional on S22 because the image is already the hero and has KPIs/notes below |
| Hairline / border-bottom | optional; only for building hierarchy, never stacked lines for decoration |
| KPI / numbers | only with real data; never invent values to explain a concept |
| `footnote` / bottom note | optional; if used, must stay out of the nav safe zone |
| `S08 + Swiss Map Component` | reserved for place/route/residence relationships; the right-side map must have dots, connections, cards, and `+` / `-` / `DRAG` controls, see `swiss-map-component.md` |

### Universal / non-universal layouts

| Type | Layouts | Usage boundary |
|---|---|---|
| Universal | S01, S03, S08, S09, S10, S11, S19 | work for most narrative decks, but still must satisfy the content shape |
| Conditionally universal | S04, S05, S13, S16 | depend on whether the count matches exactly: 3/4/6 items |
| Data-specific | S02, S06, S07, S18, S20, S21, S22 | must have real time, values, metrics, or case data |
| Structure-specific | S14, S15, S17 | must have a loop, matrix, tier/ecosystem relationship; not for plain paragraphs |

---

## The 22 registered layouts

### P1 · Cover

**Purpose**: deck opener / theme manifesto.
**Suitable content**: cover / chapter home / theme manifesto. **A pure text structure** (main title + subtitle + meta), carries no data.

**Default recommendation: fullscreen IKB + ASCII breathing field** ⭐
- `<section class="slide accent">` fullscreen IKB, **not** a light white background
- Insert `<canvas class="ascii-bg" aria-hidden="true">` as the first child inside `.canvas-card`; the template's bottom IIFE drives the sin/cos 2D-noise breathing field automatically
- Main title inverted white weight 200; the subtle emphasis uses italics (`font-style:italic;font-weight:300`) instead of IKB blue (the background is already blue; blue on blue is invisible)
- **Don't** put in a giant "01" number — chrome-min already shows 01/NN
- Pairs with P9 Closing's half-IKB screen for the "open full IKB ↔ close half IKB" color loop

**Key classes**: `.slide.accent` `.ascii-bg` + `min(11.6vw,19vh)` dual-constraint big type
**Motion recipe**: `hero` — ASCII character field breathes continuously, text fades up in sequence

**Example code (IKB default variant)**:
```html
<section class="slide accent" data-animate="hero">
  <div class="canvas-card">
    <canvas class="ascii-bg" aria-hidden="true"></canvas>
    <div class="chrome-min">
      <div class="l">[required] Deck title · Issue/Field Note No.</div>
      <div class="r">SS · 26.05.10 · 01 / NN</div>
    </div>
    <div style="flex:1;padding:0;display:grid;grid-template-rows:auto 1fr auto;gap:2.6vh">
      <div data-anim="kicker" class="t-meta" style="color:rgba(255,255,255,.78);letter-spacing:.22em">[required] Section En</div>
      <h1 data-anim="title" style="align-self:center;font-family:var(--sans),var(--sans-zh);font-weight:200;font-size:min(11.6vw,19vh);line-height:.94;letter-spacing:-.025em;color:#fff">[required] Main title<br/>(add a subtle <span style="font-style:italic;font-weight:300">italic</span> emphasis on one character)</h1>
      <div data-anim="bottom" style="display:grid;grid-template-rows:auto auto;gap:1.6vh;border-top:1px solid rgba(255,255,255,.22);padding-top:2vh">
        <div data-anim="lead" class="lead" style="max-width:52ch;color:rgba(255,255,255,.86);font-weight:300">[required] A 1-2 line subtitle / hook setting the tone.</div>
        <div style="display:flex;justify-content:space-between;align-items:end">
          <div class="t-meta" style="color:rgba(255,255,255,.6)">[optional] Author · Date · Source</div>
          <div class="t-meta" style="color:rgba(255,255,255,.6)">→ swipe / arrow keys</div>
        </div>
      </div>
    </div>
  </div>
</section>
```

**Classic variant (left ink + right paper spread)** — only when full IKB doesn't fit the content's tone:
```html
<section class="slide" data-animate="cover-reveal">
  <div class="canvas-card cover-split">
    <div class="cover-ink">
      <span class="t-cat">Volume 18 · 2026</span>
      <h1 class="h-hero">Thin Harness,<br>Fat Skills.</h1>
      <span class="t-meta">— Kevin · 2026-05</span>
    </div>
    <div class="cover-paper">
      <p class="lead">A thin harness, fat skills.</p>
      <ul class="meta-list">
        <li>22 PAGES</li><li>SWISS · IKB</li><li>MP-75</li>
      </ul>
    </div>
  </div>
</section>
```

---

### P2 · Vertical Timeline

**Purpose**: evolution comparison, eras/change across time, version history (2-5 time points).
**Suitable content**: **time evolution with quantitative data**. Each node must carry the triad of "year + quantitative value (e.g. 1× / 4× multiplier / a unit number) + description". If a node only has a name and no data, use P11 horizontal timeline instead.
**Skeleton**: left axis column of 12px dots + a 1px dashed axis / right node info (year + large data number + small label + description).
**Key classes**: `.timeline-v` `.tl-node` `.tl-axis` (12px fixed column width, absolutely-positioned dot to prevent misalignment) `.kpi-row-4`
**Motion recipe**: `timeline-vertical` — nodes light up top to bottom in time order (dot pops first then expands → text slides in horizontally)
**Grid rules**: axis column = fixed 12px; dot uses `position:absolute;left:50%;transform:translateX(-50%)` to align with the dashed axis
**Example code**:
```html
<section class="slide" data-animate="timeline-vertical">
  <div class="canvas-card">
    <header class="chrome-min">...</header>
    <div class="timeline-v">
      <div class="tl-node">
        <div class="tl-axis"><span class="dot"></span></div>
        <div class="tl-body">
          <span class="yr">2023</span>
          <span class="multi">1<small>×</small></span>
          <p class="desc">Prompt Engineering Era</p>
        </div>
      </div>
      <!-- repeat N tl-nodes; the axis column runs through -->
    </div>
  </div>
</section>
```

---

### P3 · Statement

**Purpose**: central thesis, section start, slogan. One page holds just one statement + simple decoration.
**Suitable content**: **purely qualitative statement / slogan / section switch**. Compress the statement to 8-12 words; **carry no data or lists**. If you need data backing, use P18 Why Now; if it's a cover, use P1.
**Skeleton**: left 1/3 blank + midsection giant-type statement (8-10vw, weight 200) + bottom-right small footnote + bottom hairline.
**Key classes**: `.h-statement` (9.6vw, letter-spacing:-.05em) `.stmt-anchor`
**Motion recipe**: `statement-rise` — the big type rises staggered in word order (180ms delay per word) + footnote fades in
**Example code**:
```html
<section class="slide" data-animate="statement-rise">
  <div class="canvas-card">
    <header class="chrome-min">...</header>
    <h1 class="h-statement">
      <span>Build it</span> <span>once.</span><br>
      <span>It runs</span> <span>forever.</span>
    </h1>
    <span class="stmt-anchor">— Statement 03</span>
  </div>
</section>
```

---

### P4 · Six Cells

**Purpose**: 6 parallel concept definitions, 6 features side by side.
**Suitable content**: **6 equal concepts / feature list** (count must be exactly 6; fewer → P5, more → P15/P16). Each cell carries only "icon + index + short title + one-line description", **no expandable data / paragraphs**.
**Skeleton**: 2×3 grid / lucide icon + index + short title + one-line description above each cell / hairline separators between cells.
**Key classes**: `.cell-6` `.cell-icon-row` `.cell-num`
**Motion recipe**: `six-cells` — 6 cells light up in z-order (L→R, T→B, 90ms delay per cell)
**Note**: **do not hand-draw SVG icons**; use `<i data-lucide="bookmark"></i>` to pull lucide online.
**Example code**:
```html
<div class="cell-6">
  <div class="cell">
    <i data-lucide="square-stack"></i>
    <span class="cell-num">01</span>
    <h4>Skill File</h4>
    <p>pure markdown, hand-writable and rewritable</p>
  </div>
  <!-- 5 more -->
</div>
```

---

### P5 · Three Sub-cards

**Purpose**: three-step process, three-way comparison (mild differences).
**Suitable content**: **3 equal concepts / steps** (count must be exactly 3). Homogeneous structure, **no strong data differences** (if data is comparable, use P6 KPI Tower instead). Each card carries slightly more than P4 (index + title + 1-2 line description).
**Skeleton**: left big title + description + top hairline / right 3 horizontally stacked sub-cards.
**Key classes**: `.sub-card-stack` `.sub-card` (`.card-fill` grey background, right angles)
**Motion recipe**: `sub-stack` — main title enters first → 3 cards slide in stepwise from the right (140ms delay per card)
**Example code**:
```html
<div class="grid-2-9">
  <div class="lead-col">
    <span class="t-cat">Three Forces</span>
    <h2 class="h-xl">Compress into Three Facts</h2>
  </div>
  <div class="sub-card-stack">
    <article class="card-fill sub-card">
      <span class="big-num">01</span>
      <h4>Skill File</h4>
      <p>...</p>
    </article>
    <!-- 2 more -->
  </div>
</div>
```

---

### P6 · KPI Tower

**Purpose**: 4 data points expressed as visual height hierarchy.
**Suitable content**: **4 comparable quantitative data points** (must have real values; bar height driven by data). Typically: cost, capacity, count, efficiency metrics. **Forbidden** for a data-free concept list (that's P4/P5 territory).
**Skeleton**: 4 equal columns, each with an IKB-blue rectangle of different height at the bottom (height driven by data) + icon on top + megasize number mid-column + label at the bottom.
**Key classes**: `.kpi-tower-row` `.bar-tower` (min-height:6vh, max:36vh) `.tower-cap`
**Motion recipe**: `tower-grow` — labels enter first → numbers pop in with scale → towers scaleY up from 0 (transform-origin:bottom)
**Example code**:
```html
<div class="kpi-tower-row">
  <div class="tower-col">
    <i data-lucide="layers"></i>
    <span class="num-mega">90K</span>
    <span class="lbl">Skills</span>
    <div class="bar-tower" style="--h:36vh"></div>
  </div>
  <!-- 3 more, different heights -->
</div>
```

---

### P7 · H-Bar Chart

**Purpose**: ranking comparison / share comparison (5-10 items).
**Suitable content**: **5-10 comparable quantitative data points** (must have real percentages / scores / values; bar width driven by data). Typically: benchmark rankings, market share, survey shares. ⚠️ **Strictly forbidden for a data-free concept list** (that's P4/P5/P15 territory) — fabricated numbers will be spotted.
**Skeleton**: big title at top / empty mid-section / lower-half bar list (each row: text label + 1px blue bar 0→target width + value at the end).
**Key classes**: `.h-bar-chart` `.bar-row` `.bar-fill` (scaleX animation)
**Motion recipe**: `hbar-grow` — big title enters first → each row width 0→target in order (transform-origin:left) + end numbers count up
**Example code**:
```html
<div class="h-bar-chart">
  <div class="bar-row">
    <span class="bar-lbl">Anthropic Advisor</span>
    <span class="bar-fill" style="--w:84%"></span>
    <span class="bar-num">84</span>
  </div>
  <!-- N more -->
</div>
```

---

### P8 · Duo Compare

**Purpose**: Before/After, A vs B, old/new comparison.
**Suitable content**: **binary comparison** (must be exactly 2 items). Both sides are structurally homogeneous (t-cat label + big title + paragraph / list explanation). Typically: old/new workflow, traditional/AI, customer view/team view.
**Skeleton**: two half-screens split by a single vertical 1px line / t-cat + big title at each top + explanation below.
**Key classes**: `.duo-compare` `.duo-half` `.vrule` (scaleY stretch)
**Motion recipe**: `duo-mirror` — center vrule scales Y 0→1 first → titles and text on both sides enter mirrored
**Example code**:
```html
<div class="duo-compare">
  <div class="duo-half">
    <span class="t-cat">Before</span>
    <h2>Handed to the model</h2>
  </div>
  <span class="vrule"></span>
  <div class="duo-half">
    <span class="t-cat">After</span>
    <h2>Handed to code</h2>
  </div>
</div>
```

---

### P9 · Closing Manifesto

**Purpose**: the deck's closing page.
**Suitable content**: **deck closing** (one page per deck). Fixed structure: manifesto short line on the left + 3 takeaways on the right (index + title + one-line explanation). **Cannot be used on a mid-deck page** (that would duplicate the P1 cover).

**Default recommendation: left IKB + ASCII / right paper takeaway** ⭐
- Use `<section class="slide split">` + left `.half.b-accent` + ASCII canvas + right white takeaway
- Builds the "full-IKB opening ↔ half-IKB closing" color loop with the P1 cover
- Highlight takeaway 03 on the right with `var(--accent)`, stitching the IKB blue across from the left half and closing the color seam
- Big title reversed white weight 200; emphasized word italic (the background is already blue — don't mark it `var(--accent)`)

**Key classes**: `.slide.split` `.half.b-accent` `.ascii-bg` (IIFE auto-start)
**Motion recipe**: `split-statement` — left ink/IKB title char sequence rises → right white takeaway trails in with three items

**Example code (IKB default variant)**:
```html
<section class="slide split" data-animate="split-statement">
  <div class="canvas-card">
    <div class="split-half">
      <!-- left half · IKB + ASCII breathing field -->
      <div class="half b-accent" style="padding:5.6vh 3.6vw 4.4vh;justify-content:space-between;position:relative;overflow:hidden">
        <canvas class="ascii-bg" aria-hidden="true"></canvas>
        <div class="chrome-min" style="margin-bottom:0;position:relative;z-index:1">
          <div class="l">NN / NN</div>
          <div class="r">CLOSING</div>
        </div>
        <div data-anim="manifesto" style="display:flex;flex-direction:column;gap:2vh;position:relative;z-index:1">
          <div class="t-meta" style="color:rgba(255,255,255,.78);letter-spacing:.22em;margin-bottom:1.6vh">MANIFESTO</div>
          <h2 style="font-family:var(--sans),var(--sans-zh);font-size:min(8vw,14vh);line-height:.94;letter-spacing:-.025em;font-weight:200;color:#fff">[required] Build a model.<br/>Run <span style="font-style:italic;font-weight:300">forever</span>.</h2>
          <div style="font-family:var(--sans),var(--sans-zh);font-size:max(13px,1vw);line-height:1.6;color:rgba(255,255,255,.82);font-weight:300;max-width:36ch;margin-top:1.4vh">[required] One line is the landing note in Chinese or English.</div>
        </div>
        <div data-anim="signature" style="display:flex;justify-content:space-between;align-items:end;border-top:1px solid rgba(255,255,255,.22);padding-top:2vh;position:relative;z-index:1">
          <div class="t-meta" style="color:rgba(255,255,255,.62)">[optional] Author · Title</div>
          <div class="t-meta" style="color:rgba(255,255,255,.62)">YY.MM.DD</div>
        </div>
      </div>
      <!-- right half · white takeaway, third item highlighted IKB blue, closing the color loop -->
      <div class="half" style="padding:5.6vh 3.6vw 4.4vh;justify-content:space-between">
        <div class="chrome-min"><div class="l">TAKEAWAYS</div><div class="r">03 RULES</div></div>
        <div data-anim="rules">...</div>
        <div class="t-meta" style="color:var(--text-helper);text-align:right">→ done · END OF FIELD NOTE</div>
      </div>
    </div>
  </div>
</section>
```

**Classic variant (`.closing-split` ink dual-half)** — when the cover doesn't use a full IKB screen, use the classic ink close instead:
```html
<div class="closing-split">
  <div class="cl-ink">
    <p class="line-mega">Build it<br>once.</p>
    <p class="line-mega">It runs<br>forever.</p>
  </div>
  <div class="cl-paper">
    <ul class="takeaway-list">
      <li><span class="num">01</span><h4>Skill</h4><p>...</p></li>
      <!-- 2 more -->
    </ul>
  </div>
</div>
```

---

### P10 · Dot Matrix Statement

**Purpose**: second statement page / section switch / visual air page.
**Suitable content**: **slogan / metaphor / section switch** (same as P3, but with geometric dot-matrix decoration). Used to **avoid two consecutive P3 pages** within a deck; typically the flavor page right before a "concept definition".
**Skeleton**: three-line 7vw giant-type manifesto mid-page / 36vw dot-matrix top-right + stroked ring matrix bottom-left.
**Key classes**: `.dot-mat` (SVG-mask solid dots) `.ring-mat` (stroked rings) `.cross-mat` (× grid)
**Motion recipe**: `matrix-statement` — text lines enter one by one → dot matrix mask-position sweeps left to right
**Example code**:
```html
<div class="canvas-card">
  <span class="ring-mat" style="left:5vw;bottom:5vh;width:18vw;height:18vw"></span>
  <h1 class="h-statement">Build a thin harness.<br>Write fat skills.<br>Codify everything.</h1>
  <span class="dot-mat" style="right:0;top:0;width:36vw;height:36vw"></span>
</div>
```

---

### P11 · Horizontal Timeline

**Purpose**: multi-step process (4-7 steps), time evolution.
**Suitable content**: **4-7 step linear process** (each step is just a name; no expandable data / description needed). If each step needs expansion, use P5; if it carries quantitative data, use P2. **Forbidden** for loop structures (that's P14).
**Skeleton**: big title at top / mid-section one 1px hairline horizontal axis + N evenly-spaced nodes (8×8 right-angle square + mono index above + step name below).
**Key classes**: `.timeline-h` `.tl-h-node` `.tl-h-axis`
**Motion recipe**: `timeline-walk` — nodes light up left→right along the axis (220ms per node)
**Alignment note**: the horizontal-timeline label CSS relies on `translateX(-50%)` centering. When the motion does vertical displacement, write the full `transform: translate(-50%, y)` sequence — never just `y` — or the label will drift off the dot after the animation ends.
**Example code**:
```html
<div class="timeline-h">
  <span class="tl-h-axis"></span>
  <div class="tl-h-node">
    <span class="num">01</span>
    <span class="dot"></span>
    <span class="lbl">Investigate</span>
  </div>
  <!-- 4-6 more -->
</div>
```

---

### P12 · Manifesto + Ink Banner · Manifesto + full-bleed banner

**Purpose**: section conclusion, chapter closer, slogan + strong visual closure.
**Suitable content**: **section close / mid-deck manifesto** (for the middle of a deck, not the end — P9 is the deck finale). Carries a three-part structure of "claim + short note + full-bleed banner", no data.
**Skeleton**: upper-left t-cat + 4-line big manifesto title + short note on the right / lower-half ink banner (no left/right/bottom margin) + reversed short line + lucide icon matrix.
**Key classes**: `.manifesto-top` `.ink-banner-full` (`margin:0 -5vw -4.4vh` cancels the parent padding)
**Motion recipe**: `manifesto` — three title lines rise staggered → bottom ink band scales in laterally 0→1 → reversed text fades in
**Note**: the small Skill File text aligns **top-aligned with the big-title baseline on the right** (`align-items:flex-start;padding-top:1.2vw`)

---

### P13 · Three Forces Cards · Three-force cards

**Purpose**: 3 parallel concepts (each = mega number + title + two-column description).
**Suitable content**: **3 parallel concepts in depth** (count = 3, carries more text than P5). Each card is richer (mega number + title + two-column paragraphs). 01/02/03 are number anchors, not real data. Typical: three rebuttals, three forces, three claims.
**Skeleton**: left 5/16 ink hero block (t-cat + 4-line title + dot decoration) / right 11/16 three horizontally stacked cards.
**Key classes**: `.three-forces` `.hero-ink-col` `.force-card` (`.card-fill`) `.force-num` (9.2vw IKB blue)
**Motion recipe**: `three-forces` — left hero slides in → right 3 cards slide in staggered → the big blue number pops alone
**Note**: **all 3 cards must share one style** (all `.card-fill` grey, don't mix outline/blue fills); to highlight one, use `.card-accent` instead — **never** blue fill + outline.

---

### P14 · Loop Diagram · Loop diagram

**Purpose**: self-study loops, automated flows (3-5 step cycles).
**Suitable content**: **cyclic / loop flows** (the end returns to the start, 3-5 steps). E.g. self-study loop, CI/CD, feedback loop, agent loop. **Linear flows are forbidden** (that's P11).
**Skeleton**: left 4 numbered steps (top-aligned) / right-side SVG concentric rings / central giant LOOP / nodes uniformly grey right-angle squares (no alternating dot colors).
**Key classes**: `.loop-diagram` `.loop-steps` `.loop-svg`
**Motion recipe**: `loop-form` — left steps arrive vertically in order → right SVG ring draws via stroke-dashoffset → nodes light in sequence
**Note**: left and right **align as one vertical center** (top-aligned with equal heights)

---

### P15 · Image Matrix + Hero Stat · Matrix + hero stat

**Purpose**: many same-kind items (8-12 skills / team members / case icons) closed by one aggregate number at the bottom.
**Suitable content**: **8-12 small same-type items + one aggregate metric**. Each item carries only a short title (no expansion); the bottom mega number is the "aggregate value" (project total / total traffic / total users). **Too few items → use P4 (6 items)**.
**Skeleton**: top title (leave 9vh gap) / middle 4×3 matrix cards (each 12vh fixed height) / bottom mega number + label (pushed down with margin-top:auto).
**Key classes**: `.matrix-fill` (grid-template-columns:repeat(4,1fr)) `.matrix-cell` (`.card-fill` grey, **no outline**) `.hero-stat-bottom`
**Motion recipe**: `matrix-fill` — 12 cells reveal in random checkerboard order (random per-cell delay) → bottom mega number count-up
**Note**: cap the card height (avoid big-number overflow); **all cards `.card-fill` grey**, switch a single highlight item to `.card-accent`

---

### P16 · Multi-card Brief · Multi-card brief

**Purpose**: 6 small cards in a row (quick notes, tip collections, feature overviews).
**Suitable content**: **6 lightweight briefs / tips / footnotes** (count = 6, short main text per item + small footnote). More granular than P4, suited to quick-news. **Only one accent-blue highlight allowed** (single-focus rule).
**Skeleton**: large title on top (leave 9vh) / 3×2 micro-cards below (per card: main text top-left + small note bottom-right + empty middle).
**Key classes**: `.brief-grid` `.brief-card` (`.card-fill` grey) `.brief-card.is-accent` (single blue emphasis)
**Motion recipe**: `field-notes` — 6 cards light in z-order (L→R, T→B, 90ms stagger)
**Note**: inside cards **main text top-left + small note bottom-right**, keep the middle empty (avoid clutter); **only one accent-blue card**

---

### P17 · System Diagram · Concentric system diagram

**Purpose**: layered architecture (core→middle→outer), ecosystem maps.
**Suitable content**: **a strict three-layer nesting** (core / middle / outer). Typical: tech-stack layers, ecosystem layering, influence radiation. **Non-three-layer structures forbidden** (flat → P4, unclear hierarchy → P5).
**Skeleton**: left half title + three-part note / right half SVG three-layer concentric rings + outbound label leaders.
**Key classes**: `.system-diagram` `.sys-svg` `.sys-label`
**Motion recipe**: `system-diagram` — concentric rings scale in from outer to inner → labels appear in sequence

---

### P18 · Why Now · Three-column escalation + mega numbers

**Purpose**: three arguments + supporting number each (why now).
**Suitable content**: **3 arguments + one quantitative data point per argument**. Structure per argument = t-cat label + one-line title + paragraph + one mega number at the bottom (percentage / year / multiplier all fine). The last column is emphasized in IKB blue to flag the "key supporting argument".
**Skeleton**: big title at top / 3 mid-section columns (each: t-cat + title + description) / one 8.4vw mega number at each column bottom (01 / 02 / 03, last column IKB-blue emphasized).
**Key classes**: `.why-now-grid` `.why-col` `.why-num-bottom` (8.4vw, weight 200)
**Motion recipe**: `why-now` — three columns rise in sequence → bottom mega numbers count up
**Note**: keep the mega-number size uniform; highlight only the last column via color (IKB blue), **not** bold.

---

### P19 · Four Cards · Four-column equal cards

**Purpose**: 4 features/attributes side by side (equal weight).
**Suitable content**: **4 equal-weight features / modules** (count = 4, fully homogeneous structure). Each item = t-meta index + big title + one paragraph. No data dimension, purely qualitative. More even than P5 (three steps), more text-only than P6 (data height).
**Skeleton**: top 80px IKB-blue short hairline cap + big two-line title / four equal columns below (each card: t-meta top "— 01 / SLASH" + big title + paragraph).
**Key classes**: `.four-cards` `.fc-col`
**Motion recipe**: `four-cards` — top blue line width 0→100% → 4 columns push up from the bottom (110ms stagger per column)
**Note**: **don't** use 9px circular dots (violates the right-angle language); use `.t-meta` text instead.

---

### P20 · Stacked KPI Ledger · Vertical ledger KPI

**Purpose**: 4-6 rows of core data presented as a ledger (each row = number + label + icon).
**Suitable content**: **4-6 core-data ledger rows** (each row must have a real value + label + icon). The vertical ledger form fits finance data, KPI dashboards, key-metric lists. It holds more data than P6 KPI Tower but visualizes it weaker (no bar-height comparison).
**Skeleton**: a hairline divider per row / megasize number on the left (height-capped with `min(13vw,16vh)` to prevent overflow) / label in the middle / lucide icon on the right.
**Key classes**: `.stacked-ledger` `.ledger-row` (border-bottom:1px solid var(--border-subtle)) `.ledger-num`
**Motion recipe**: `stacked-ledger` — each row's number rises → label slides left → icon pops (180ms stagger per row)
**Note**: **the font size must be height-capped** (`font-size:min(13vw, 16vh)`), or bottom rows get squeezed off a standard 16:9 screen.

---

### P21 · Tech Spec Sheet · Spec sheet

**Purpose**: product specs, benchmark data, performance baseline (multiple KPIs + decorative vertical lines).
**Suitable content**: **product spec / benchmark / performance baseline** (must have real multi-dimensional data: 3 KPI + 9 vertical bars = 12+ data points). Typically: model scores, API performance, stress-test results. The densest data layout in the deck.
**Skeleton**: 4-row big title on the left / 3 KPI mid (top hairline + number + unit) / 9 uneven-height vertical bars bottom-right / bottom mega number + Yearly goal + three tags + MP-XX bottom-right + page number.
**Key classes**: `.tech-spec` `.spec-title-col` `.spec-kpi-grid` `.spec-bars` (`.bar-vert`, scaleY spring-up, transform-origin:bottom)
**Motion recipe**: `tech-spec` — hero area fades in → title enters → KPI top lines draw one by one → bottom mega number pops → bars spring up from the bottom by scaleY (50ms stagger)
**Note**: the bottom-right bars matrix must be **bottom-aligned** and **not exceed the right margin**.

---

### P22 · Image Hero · Image + copy hero

**Purpose**: case study, product image + data anchoring, chapter cover with image.
**Suitable content**: **case study / product launch / chapter cover with image** (must have real image assets + 3 core data points). Typically: product screenshot + key metrics, case image + ROI, user-feedback image + repeat-purchase rate. **Forbidden whenever there's no real image source** (placeholder grey images break the visual).
**Skeleton**: top 60% full-bleed image + white title block overlaid on the upper-left (top:11vh, generous buffer) / bottom 40% long caption + three KPI columns ($ / 127× / 100%).
**Key classes**: `.image-hero` `.hero-img-wrap` (60vh) `.hero-overlay-block` `.hero-stats`
**Motion recipe**: `image-hero` — image slowly zooms out (scale 1.05→1) → white block pushes in scaleX 0→1 → three KPI top lines draw in sequence
**Note**:
- Prefer local `images/{page}-{semantic}.png` files (GPT-M 2.0 or user-provided assets); don't default to unsplash hotlinks
- Don't glue content under the image's bottom edge; use `.image-hero-body` to add uniform top buffer to the lower half
- Height-cap the three KPI large type (`min(4.6vw, 7.6vh)`); anchor small text with `margin-top:auto` at the column bottom to prevent overflow into the nav dots
- Keep column heights uniform (no `align-items:start` on the grid; let the columns stretch to equal height)

**Example code**:
```html
<section class="slide light" data-animate="image-hero">
  <div class="canvas-card" style="padding:0;display:flex;flex-direction:column;overflow:hidden">
    <div data-anim="img" style="position:relative;flex:0 0 60%;overflow:hidden;background:var(--grey-1)">
      <img src="images/22-product-scene.png" alt="[required] Image description" loading="eager"
           style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;object-position:center 30%">
      <div class="chrome-min" style="position:absolute;top:0;left:0;right:0;color:rgba(255,255,255,.9);padding:5.6vh 5vw 0">
        <div class="l">Section · Case / Visual Evidence</div>
        <div class="r">22 / NN</div>
      </div>
      <div data-anim="title-block" style="position:absolute;left:5vw;top:11vh;background:var(--paper);padding:3.2vh 3.2vw;max-width:40vw">
        <div style="font-family:var(--sans),var(--sans-zh);font-weight:200;font-size:min(5.2vw,9vh);line-height:1;letter-spacing:-.035em;color:var(--text-primary)">
          [required] Image<br>Evidence
        </div>
      </div>
    </div>
    <div data-anim="kpi" class="image-hero-body">
      <div style="max-width:48ch;font-family:var(--sans),var(--sans-zh);font-size:max(15px,1.3vw);line-height:1.55;font-weight:300;color:var(--text-primary);letter-spacing:-.005em">
        [required] In 1-2 lines, explain why this image matters; don't repeat the title.
      </div>
      <div class="image-hero-stats" style="gap:4vw">
        <div style="display:flex;flex-direction:column;gap:.6vh"><div style="height:1px;background:var(--ink)"></div><div class="t-meta">Metric 01</div><div style="font-family:var(--sans);font-weight:200;font-size:min(4.6vw,7.6vh);line-height:.95;letter-spacing:-.04em">12×</div><div style="height:1px;background:var(--border-subtle);margin-top:auto"></div><p class="body-sm">[required] Explain the metric</p></div>
        <div style="display:flex;flex-direction:column;gap:.6vh"><div style="height:1px;background:var(--ink)"></div><div class="t-meta">Metric 02</div><div style="font-family:var(--sans);font-weight:200;font-size:min(4.6vw,7.6vh);line-height:.95;letter-spacing:-.04em">3.4h</div><div style="height:1px;background:var(--border-subtle);margin-top:auto"></div><p class="body-sm">[required] Explain the metric</p></div>
        <div style="display:flex;flex-direction:column;gap:.6vh"><div style="height:1px;background:var(--ink)"></div><div class="t-meta">Metric 03</div><div style="font-family:var(--sans);font-weight:200;font-size:min(4.6vw,7.6vh);line-height:.95;letter-spacing:-.04em;color:var(--accent)">100%</div><div style="height:1px;background:var(--border-subtle);margin-top:auto"></div><p class="body-sm">[required] Explain the metric</p></div>
      </div>
    </div>
  </div>
</section>
```

---

## Historical experiment zone (disabled by default)

P23/P24 below are experimental layouts added early on to explore mixing image and text. They are not part of the original 22P; don't use them for production generation by default. Unless the user explicitly asks to "experiment with new image-text layouts", use the S22 or S15/S16 image slots instead.

### P23 · Swiss Image Split · Text-left/image-right, or image-left/text-right (experimental, disabled by default)

**Purpose**: pair a documentary photo, infographic, UI scene, or system diagram with an argument.
**Suitable content**: **one core thesis + one hero image**. Fits "big title left + image evidence right" or "image left + caption right". If the image is the whole-page protagonist and needs KPIs, use P22; if multiple images, use P24.
**Skeleton**: head stacked inside `.canvas-card` / body `.swiss-img-split` two columns (5:7 or reverse 7:5) / `.swiss-img-caption` below the image.
**Key classes**: `.swiss-img-split` `.swiss-img-copy` `.frame-img.r-16x10.fit-contain|cover` `.swiss-img-caption`
**Motion recipe**: `grid-reveal` — head enters first, image and text blocks appear staggered
**Note**:
- Align the image with the first line of the body text, not with the top of the big title; you may add `padding-top:1vh` to `3vh` to the image column
- If you want the left content block to align with the bottom of the right image, use `.swiss-img-split.align-image-bottom` — don't force it with extra blank lines
- `.align-image-bottom` already has the bottom nav safe zone built in; don't push the image or caption toward the page bottom on top of that
- Avoid meaningless dividers in the left content block; don't insert a `.rule` unless you need a section break
- Infographics/UI diagrams must use `.fit-contain`; documentary photos default to cover
- The right image is wide, so keep the title to 3 lines or fewer and the body to 2-3 short paragraphs or 3 bullets

```html
<section class="slide light" data-animate="grid-reveal">
  <div class="canvas-card">
    <div class="chrome-min">
      <div class="l">Section · Visual Argument</div>
      <div class="r">23 / NN</div>
    </div>
    <div style="flex:1;padding:0;display:grid;grid-template-rows:auto 1fr;gap:5vh">
      <div data-anim="head" style="display:flex;flex-direction:column;gap:1.4vh">
        <div class="t-meta">Evidence · GPT-M 2.0</div>
        <h2 style="font-family:var(--sans),var(--sans-zh);font-weight:200;font-size:min(7vw,12vh);line-height:.96;letter-spacing:-.035em">[required] One core thesis in one line</h2>
      </div>
      <div class="swiss-img-split align-image-bottom" data-anim="up">
        <div class="swiss-img-copy">
          <div class="t-cat" style="color:var(--accent)">Why it matters</div>
          <p class="lead" style="font-weight:300;max-width:36ch">[required] In 2-3 lines, explain how the image relates to the thesis.</p>
          <div class="body" style="font-weight:300;color:var(--text-secondary)">[required] Add 2-3 short bullets or one note here; keep left-aligned with generous whitespace.</div>
        </div>
        <figure class="tile">
          <div class="frame-img r-16x10 fit-contain">
            <img src="images/23-visual-evidence.png" alt="[required] Image caption">
          </div>
          <figcaption class="swiss-img-caption"><strong>[required] Image title</strong><span>16:10 · fit-contain</span></figcaption>
        </figure>
      </div>
    </div>
  </div>
</section>
```

---

### P24 · Swiss Evidence Grid · Multi-image evidence wall (experimental, disabled by default)

**Purpose**: three same-type images/screenshots/charts side by side, showing an evidence chain or multi-case comparison.
**Suitable content**: **2-3 same-type images**. Fits UI-screenshot redraws, three-stage flowcharts, three case photos, three small data charts. Mixing different types breaks the Swiss order.
**Skeleton**: head stacked top / `.swiss-img-grid` three columns / every tile uses the same `.h-22` or `.h-26`.
**Key classes**: `.swiss-img-grid` `.frame-img.h-22|h-26` `.fit-contain` `.swiss-img-caption`
**Motion recipe**: `grid-reveal`
**Note**:
- Same-group images must share aspect ratio, height, and margin density; don't mix one 16:9, one 4:3 and one long-screenshot
- There must be clear buffer between the title area and the image area; the template's `.swiss-img-grid` carries default top spacing, only add `.tight` when the outer grid already gives enough gap
- UI/info-graphics uniformly use `.fit-contain`; photos uniformly cover
- If the user's raw screenshot ratios are messy, first apply the CleanShot X-style programmatic reframing from `screenshot-framing.md`; only when an image is too long, too narrow, or needs information restructuring, use GPT-M 2.0 to regenerate a same-ratio "screenshot redesign"

```html
<section class="slide light" data-animate="grid-reveal">
  <div class="canvas-card">
    <div class="chrome-min">
      <div class="l">Section · Evidence Grid</div>
      <div class="r">24 / NN</div>
    </div>
    <div style="flex:1;padding:0;display:grid;grid-template-rows:auto 1fr;gap:6vh">
      <div data-anim="head" style="display:flex;flex-direction:column;gap:1.4vh">
        <div class="t-meta">Three visual proofs</div>
        <h2 style="font-family:var(--sans),var(--sans-zh);font-weight:200;font-size:min(6.6vw,11.6vh);line-height:.96;letter-spacing:-.035em">[required] Three proofs, one conclusion</h2>
      </div>
      <div class="swiss-img-grid" data-anim="up">
        <figure class="tile"><div class="frame-img h-26 fit-contain"><img src="images/24-proof-a.png" alt="[required]"></div><figcaption class="swiss-img-caption"><strong>01</strong><span>[required] Evidence A</span></figcaption></figure>
        <figure class="tile"><div class="frame-img h-26 fit-contain"><img src="images/24-proof-b.png" alt="[required]"></div><figcaption class="swiss-img-caption"><strong>02</strong><span>[required] Evidence B</span></figcaption></figure>
        <figure class="tile"><div class="frame-img h-26 fit-contain swiss-lined"><img src="images/24-proof-c.png" alt="[required]"></div><figcaption class="swiss-img-caption"><strong>03</strong><span>[required] Key evidence</span></figcaption></figure>
      </div>
    </div>
  </div>
</section>
```

---

## Layout selection index (decision table for the LLM)

| Content intent | Recommended layout |
|---|---|
| Deck opening cover | P1 Cover |
| Evolution comparison / timeline (vertical) | P2 Vertical Timeline |
| One-liner / section opener | P3 Statement / P10 Dot Matrix |
| 6 concept definitions | P4 Six Cells |
| Three-step process (light) | P5 Three Sub-cards |
| 4 data points, visual height comparison | P6 KPI Tower |
| 5-10 ranking comparison | P7 H-Bar Chart |
| Before/After / two-track contrast | P8 Duo Compare |
| Whole-deck closing | P9 Closing Manifesto |
| Multi-step process (horizontal, 4-7 steps) | P11 Horizontal Timeline |
| Section conclusion + ink full-bleed | P12 Manifesto + Banner |
| 3 parallel concepts, deepened | P13 Three Forces Cards |
| Loop process / self-learning cycle | P14 Loop Diagram |
| 8-12 matrix items + total data | P15 Image Matrix |
| 6 brief cards | P16 Multi-card Brief |
| Layered architecture / concentric system | P17 System Diagram |
| Three arguments + data backing | P18 Why Now |
| 4 equal-weight features | P19 Four Cards |
| 4-6 ledger-style KPI rows | P20 Stacked Ledger |
| Product spec / benchmark | P21 Tech Spec |
| Case image + data anchoring | P22 Image Hero |
| Place / route / who-lives-where relations | S08 + Swiss Map Component |
| Single image explaining a thesis / image-text mix | P23 Swiss Image Split |
| 2-3 image/screenshot/chart evidence chain | P24 Swiss Evidence Grid |

---

## Layout-selection P0 rule: the content-data type must match the layout

> This is the **easiest trap** when writing a deck. The "shape" a layout carries is fixed — you must look at the content first, then pick the layout; **never pick the layout first and cram content into it**.

| Content type | Must use | Must never use |
|---|---|---|
| Real quantitative data (percentages/numbers) | P6 KPI Tower / P7 H-Bar / P20 Ledger / P21 Tech Spec | P3 / P4 / P10 / P13 (data-free layouts) |
| No data, purely qualitative claim | P3 / P10 Statement / P12 / P13 / P19 | ⚠️ **P7 H-Bar / P6 KPI Tower** (fabricated data will be spotted) |
| 4 equal-weight items | P19 Four Cards / P6 (if data) | Don't pad it up to 6 just to use P4 |
| 6 equal-weight items | P4 Six Cells / P16 Brief | Don't squeeze it down to 4 just to use P19 |
| 3 equal-weight items | P5 Sub-cards / P13 Three Forces | |
| Before/After | P8 Duo Compare (must be exactly 2 items) | |
| Place/route/city relations | S08 + Swiss Map Component | Plain S04/S16 card grids |
| Loop structure | P14 Loop Diagram | P11 horizontal process (linear ≠ loop) |
| Three-layer nesting | P17 System Diagram | |
| Time evolution (with data) | P2 Vertical Timeline | |
| Multi-step process (no data) | P11 Horizontal Timeline | |
| 8-12 same-type items | P15 Image Matrix | |
| Deck closing | P9 Closing (no more than once per deck) | |
| 1 hero image + one explanation | P23 Swiss Image Split | P22 (unless the image is the protagonist AND has KPIs) |
| 2-3 same-type images | P24 Evidence Grid | P4/P16 (text cards, not image evidence) |

**Landmine case**: using P7 H-Bar Chart for a concept list like "smart autocomplete / real-time collaboration / autonomous agents" that has **no comparable percentages**, then fabricating numbers like 96/88/78 → **the data isn't credible and the layout is misused**. Such content belongs in P2 (if there's a time dimension) or P3 Statement (if it's a claim).

---

## Common mistakes (P0 checklist)

1. ❌ Adding `border-radius` to cards → ✅ must be right angles
2. ❌ Adding a stroke on `.card-accent` → ✅ card fill types are mutually exclusive
3. ❌ Hand-drawing SVG icons → ✅ use the `lucide` online library, angular style
4. ❌ Aligning timeline dots to the dashed axis with grid `justify-self` → ✅ fixed 12px axis column + absolutely-positioned dot
5. ❌ Big type without a height cap (`13vw`) → ✅ always dual-constrain with `min(Xvw, Yvh)`
6. ❌ ESC index thumbnails can't see animated content → ✅ add a visibility override CSS to the cloned slide
7. ❌ Same fade-up recipe on every page → ✅ one semantic recipe per page, coupled to the graphic
8. ❌ Title + card spacing < 5vh → ✅ section-level titles at least 9vh
9. ❌ 9px circular dots → ✅ 8×8 right-angle squares / mono `t-meta` text
10. ❌ Decorative elements crossing the page margin → ✅ strictly inside the grid, never flush to an edge
