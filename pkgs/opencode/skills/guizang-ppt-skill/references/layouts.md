# Page Layout Library (Layouts)

This document collects the 10 most commonly used page layout skeletons. Each is a complete, copy-paste-ready `<section class="slide ...">...</section>` code block — swap in your own copy/images and use it directly.

---

## ⚠️ Read Before Generating (Pre-flight)

### A. Class names must come from template.html

All classes used in layouts.md (`h-hero` / `h-xl` / `h-sub` / `h-md` / `lead` / `meta-row` / `stat-card` / `stat-label` / `stat-nb` / `stat-unit` / `stat-note` / `pipeline-section` / `pipeline-label` / `pipeline` / `step` / `step-nb` / `step-title` / `step-desc` / `grid-2-7-5` / `grid-2-6-6` / `grid-2-8-4` / `grid-3-3` / `grid-6` / `grid-3` / `grid-4` / `frame` / `frame-img` / `img-cap` / `callout` / `callout-src` / `kicker`) are predefined in the `<style>` block of `assets/template.html`.

**Do not invent new class names.** If you must customize, write inline `style="..."`. If you're unsure a class exists before generating, grep template.html to confirm.

### B. Image aspect-ratio rules (very important)

**Always use standard ratios**, never the original image's odd ratio like `aspect-ratio: 2592/1798`:

| Scene | Recommended ratio | Usage |
|------|---------|------|
| Main image, text left / image right | 16:10 or 4:3 | `.frame-img.r-16x10` or `.frame-img.r-4x3` |
| Image grid (multi-image comparison) | Uniform | `.frame-img.h-22` / `.frame-img.h-26`, no aspect-ratio |
| Small panel groups | Uniform | `.frame-img.h-16` / `.frame-img.h-18`, same height within a group |
| Small image left + text right | 1:1 or 3:2 | `.frame-img.r-1x1` or `.frame-img.r-3x2` |
| Fullscreen hero visual | 16:9 | `.frame-img.r-16x9` |
| Infographic / screenshot redesign | 16:9 or 16:10 | `.frame-img.r-16x9.fit-contain` or `.frame-img.r-16x10.fit-contain` |
| Mixed text + image small illustrations | 3:2 or 3:4 | `.frame-img.r-3x2` or `.frame-img.r-3x4` |

Images must be wrapped in `<figure class="frame-img">`. By default, photos get `object-fit:cover + object-position:top center`, cropping only the bottom, never top/left/right. Infographics and screenshot redesigns must add `.fit-contain` so text or annotations are never cropped.

### B2. Vertical alignment of images and content

Images should align with the body content area rather than defaulting to flush with the top of the big title. Especially on text-left/image-right pages and mixed text+image pages:

- If the left column is kicker + big title + body + callout, the right-column image usually starts at body height; give the image `style="margin-top:7vh"` up to `9vh`
- If the image is an infographic or UI scenario shot, align it with the first body line or the caption text, not flush with the top of the oversized title
- If a screenshot/UI scenario shot becomes a very long strip on a landscape page, don't force it full width; either swap in an extra-wide image, or split it into 2-3 partial panels arranged side by side
- Multi-image panels must use the same height class — don't mix `h-16` / `h-22` or hand-write different `height` values

### B3. Spacing between title and body

- Two-part pages (title on top + long body/quote/chart below) must leave clear spacing between title and content; recommend `margin-top:6vh` to `8vh`
- Centered-big-title pages must horizontally center the main title, using `.center` or `text-align:center; margin-inline:auto`
- Complex-content pages (big title + subheadings + detailed content) must separate the big title from what's below; lay the lower content out on a left-right aligned grid or rowline instead of stacking everything on a single center axis

### C. Image positioning guidelines (avoid images piling at the very bottom of the page or being hidden behind the browser toolbar)

