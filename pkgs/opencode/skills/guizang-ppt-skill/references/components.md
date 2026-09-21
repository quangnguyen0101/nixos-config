# Component Reference · Components

This is the component manual for the `guizang-ppt-skill` skill. All styles are already defined in template.html; this document only covers "what each component looks like and how to use it".

## Table of Contents

- [Basic Slide Shell](#basic-slide-shell)
- [Typography](#typography)
- [Chrome & Foot](#chrome--foot)
- [Callout Quote Box](#callout-quote-box)
- [Stat Number Grid](#stat-number-grid)
- [Platform Card](#platform-card)
- [Rowline Table Row](#rowline-table-row)
- [Pillar Card](#pillar-card)
- [Tag & Kicker](#tag--kicker)
- [Figure Image Frame](#figure-image-frame)
- [Icons](#icons)
- [Ghost Oversized Background Text](#ghost-oversized-background-text)
- [Highlight Marker](#highlight-marker)
- [Motion System](#motion-system)

---

## Basic Slide Shell

Every page is a `<section class="slide ...">`. It must carry a `data-theme` attribute (`light` or `dark`) — the paging JS switches the background based on this attribute.

```html
<section class="slide light" data-theme="light">   <!-- light slide -->
<section class="slide dark" data-theme="dark">     <!-- dark slide -->
<section class="slide light hero" data-theme="light">  <!-- Hero slide: light + thin mask letting the WebGL show through -->
<section class="slide dark hero" data-theme="dark">    <!-- Hero slide: dark + thin mask -->
```

**light vs dark usage: alternate** — switch themes every 2–3 slides and avoid more than 3 consecutive slides of the same color. On paging, the WebGL background automatically cross-fades between the two shaders.

**hero usage**: only for visually dominant slides (cover, quote page, act divider, closing). Adding `hero` drops the mask to 12–16%, letting the WebGL background show through strongly, so don't put too much text on hero slides.

---

## Typography

Font roles are the most important rule in this template. Mixing them is forbidden.

| Class | Purpose | Font |
|---|---|---|
| `.display` | Extra-large English (hero slides) | Playfair Display 700, 11vw |
| `.display-zh` | Extra-large Chinese title | Noto Serif SC 700, 7.8vw |
| `.h1-zh` | Page main title | Noto Serif SC 700, 4.6vw |
| `.h2-zh` | Subtitle | Noto Serif SC 600, 3.2vw |
| `.h3-zh` | Pipeline step title | Noto Serif SC 500, 1.9vw |
| `.lead` | Lead paragraph (larger than body) | Noto Serif SC 400, 1.9vw |
| `.body-zh` | **Body/description (sans-serif)** | Noto Sans SC 400, 1.22vw |
| `.body-serif` | Body (serif) | Noto Serif SC 400, 1.3vw |
| `.kicker` | Section cue (above the heading) | IBM Plex Mono, 12px uppercase |
| `.meta` | Metadata tag | IBM Plex Mono, 0.88vw uppercase |
| `.big-num` | Oversized number | Playfair Display 800, 10vw |
| `.mid-num` | Mid-size number | Playfair Display 700, 5.5vw |

**Core rules**:
- **Serif** (`serif-zh` / `serif-en`): headings, key quotes, numbers — for "visual accent"
- **Sans-serif** (`sans-zh`): body copy, long reading passages — for "information density"
- **Mono** (`mono`): the English labels in kicker, meta, and foot — for "decorative rhythm"

**Emphasis tricks**:
- `<em class="en">english-word</em>` — renders an English word in Playfair Display italic (looks great)
- `<em style="opacity:.65">phrase</em>` — fades out the tail half of a heading to create rhythm

---

## Chrome & Foot

The metadata bars at the top and bottom of each slide. Almost every slide should have them.

```html
<div class="chrome">
  <div class="left">
    <span>Act I · Hard Data</span>
    <span class="sep"></span>
    <span>Act I</span>
  </div>
  <div class="right"><span>02 / 27</span></div>
</div>

<!-- ... slide body ... -->

<div class="foot">
  <div class="title">Project · CodePilot　|　github.com/codepilot</div>
  <div>Act I · Dev Numbers</div>
</div>
```

**Rules**:
- `chrome.right` always holds the page number `NN / TOTAL` (TOTAL = total slides)
- `foot.title` is the Chinese description, `foot.right` is the English act marker
- chrome and foot together form the magazine-style "masthead and footer"

---

## Callout Quote Box

Shows a key quote / core takeaway / someone else's quotation.

```html
<div class="callout" style="max-width:80vw">
  <div class="q-big">"Three years ago,<br>this needed a ten-person team for a year."</div>
  <span class="cite">— One observer's judgment</span>
</div>
```

Variants:
- Without a cite: just drop the `<span class="cite">`
- With an English quote: `<em class="en">"Thin Harness, Fat Skills."</em>`
- On hero slides: add `style="position:relative;z-index:2"` on the wrapper (so the background mask doesn't cover it)

---

## Stat Number Grid

Shows data metrics; commonly paired with `.grid-6` / `.grid-4`.

```html
<div class="grid-6">
  <div class="stat">
    <span class="m">Duration</span>
    <span class="n">64<em style="font-size:.4em;opacity:.5;font-style:normal"> days</em></span>
    <span class="l">From 0 to now</span>
  </div>
  <!-- ... more stats ... -->
</div>
```

Three-part structure: `.m` mono small label → `.n` oversized number → `.l` description. Units after the number are shrunk with `<em>` to 0.4em at opacity 0.5.

**Common layout containers**:
- `.grid-6` — 3×2 grid (most common, 6 stats)
- `.grid-4` — 2×2 grid (4 stats)
- `.grid-3` — 3 equal columns in one row (3 stats / pillars)

---

## Platform Card

Shows a social platform / channel + follower count.

```html
<div class="plat">
  <div class="sub">Weibo</div>
  <div class="name">Weibo</div>
  <div class="nb">289K</div>
</div>
```

Optional fourth row (supplementary note):
```html
<div class="body-zh" style="font-size:max(11px,.8vw);opacity:.5;margin-top:.6vh">
  Includes Little Green Book sync
</div>
```

**"Also On" variant** (additional platforms):
```html
<div class="plat" style="border-top-style:dashed;opacity:.72">
  <div class="sub">Also On</div>
  <div class="body-zh" style="font-weight:600;margin-top:.8vh">
    Bilibili　·　Zhihu
  </div>
</div>
```

---

## Rowline Table Row

List-style content, one entry per row.

```html
<div class="rowline">
  <div class="k">CLAUDE.md</div>
  <div class="v">How you should work —— behavior rules + work preferences + don'ts</div>
  <div class="m">EMPLOYEE · HANDBOOK</div>
</div>
```

Three-column structure: `.k` serif keyword · `.v` body description · `.m` mono label (right-aligned). The first and last rowlines automatically get top/bottom borders.

**Variant: 2 columns**: `style="grid-template-columns:1fr 3fr"` drops the `.m` column.

---

## Pillar Card

Three-pillar structure, commonly used for "parallel concepts" pages.

```html
<div class="grid-3">
  <div class="pillar">
    <div class="ic">01</div>
    <div class="t">Three-layer<br>document system</div>
    <div class="d">CLAUDE.md<br>+ project knowledge base<br>+ guardrail files</div>
  </div>
  <!-- ... more pillars ... -->
</div>
```

**Pillar with an icon (for emphasis pages)**:
```html
<div class="pillar" style="padding:4vh 2vw;border:1px solid currentColor;border-color:rgba(10,10,11,.2)">
  <div class="ic"><i data-lucide="compass" class="ico-lg"></i></div>
  <div class="t">Judgment</div>
  <div class="d">The authority on decisions and direction.<br>Trade-offs, taste, a sense of direction.</div>
</div>
```

`.ic` can be a sequence number (`01 / 02 / 03` or `A. / B. / C.`) or a Lucide icon.

---

## Tag & Kicker

**Kicker** is the small cue text above the heading (mono, all caps, small size):
```html
<div class="kicker">Last 64 Days · Dev Chapter</div>
<div class="h1-zh">One person, what did they do.</div>
```

**Tag** is a standalone pill label (bordered):
```html
<div style="display:flex;gap:1.6vw;flex-wrap:wrap">
  <div class="tag">Up at 10 AM</div>
  <div class="tag">Gym Tue / Thu afternoons</div>
  <div class="tag">Shows & games at night as usual</div>
</div>
```

---

## Figure Image Frame

**This is the most failure-prone component in this template — you MUST follow the rules below.**

### Basic structure

```html
<figure class="tile">
  <div class="frame-img" style="height:26vh">
    <img src="images/xxx.png" alt="Description">
  </div>
  <figcaption class="frame-cap">
    <span class="pf">Twitter</span>
    <span class="nb">137K</span>
  </figcaption>
</figure>
```

### Key constraints (hard-won lessons — don't violate)

1. **Image grids must use a fixed `height:Nvh`** — never `aspect-ratio`.
   - Reason: aspect-ratio inside a grid easily overflows the parent container and stacks the images.
   - Recommended sizes: `.h-16` (small panels) / `.h-18` (compact bars) / `.h-22` (standard grid) / `.h-26` (featured) / `.h-28` (large image).
   - A single hero image can use the template's ratio classes: `.r-16x9` / `.r-16x10` / `.r-4x3` / `.r-3x2` / `.r-3x4` / `.r-1x1`.
   - Images in the same group must share one height class — don't mix a `25vh` with a `21vh`.

2. **`object-position:top center` (already set in the CSS)** — only the bottom may be cropped.
   - Cropping left/right or the top is forbidden — that's the image's core identity zone.

3. **For multiple images in a grid, use an inline grid instead of `grid-3`**:
   ```html
   <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:1vh 1.2vw">
     <figure class="tile">...</figure>
     <figure class="tile">...</figure>
     <figure class="tile">...</figure>
   </div>
   ```

4. **Align images with the rest of the layout**: use the `.grid-2-7-5` / `.grid-2-6-6` / `.grid-2-8-4` grid structures to align to the top naturally. Don't add `align-self:end` to images.

5. **Infographics / redesigned screenshots**: add `.fit-contain` to the `.frame-img` at the same time so in-image text and annotations aren't cropped.

6. **When the user's original screenshot has a bad aspect ratio**: prefer the CleanShot X–style programmatic adaptation per `screenshot-framing.md`; only regenerate a "screenshot redesign / UI scenario image" when the screenshot is too long, too narrow, or needs its information restructured.

### Frame caption variants

```html
<!-- standard: figure name left, number right -->
<figcaption class="frame-cap">
  <span class="pf">Twitter</span>
  <span class="nb">137K</span>
</figcaption>

<!-- numbered -->
<figcaption class="frame-cap">
  <span class="idx">01</span>
  <span class="pf">AI Polish</span>
  <span>Polish</span>
</figcaption>
```

### Image placeholders (placeholders during design)

While the image isn't ready, use a dashed placeholder box:
```html
<div class="img-slot r-4x3">  <!-- r-4x3 / r-16x9(default) / r-3x2 / r-1x1 -->
  <span class="plus">+</span>
  <span class="label">GitHub Screenshot Slot</span>
</div>
```

---

## Icons

**Emoji is forbidden.** Use Lucide via CDN (already included in template.html).

```html
<i data-lucide="compass" class="ico-lg"></i>     <!-- large icon (for pillars) -->
<i data-lucide="target" class="ico-md"></i>      <!-- medium icon (for list items) -->
<i data-lucide="check-circle" class="ico-sm"></i>  <!-- small icon (for inline use) -->
```

**Common Lucide icon names** (grouped by meaning):

- Judgment: `compass`, `target`, `crosshair`, `search-check`
- Relations: `share-2`, `users`, `network`, `link`, `handshake`
- Brand/quality: `crown`, `gem`, `award`, `star`, `badge-check`
- Process: `workflow`, `route`, `arrow-right-left`, `repeat`
- Data: `grid-2x2`, `bar-chart-3`, `trending-up`, `activity`
- Aesthetics: `palette`, `brush`, `eye`, `sparkles`
- Yes/no: `check-circle`, `x-circle`, `check`, `x`
- Direction: `arrow-right`, `arrow-up-right`, `corner-down-right`

**Inline icon + text combo**:
```html
<div class="h3-zh" style="display:flex;align-items:center;gap:.8em">
  <i data-lucide="target" class="ico-md"></i>
  Judgment — what's worth writing
</div>
```

---

## Ghost Oversized Background Text

Used as decorative background lettering at very low opacity to create a magazine feel.

```html
<div class="ghost" style="right:-6vw;top:-8vh">BUT</div>
<div class="ghost" style="left:-8vw;bottom:-18vh;font-style:italic">Harness</div>
```

- Font size 34vw, opacity 0.06
- Common positions: `right:-6vw;top:-8vh` (overflow top right) / `left:-8vw;bottom:-18vh` (overflow bottom left)
- Content: English words or numbers (act numbers 01/02/03, keywords like BUT/NOW/HERE)

**Note**: on pages using ghost, other content needs `position:relative;z-index:2` so it isn't pushed underneath.

---

## Highlight Marker

The "highlighter" effect for inline phrases:

```html
<span class="hi">Not</span>
<span class="hi">One big burst</span>
```

Renders a translucent highlight bar under the text. Dark themes get a light bar, light themes a dark one (handled in CSS).

**When to use**: only on 1–3 key words; don't apply broadly.

---

## Motion System

The whole deck has page-entry animations on by default, driven by Motion One (the vanilla version of Framer Motion, ~4KB).

### Loading

The module script at the bottom of `assets/template.html` first tries the **local** `assets/motion.min.js`, falls back to the **jsdelivr CDN**, and if both fail, forces every element with `data-anim` to `opacity:1` — content stays readable, and the presentation never depends on the network.

```js
// core loader in the template (don't modify)
let motion;
try { motion = await import('./assets/motion.min.js'); }
catch(e1) {
  try { motion = await import('https://cdn.jsdelivr.net/npm/motion@11.11.17/+esm'); }
  catch(e2) {
    document.querySelectorAll('[data-anim]').forEach(el=>{el.style.opacity='1';el.style.transform='none'});
  }
}
```

### Driven by data attributes

You only need to add two kinds of attributes in the HTML:

```html
<!-- 1. pick a recipe on the <section> (optional; defaults to cascade, auto for hero) -->
<section class="slide light" data-animate="quote">

<!-- 2. add data-anim to elements that should animate in (values: left/right/line/step/divider) -->
<h1 class="h-xl" data-anim>Big Title</h1>
<div class="stat-card" data-anim>...</div>
<div data-anim="left">Left-column content</div>
<span data-anim="line" style="display:block">Quote line one</span>
```

### The 5 recipes at a glance

| recipe | Trigger | Behavior | Representative layout |
|---|---|---|---|
| `cascade` (default) | This is the value when `data-animate` is omitted | All `data-anim` fade in one by one with a stagger of 75ms/step | Layout 3 / 4 / 5 / 10 |
| `hero` | `.hero` slides use this automatically | Slower, more ceremonial stagger at 160ms/step | Layout 1 / 2 / 7 |
| `quote` | `data-animate="quote"` | Other elements come first, then lines with `data-anim="line"` are revealed one by one at 550ms intervals | Layout 8 |
| `directional` | `data-animate="directional"` | `data-anim="left"` slides in from the left → divider → `data-anim="right"` slides in from the right | Layout 9 |
| `pipeline` | `data-animate="pipeline"` | Steps stay at 15% opacity on this page; →/space/scroll lights them up one by one, and advancing only unlocks after the last step | Layout 6 |

### Decision tree for choosing a recipe per slide

1. **Is it a `.hero` slide?** → Don't add `data-animate`; it uses `hero` automatically
2. **Is it a big quote page?** → `data-animate="quote"`, each line as `<span data-anim="line" style="display:block">`
3. **Is it a side-by-side Before/After?** → `data-animate="directional"`, left column `data-anim="left"`, right column `data-anim="right"`
4. **Is it a pipeline walk-through?** → `data-animate="pipeline"`, each step `data-anim="step"`
5. **All other content pages** → Add nothing; `cascade` is used automatically

### Which elements should get `data-anim`?

- ✅ Blocks with independent meaning at each level: kicker / h1 / h-xl / lead / callout / stat-card / figure / tag / rowline
- ✅ Each column in a multi-column layout, so they fade in column by column instead of together
- ❌ Don't add it to containers (`.grid-6` / `.frame`); only to leaf elements
- ❌ Don't add it to every `<li>`; adding it at the `<ul>` level is usually enough
- ❌ If a slide wants no animation (e.g., a transition slide), simply don't add `data-anim` anywhere on it — Motion One only affects marked elements

### FAQ

- **Image flashes before appearing?** That's expected — the animation fires mid-page-turn (at 450ms)
- **Pipeline page stuck and won't advance?** That's correct — press → to light each step one by one; page-turn only happens after all steps are lit
- **Content not showing even when static?** Check that motion.min.js is under `assets/`; or look at the console for errors