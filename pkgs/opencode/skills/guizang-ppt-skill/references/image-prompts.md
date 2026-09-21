# GPT-M 2.0 Image Prompt Templates

For generating PPT imagery for this skill in a Codex environment. The prompts only set the tone — don't expand them into long essays. First decide the image slot and ratio, then pick a type.

## General rules

- First determine the deck's style: Style A = editorial magazine × e-ink; Style B = Swiss International / Swiss Style
- Style A tone: editorial magazine × e-ink — restrained, authentic, ample whitespace, suited to landscape web PPTs
- Style B tone: Swiss International Typographic Style — 12/16-column grid, Helvetica/Inter character, a single saturated accent, right-angle solid colors, hairline rules, extreme whitespace
- Text in infographics, charts, and screenshot redesigns must match the user's language: Chinese decks use Chinese, English decks use English
- Don't generate cartoon, 3D, neon-tech, SaaS-template, over-decorated, or fake-logo looks
- Images must leave room for titles or body text to overlay; don't fill the frame with detail
- Images on the same page or in the same group must use the same ratio, visual scale, and margin density
- Imagery is PPT-embedded material, not a standalone slide: no headers, footers, page numbers, title bars, corner marks, bylines, decorative frames, or slide chrome
- Save output to `images/` named `{page-number}-{semantic}.{ext}`

## Ratio selection

| Use case | Recommended ratio | HTML slot |
|------|---------|-----------|
| Section cover / full-screen key visual | 16:9 | `.frame-img.r-16x9` or hero background reference |
| Swiss-style top banner / Image Hero | 16:9 or 21:9 | P22 top image cover / `.frame-img.r-21x9` |
| Lead image beside text | 16:10 or 4:3 | `.frame-img.r-16x10` / `.frame-img.r-4x3` |
| Infographic / system diagram | 16:9 or 16:10 | original screenshots use `.fit-contain`; slot-regenerated ones use `.frame-img.r-16x9` / `.frame-img.r-16x10` to fill |
| Screenshot redesign / UI scenario image | 16:10 or 21:9 | original screenshots use `.fit-contain`; regenerated for S15/S16 use `.frame-img.r-21x9` to fill |
| Small mixed image | 3:2 or 3:4 | `.frame-img.r-3x2` / `.frame-img.r-3x4` |
| Image grid | uniform landscape | `.frame-img.h-22` / `.frame-img.h-26` |
| Small panel group | uniform landscape | `.frame-img.h-16` / `.frame-img.h-18` |

For infographics and screenshot redesigns from uncontrolled source material, prefer `fit-contain` so text isn't cropped; if GPT-M 2.0 regenerates them for a slot, they must match the slot's ratio and fill the container — don't let a small image float in a white box. Documentary photos should keep the default `cover` for visual tension.

## Image standardization strategy

### A. Pick the target slot first

Don't generate an image first and then cram it into the page. Decide the slot first:

1. Key visual: 16:9
2. Text-left / image-right: 16:10 or 4:3
3. Infographic / screenshot redesign: 16:9 or 16:10, using `fit-contain`
4. Multi-image grid / panel group: uniform height class; mixing heights within a group is forbidden

### B. Handling the user's original images / screenshots

Original screenshots usually have uncontrolled ratios; don't take them as the final visual standard directly. Process them in this order:

1. If the source content must stay faithful, read `screenshot-framing.md` first and use CleanShot X–style programmatic adaptation: target-ratio canvas + stylized background + proportional screenshot scaling + semantic padding/alignment
2. If the source ratio is close to the target slot, drop it into a uniform `.frame-img` with `cover` or `fit-contain`
3. If a UI image was stretched into a super-long strip, split it into 2–3 same-size panels; each panel uses the same height class
4. If the source is too tall, too narrow, or too long and adaptation can't fix it, then regenerate it to the target ratio as a "screenshot redesign / UI scenario image"
5. If the original must be kept, put it in a uniform frame with `fit-contain`, accept the whitespace, and don't crop key text

### C. Prompt suffix to append

Every image prompt ends with a specification constraint:

```text
Output must be [16:9/16:10/4:3/3:2] landscape composition, subject centered but with margins kept, medium visual density, matching the same visual scale and margins as the other images in the group. Keep only the core graphic/frame itself — no headers, footers, titles, page numbers, corner marks, bylines, decorative borders, extra-long strips, portrait images, or irregular ratios.
```

When a page needs several images, add one more line:

```text
This is one image in a group; keep the same frame ratio, element sizes, margins, line weights, and annotation density as the rest of the group.
```

