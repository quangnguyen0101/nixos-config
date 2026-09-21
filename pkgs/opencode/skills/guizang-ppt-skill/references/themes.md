# Theme Color Presets (Themes)

5 carefully tuned theme palettes that keep the "e-magazine × e-ink" aesthetic from falling apart. **Users are not allowed to customize colors — a wrong color match instantly ruins the look**; always pick from the presets below.

---

## How to use

1. Ask the user which palette to use (or recommend one based on content)
2. Open the `<style>` block of `assets/template.html`
3. Find the `:root{` block at the top
4. **Replace as a whole** the lines marked with the "theme color" comment — `--ink` / `--ink-rgb` / `--paper` / `--paper-rgb` / `--paper-tint` / `--ink-tint`
5. Everything else in the CSS goes through `var(--...)`; no other changes needed

---

## 🖋 Monocle Classic (Monocle default)

**Best for**: general talks, business publishing, tech products — a safe default for any topic.
**Vibe**: pure ink black + warm cream white, the strongest magazine feel, Monocle / Apricot / A Book Apart style.

```css
--ink:#0a0a0b;
--ink-rgb:10,10,11;
--paper:#f1efea;
--paper-rgb:241,239,234;
--paper-tint:#e8e5de;
--ink-tint:#18181a;
```

---

## 🌊 Indigo Porcelain (Indigo Porcelain)

**Best for**: tech/research/data talks, engineer culture, deep content, product launches.
**Vibe**: deep indigo + porcelain white, calm, rational, deep — like an academic journal or blue-white porcelain.

```css
--ink:#0a1f3d;
--ink-rgb:10,31,61;
--paper:#f1f3f5;
--paper-rgb:241,243,245;
--paper-tint:#e4e8ec;
--ink-tint:#152a4a;
```

---

## 🌿 Forest Ink (Forest Ink)

**Best for**: nature/sustainability/culture/nonfiction content, outdoor brands, environmental topics.
**Vibe**: deep forest green + ivory, steady, breathable, like an old National Geographic.

```css
--ink:#1a2e1f;
--ink-rgb:26,46,31;
--paper:#f5f1e8;
--paper-rgb:245,241,232;
--paper-tint:#ece7da;
--ink-tint:#253d2c;
```

---

## 🍂 Kraft Paper (Kraft Paper)

**Best for**: nostalgia/humanities/reading/history/literature talks, indie magazines, handmade brands.
**Vibe**: deep brown + warm cream, like a kraft envelope or an old notebook — warm, with a vintage feel.

```css
--ink:#2a1e13;
--ink-rgb:42,30,19;
--paper:#eedfc7;
--paper-rgb:238,223,199;
--paper-tint:#e0d0b6;
--ink-tint:#3a2a1d;
```

---

## 🌙 Dune (Dune)

**Best for**: art/design/creative/fashion talks, gallery booklets, aesthetics-first private salons.
**Vibe**: charcoal + sand, restrained, premium, neutral — like a desert dusk or an architecture drawing book.

```css
--ink:#1f1a14;
--ink-rgb:31,26,20;
--paper:#f0e6d2;
--paper-rgb:240,230,210;
--paper-tint:#e3d7bf;
--ink-tint:#2d2620;
```

---

## Recommendation reference

| If it's... | Recommended theme |
|---|---|
| Don't know what to pick / first time | 🖋 Monocle Classic |
| AI / tech / product launch | 🌊 Indigo Porcelain |
| Content / industry observation / culture | 🌿 Forest Ink |
| Book review / lifestyle / humanities | 🍂 Kraft Paper |
| Design / art / brand | 🌙 Dune |

---

## Switching principles

- **A deck uses exactly one theme**; never switch colors mid-deck
- The WebGL shader's default accent (titanium gold scatter / silver flow) works with all 5 palettes (tested and acceptable)
- `currentColor`-driven borders / icons auto-adapt to the section's text color; no extra tuning needed
- Once a theme is chosen, the `<title>` text and `chrome` copy can reinforce that theme's semantics (e.g. Kraft Paper paired with "Vol.03 · Autumn")

## ❌ Don'ts

- ❌ **No mixing palettes** (e.g. using Monocle Classic's ink with Dune's paper) — it will clash outright
- ❌ **No arbitrary user-supplied hex values** — politely decline and show the 5 presets to choose from
- ❌ **Don't edit colors elsewhere in template.html** — every scattered rgba goes through var; change the single `:root` block instead

After the theme is chosen, tell the user in the skill conversation: "Using Monocle Classic / Indigo Porcelain ..." and record it in the deck's project notes so later iterations stay consistent.