**Wrong approaches** (already tripped up on — don't repeat):
- Using `align-self:end` in a non-grid container: `align-self` has zero effect outside flex/grid, so the image falls to the end of the document flow and piles up at the bottom
- Using `position:absolute + bottom:0` to "pin" the image to the bottom: it gets covered by the bottom `.foot` and `#nav` dots
- Writing only `height:N vh` on a single image with no `max-height`: it overflows the viewport on low-resolution screens

**Correct approach**:
- Mixed text+image pages **must use the grid structure `.frame.grid-2-7-5`** (or `.grid-2-6-6` / `.grid-2-8-4`)
- Grid containers default to `align-items:start` (already set in the template), so images naturally sit at the top of the cell
- If you want the image bottom-aligned with the left column's callout: **left column uses flex column + `justify-content:space-between`** (letting the callout sit at the left column's bottom), **the right-column figure just stays at align-items:start** — don't add `align-self:end`
- All grid parent containers should get inline `style="padding-top:6vh"` to give the title area breathing room

### D. Theme color and theme rhythm

- Pick theme colors from the 5 presets in `references/themes.md`; custom hex values are not allowed
- Theme rhythm (whether each page uses light / dark / hero light / hero dark) has hard rules in the "Theme rhythm planning" section below — read before generating
- Decide both before picking layouts, to avoid rework

### E. Motion system (on by default · Motion One driven)

**Core mechanism**: the module script at the bottom of template.html triggers entrance animations on page turn. All elements with `data-anim` start invisible and are faded in one by one by Motion One when the page becomes current.

**Motion strategy**: add `data-animate="<recipe>"` to the `<section>` to choose an animation style; add `data-anim` to each element that needs an entrance animation (optionally with a value like `left` / `right` / `line` / `step`).

| recipe | Usage | Best for |
|---|---|---|
| default (cascade) | Add nothing; auto cascading fade-in | Most content pages (Layout 3 / 4 / 5 / 10) |
| `hero` | Enabled automatically on `.hero` pages; slower, more ceremonial rhythm | Layout 1 / 2 / 7 (all hero pages) |
| `quote` | Reveal one line at a time; slow rhythm (550ms stagger) | Layout 8 big quote |
| `directional` | Enter from left → split → enter from right, for comparison | Layout 9 Before/After |
| `pipeline` | Manual advance; light up step by step with →/Space | Layout 6 pipeline |

**Fallback safety**: if both the local and CDN copies of motion.min.js fail to load, the script forces all `data-anim` elements to `opacity:1`, so content is always readable.

**Pages that need no motion**: if a page should skip motion entirely, just don't add any `data-anim` — Motion One only affects marked elements.

---

## 0. Base structure (same for every slide)

```html
<section class="slide [light|dark|hero light|hero dark]">
  <div class="chrome">
    <div>Context Label · Sub-label</div>
    <div>ACT · Page / Total</div>
  </div>
  <!-- main content -->
  <div class="foot">
    <div>Page Note · Page Description</div>
    <div>— · —</div>
  </div>
</section>
```

- Non-hero pages should carry a `light` or `dark` theme; hero pages carry `hero light` or `hero dark` (participates in the WebGL theme interpolation)
- `chrome` and `foot` are optional but recommended four-corner metadata
- **Hero pages are for chapter covers/openings/closings/transitions**; non-hero pages are for body content

### ⚠️ chrome and kicker must not say the same thing

This is the most common content-duplication problem. The two live on entirely different semantic axes:

| Position | Role | Nature of content | Example |
|------|------|---------|------|
| `.chrome` top-left | **magazine header / navigation metadata** | a stable "column name" or "chapter category", may repeat across pages | "Act II · Workflow" / "Data · Result" / "lukew.com · 2026.04" |
| `.chrome` top-right | **page number + act** | fixed format | "Act II · 15 / 25" |
| `.kicker` | **this page's one-of-a-kind lead line** | the "small prefix" of the big title, like the line above a magazine headline; should differ per page | "BUT" / "One person, what did they do." / "Phase 01 · Design Phase" |

