# Quality Checklist

This checklist comes from the real iteration process of the "One-Person Company" deck. Every item was learned the hard way, ordered by importance.

Read it through once before generating a deck; after generating, self-check every item.

---

## 🔴 P0 · Mistakes That Must Never Happen

### 0-P. Presenter Mode Must Be Controllable, Rehearsable, Recoverable, Notes Never Leak Across Slides

**Symptom**: the presenter side has advanced, but the audience screen still sits on the previous slide; closing the audience window gives no notice; after a reflow the user's edited script lands on a different slide; or the presenter-mode entry becomes an abrupt button in the page's top-right corner.

**Do**:
- The presenter entry lives only in the existing shortcut control area at the bottom right, labeled `P Presenter Mode`.
- The presenter body is only two columns, "preview on the left + notes on the right"; the current slide on top, the next slide below, avoiding a three-column layout that crushes the current slide.
- Both preview iframes must strictly stay `16:9`; when the container is too small, scale down proportionally with margins — never crop or stretch; on small screens shrink the next-slide preview height first.
- The bottom bar is fixed as "time on the left, controls in the middle, page progress on the right": the left groups show elapsed / current slide / remaining or overtime, the middle two rows hold paging and session controls, the right shows only page number and percentage — do not repeat the current slide's title. Session controls use explicit action names like "Start Timer / Resume Timer / Reset Timer / Rehearse", not bare "Start" or "Reset".
- Paging order is always `Home / Prev / Next / End`; on the last slide the final button becomes "Restart". Auto-advance lives in the top-right status bar.
- `Grid` sits beside the current slide's title; opening it replaces the current/next preview area, and picking a slide returns to the preview — do not pop an abrupt fullscreen overview.
- The right card shows, in order, the title, this slide's purpose, and draft notes; settings toggles use capsule switches and the time interval uses a polished plus/minus stepper.
- The audience screen must show the pipeline status: `connecting / synced / not synced / not connected / pop-up blocked`, and always offer "Reopen Audience Screen".
- The presenter must see total duration, this slide's duration, and planned/remaining/overtime; when `minutes` is missing show a dash, never guess.
- When a newly added slide has no matching notes, the UI fallback shows only `—`, not "to be filled"; the validator must still report the slide/note count mismatch.
- Rehearse mode records each slide's real duration, keeping the last 5 runs locally; it only aggregates data, it does not score like an AI coach.
- Auto-advance is off by default; `minutes` and `autoAdvanceSeconds` must stay separate; the countdown must pause on overview, marquee, settings, hidden slides, or when the audience screen pauses or desyncs.
- Laser pointer, marquee, clear, black screen, white screen, and freeze/resume must all be provided; annotation coordinates must be normalized and synced to the audience screen.
- The preview iframes load once; paging syncs via `postMessage`; on the last slide the next-slide preview shows "Presentation Over", not a repeat of the current slide.
- Exiting must handle `bye`: windows the script opened close themselves, and when they cannot, show "Presentation Ended"; on heartbeat timeout show "Not Connected" instead of staying forever on "Not Synced".
- The pre-talk check must cover the audience screen, popups, fullscreen, fonts, images/video, and 16:9; it must also clearly warn that it cannot detect physical cables.
- In notes, `section / cue / interaction / delivery / advance / fallback / pronunciation / autoAdvanceSeconds` are all optional fields; if the user's outline lacks them, hide that whole block.
- Every slide needs a stable, unique `data-slide-id`; the `SPEAKER_NOTES` count, order, and IDs must match every slide.
- Local note edits save by slide ID; switching slides resets the scroll position and shows the save state.
- The browser can only confirm whether the audience page is in sync, not the physical HDMI/projector cable; on site you still check the external screen by sight.

**Check**:

```bash
node <SKILL_ROOT>/scripts/validate-presenter-mode.mjs path/to/index.html
```

In the browser, close the audience window and confirm the state change; then click "Reopen Audience Screen" and confirm it returns to the presenter's current slide. Then test, item by item: the inline grid picker return, timer, rehearsal, auto-advance pause/resume, laser pointer, marquee, clear, black screen, white screen, freeze, settings widgets, and pre-talk check. Shrink the browser window and check again: current and next slides still stack vertically, both iframes' `width / height` are still about `16 / 9`, and nothing overflows the preview container.

### 0-S. Swiss locked mode: content pages must come from the original 22P

**Symptom**: colors and fonts look Swiss, but the title sits in the middle, images are off the grid, and the page structure shares nothing with the original 22P.

**Root cause**: the generator treated Swiss as a style pack and freely combined new P23/P24/self-drawn SVG pages instead of picking from the 22 registered layouts of the original reference PPT.

**Do**:
- Read `references/swiss-layout-lock.md` first
- Content pages may only use `S01-S22`; new cover/closing pages may only use `SWISS-COVER-ASCII` / `SWISS-CLOSING-ASCII`
- Every `<section class="slide">` must carry `data-layout="Sxx"`
- After generating, you must run:

```bash
node <SKILL_ROOT>/scripts/validate-swiss-deck.mjs path/to/index.html
```

