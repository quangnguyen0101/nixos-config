# Screenshot Beautification Semantic Rules

Used to turn the user's product screenshots, web screenshots, code screenshots, and design-filing screenshots into image assets that fit the template's ratios. The target is a CleanShot X-style "centered screenshot + filled background + uniform ratio", rather than having GPT-M 2.0 redraw every screenshot by default.

## Priority

1. **Programmatic adaptation first**: when screenshot content, text, or UI details must stay faithful, don't redraw — create a canvas at the target ratio, scale the original screenshot proportionally, and place it in the canvas.
2. **GPT-M 2.0 only for restructuring**: use "screenshot redesign / UI scenario" only when the original is too long, too narrow, too messy, or needs UI scenario-ization or conceptual expression.
3. **Template slots first**: determine the slide layout and image slot ratios first, then decide the screenshot adaptation parameters.

## Ask Before Starting

In Step 1 of the main flow, as long as the user is likely to provide screenshots, ask first:

- Which folder are the screenshots in? Do they include web pages, apps, code, dashboards, design files, or old PPTs?
- Does this batch need **faithful display**, **uniform beautification**, **redesign into UI scenario images**, or a mix?
- Which slots will they go into: 21:9 top strip, 16:10 main image, 4:3 side image, 1:1 square, or a multi-image grid?
- Must all text and data be preserved? Do sensitive items like accounts, avatars, or project names need to be hidden?
- Should the composition be centered, top-left, bottom-right, or auto-decided from the page content?

In Claude Code, use Ask Question / `ask_question` for these clarifications; in Codex, ask in a normal conversation and do not call Ask Question.

## Processing Chain

1. **Match a layout first**: pick a template layout from the content, and pin down the screenshot slot size and ratio.
2. **Then choose the treatment**:
   - Keep faithful: programmatic adaptation, don't redraw the screenshot.
   - Unify the look without changing content: programmatic adaptation + theme background.
   - Original unusable or a concept needs explaining: go through GPT-M 2.0 screenshot redesign.
3. **Then choose a background**: prefer the built-in background assets; don't generate a one-off style per screenshot.
4. **Finally compose the screenshot**: create a canvas at the target ratio, cover-fill the background, then place the proportionally scaled screenshot at the given `padding` and `alignment`.

By default, don't crop screenshot content. Only when the screenshot has already been re-generated for the target slot, or the user explicitly allows cropping, use cover cropping.

## Semantic Parameters

Before processing a screenshot, settle these 7 parameters:

| Parameter | Choices | How to decide |
|---|---|---|
| `ratio` | `21:9` / `16:10` / `16:9` / `4:3` / `1:1` | follow the template's image slot, not the original screenshot's ratio |
| `background` | `plain` / `gradient` / `wallpaper` / `blurred` / `grid` / `paper` | follow the current PPT style and theme |
| `padding` | `compact` / `standard` / `spacious` | standard for normal screenshots; spacious for text-dense or tall screenshots; compact for small screenshot groups |
| `inset` | `none` / `subtle` / `balanced` | balanced when the screenshot needs to float off the background; Swiss style mostly uses none/subtle |
| `shadow` | `none` / `soft` / `editorial` | Style A may use soft/editorial; Style B defaults to none |
| `corners` | `square` / `small` / `medium` | Style B uses square; Style A uses small/medium |
| `alignment` | `center` / `top-left` / `top-right` / `bottom-left` / `bottom-right` | follow page composition, not always center |

## Style Mapping

### Style A · E-magazine style

- Background: `paper` / `blurred` / low-saturation `gradient`
- Texture: paper, ink, film grain, warm white, low contrast
- Screenshot: a small corner radius and a light shadow are fine, but don't make it look like a SaaS marketing card
- Background assets: prefer the theme-matched 16:9 crop-safe WebP under `assets/screenshot-backgrounds/style-a/`; crop it to the slot when composing
- Recommended semantics:

```text
ratio:16:10, background:paper, padding:standard, inset:balanced, shadow:editorial, corners:small, alignment:center
```

### Style B · Swiss International Style

- Background: `plain` / `grid` / `dot-matrix`
- Color: the current anchor color may be used only as very low-share emphasis; no large bright color blocks
- Screenshot: right angles, no shadow, no corner radius, with a few hairlines or a top accent line
- Background assets: prefer the theme-color-matching 16:9 crop-safe WebP under `assets/screenshot-backgrounds/style-b/`; use only the current accent, never mixed colors
- Recommended semantics:

```text
ratio:21:9, background:grid, padding:standard, inset:subtle, shadow:none, corners:square, alignment:center
```

## Background Intensity Rules