**Counterexample** (already tripped up on): chrome writes "Design First" and the kicker writes "Phase 01 · Design Phase" — the meaning repeats, and readers instantly sense it was AI-generated.

**Correct approach**: chrome is a **column label** (stable, reusable across pages), the kicker is **this page's hook** (short, dramatic); the two complement each other rather than translating each other.

### ⚠️ Theme rhythm planning (must-read · do before generating)

**Core mechanism**: every page's `<section>` must carry one of `light` / `dark` / `hero light` / `hero dark`. The JS infers the theme from the class and decides whether the body gets `light-bg`, which controls which of the two dark/light WebGL canvases sits in front. No theme or a custom name = a broken fallback.

#### Per-layout theme defaults

| Layout | Default theme | Reason |
|---|---|---|
| 1. Opening cover | `hero dark` | Opening ceremony; strong impact on dark |
| 2. Chapter divider | `hero dark` and `hero light` **must alternate** | breathing rhythm |
| 3. Big numbers (data) | `light` | numbers need a paper-white background; may occasionally insert `dark` across multiple acts |
| 4. Text left / image right | **alternate `light` / `dark`** | the main driver of body-copy rhythm |
| 5. Image grid | `light` | screenshots need a bright background |
| 6. Pipeline | `light` | flowcharts need clarity |
| 7. Question page | `hero dark` | strong visual impact by default |
| 8. Big quote | **`dark` preferred**, occasional `light` | a golden line's ceremony comes from a dark background |
| 9. Comparison page | `light` | two columns need clarity |
| 10. Mixed text + image | **alternate `light` / `dark`** | rhythm |

#### Hard rhythm rules (grep self-check after generating)

- ❌ **Forbidden**: more than 3 consecutive pages of the same theme (includes light stacks and dark stacks)
- ❌ **Forbidden**: a deck over 8 pages with no `hero dark` and no `hero light`
- ❌ **Forbidden**: a deck with only `light` content pages and no `dark` content page — it reads flat, with no breathing
- ✅ **Recommended**: insert 1 hero every 3-4 pages (cover / divider / question / big quote)

#### 8-page rhythm template (ready to use)

| Page | Theme | Layout | Note |
|---|---|---|---|
| 1 | `hero dark` | cover | opening |
| 2 | `light` | big numbers | throw hard data |
| 3 | `dark` | text left / image right | comparison / story |
| 4 | `light` | Pipeline | process |
| 5 | `hero light` | chapter divider | breathing |
| 6 | `dark` | text left / image right or big quote | |
| 7 | `hero dark` | question page | suspense closer |
| 8 | `light` | big quote / closing | wrap-up |

**Draw this table and align on it first, then write slides.** Skipping the planning and pasting skeletons directly = a deck of nothing but `light`.

---

## Layout 1: Opening Cover (Hero Cover)

```html
<section class="slide hero dark">
  <div class="chrome">
    <div>A Talk · 2026.04.22</div>
    <div>Vol.01</div>
  </div>
  <div class="frame" style="display:grid; gap:4vh; align-content:center; min-height:80vh">
    <div class="kicker" data-anim>Private Meetup · Li Jigang</div>
    <h1 class="h-hero" data-anim>One-Person Company</h1>
    <h2 class="h-sub" data-anim>An Organization Folded by AI</h2>
    <p class="lead" style="max-width:60vw" data-anim>
      An AI creator who wrote 110K lines of code in 64 days and kept publishing across 9 platforms, with barely a shift in daily rhythm.
    </p>
    <div class="meta-row" data-anim>
      <span>Guizang</span><span>·</span><span>Independent creator / CodePilot author</span>
    </div>
  </div>
  <div class="foot">
    <div>A talk about AI · organizations · individuals</div>
    <div>— 2026 —</div>
  </div>
</section>
```

**Key points**:
- Use `hero dark` so the WebGL background shows through most areas
- `h-hero` is the largest size (10vw), used here as the title hero visual
- Use `min-height:80vh + align-content:center` to vertically center the whole content block
- No page number needed in `.chrome`; the cover page stands alone