## Type 1: Documentary photography

For adding a sense of place, emotion, and real-world anchors.

```text
Generate a landscape documentary photography illustration on the theme: [page concept]. Styled like Fujifilm / Leica editorial documentary — natural light, low saturation, slight film grain, real work or life scenes, restrained with humanistic warmth. Suited to editorial magazine × e-ink PPTs; leave room for a title. No commercial staging, sci-fi interfaces, AI robots, logos, or watermarks. Output must be [16:9/16:10/4:3] landscape composition, subject centered but with margins kept, medium visual density. Keep only the core photo itself — no headers, footers, titles, page numbers, corner marks, bylines, decorative borders, extra-long strips, portrait images, or irregular ratios.
```

## Type 2: Magazine-style infographic

For explaining concepts, processes, comparisons, or system relationships.

```text
Generate a landscape magazine-style infographic explaining: [concept/process/relationship]. E-ink style, mostly black, white, and gray with a small amount of low-saturation accent color, thin lines, grids, numbering, short labels, and generous whitespace. Text in the graphic uses [Chinese/English], kept short and readable. No cartoon, 3D, neon-tech, or template looks. Output must be [16:9/16:10] landscape composition, subject centered but with margins kept, medium visual density. Keep only the core infographic itself — no headers, footers, titles, page numbers, corner marks, bylines, decorative borders, extra-long strips, portrait images, or irregular ratios.
```

## Type 3: Process / Pipeline diagram

For clearly explaining a process from A to B to C.

```text
Generate a landscape process infographic showing: [step 1] → [step 2] → [step 3] → [result]. Styled as editorial magazine × e-ink, thin arrows, numbered segments, short annotations, restrained whitespace. Text in the graphic uses [Chinese/English]. Keep only the core flow diagram itself — no headers, footers, titles, page numbers, corner marks, bylines, or decorative borders. Ratio: 16:9.
```

## Type 4: Comparison diagram

For before/after, old vs. new models, or comparing two ways of working.

```text
Generate a landscape comparison infographic with [old model] on the left and [new model] on the right. Styled like an analysis chart in a premium independent magazine — black, white, gray, and one low-saturation accent color, thin ruled columns, short labels, clear hierarchy. Text in the graphic uses [Chinese/English]. Keep only the core comparison chart itself — no headers, footers, titles, page numbers, corner marks, bylines, or decorative borders. Ratio: 16:9.
```

## Type 5: System relationship diagram

For relationships among multiple roles, tools, or modules.

```text
Generate a landscape system relationship diagram showing how [roles/tools/modules] connect. E-ink magazine style, nodes, thin lines, arrows, numbering, and a few short annotations, clear structure, generous whitespace. Text in the graphic uses [Chinese/English]. Keep only the core relationship diagram itself — no headers, footers, titles, page numbers, corner marks, bylines, or decorative borders. Ratio: 16:9.
```

## Type 6: Screenshot redesign / UI scenario image

For turning real screenshots, code, design files, and workspaces into unified visual material.

```text
Generate a landscape UI scenario image that redesigns [screenshot/interface/workspace content] into visuals suited to a magazine-style PPT. Keep the feel of the real product workflow, using paper-colored backgrounds, thin frames, grids, minimal annotations, and restrained shadows. Text in the graphic uses [Chinese/English], short and clear. No real brand logos, flashy dashboards, neon gradients, or excessive skeuomorphism. Output must be landscape 16:10 composition, subject centered but with margins kept, medium visual density. Keep only the core UI frame itself — no headers, footers, titles, page numbers, corner marks, bylines, decorative borders, extra-long strips, portrait images, or irregular ratios.
```

## Type 7: Big-number data visual

For highlighting a single key number or a few metrics.

```text
Generate a landscape big-number data visual; the core number is [number] and its meaning is [meaning]. Styled as e-ink magazine layout — oversized serif numeral, a few short annotations, thin lines, whitespace, and paper texture. Text in the graphic uses [Chinese/English]. Keep only the core data visual itself — no headers, footers, titles, page numbers, corner marks, bylines, or decorative borders. Ratio: 16:9.
```

---

## Style B: Swiss International illustration rules

When the deck uses `assets/template-swiss.html` / `layouts-swiss.md`, prefer the prompt set below. They pair with GPT-M 2.0 to generate images that drop straight into the Swiss layout's slots — especially the S22 top banner and the S15/S16 image grids.

### Swiss image hard rules

