# Swiss Style · Theme Color Presets (Swiss Themes)

4 high-contrast palettes based on the Swiss International Style (Swiss Style). **Each follows the minimalist principle of "premium gray-white base + a single high-saturation highlight color"** — this is the soul of Swiss style; mixing multiple highlight colors is not allowed.

---

## How to Use

1. Ask the user which set to use (or recommend one based on the content)
2. Open the `<style>` block of `assets/template-swiss.html`
3. Find the `:root{` block at the top
4. **Replace wholesale** every variable marked “theme color”: `--paper` / `--paper-rgb` / `--ink` / `--ink-rgb` / `--grey-1` / `--grey-2` / `--grey-3` / `--accent` / `--accent-rgb` / `--accent-on`
5. All other CSS goes through `var(--...)`; no further changes are needed

---

## 🔵 Klein Blue (IKB · International Klein Blue)

**Best for**: general use, business launches, AI/tech products, design sharing. The most classic Swiss palette — you cannot go wrong.
**Tone**: pure white base + IKB Klein Blue — extremely calm, rational, academic, like a Helvetica Forever or Massimo Vignelli portfolio.

```css
--paper:#fafaf8;
--paper-rgb:250,250,248;
--ink:#0a0a0a;
--ink-rgb:10,10,10;
--grey-1:#f0f0ee;
--grey-2:#d4d4d2;
--grey-3:#737373;
--accent:#002FA7;
--accent-rgb:0,47,167;
--accent-on:#ffffff;
```

**Usage notes**:
- IKB is a high-saturation deep blue that hits hard on large color blocks (e.g. `.accent-block`)
- Use blue for KPI numbers with the `.accent` class, but do not flood the screen with blue — overusing IKB cheapens it
- Pair it with `dark` theme pages alternately; bold IKB on black looks just as premium

---

## 🟡 Lemon Yellow (Lemon · Cadmium Yellow)

**Best for**: youth, sports, retail, consumer goods, energetic themes, Y2K retro design.
**Tone**: light beige-white base + lemon yellow — bright, energetic, strongly warning-like, like the visual language of IKEA or Beck Design.

```css
--paper:#fafaf8;
--paper-rgb:250,250,248;
--ink:#0a0a0a;
--ink-rgb:10,10,10;
--grey-1:#f0f0ee;
--grey-2:#d4d4d2;
--grey-3:#737373;
--accent:#FFD500;
--accent-rgb:255,213,0;
--accent-on:#0a0a0a;
```

**Usage notes**:
- Lemon yellow is light and high-saturation; **`.accent-on` must be pure black** (not white) to stay readable
- Do not put white text on yellow blocks — it washes out
- Lemon yellow is strongest as single-character highlights (`.mark` / `.underline-accent`)

---

## 🟢 Lemon Green (Lemon Green · Highlighter Green)

**Best for**: ecology, sustainability, health, emerging tech, Gen-Z brands, AI startups.
**Tone**: light beige-white base + fluorescent lemon green — futuristic, young, contemporary, like the look of Acne Studios or Off-White.

```css
--paper:#fafaf8;
--paper-rgb:250,250,248;
--ink:#0a0a0a;
--ink-rgb:10,10,10;
--grey-1:#f0f0ee;
--grey-2:#d4d4d2;
--grey-3:#737373;
--accent:#C5E803;
--accent-rgb:197,232,3;
--accent-on:#0a0a0a;
```

**Usage notes**:
- Like yellow, fluorescent green is a light color; **`.accent-on` must be pure black**
- Renders better on screen than in print; suited to presentation/projection scenarios
- Recommended for “emerging technology” and “future” themes

---

## 🟠 Safety Orange (Safety Orange)

**Best for**: industry, warnings, sports, construction, automotive, and the “warning/emphasis” pages of a tech launch.
**Tone**: light beige-white base + safety orange — industrial, urgent, a visual anchor, like Saul Bass posters or the Highway Gothic signage system.

```css
--paper:#fafaf8;
--paper-rgb:250,250,248;
--ink:#0a0a0a;
--ink-rgb:10,10,10;
--grey-1:#f0f0ee;
--grey-2:#d4d4d2;
--grey-3:#737373;
--accent:#FF6B35;
--accent-rgb:255,107,53;
--accent-on:#ffffff;
```

**Usage notes**:
- Orange sits between light and dark; **white text barely reads, so bold it** (`font-weight:600` or above)
- Strong industrial feel; suits content about “warnings”, “decisions”, and “turning points”
- Avoid full-page `.accent` mode; orange across the whole screen is too glaring — use it as local highlights only

---

## Recommended Choice Reference

| If it is... | Recommended theme |
|---|---|
| Not sure / first time / AI-tech-design | 🔵 Klein Blue |
| Youth, energy, consumer, retail | 🟡 Lemon Yellow |
| Ecology, future, Gen Z, emerging | 🟢 Lemon Green |
| Industry, warning, automotive, urgency | 🟠 Safety Orange |

---

## Switching Principles

- **Use only one theme per deck**; do not switch the accent color midway
- Gray-scale variables (`--grey-1/2/3`) are identical across all 4 themes; no adjustment needed
- The WebGL grid background reads the `--accent` variable automatically, letting a hint of the highlight color sneak in near the cursor on page turn
- After choosing a theme, reinforce the semantics with a related word in the chrome copy (e.g. IKB pairs with `International / Helvetica`, lemon yellow with `Active / Living`)

---

## ❌ What Not to Do

- ❌ **No mixing** (e.g. IKB blue + lemon yellow appearing together as highlights) — it outright violates the Swiss “single anchor color” principle
- ❌ **No user-defined arbitrary hex values** — politely decline and offer the 4 presets to choose from
- ❌ **Do not change the gray-scale variables** — `--paper` / `--grey-1/2/3` / `--ink` stay uniform across themes; swap only the accent
- ❌ **No gradients** — Swiss style rejects every gradient; all color blocks must be solid
- ❌ **No shadow / rounded corners / transparency on the accent** — right angles, solid color, opaque: that is the hard rule of Swiss style

---

## On the Gray Scale (Uniform Across Themes)

| Variable | Value | Use |
|---|---|---|
| `--paper` | `#fafaf8` | Base background (very light warm white) |
| `--grey-1` | `#f0f0ee` | Light gray background (for `.grey-block` / block backgrounds) |
| `--grey-2` | `#d4d4d2` | Mid gray (dividers, borders) |
| `--grey-3` | `#737373` | Dark gray (helper text / meta) |
| `--ink` | `#0a0a0a` | Main text color (near black) |

This gray scale is a calibrated “premium gray” that never competes with any accent color. **Do not** switch it to pure white (`#fff`) or pure black (`#000`) — you would lose the “restrained” feel of Swiss style.

---

After choosing a theme, tell the user: “using 🔵 Klein Blue / 🟡 Lemon Yellow ...” and note it in the deck's project record so later iterations stay consistent.