---

## Layout 2: Chapter Divider (Act Divider)

```html
<section class="slide hero light">
  <div class="chrome">
    <div>Act I · Hard Data</div>
    <div>Act I · 01 / 25</div>
  </div>
  <div class="frame" style="display:grid; gap:6vh; align-content:center; min-height:80vh">
    <div class="kicker" data-anim>Act I</div>
    <h1 class="h-hero" style="font-size:8.5vw" data-anim>Hard Data</h1>
    <p class="lead" style="max-width:55vw" data-anim>
      Numbers first, methods second.
    </p>
  </div>
  <div class="foot">
    <div>Act I Intro</div>
    <div>— · —</div>
  </div>
</section>
```

**Key points**:
- Minimal: just kicker + big title + one intro line
- Covers of two acts can alternate `hero light` / `hero dark` to create rhythm
- The `h-hero` size can be adjusted from 10vw to 8.5vw to fit shorter or longer titles

---

## Layout 3: Big Numbers (Big Numbers Grid)

```html
<section class="slide light">
  <div class="chrome">
    <div>Last 64 Days · Dev Chapter</div>
    <div>Act I / Dev · 02 / 25</div>
  </div>
  <div class="frame" style="padding-top:3vh">
    <div class="kicker" data-anim>One person, what did they do.</div>
    <h2 class="h-xl" data-anim>Last 64 Days</h2>
    <p class="lead" style="margin-bottom:2vh" data-anim>From 0 to open-sourcing CodePilot.</p>

    <div class="grid-6" style="margin-top:2vh">
      <div class="stat-card" data-anim>
        <div class="stat-label">Duration</div>
        <div class="stat-nb">64 <span class="stat-unit">days</span></div>
        <div class="stat-note">From 0 to now</div>
      </div>
      <div class="stat-card" data-anim>
        <div class="stat-label">Lines of Code</div>
        <div class="stat-nb">110K+</div>
        <div class="stat-note">Written line by line to 110K+</div>
      </div>
      <div class="stat-card" data-anim>
        <div class="stat-label">GitHub Stars</div>
        <div class="stat-nb">5,166</div>
        <div class="stat-note">One open-source repo</div>
      </div>
      <div class="stat-card" data-anim>
        <div class="stat-label">Downloads</div>
        <div class="stat-nb">41K+</div>
        <div class="stat-note">Installed on tens of thousands of machines</div>
      </div>
      <div class="stat-card" data-anim>
        <div class="stat-label">AI Providers</div>
        <div class="stat-nb">19</div>
        <div class="stat-note">Cross-platform integrations</div>
      </div>
      <div class="stat-card" data-anim>
        <div class="stat-label">Commits</div>
        <div class="stat-nb">608+</div>
        <div class="stat-note">No collaborators</div>
      </div>
    </div>
  </div>
  <div class="foot">
    <div>Project · CodePilot　|　github.com/codepilot</div>
    <div>Act I · Dev Numbers</div>
  </div>
</section>
```

**Key points**:
- A 3×2 or 4×2 grid is most stable (see `.grid-6`)
- Each `stat-card` has a fixed structure: label (small English text) → nb (big-number value) → note (annotation)
- Keep numbers to 2-3 characters (longer ones overflow); use K / M shorthand
- **Do not increase the spacing**: the skeleton's defaults of `padding-top:3vh` + lead `margin-bottom:2vh` + grid `margin-top:2vh` are the measured upper limit for a 3×2 grid that doesn't press the foot on a 16:9 screen; when you need more content, cut cards first rather than compressing foot space

---

## Layout 4: Text Left, Image Right (Quote + Image)