**The validator blocks**:
- Unregistered layouts / missing `data-layout`
- P23/P24 experiment structures
- Visible text written in SVG
- S22 images not bound to `s22-hero-21x9`
- S22 photos using `object-position:top center`

### 0-S-2. Swiss top title defaults to the top left, not centered

**Symptom**: the top Chinese title sits in the middle of the page, like a self-made poster and nothing like the original PPT.

**Do**:
- Except for statement/split layouts like `S03/S09/S10`, the top title must hug the original template's top-left content axis.
- Do not put the small title in the left column and the big title in the large right column, which visually centers the title.
- If you need a title + note two-column header, copy the original `S11` or `S17` skeleton — do not hand-write `4fr 8fr`.

### 0-S-3. Swiss map pages must use the S08 Map Component

**Symptom**: place/history content only draws a simple SVG map, without real pins, relation cards, zoom/drag controls, or the wheel triggering a PPT page turn.

**Do**:
- Use `data-layout="S08"`.
- Read `references/swiss-map-component.md` first.
- The right map component must include marker dots, connection lines, place cards, and `+` / `-` / `DRAG` controls.
- Scroll zoom and drag pan are disabled by default; dragging is allowed only after the user clicks `DRAG`.
- Keep the static fallback: still readable when the map CDN or tiles fail.

**Check**:
- `grep -n "data-map-ctrl" index.html`
- `grep -n "maplibregl.Map" index.html`
- In the browser, `+` actually zooms in and `DRAG` toggles to `DRAG ON`

### 0-S-4. Swiss display sizes must not shrink past legibility + the weight ladder must hold

**Symptom**: the Swiss page structure is fine, but captions, notes, timelines, KPI notes, and small card text are unreadable when projected; or 16px small text uses weight 300 and becomes too thin.

**Do (size floor)**:
- Body paragraphs / main notes ≥ `18px`
- Card descriptions / lists / timeline notes / captions / figure notes ≥ `16px`
- meta / kicker / mono label / chart labels ≥ `14px`
- When content overflows, first cut copy, split into more slides, or switch to another Sxx layout — do not cram in 10/11/12/13px small text.

**Do (weight ladder ⭐)**:
Swiss style insists "bigger is thinner, smaller is heavier"; size and weight must run an inverse ladder:
- ≥ 8vw → weight **200** (ExtraLight)
- 4-7.9vw → weight **200-300**
- 1.8-3.9vw → weight **300-400**
- 1-1.7vw / 16-20px → weight **400-500**
- 13-15px → weight **500-600**
- Within one page, a smaller element's weight must be ≥ a larger element's weight.
- **Small text around 16px must never use weight 300** (too thin to read); the floor is 400, recommend 500.
- Emphasis inside cover/IKB inverted huge titles uses `italic + weight 300`, not the accent color.

**Check**:
- `rg -n "font-size:(10px|11px|12px|13px)|max\\((9|10|11|12|13)px" index.html`
- `rg -n "font-weight:(300)" index.html | rg -v "min\(|h-xl|h-hero|h-statement|num-mega|kpi-thin|name-mega|8vw|9vw|1[1-9]vw|cover-|\.multi"` — check whether weight 300 landed on a small font size
- View the browser at 100% zoom: bottom note, captions, timeline labels, card descriptions still read at a glance.

### 0-A. Swiss canvas alignment law (check every page · most-often-trodden)

**Symptom**: the `chrome-min` header and the bottom footer both sit on the 5vw edge, but the middle area indents inward, so left/right don't align.

**Root cause**: `.canvas-card` already carries `padding:5.6vh 5vw 4.4vh`. If you add `padding:5vh 5vw 4vh` again on the body area, the horizontal direction becomes `5vw + 5vw = 10vw`, so the body indents 5vw more than `chrome-min`.

**Do**:
- The body layer keeps `padding:0`; control vertical spacing only through grid `gap`
- The gap between `chrome-min` and the body comes from `.chrome-min{margin-bottom:48px}` — do **not** stack `margin-top` / `padding-top` on top of the body
- Split mode is the exception: `.slide.split .canvas-card{padding:0}`, and each `.half` sets its own `padding:5.6vh 3.6vw 4.4vh`

```html
<!-- ❌ Wrong: the body indents 5vw extra, left/right misalign -->
<div class="canvas-card">
  <div class="chrome-min">...</div>
  <div style="flex:1;padding:5vh 5vw 4vh;...">body</div>
</div>
<!-- ✅ Right -->
<div class="canvas-card">
  <div class="chrome-min">...</div>
  <div style="flex:1;padding:0;display:grid;grid-template-rows:auto 1fr auto;gap:3vh">body</div>
</div>
```

**Self-check command**: `grep "padding:.*5vw" index.html`. If a `padding:Xvh 5vw Yvh` hits a direct child of `canvas-card`, it's wrong (`.half` / decorative layers excepted).

### 0-B. Swiss head area: kicker must sit "above" the big title (not side by side)

**Symptom**: the small title (`.t-meta` / `.t-cat`) and the big title are squeezed onto one line — a lump of small text on the left, a lump of big text on the right, and the head loses hierarchy.