- Visual anchors: International Typographic Style / Swiss modernism / Helvetica / Josef Müller-Brockmann / Massimo Vignelli
- Composition: strict 12/16-column grid, asymmetric whitespace, left-aligned, hairline rules, right-angle modules
- Color: only black, white, gray, and **one** theme accent (default IKB blue; if the user chose lemon yellow/green or safety orange, substitute that accent)
- Forbidden: gradients, shadows, rounded corners, glassmorphism, neon, 3D, cartoon, SaaS-template looks, fake logos, decorative borders
- Don't generate a PPT shell inside the image: no headers, footers, page numbers, title bars, corner marks, bylines, or outer frames
- Text in UI/infographics must be short and stay consistent in Chinese/English; real photos should mostly carry no text
- Decide the layout slot before generating: single large image uses `s22-hero-21x9`; multi-image grids use `s15-grid-21x9` or `s16-brief-21x9`
- 21:9 images must keep the core subject within the central 70% safe zone with whitespace around it; don't push faces, key nodes, or UI text to the edges

### Swiss Type 1: Documentary photo / case hero image

For the S22 Image Hero, adding real-world scene anchors.

```text
Generate a 21:9 ultra-wide landscape documentary photography image on the theme: [page concept]. Styled as Swiss editorial documentary: high contrast, low saturation, calm and restrained, real office/city/product usage scenes, composition with large negative space, subject in the central 70% safe zone, suited to the top banner of a Swiss International PPT. No AI robots, sci-fi interfaces, commercial staging, logos, watermarks, or text. Keep only the core photo itself — no headers, footers, titles, page numbers, corner marks, bylines, decorative borders, or PPT shells.
```

### Swiss Type 2: Infographic / system diagram

For explaining abstract content like concepts, architecture, processes, or separation of data and presentation.

```text
Generate a landscape Swiss Style infographic explaining: [concept/process/system relationship]. Use sans-serif short labels in the Helvetica/Inter character, a 12/16-column grid, right-angle modules, 1px hairline rules, black/white/gray, and one [IKB blue/lemon yellow/lemon green/safety orange] accent. Text in the graphic uses [Chinese/English], no more than 8 characters/words per label. No gradients, shadows, rounded corners, 3D, cartoon, neon, or SaaS-template looks. Output ratio [21:9/16:10], subject centered with large whitespace. Keep only the core infographic itself — no headers, footers, titles, page numbers, corner marks, bylines, decorative borders, or PPT shells.
```

### Swiss Type 3: Screenshot redesign / UI scenario image

For redrawing screenshots, workspaces, code, and dashboards into a unified Swiss-style visual.

```text
Generate a landscape UI scenario image redesigning [screenshot/interface/workspace content] into Swiss International Typographic Style. Use a minimalist dashboard/workspace structure with right-angle panels, hairline rules, a 12-column grid, and a little [IKB blue/lemon yellow/lemon green/safety orange] accent, no shadows, no rounded corners. Text in the graphic uses [Chinese/English], short and clear, no real brand logos. Output must be landscape 16:10 composition with medium visual density, suited to `.frame-img.r-16x10.fit-contain`. Keep only the core UI frame itself — no headers, footers, titles, page numbers, corner marks, bylines, decorative borders, or PPT shells.
```

### Swiss Type 4: Single asset for a multi-image grid

For the S15/S16 image-grid rework: generate one image at a time when a group of 2–6 images sits side by side.

```text
Generate a landscape evidence image on the theme: [piece of evidence A/B/C]. This is one image in a Swiss Style group; keep right-angle modules, black/white/gray, a single [IKB blue/lemon yellow/lemon green/safety orange] accent, the same margins, the same line weights, and the same visual scale. Text in the graphic uses [Chinese/English], short labels only. Output must be [21:9/16:10] landscape composition, suited to the S15/S16 uniform image grid. Keep only the core image itself — no headers, footers, titles, page numbers, corner marks, bylines, decorative borders, or PPT shells.
```

### Swiss Type 5: Minimal chart / data block

For small explanatory data graphics in S21 or the S15/S16 image grid.

```text
Generate a landscape Swiss Style data graphic; the core data is [number/comparison/rank] and its meaning is [description]. Use extra-large sans-serif numerals, 1px hairline rules, right-angle color blocks, black/white/gray, and one [IKB blue/lemon yellow/lemon green/safety orange] accent, like data layout in a Swiss poster. Text in the graphic uses [Chinese/English]; keep only the necessary labels. No gradients, shadows, rounded corners, 3D, or decorative borders. Ratio: [16:9/16:10]. Keep only the core data graphic itself — no headers, footers, titles, page numbers, corner marks, bylines, or PPT shells.
```