```html
<section class="slide light">
  <div class="chrome">
    <div>Identity Contrast · The Twist</div>
    <div>03 / 25</div>
  </div>
  <div class="frame grid-2-7-5" style="padding-top:6vh">
    <!-- Left column: title + body + callout; flex column keeps the callout at the bottom -->
    <div style="display:flex; flex-direction:column; justify-content:space-between; gap:3vh">
      <div>
        <div class="kicker" data-anim>BUT</div>
        <h2 class="h-xl" style="white-space:nowrap; font-size:7.2vw" data-anim>
          I'm not a programmer.
        </h2>
        <p class="lead" style="margin-top:3vh" data-anim>
          Not a single line of code since graduation. The last ten years were all UI design and AI effects.
        </p>
      </div>
      <div class="callout" data-anim>
        "Three years ago, this<br>
        needed a ten-person team for a year."
        <div class="callout-src">— One observer's judgment</div>
      </div>
    </div>
    <!-- Right column: standard 16/10 ratio + max-height; no align-self:end -->
    <figure class="frame-img r-16x10" data-anim>
      <img src="images/codepilot.png" alt="CodePilot product screenshot">
      <figcaption class="img-cap">CodePilot · Screenshot</figcaption>
    </figure>
  </div>
  <div class="foot">
    <div>Page 03 · I'm Not a Programmer</div>
    <div>— · —</div>
  </div>
</section>
```

**Key points**:
- Use `grid-2-7-5` (7 parts left, 5 parts right); `align-items:start` is preset in the template
- **Left column**: flex column + `justify-content:space-between` — title sits at the top, callout naturally at the bottom
- **Right-column image**: **do not add `align-self:end`**. It slides the image down to the bottom of the cell, where the browser toolbar covers it on low-res screens
- Images must use the **standard ratio classes `.r-16x10` or `.r-4x3`**, not the original image's odd ratio (like `2592/1798`)

---

## Layout 5: Image Grid (multi-image comparison)

```html
<section class="slide light">
  <div class="chrome">
    <div>Follower Evidence</div>
    <div>Act I / Ops · 05 / 27</div>
  </div>
  <div class="frame" style="padding-top:3vh">
    <div class="kicker" data-anim>Proof · Follower Evidence</div>
    <h2 class="h-xl" data-anim>10 Platforms · 6 Screenshots</h2>

    <div class="grid-3-3" style="margin-top:3vh">
      <figure class="frame-img" style="height:26vh" data-anim>
        <img src="images/weibo.png" alt="Weibo 289K">
        <figcaption class="img-cap">Weibo · 289K</figcaption>
      </figure>
      <figure class="frame-img" style="height:26vh" data-anim>
        <img src="images/twitter.png" alt="Twitter 137K">
        <figcaption class="img-cap">Twitter · 137K</figcaption>
      </figure>
      <figure class="frame-img" style="height:26vh" data-anim>
        <img src="images/wechat.png" alt="WeChat Official 96K">
        <figcaption class="img-cap">WeChat Official · 96K</figcaption>
      </figure>
      <figure class="frame-img" style="height:26vh" data-anim>
        <img src="images/jike.png" alt="Jike 26K">
        <figcaption class="img-cap">Jike · 26K</figcaption>
      </figure>
      <figure class="frame-img" style="height:26vh" data-anim>
        <img src="images/xhs.png" alt="Xiaohongshu 19K">
        <figcaption class="img-cap">Xiaohongshu · 19K</figcaption>
      </figure>
      <figure class="frame-img" style="height:26vh" data-anim>
        <img src="images/douyin.png" alt="Douyin 10K">
        <figcaption class="img-cap">Douyin · 10K</figcaption>
      </figure>
    </div>
  </div>
  <div class="foot">
    <div>Screenshot Date · 2026.04</div>
    <div>Page 05 · Follower Evidence</div>
  </div>
</section>
```

**Key points**:
- Critical: every `frame-img` must hard-code `height:NNvh` (not `aspect-ratio`), or the grid breaks
- Images get `object-fit:cover + object-position:top` automatically, cropping only the bottom
- **Captions live inside the frame**: `figcaption.img-cap` renders along the inner bottom edge of the fixed-height frame (the template handles the elastic shrink) and adds no outside height; with a caption, the image actually shows at ≈ NNvh − 4vh
- Use `.grid-3-3` (3×2) or `.grid-3` (3×1) to carry them
- For a 3×2 two-row grid with captions, `height:26vh` is the upper limit before pressing the foot; drop to `22vh` when the title is longer or a description line is added