**Root cause**: `grid-template-columns:auto 1fr` presses two elements that should stack vertically into two side-by-side columns.

**Do**:
```html
<!-- ❌ Wrong -->
<div data-anim="head" style="display:grid;grid-template-columns:auto 1fr;gap:3vw;align-items:end">
  <div class="t-meta">METHODOLOGY · 03</div>
  <h2 class="h-xl-zh">Why N+1</h2>
</div>
<!-- ✅ Right -->
<div data-anim="head" style="display:flex;flex-direction:column;gap:1.4vh">
  <div class="t-meta">METHODOLOGY · 03</div>
  <h2 class="h-xl-zh">Why N+1</h2>
</div>
```

Exception: when one head row carries both "left: kicker + big title (stacked)" and "right: a small footnote", the outer layer may use `display:grid;grid-template-columns:1fr auto`, but the **inner** layer must stay a flex column.

### 0-B-2. Swiss cover / closing default: fullscreen IKB + ASCII breathing field + white weight 200 (mandatory)

**Symptom**: the cover uses a `slide light` white background + black text + a giant "01" — while the chrome badge already reads `01 / 07`, so the screen shows two "01"s, visually redundant; a white background is too plain and entirely lacks the "hello" ceremony of an opening.

**Root cause**: an older version of layouts-swiss.md recommended a left-ink + right-paper spread by default; in practice this gets written as "white background + big black type + big number", losing the opening impact of IKB, the signature color.