The screenshot background is a "mat", not the hero visual.

- If `alignment` is uncertain, the center and all four corners of the background must stay quiet — no prominent color blocks.
- If the screenshot sits in the bottom-right, the bottom-right must hold no strong color block; likewise for other positions.
- Swiss-style anchor colors appear only as `5%-8%` visual-share thin lines, dot matrices, or very subtle geometry — never bright blue bars, large color blocks, or neon gradients.
- The background must have no text, logo, icon, person, device, border, obvious subject, or directional composition.
- The background must be crop-safe: cropping to `21:9`, `16:10`, `4:3`, or `1:1` must not reveal any "cropped" seam.

## Built-In Theme Background Assets

This Skill ships a set of GPT-M 2.0 pre-generated backgrounds. When processing screenshots, **prefer these assets** — don't call GPT-M 2.0 live to regenerate a background. Generate a new background only when the user explicitly asks for a new style, the current theme has no matching asset, or the background clearly mismatches the content.

A background image is afterwards reused programmatically across every screenshot. Don't design a background as a single slide — a background image must not contain titles, footers, borders, logos, people, or obvious subjects.

### Style A · 5 theme backgrounds

| Theme | Built-in asset | Background semantics |
|---|---|---|
| Monocle Classic | `assets/screenshot-backgrounds/style-a/monocle-classic.webp` | black-white-gray paper texture, soft shadows, fine grain |
| Indigo Porcelain | `assets/screenshot-backgrounds/style-a/indigo-porcelain.webp` | low-saturation indigo ink, paper-feel gradient, slight noise |
| Forest Ink | `assets/screenshot-backgrounds/style-a/forest-ink.webp` | blurred plant shadows, low-saturation green, paper grain |
| Kraft Paper | `assets/screenshot-backgrounds/style-a/kraft-paper.webp` | warm paper color, faint ink shadows, vintage print grain |
| Dune | `assets/screenshot-backgrounds/style-a/dune.webp` | soft sand/gray gradient, low contrast, quiet whitespace |

### Style B · 4 theme backgrounds

| Theme color | Built-in asset | Background semantics |
|---|---|---|
| IKB blue | `assets/screenshot-backgrounds/style-b/ikb-dot-gradient.webp` | dot matrix + low-contrast blue gradient, avoid bright blue color blocks |
| Lemon yellow | `assets/screenshot-backgrounds/style-b/lemon-grid.webp` | clean grid + sparse dot matrix, yellow only as low-opacity thin lines/dots |
| Lemon green | `assets/screenshot-backgrounds/style-b/lemon-green-dot-shadow.webp` | dot matrix + shadow field, green only as a slight glow |
| Safety orange | `assets/screenshot-backgrounds/style-b/safety-orange-halftone.webp` | modular halftone dots + dark shadows, orange in low share |

All built-ins are 16:9 WebP at 1920×1080 level. When composing programmatically, first cover the background onto the target canvas, then crop to screenshot slots like `21:9` / `16:10` / `4:3` / `1:1`. The background must keep all four corners quiet, because the screenshot may be centered, top-left, bottom-right, or cropped to different sizes.

## Screenshot Type Decisions

| Raw material | Recommended treatment |
|---|---|
| Ordinary web / app / desktop screenshot | programmatic adaptation to the target ratio |
| Product UI details matter | programmatic adaptation with `fit-contain`, don't redraw |
| Long web-page screenshot | clip the key region or split into 2-3 same-size panels |
| Extremely narrow / extremely tall screenshot | try `spacious + side alignment` first; restructure only if still too small |
| Code screenshot | paper-feel background for Style A; light grid background for Style B; text must stay readable |
| UI scenario image for concept explanation | may be redesigned with GPT-M 2.0 |

## Background Image Generation Prompts

Use this section only when new background assets are needed. For routine screenshot beautification, don't generate backgrounds live — use the built-in assets above.

### Style A background

```text
16:9 crop-safe screenshot background for an editorial magazine / e-ink PPT system. Warm off-white paper texture, subtle ink wash, fine film grain, low contrast, quiet center and quiet corners, no text, no logo, no objects, no border, no focal subject. Suitable for cropping to 21:9, 16:10, 4:3, or 1:1.
```

### Style B background

```text
16:9 crop-safe screenshot background for a Swiss International Style PPT system. Pure off-white base, ultra-subtle 16-column grid and sparse dot matrix, one accent color only: [theme color], used at very low opacity as thin lines or tiny dots, no large bright color blocks. Quiet center and quiet corners, no text, no logo, no objects, no border, no focal subject. Suitable for cropping to 21:9, 16:10, 4:3, or 1:1.
```