---

## Layout 6: Two-Column Pipeline

```html
<section class="slide light" data-animate="pipeline">
  <div class="chrome">
    <div>My Workflow</div>
    <div>Act II · 15 / 27</div>
  </div>
  <div class="frame">
    <div class="kicker">Pipeline</div>
    <h2 class="h-xl">Two Pipelines</h2>

    <!-- Group 1: text side -->
    <div class="pipeline-section">
      <div class="pipeline-label">Text · Text Pipeline</div>
      <div class="pipeline">
        <div class="step" data-anim="step">
          <div class="step-nb">01</div>
          <div class="step-title">Draft</div>
          <div class="step-desc">AI drafts my first draft</div>
        </div>
        <div class="step" data-anim="step">
          <div class="step-nb">02</div>
          <div class="step-title">Polish</div>
          <div class="step-desc">AI polishes the AI flavor out</div>
        </div>
        <div class="step" data-anim="step">
          <div class="step-nb">03</div>
          <div class="step-title">Morph</div>
          <div class="step-desc">AI morphs into Twitter / Xiaohongshu posts</div>
        </div>
        <div class="step" data-anim="step">
          <div class="step-nb">04</div>
          <div class="step-title">Illustrate</div>
          <div class="step-desc">AI generates infographics</div>
        </div>
        <div class="step" data-anim="step">
          <div class="step-nb">05</div>
          <div class="step-title">Distribute</div>
          <div class="step-desc">One-click distribution to 9 platforms</div>
        </div>
      </div>
    </div>

    <!-- Group 2: video side -->
    <div class="pipeline-section">
      <div class="pipeline-label">Visual · Video Side · Video Pipeline</div>
      <div class="pipeline">
        <div class="step" data-anim="step">
          <div class="step-nb">06</div>
          <div class="step-title">Cut</div>
          <div class="step-desc">AI helps me edit</div>
        </div>
        <div class="step" data-anim="step">
          <div class="step-nb">07</div>
          <div class="step-title">Wrap</div>
          <div class="step-desc">AI helps me package</div>
        </div>
        <div class="step" data-anim="step">
          <div class="step-nb">08</div>
          <div class="step-title">Cover</div>
          <div class="step-desc">AI generates the cover</div>
        </div>
      </div>
    </div>
  </div>
  <div class="foot">
    <div>Page 15 · My Content Factory</div>
    <div>Workflow</div>
  </div>
</section>
```

**Key points**:
- Group with `.pipeline-section` + `.pipeline-label` as the group title
- Between groups: 3.6vh spacing + a thin top divider (already preset in CSS)
- Each step has the fixed nb → title → desc structure
- Step count is unlimited, but keep a single row at ≤5; otherwise split into a second pipeline
- **Motion**: add `data-animate="pipeline"` to `<section>` and `data-anim="step"` to each `.step`. On this page, steps default to `opacity:.15`; each →/Space/scroll-down lights up one step; **only when every step is lit does the deck advance to the next page**, which creates presentation interactivity

---

## Layout 7: Suspense Closer / Question Page (Hero Question)

```html
<section class="slide hero dark">
  <div class="chrome">
    <div>A Question Left for You</div>
    <div>24 / 27</div>
  </div>
  <div class="frame" style="display:grid; gap:8vh; align-content:center; min-height:80vh">
    <div class="kicker" data-anim>The Question</div>
    <h1 class="h-hero" style="font-size:7vw; line-height:1.15">
      <span data-anim style="display:block">In your company,</span>
      <span data-anim style="display:block">which roles were never</span>
      <span data-anim style="display:block">meant for humans?</span>
    </h1>
    <p class="lead" style="max-width:50vw" data-anim>
      This isn't a technical question — it's an architecture question.
    </p>
  </div>
  <div class="foot">
    <div>Page 24 · The Question</div>
    <div>— · —</div>
  </div>
</section>
```