**Do** (Swiss style mandatory):
- **The cover forces `<section class="slide accent">`** (fullscreen IKB), never `slide.light`, never `slide.dark`; insert `<canvas class="ascii-bg">` as the **first child** inside `.canvas-card` (ASCII breathing field; the template's built-in IIFE activates it automatically)
- **Do not write a big "01" number anymore**: `.chrome-min` already shows `01 / N`; a giant "01" on the cover is redundant repetition — delete it
- **Emphasis words must use italics**: `font-style:italic;font-weight:300`, **never** `color:var(--accent)` — IKB blue on IKB blue is invisible to the eye, so no emphasis reads at all
- **The closing forces `slide.split`** with two half screens: the left half `.half.b-accent` + an ASCII canvas (a color loop back to the cover), the right half paper-white with 3 takeaways; **the 03rd item** is colored with `var(--accent)`, closing the "open full IKB ↔ close half IKB" color loop
- The ASCII canvas already gets `mix-blend-mode:screen;opacity:.92` preset in the template's `<style>`; don't touch that value
- Cover/closing main-title size has a double constraint: `min(11.6vw,19vh)` ~ `min(8vw,14vh)` (respects the Y ≥ X × 1.6 rule)

**Self-check commands**:
- `grep -c "ascii-bg" index.html` — cover + closing should hit ≥ 2 (one canvas each)
- `grep -E '"slide accent"' index.html | head -1` — the cover should be `slide accent`, not `slide light`
- `grep "color:var(--accent)" index.html` — if a hit line also contains `font-style:italic`, that's a danger signal (blue on blue); change it to italic-only without accent; the only legal `var(--accent)` use is the closing "03 takeaway" (there the background is white)
- Eyes-on: open the page and look for a giant "01" etc. on the cover — delete it if present

### 0-C. Swiss big-type double constraint: in `min(Xvw, Yvh)`, Y ≥ X × 1.6

**Symptom**: on a standard 16:9 screen (MacBook 13/14/16, common monitors), the title comes out noticeably smaller than intended and the whole slide looks empty or shrunk.

**Root cause**: 1vw : 1vh ≈ 1.78. If you write `min(7vw, 10vh)`, on a 16:9 screen 7vw = 12.46vh and gets clipped to the 10vh cap, shrinking the type by 20%.

**Do**: quick reference of recommended values
| Use | Recommended |
|---|---|
| h-hero giant statement | `min(11.6vw, 19vh)` |
| h-xl section title | `min(7vw, 12vh)` ~ `min(7.4vw, 13vh)` |
| big-number KPI | `min(8.4vw, 14vh)` |
| mid numbers / indexes | `min(4.6vw, 8.5vh)` ~ `min(5.6vw, 10vh)` |
| subtitle | `min(7.6vw, 13vh)` |

**Self-check command**: `grep -E "font-size:min\([0-9.]+vw,\s*[0-9.]+vh\)" index.html`; eyeball every hit's X/Y, and enlarge any Y/X below 1.6.

### 0-D. Swiss image mixing: right angles, equal height, evidence only

**Symptom**: images look like ordinary PPT illustrations with rounded corners, shadows, and chaos of ratios; multiple screenshots have different heights, or GPT-M 2.0 generations carry their own titles/footers that duplicate the page chrome.

**Root cause**: in Swiss style an image is not decoration but an evidence block inside the grid. If you don't pick the original layout and image slot first, you stuff arbitrary images into the page.

**First decide the image's role**:
- Evidence screenshots, UI, code, dashboards: fidelity first — key text and data must not be cropped; when a uniform ratio is needed, first build a screenshot background canvas and use `.fit-contain`.
- Infographics/illustrations already generated for a slot: fill the S22/S15/S16 target ratio — do not shrink them into small pictures again.
- Photos/product shots/people: must state the `object-position` explicitly; the subject must not be cropped or covered by a title block or caption.
- Text over images: first check there is enough quiet zone; without low-detail whitespace, do not lay a title over the image.
- Multi-image groups: unify ratio, height, container style, and caption density; don't force images with different visual roles into one group.

**Do**:
- Pick the layout first: one big image + KPI uses `S22`; multiple images adapt the original `S15/S16` grid skeletons
- S22 generated images are fixed at `21:9` and the `<img>` carries `data-image-slot="s22-hero-21x9"`
- Photos default to `object-position:center 35%` or `center center` — never `top center`, which beheads people
- Image containers only use `.frame-img`; **no** `border-radius` / `box-shadow`
- UI / infographics / flowcharts that are the user's raw screenshots or text-dense use `.fit-contain`; if already regenerated for the slot, fill the container with the matching ratio class such as `.frame-img.r-21x9` — never shrink the image with a fixed short height again
- Images in one group must share slot, ratio, and height — don't mix
- The user's raw screenshots should first read `references/screenshot-framing.md`: prefer the built-in theme backgrounds of `assets/screenshot-backgrounds/` plus programmatic scale/margins/alignment — do not redraw screenshot content just to unify ratios
- Screenshot backgrounds must follow the current theme color and crop to `21:9` / `16:10` / `4:3` / `1:1`; the background must contain no title, footer, border, logo, person, or obvious subject
- GPT-M 2.0 prompts must state: Swiss Style, a single accent, right angles, no gradients/shadows/rounded corners, no header/footer/title/chrome

- Text over image / fullscreen hero must first pass a quiet-zone check: at least about 30% low-detail area to carry the title; if it fails, change the image, the crop, or split into side-by-side columns — do not slap a full-page black/white overlay

**Self-check commands**:
- `grep -E "frame-img.*border-radius|box-shadow" index.html` — delete any hit
- `grep -n "data-image-slot" index.html` — every local image should declare its slot
- Eyes-on: if the image itself carries a big title, page number, footer, or corner badge, regenerate it first — don't try to crop-save it inside the page
- Eyes-on: the area around a screenshot should be a quiet backdrop, not louder than the screenshot itself; Swiss screenshots must not show rounded corners or drop shadows

### 0-D-2. Swiss bottom page-safe zone: the lowest content must not touch nav

**Symptom**: image captions, footnotes, labels under timelines, and bottom KPIs are hidden behind the pager dots, or visually too close to them.

**Root cause**: `#nav` is fixed at `bottom:2vh`; if the body content hugs the bottom with `align-self:end` / `align-items:end` / `margin-top:auto`, its lowest edge enters the pager region.

**Do**:
- Keep at least `3vh` of breathing room between the main content's lowest edge and the pager
- On image-text pages that need bottom alignment, control the image height first, then add `.nav-safe-bottom` / `.nav-safe-bottom-tight` to the body container
- On other pages that need to hug the bottom, add `.nav-safe-bottom` or `.nav-safe-bottom-tight` to the body container
- Don't hand-write `bottom:2vh` / `bottom:0` for caption text; that fights the nav for space

**Self-check**:
- Visual: flip to the slide; is the last row of caption/label clearly above the pager?
- Code: `grep -E "align-items:end|align-self:end|bottom:0|bottom:2vh|margin-top:auto" index.html`; confirm each hit has a nav safe zone

### 0-D-3. Measure after the fact: quantify overflow and whitespace before changing layout

**Symptom**: a page overflows by only 20-30px, but the fix deletes a large block, leaving a huge empty area below; or the title and body touch, which eyeball checks miss.

**Do**:
- After generating, run `node <SKILL_ROOT>/scripts/validate-swiss-deck.mjs path/to/index.html`
- If Playwright is resolvable in the environment, the validator additionally performs real rendered measurements:
  - `M1 DOM/visual overflow`: measures how many px it overflows and points out the lowest/highest offending elements
  - `M1 bottom whitespace`: measures the bottom whitespace and active content height, so fixing "overflow" doesn't morph into "giant empty gap"
  - `M1 nav-safe`: measures whether the lowest content crosses into the bottom pager safe line
  - `M2 title gap`: measures the distance from the title to the next content block, so the title and body can't stick together

**Overflow fix ladder**:
- `1-40px` over: fine-tune only — shift a content group up or tighten one gap/padding; don't delete content.
- `40-90px` over: compress gaps/paddings locally or reduce one module's height; still prefer keeping content.
- `90-160px` over: lightly compress the title or one body paragraph, then consider splitting the slide.
- `160px+` over: only now consider a higher-capacity layout, merging modules, or deleting content.

**Recheck after fixing**:
- If `M1 bottom whitespace` grew, you over-fixed; restore some spacing, enlarge the last block, or ease the content group back down.
- Each round makes only one tier of adjustment; re-render, then rerun the validator.
- Don't guess with your eyes and a multimodal model first; read the overflow, bottom whitespace, and title gap measurements.

---

### 0-E. Swiss template fidelity guard: the original PPT is the golden source

**Symptom**: the generated page looks Swiss but disagrees with the actual reference PPT in weights, spacing, timelines, and card density; each iteration drifts further from the reference.

**Root cause**: new image layouts or experiment structures were written as global style changes, or original base classes were unintentionally altered — e.g. `.h-hero` / `.h-xl` weights, `.tl-node` column widths, `.duo-compare` spacing.

**Do**:
- The repo's `assets/template-swiss.html` is the golden-source snapshot of the Swiss theme, but trust what **actual pages do**, not unused CSS helpers
- The original pages widely use `font-weight:200` for big titles and `300` for emphasis words/numbers; `.h-hero` / `.h-xl` / `.h-hero-zh` / `.h-xl-zh` must stay light-weight in this template — don't restore 800/900
- Beyond the added cover/closing ASCII mechanism, S22 image-slot fixes, horizontal-timeline label centering fix, and correcting title helpers to their actual light weights, don't touch the original base CSS/JS recipe
- New image capabilities must bind to the original S22/S15/S16 slots; don't invent new content structures
- If you must modify `assets/template-swiss.html`, compare against the original reference first; acceptable diffs are only the ASCII class, S22 image positioning, light-weight title helpers, and known motion fixes

**Self-check commands**:
- Run `compare-swiss-base.mjs` in this test directory and confirm the output shows `missing in template: 0`
- Visually compare the same page type in the original PPT: big-title weights, `chrome-min` position, timeline dots/labels, card density must all match

### 0-F. Double-check visuals + code: don't just read HTML

**Symptom**: the code has the right class names, but the real page is crowded, image-text relations are off, too many optional components stacked, or the layout doesn't fit the content.

**Do**:
- Open the original reference PPT, the current template or generated page, and the test PPT side by side; judge visually first
- Wait for entrance animations to settle before screenshotting or judging — don't mistake an animation intermediate state for missing content
- First open the webpage and go page by page visually: title weights, header spacing, body density, image alignment, nav safe zone
- Then return to the code for structure: the right layout? required components present? optional components overused?
- When comparing to the original PPT, trust the actual render; raw CSS helpers assist but can't replace visual judgment
- Diagnose the source: wrong layout / missing required component / overused optional component / spacing and safe-zone issue
- Generic layouts (S03/S08/S11/S19) can be reused liberally; data-specific ones (S06/S07/S20/S21/S22) need real data or cases; structure-specific ones (S14/S15/S17) need a loop, matrix, or hierarchy relationship
---

### 0. Class-name validation that must pass before generating (most important)

**Symptom**: paste a skeleton from layouts.md straight into new HTML and all styles vanish — big titles turn sans-serif, data wall-of-numbers font becomes body-sized, pipeline pages blur into one lump, images pile up at the browser's bottom.

**Root cause**: if the current template's `<style>` has no definitions for these classes, the browser falls back to default styling.

**Do**:
- **Before generating a deck, you must `Read` the template of the current style**: style A reads `assets/template.html`, style B reads `assets/template-swiss.html`; confirm the classes used by the layouts are all defined
- The most-often-missing classes: `h-hero / h-xl / h-sub / h-md / lead / meta-row / stat-card / stat-label / stat-nb / stat-unit / stat-note / pipeline-section / pipeline-label / pipeline / step / step-nb / step-title / step-desc / grid-2-7-5 / grid-2-6-6 / grid-2-8-4 / grid-3-3 / frame / img-cap / callout-src`
- If a class really is missing, **add it to the template's `<style>`**; don't rewrite it inline on every page
- After generating, open the browser: if you see "big titles are sans-serif" or "pipeline steps squashed into one line", it's almost 100% this problem

### 1. Don't use emoji as icons

**Symptom**: using emoji (🎯 💡 ✅) in the Chinese-magazine style instantly kills the tone.

**Do**: use the Lucide icon library, referenced via CDN:

```html
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
...
<i data-lucide="target" class="ico-md"></i>
...
<script>lucide.createIcons();</script>
```

Common icon names: `target / palette / search-check / compass / share-2 / crown / check-circle / x-circle / plus / arrow-right / grid-2x2 / network`

### 2. Images may only be cropped at the bottom; the left/right and top must never be cut

**Symptom**: stretching the image with `aspect-ratio` makes the grid stack or crop key information when the parent container is too small (e.g. a screenshot's top title bar).

**Do**: use a **fixed height + overflow hidden** on the image container, with `object-fit:cover + object-position:top` on the image:

```html
<figure class="frame-img" style="height:26vh">
  <img src="screenshot.png">
</figure>
```

In the CSS, `.frame-img img` already presets `object-position:top` — crop the bottom only.

**Never use this** (it bursts the container inside a grid):

```html
<!-- Bad example -->
<figure class="frame-img" style="aspect-ratio: 16/9">...</figure>
```

**Exception**: a single hero visual (not inside a grid) may use `aspect-ratio + max-height`, because the parent container cushions it.

### 2b. Bright page + dark WebGL = hazy gray (theme switch didn't apply)

**Symptom**: every light page's background looks veiled in gray, even hero light.

**Root cause**: the JS toggles the two canvases' opacity based on the slide's theme. If the whole deck opens with a hero dark and nothing ever switches the bg to light, `body` never gets the `light-bg` class and `canvas#bg-dark` stays on top.

**Do**:
- In the template, the `go()` function now infers the theme from `classList` (`light` / `dark`), so **slides must explicitly carry a `light` or `dark` class**. Don't omit it, and never use other custom theme names
- Hero pages use `hero light` / `hero dark`, content pages use `light` / `dark`. Writing only `hero` without a theme color is broken
- A deck must contain at least one **non-hero light page**, ensuring `body` gets a chance to add `light-bg`

### 2b-2. The whole deck is all light, no rhythm

**Symptom**: other than a `hero dark` cover, every page defaults to `light` — visually flat, no breathing room, an endless white stretch.

**Root cause**: the layouts.md skeletons default everything to `light`; pasting them unadjusted keeps the whole deck bright.

**Do**:
- **Draw a "theme rhythm chart" before generating**: write clearly which of `hero dark` / `hero light` / `light` / `dark` each page uses, and only then write the code
- **Hard rule**: 3+ consecutive pages of the same theme is not allowed; 8+ pages requires ≥1 `hero dark` + ≥1 `hero light`; can't be all `light` content pages — there must be `dark` content pages
- **Pick the theme by layout** (see "theme rhythm planning" at the top of layouts.md):
  - Text-left image-right (Layout 4), big quote (Layout 8), mixed image-text (Layout 10) → **alternate `light` / `dark`**
  - Wall-of-words, image grid, Pipeline, comparison pages → `light` (screenshots/numbers/flow need a bright base)
  - Cover, question pages → `hero dark`
  - Chapter dividers → alternate `hero dark` with `hero light`
- **Self-check after generating**: `grep 'class="slide' index.html`, confirm by eye that the rhythm alternates

### 2c. chrome and kicker must not say the same thing

**Symptom**: top-left `.chrome` says "Design First", and the same page's `.kicker` says "Phase 01 · Design Phase" — synonymous duplication, smells of AI.

**Do**:
- **chrome = magazine header / navigation label**: can repeat across pages (e.g. "Act II · Workflow", "Data · Result", "lukew.com · 2026.04")
- **kicker = this page's one-of-a-kind lead-in**: short, has a hook, is the "small prefix" of the big title (e.g. "BUT", "One person. What did they do.", "The Question")
- One describes the section, the other describes this page — never translate each other

### 3. Big-title size must not exceed screen width / one character per line

**Symptom**: the Chinese big title's font size is set too large (e.g. 13vw), so each line fits only 1 character and forced wrapping looks terrible.

**Do**:
- `h-hero` (largest): 10vw, **and the title must be ≤ 5 characters**
- `h-xl` (second largest): 6vw-7vw
- Break long titles manually with `<br>`, don't rely on auto-wrap
- Add `white-space:nowrap` when needed

**Example**: "I am not a programmer." uses `h-xl` 7.2vw + nowrap, fitting on one line.

### 4. Font division of labor: serif titles, sans body

**Do**:
- Big titles, key quotes, giant numbers → **serif fonts** (Noto Serif SC + Playfair Display + Source Serif)
- Body, descriptions, pipeline step names → **sans-serif fonts** (Noto Sans SC + Inter)
- Metadata, code, labels → **monospace fonts** (IBM Plex Mono + JetBrains Mono)

All fonts load via Google Fonts CDN, already preset in the template.

### 4b. Images must not hug the bottom with `align-self:end`

**Symptom**: to align the right image column's bottom with the left callout's bottom in a text-left image-right layout, `align-self:end` is added to `<figure>`. The results:
- If the parent isn't a grid (e.g. the class isn't defined), `align-self` does nothing and the image drops to the bottom of the document flow, hidden behind the browser bar
- Even in a grid, the image hugs the bottom of the cell and is still covered by `.foot` and `#nav` dots on short screens

**Do**:
- Image-text mixing **must use `.frame.grid-2-7-5`** (or `.grid-2-6-6`/`.grid-2-8-4`)
- The right column uses `<figure class="frame-img r-16x10">` or `<figure class="frame-img r-4x3">` and naturally sticks to the top
- To make the left callout look "bottom-aligned", give the **left column** a flex column + `justify-content:space-between` — don't touch the right column
- If the image is level with the big title's top but the body starts below the title, add `margin-top:7vh` to `9vh` to the image so it aligns with the body content area

### 4c. Images must not use the original image's odd ratios

**Symptom**: `aspect-ratio: 2592/1798` copied from the original image produces odd whitespace or overflow on different screens.

**Do**: whatever the original ratio, the placeholder always uses a standard ratio **16/10 / 4/3 / 3/2 / 1/1 / 16/9**. The image automatically uses `object-fit:cover + object-position:top` — top never crops, losing a little off the bottom is harmless.

### 5. Don't give images thick borders / shadows

**Symptom**: adding a strong shadow or black frame for "premium feel" instantly becomes corporate PPT.

**Do**: at most a 1-4px slight border radius + **an extremely faint noise** (already in the template). No `box-shadow`, no `border` (except a 1px super-pale gray).

---

## 🟡 P1 · Layout Rhythm

### 6. Hero pages and non-hero pages must alternate

**Recommended rhythm** (25–30 pages):
```
Hero Cover → Act Divider (hero) → 3-4 pages non-hero → Act Divider (hero)
→ 4-5 pages non-hero → Hero Question → ... → Hero Close
```

More than 2 consecutive hero pages tires people out; more than 4 consecutive non-hero pages kills the rhythm.

### 7. Data-banner pages and dense pages must alternate

Big-number pages (big numbers / hero question) and dense pages (pipeline / image grid) should alternate, so the audience's eyes don't tire.

### 8. Keep English/Chinese usage of the same concept consistent

**Symptom**: sometimes writing "Skills", sometimes "skills", sometimes "a thin carrier holds thick skill", inconsistent across the deck.

**Do**:
- Prefer **English terms** (Skills / Harness / Pipeline / Workflow) — these are familiar words to the circle
- **Don't force-translate**, forced translation reads stiff
- Use only 1 spelling of the same word across the whole deck

### 9. Bottom chrome page numbers must be consistent

Use the `XX / total` format (e.g. `05 / 27`). **Don't add a dynamic page number top-right** (it duplicates `.chrome`).

### 9b. Motion system: every page must carry data-anim markers

**Symptom**: after generating, opening in a browser the content just "pops" in on each page turn with no rhythm — the magazine style is held up purely by the layout, missing the ceremony of layered reveal.

**Root cause**: no `data-anim` on any element, Motion One finds nothing to play, the whole page appears statically.

**Do**:
- On every content page, **at least give leaf elements — kicker / main title / lead / callout / stat-card / figure — a `data-anim`**
- **Hero pages** (opening/act-divider/question/ending): all core blocks (kicker + main title + lead + meta-row) get one
- **Pages needing no special recipe**: write nothing, the default cascade already looks good
- **The 4 page types that need a special recipe**: put the matching `data-animate` on `<section>`
  - Big quote → `data-animate="quote"` + each line `<span data-anim="line" style="display:block">`
  - Before/After compare → `data-animate="directional"` + left column `data-anim="left"` + right column `data-anim="right"`
  - Pipeline flow → `data-animate="pipeline"` + every step gets `data-anim="step"`
  - Hero pages (get the hero recipe automatically, but elements still need `data-anim`)

**Self-check**: after generating `grep -c 'data-anim' index.html`, should be dozens+. If only single digits, markers were missed.

### 9c. Pipeline pages must carry data-animate="pipeline"

**Symptom**: a pipeline page fades everything in at once, losing the "step by step" rhythm, but turning to the next page only goes forward, no way back to a previous step.

**Do**: Layout 6's `<section>` must have `data-animate="pipeline"`. During the presentation, →/space/scroll-down **lights up each step one at a time**; only after all steps light up does → turn to the next page. This rhythm is deliberate, not a bug.

---

## 🟢 P2 · Visual Polish

### 10. WebGL background overlay transparency

**dark hero**: overlay 12–15% (WebGL clearly shows through)
**light hero**: overlay 16–20% (WebGL faintly visible, doesn't fight the text)
**normal light/dark pages**: overlay 92–95% (almost opaque)

If the page has very little text (hero question), the overlay can be thinner; if the body is dense, thicken the overlay to guarantee readability.

### 11. Light hero shader must not have a strong center point

**Symptom**: Spiral Vortex, radial ripples are too prominent on the light theme, like a Windows 98 screensaver.

**Do**: light hero uses FBM domain-warp-driven centerless flow, keeping the base color silver/paper (near #F0F0F0 / #FBF8F3), rainbow tint subtle (below 0.05).

### 12. Dark hero allows more visual impact

Dark hero can use center-structured shaders like Holographic Dispersion (titanium-gold dispersion), because a black base can hold more visual information.

### 13. Text-left image-right alignment

- The left text group uses `justify-content:space-between`: title pinned top, quote box pinned bottom
- The right image stays naturally top-aligned, don't add `align-self:end`
- The right image usually aligns with the body content area, not with the big title's top; add `margin-top:7vh` to `9vh` if needed
- The grid overall uses `align-items:start` (not `center` / `end`)

### 13b. Title-to-body spacing

- For the two-part layout of a top title + long article/quote/chart below, there must be clear space between them — recommend `margin-top:6vh` to `8vh`
- Centered big-title pages must center the whole block, not just left-align the text block and place it centered
- Dense-content pages: let the big title set the tone, lay out the content below with grid / rowline flushed both ends; don't squeeze the big title, subhead, and body into one lump

### 13c. Don't stretch UI scenario shots into ultra-long strips

- If a single UI screenshot becomes a long strip when stretched full-width, split it into 2–3 partial panels first
- When fitting multiple panels, give every `.frame-img` the same fixed-height class, e.g. `.h-16` / `.h-18` / `.h-22`, don't cram them into one oversized container
- Images in the same group must be visually the same size; don't mix different heights, zooms, and margin densities
- If full-width is truly needed, generate a horizontal image that's wide enough and state "ultra-wide horizontal strip" explicitly in the prompt

### 13d. Generated illustrations must not carry slide elements

- GPT-M 2.0 generated images are embed material only: the image must not carry its own header, footer, title, page number, corner badge, caption, or decorative border
- Flowcharts/infographics keep only the core graphic and necessary short labels; the PPT takes care of title, footer, and chrome
- If the generated image already has these, regenerate it first; don't stack another chrome layer inside the deck

### 13e. Swiss image-text mixing can't use only one kind

- A 7–8 page Swiss test deck uses at least 6 different S-numbered layouts
- With 2-3 images, use at least two image carriers: S22 hero visual / S15 matrix / S16 patch-sheet / S08 side-by-side compare / S19 four-card evidence
- When text-left image-right or text-right image-left needs bottom alignment, control the image height and the body safe zone first; don't push the whole block near the pager
- White-infographic containers must be white with no outline; don't wrap a white image in a gray frame

### 13f. Swiss Chinese big titles step down a level

- A 2-line Chinese title starts from `min(5.8vw,10.2vh)` by default, not the English page's `6.8vw-7vw`
- When any line has 9-12 Chinese characters, drop to `min(5.2vw,9.2vh)`
- 3-line titles should be rewritten first; don't shrink the content below to keep the title big

### 14. Images' faint corner radius

Style A may have a slight radius. Style B / Swiss must be right-angled: `.frame-img` and the images themselves carry no radius, no shadow, no consumer-app card feel.
---

## 🔵 P3 · Operation Details

### 15. Image paths are relative

Put images in the `images/` folder and reference them in HTML via relative paths like `images/xxx.png`, never absolute paths.

### 16. Page numbers hard-coded in `.chrome`

JS dynamically counts total pages and expands the bottom pager dots, but the `XX / N` in `.chrome` is hard-coded. When adding/removing pages, update N by hand.

### 17. Keep pager navigation

The template supports by default: ← → / wheel / touch swipe / bottom dots / Home·End. Don't delete the navigation logic in the JS.

### 18. Don't hard-set `height:100vh`; use `min-height:80vh`

`100vh` makes content exactly fill the screen, but browser toolbars and tab bars eat some height, causing overflow. `min-height:80vh + align-content:center` is more robust.

---

## 🧪 Final Self-Check List

After generating the deck, check each item against this list:

```
Pre-check (before generating)
  □  Read template.html's <style>, confirm all required classes exist
  □  Chose a Layout (1-10) for every page
  □  Drew a "theme rhythm chart": every page clearly says hero dark / hero light / light / dark
  □  The rhythm chart meets the hard rules: no 3 consecutive same-theme pages / has ≥1 hero dark + ≥1 hero light (8+ pages) / has at least 1 dark content page
  □  <title> changed to the actual deck title (grep "[required]" should return nothing)
  □  Swiss: cover is `slide accent` fullscreen IKB + `<canvas class="ascii-bg">` (not `slide light` white bg)
  □  Swiss: closing is `slide split` + left `b-accent` + ASCII canvas / right paper with 3 takeaways, item 03 uses var(--accent)
  □  Swiss: grep -c "ascii-bg" index.html ≥ 2 (one each on cover + closing)
  □  Swiss: no giant "01" numbering on the cover (chrome already shows 01/N, don't repeat)
  □  Swiss: emphasized words on the IKB background use font-style:italic, never color:var(--accent) (blue on blue)

Content
  □  Each act's page-count ratio is reasonable (no top-heavy imbalance)
  □  No emoji used as icons
  □  Skills / Harness etc. terms used consistently
  □  Every page's kicker + title + body three-tier info is clear

Layout
  □  No big title wraps 1 char per line
  □  Image grids use height:Nvh not aspect-ratio
  □  Images crop only the bottom, top and left/right intact
  □  Serif/sans font division follows the template
  □  Pipeline groups clearly separated

Visual
  □  hero and non-hero pages alternate
  □  WebGL background visible on hero pages
  □  Images have a faint corner radius
  □  No heavy shadows or borders

Interaction
  □  ← → paging works
  □  Bottom dot count matches total pages
  □  chrome page number matches the actual page number
  □  ESC triggers the index view (if kept)
  □  B toggles static/low-power mode, bottom-right hint switches between `B static` / `B dynamic`

Motion
  □  assets/motion.min.js exists (local fallback)
  □  In low-power mode the WebGL/ASCII canvas drops the RAF loop, current page content still fully visible
  □  On page turns content fades in one item at a time, not all at once
  □  Big-quote page <section> carries data-animate="quote", every line <span data-anim="line">
  □  Before/After compare page <section> carries data-animate="directional", left/right columns marked left/right
  □  Pipeline page <section> carries data-animate="pipeline", every step marked data-anim="step"
  □  grep -c 'data-anim' index.html count ≥ pages × 3 (3+ markers per page on average)
```

All boxes checked, and only then is it a qualified deck.