**Key points**:
- The more whitespace on a hero page the better — just one question
- Adjust the `h-hero` size by length (7vw suits 3 lines, 10vw suits 1 line)
- Use `<br>` for manual line breaks so breakpoints land at semantic points
- Optionally end with one `lead` line as the reveal

---

## Layout 8: Big Quote Page (Big Quote · serif golden line)

```html
<section class="slide light" data-animate="quote">
  <div class="chrome">
    <div>The Takeaway · Core Wisdom</div>
    <div>18 / 25</div>
  </div>
  <div class="frame" style="display:grid; gap:5vh; align-content:center; min-height:80vh">
    <div class="kicker" data-anim>Quote</div>
    <blockquote style="font-family:var(--serif-zh); font-weight:700; font-size:5.8vw; line-height:1.2; letter-spacing:-.01em; max-width:72vw">
      <span data-anim="line" style="display:block">"No handoff,</span>
      <span data-anim="line" style="display:block">everyone builds."</span>
    </blockquote>
    <p class="lead" style="max-width:55vw; opacity:.65" data-anim>
      Without the handoff, everyone builds.<br>
      And that makes all the difference.
    </p>
    <div class="meta-row" data-anim>
      <span>— Luke Wroblewski</span><span>·</span><span>2026.04.16</span>
    </div>
  </div>
  <div class="foot">
    <div>Page 18 · Golden Line</div>
    <div>— · —</div>
  </div>
</section>
```

**Key points**:
- Full-page whitespace, just one big quote + attribution
- Enlarge `<blockquote>` alone via inline style (5-6vw); don't use `h-hero` (that name is reserved for the page's main title)
- Follow below with the English original (lead · opacity:.65) to create hierarchy
- Pair with `meta-row` for attribution · date

---

## Layout 9: Side-by-Side Comparison (A vs B · Old vs New)

```html
<section class="slide light" data-animate="directional">
  <div class="chrome">
    <div>Old vs New · The Shift</div>
    <div>12 / 25</div>
  </div>
  <div class="frame" style="padding-top:5vh">
    <div class="kicker" data-anim>Before / After · Paradigm Shift</div>
    <h2 class="h-xl" style="margin-bottom:4vh" data-anim>From Handoff to Co-building</h2>

    <div class="grid-2-6-6" style="gap:5vw 4vh">
      <!-- Left column: old -->
      <div data-anim="left" style="padding:3vh 2vw; border-left:3px solid currentColor; opacity:.55">
        <div class="kicker" style="opacity:.9">Before · Old Mode</div>
        <h3 class="h-md" style="margin-top:2vh">Design → Dev → Handoff</h3>
        <ul style="margin-top:3vh; padding-left:1.2em; display:flex; flex-direction:column; gap:1.4vh; font-family:var(--sans-zh); font-size:max(14px,1.1vw); line-height:1.55">
          <li>Designers mock up in Figma</li>
          <li>Devs translate pixels from the file</li>
          <li>PR ping-pong to align</li>
          <li>Non-technical people can't touch code</li>
        </ul>
      </div>
      <!-- Right column: new -->
      <div data-anim="right" style="padding:3vh 2vw; border-left:3px solid currentColor">
        <div class="kicker" style="opacity:.9">After · New Mode</div>
        <h3 class="h-md" style="margin-top:2vh">Same Tools · Parallel · Co-building</h3>
        <ul style="margin-top:3vh; padding-left:1.2em; display:flex; flex-direction:column; gap:1.4vh; font-family:var(--sans-zh); font-size:max(14px,1.1vw); line-height:1.55">
          <li>Three roles work in Intent at once</li>
          <li>agents.md as shared context</li>
          <li>Agents handle alignment / conflicts / animation</li>
          <li>Anyone can safely contribute code</li>
        </ul>
      </div>
    </div>
  </div>
  <div class="foot">
    <div>Page 12 · Paradigm Shift</div>
    <div>Before / After</div>
  </div>
</section>
```

**Key points**:
- Use `.grid-2-6-6` (1:1) to split left/right in half
- Left column's `opacity:.55` visually de-emphasizes "old"; the full-brightness right column highlights "new"
- Both columns use `border-left:3px solid` + `padding-left` for a blockquote feel
- Keep each column's structure uniform: `kicker` → `h-md` → `<ul>` bullet list, consistent rhythm

---

## Layout 10: Mixed Text + Image (Lead Image + Side Text)

```html
<section class="slide light">
  <div class="chrome">
    <div>Design First</div>
    <div>08 / 16</div>
  </div>
  <div class="frame grid-2-8-4" style="padding-top:6vh">
    <!-- Left column: long body text + quote -->
    <div>
      <div class="kicker" data-anim>Phase 01 · Design Phase</div>
      <h2 class="h-xl" style="margin-top:1vh; margin-bottom:3vh" data-anim>Design First · 2 Weeks</h2>

      <p class="lead" style="margin-bottom:3vh" data-anim>
        Visual exploration and a design system in Figma — grids / typography / color variables / reusable components, a few feedback rounds on desktop and mobile mocks.
      </p>

      <p data-anim style="font-family:var(--sans-zh); font-size:max(14px,1.15vw); line-height:1.75; opacity:.78; margin-bottom:2.4vh">
        Within two weeks the visual style, rough structure, and directional content all stabilized. A solid traditional design process — nothing new here yet.
      </p>

      <div class="callout" style="margin-top:3vh" data-anim>
        "This phase was pretty standard.<br>Just a solid Web design process."
        <div class="callout-src">— Luke Wroblewski</div>
      </div>
    </div>
    <!-- Right column: supporting image · portrait or square -->
    <figure class="frame-img r-3x4" data-anim>
      <img src="images/figma.png" alt="Figma design system">
      <figcaption class="img-cap">Figma · Design System</figcaption>
    </figure>
  </div>
  <div class="foot">
    <div>Page 08 · Design First</div>
    <div>About 2 Weeks</div>
  </div>
</section>
```

**Key points**:
- `.grid-2-8-4` (8:4) makes body text dominant, with the image as support
- The left column holds several information levels: kicker → big title → lead → body paragraph → callout (quote)
- The right-column image uses **portrait 3:4** or square 1:1, so it doesn't compete with the left text for attention
- This layout suits **information-dense pages** (unlike Layout 4, which holds a single golden line)

---

## Appendix: Common grid templates

| Class | Ratio | Use |
|---|---|---|
| `.grid-2-6-6` | 6:6 (1:1) | split in half |
| `.grid-2-7-5` | 7:5 | text-primary + supporting image |
| `.grid-2-8-4` | 8:4 (2:1) | long text + small image/data |
| `.grid-3` | 1:1:1 | 3 items side by side (cases/screenshots) |
| `.grid-3-3` | 3×2 | 6-image matrix |
| `.grid-6` | 3×2 | 6 data cards |

All grids reserve `gap: 3vw 4vh` (3vw horizontal, 4vh vertical), overridable individually.

---

## Page rhythm suggestions

For a 25-30 page talk, the following rhythm is recommended:

1. **Hero Cover** (page 1)
2. **Act Divider** (opens Act I, hero light or hero dark)
3. **Big Numbers** (throw hard data for impact)
4. **Quote + Image** (identity contrast / hook)
5. **Image Grid** (evidence support)
6. **Hero Question** (closes the act, leaves suspense)
7. ... Acts II, III follow the same rhythm ...
8. **Hero Close** (final page, question or thanks)

Hero and non-hero pages should interleave at roughly **2-3 : 1**; never run more than 3 consecutive non-hero pages, and never more than 2 consecutive hero pages.