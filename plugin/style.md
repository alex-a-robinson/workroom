# Workroom Visual Design System

This document captures the complete visual identity of **useworkroom.com** for use in Workroom Cowork plugin artefacts. Copy the design tokens below into your artefact stylesheet for instant brand consistency.

---

## Design Tokens (Dark Mode)

The site defaults to dark mode (`data-theme="dark"`). All colour, typography, and spacing tokens are defined in CSS custom properties and can be pasted directly into your artefact.

### Root Token Block (Dark Mode)

```css
:root {
  /* Ground / Base Tones */
  --ink: #F5F1EA;              /* Primary text: warm off-white */
  --ink-dim: #A8A29A;          /* Secondary text: muted taupe */
  --ink-faint: #5F5B54;        /* Tertiary text, labels, borders: dark brown */
  --ink-whisper: #2A2825;      /* Faint dividers: near-black brown */
  --ground: #0A0A0A;           /* Background: true near-black */
  --ground-raised: #131211;    /* Card backgrounds: very dark grey-brown */
  --ground-sunken: #060605;    /* Input wells, sunken surfaces: ultra-dark */

  /* Accent & Interaction */
  --accent: #E8623D;           /* Primary accent: warm terracotta/coral */
  --accent-ink: #0A0A0A;       /* Text on accent backgrounds: near-black */
  --accent-glow: rgba(232, 98, 61, 0.18);  /* Subtle accent glow for shadows */
  --accent-dim: #A84426;       /* Darker accent variant */

  /* Semantic Colors */
  --ok: #7EA876;               /* Success: muted sage green */
  --warn: #D4A24E;             /* Warning: muted amber/gold */
  --bad: #B8554A;              /* Error: dusty red-brown */

  /* Typography Families */
  --f-display: "Instrument Serif", "Times New Roman", serif;
  --f-sans: "Geist", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --f-mono: "Geist Mono", ui-monospace, "SF Mono", Menlo, monospace;

  /* Geometric Scale */
  --radius-sm: 4px;            /* Small border radius */
  --radius: 8px;               /* Default border radius */
  --radius-lg: 14px;           /* Large border radius (cards, modals) */
  --border: 1px solid var(--ink-whisper);

  /* Layout Scale */
  --gutter: 32px;              /* Page horizontal padding */
  --maxw: 1280px;              /* Max container width */

  /* Motion & Easing */
  --ease-out: cubic-bezier(0.22, 1, 0.36, 1);      /* Standard ease-out */
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1); /* Bouncy spring easing */
}
```

### Light Mode Overrides

For light theme support (`[data-theme="light"]`):

```css
[data-theme="light"] {
  --ink: #17140F;              /* Primary text: very dark brown */
  --ink-dim: #5F5B54;          /* Secondary text: dark taupe */
  --ink-faint: #8C8880;        /* Tertiary: medium taupe */
  --ink-whisper: #E3DED4;      /* Dividers: light beige */
  --ground: #F5F1EA;           /* Background: warm off-white */
  --ground-raised: #FBF8F2;    /* Cards: off-white raised */
  --ground-sunken: #EEE8DC;    /* Inputs: light beige sunken */
  --accent-ink: #F5F1EA;       /* Text on accent: off-white */
}
```

---

## Typography Scale

All typography uses the design system families above. Font loading is handled via Google Fonts in the page `<head>`:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Geist:wght@300;400;500;600;700&family=Geist+Mono:wght@400;500&display=swap" rel="stylesheet">
```

### Type Scale Classes

| Use Case | Font | Size | Weight | Line Height | Letter Spacing |
|----------|------|------|--------|-------------|-----------------|
| **Display / Hero Heading** | Instrument Serif | 38px–68px (clamp) | 400 | 1.1 | -0.022em |
| **Section Title** | Instrument Serif | 38px–64px (clamp) | 400 | 1.02 | -0.02em |
| **Eyebrow / Label** | Geist Mono | 11px | 400 | 1 | 0.14em uppercase |
| **Body / Paragraph** | Geist | 16px–20px | 400 | 1.55 | normal |
| **Small Body** | Geist | 14px | 400 | 1.5 | normal |
| **Monospace Label** | Geist Mono | 12px | 400 | 1 | 0.06em |
| **CTA / Button Text** | Geist | 14px | 500 | 1 | normal |

### Font Feature Settings

Applied globally to optimise serif and sans letterforms:

```css
font-feature-settings: "ss01", "ss02", "cv01";
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
```

**Notes:**
- Italic is used exclusively with Instrument Serif for emphasis (e.g., `<em>` tags in headlines).
- Geist weights available: 300 (light, rarely used), 400 (regular), 500 (semibold for buttons), 600 (bold for strong emphasis), 700 (heavy, rare).
- `letter-spacing` is tight on headings (-0.02em) to create visual presence; looser on small labels (0.1–0.14em) for readability.

---

## Component Patterns

### Buttons

Two primary button variants, with consistent padding and interactive states.

#### Primary Button (Accent)

```css
.btn-primary {
  background: var(--accent);      /* #E8623D */
  color: var(--accent-ink);       /* #0A0A0A */
  box-shadow: 0 0 0 1px var(--accent), 
              0 10px 30px -10px var(--accent-glow);
  padding: 12px 18px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
}
.btn-primary:hover {
  box-shadow: 0 0 0 1px var(--accent),
              0 14px 40px -10px var(--accent-glow),
              0 0 60px -10px var(--accent-glow);
  /* Optional: slight scale/lift */
  transform: translateY(-1px);
}
.btn-primary:active { transform: translateY(1px); }
```

**Icon Animation:** Arrow icons inside buttons slide right on hover.

```css
.btn .arrow {
  transition: transform 200ms var(--ease-out);
}
.btn:hover .arrow { transform: translateX(3px); }
```

#### Ghost Button (Outlined)

```css
.btn-ghost {
  color: var(--ink);              /* Foreground text */
  border: 1px solid var(--ink-whisper);
  background: transparent;
  padding: 12px 18px;
  border-radius: 8px;
}
.btn-ghost:hover {
  border-color: var(--ink-faint);
  background: var(--ground-raised);
}
```

#### Mini Button
```css
.btn-mini {
  padding: 8px 12px;
  font-size: 13px;
}
```

### Reveal (Scroll Animation)

Elements fade in and slide up as they enter the viewport. Used on nearly every section.

```css
.reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 700ms var(--ease-out), 
              transform 900ms var(--ease-out);
  will-change: opacity, transform;
}
.reveal.is-in {
  opacity: 1;
  transform: none;
}
```

**Staggered reveals** use inline `style={{ transitionDelay: '${delay}ms' }}` for cascade effect (e.g., `delay={i * 80}`).

### Cards (Raised Surface)

Cards use subtle border and shadow to differentiate from ground.

```css
.card {
  background: var(--ground-raised);    /* #131211 */
  border: 1px solid var(--ink-whisper);
  border-radius: var(--radius-lg);     /* 14px */
  padding: 32px;                        /* or 36px, 48px depending on card type */
  box-shadow: 0 40px 80px -30px rgba(0, 0, 0, 0.5);
}
```

### Sections

Standard section padding and heading grid layout.

```css
section {
  padding: 96px 0;              /* Vertical rhythm: 96px top & bottom */
  position: relative;
}

@media (max-width: 720px) {
  section { padding: 64px 0; }
}
```

**Section Header Grid:**

```css
.section-head {
  display: grid;
  grid-template-columns: 120px 1fr;  /* Left column for section number */
  gap: 32px;
  align-items: start;
  margin-bottom: 56px;
}

@media (max-width: 720px) {
  .section-head {
    grid-template-columns: 1fr;
    gap: 12px;
    margin-bottom: 40px;
  }
}
```

### The Hero Section

Full-height hero with tagline, subtitle, and call-to-action buttons. Includes animated background grid and glow.

```css
.hero {
  padding: 80px 0 120px;
  min-height: 88vh;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  position: relative;
}

.hero-grid {
  display: grid;
  grid-template-columns: 1.15fr 1fr;  /* Left text, right chart */
  gap: 56px;
  align-items: center;
}

@media (max-width: 960px) {
  .hero-grid { grid-template-columns: 1fr; gap: 40px; }
}

.hero-tagline {
  font-family: var(--f-display);
  font-size: clamp(38px, 5vw, 68px);
  line-height: 1.1;
  letter-spacing: -0.022em;
  margin-bottom: 80px;
  text-wrap: balance;
}

.hero-sub {
  font-size: 20px;
  color: var(--ink-dim);
  max-width: 48ch;
  line-height: 1.45;
  margin-bottom: 40px;
}
```

#### Hero Meta Badge (Live Indicator)

```css
.hero-meta {
  display: flex;
  gap: 20px;
  align-items: center;
  margin-bottom: 40px;
}

.hero-meta .dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--accent);      /* #E8623D */
  box-shadow: 0 0 0 4px var(--accent-glow);
  animation: pulse 2.2s var(--ease-out) infinite;
}

@keyframes pulse {
  0%, 100% { box-shadow: 0 0 0 4px var(--accent-glow); }
  50% { box-shadow: 0 0 0 10px rgba(232, 98, 61, 0.04); }
}
```

### Navigation (Sticky Header)

Glassmorphic navigation bar with scroll detection.

```css
.nav {
  position: sticky;
  top: 0;
  z-index: 40;
  backdrop-filter: blur(14px) saturate(1.3);
  -webkit-backdrop-filter: blur(14px) saturate(1.3);
  background: color-mix(in srgb, var(--ground) 72%, transparent);
  border-bottom: 1px solid transparent;
  transition: border-color 240ms var(--ease-out);
}

.nav.is-scrolled { border-bottom-color: var(--ink-whisper); }

.nav-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
}

.nav-links {
  display: flex;
  gap: 28px;
}

.nav-links a {
  font-size: 14px;
  color: var(--ink-dim);
  transition: color 180ms;
  white-space: nowrap;
}

.nav-links a:hover { color: var(--ink); }
```

### Task Deck (Carousel)

The rotating task cards in section 02 use transform-based positioning for smooth swipes.

```css
.task-deck {
  position: relative;
  cursor: grab;
}

.task-deck-stage {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  height: 320px;  /* Approximate; adjust to fit card height */
}

.task-slab {
  position: absolute;
  width: 100%;
  max-width: 520px;
  background: var(--ground-raised);
  border: 1px solid var(--ink-whisper);
  border-radius: var(--radius-lg);
  padding: 32px 28px;
  transition: transform 300ms var(--ease-out),
              opacity 300ms var(--ease-out),
              z-index 0ms;
  pointer-events: none;
}

.task-slab.is-active { pointer-events: auto; }

.ts-k {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--ink-faint);
}

.ts-t {
  font-family: var(--f-display);
  font-size: 22px;
  line-height: 1.3;
  margin-top: 12px;
  color: var(--ink);
}

.ts-ba {
  margin-top: 20px;
}

.ts-ba-row {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin: 12px 0;
}

.ts-label {
  font-size: 12px;
  color: var(--ink-dim);
  letter-spacing: 0.04em;
}

.ts-val {
  font-size: 15px;
  font-weight: 500;
  color: var(--ink);
}

.ts-kpi {
  margin-top: 18px;
  padding-top: 18px;
  border-top: 1px solid var(--ink-whisper);
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: var(--accent);
  font-weight: 500;
}

.ts-kpi-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--accent);
}
```

---

## Motion & Animation

The site prioritises smooth, confident motion over frenzy. All transitions use the two easing curves defined in tokens.

### Standard Transitions

```css
/* Fade and slide up on scroll reveal */
transition: opacity 700ms var(--ease-out), 
            transform 900ms var(--ease-out);

/* Button lift and icon slide */
transition: transform 140ms var(--ease-out), 
            background 160ms, 
            color 160ms;

/* Shadow glow on hover */
transition: box-shadow 200ms var(--ease-out);

/* Link colour and nav border */
transition: color 180ms, border-color 240ms var(--ease-out);
```

### Keyframe Animations

**Pulse (hero meta dot):**
```css
@keyframes pulse {
  0%, 100% { box-shadow: 0 0 0 4px var(--accent-glow); }
  50% { box-shadow: 0 0 0 10px rgba(232, 98, 61, 0.04); }
}
.hero-meta .dot { animation: pulse 2.2s var(--ease-out) infinite; }
```

**Gap Chart Animation (hero section chart):**
- Custom timeline using `requestAnimationFrame` + easing.
- Line draws in over 6500ms (easeOutCubic), holds for 2500ms, then loops.
- Inflection marker and multiplier callout appear at specific progress points.

**Blink (hero cursor, if present):**
```css
@keyframes blink {
  50% { opacity: 0; }
}
```

---

## Spacing & Layout Scale

### Padding & Margin Scale

| Value | Use |
|-------|-----|
| 4px | Small component gaps, tiny borders |
| 8px | Button / chip padding, icon spacing |
| 12px | Section spacing, form field padding |
| 14px | Card title margins |
| 18px | Internal card spacing, line breaks |
| 20px | Meta info spacing |
| 22px | Section spacing |
| 28px | Card horizontal padding |
| 32px | Page horizontal gutter, large spacing |
| 40px | Large internal card padding |
| 48px | XL card padding |
| 56px | Section head margins, large vertical rhythm |
| 64px | Mobile section padding |
| 80px | Hero padding |
| 96px | Default section padding |
| 120px | Max container width breakpoint |

### Gap Scale (Flexbox / Grid)

| Value | Use |
|-------|-----|
| 6px | Dot arrays, micro-spacing |
| 8px | Icon + text pairs |
| 10px | Button content (icon + label) |
| 12px | Form field spacing |
| 14px | CTA group spacing |
| 16px | Navigation right-side gaps |
| 20px | Hero meta |
| 24px | Grid default gap |
| 28px | Navigation links |
| 32px | Large navigation gap, section head grid |
| 56px | Hero grid large gap |

### Container Width

- **Max width:** 1280px (`--maxw`)
- **Page gutter:** 32px desktop (`--gutter`), 20px mobile

### Breakpoints

- **Mobile:** ≤ 720px (adjusts gutter, stacks grids)
- **Tablet:** 720px–960px
- **Desktop:** ≥ 960px (full grid layouts)

---

## Colour Palette Summary

### Dark Mode (Default)

| Token | Hex | Purpose | Notes |
|-------|-----|---------|-------|
| `--ground` | #0A0A0A | Page background | Near-pure black; warm undertone |
| `--ground-raised` | #131211 | Card backgrounds | Lifts minimally from ground |
| `--ground-sunken` | #060605 | Input wells, depressions | Darker than ground |
| `--ink` | #F5F1EA | Primary text | Off-white, warm cream |
| `--ink-dim` | #A8A29A | Secondary text, meta | Medium taupe |
| `--ink-faint` | #5F5B54 | Tertiary, borders, small labels | Dark brown |
| `--ink-whisper` | #2A2825 | Dividers, very subtle borders | Nearly black |
| `--accent` | #E8623D | Primary interactive, highlights | Warm terracotta/coral; high contrast |
| `--accent-ink` | #0A0A0A | Text on accent | Same as `--ground` |
| `--accent-glow` | rgba(232, 98, 61, 0.18) | Subtle shadow/glow | 18% opacity accent |
| `--accent-dim` | #A84426 | Accent hover/disabled state | Darker variant |
| `--ok` | #7EA876 | Success states | Muted sage |
| `--warn` | #D4A24E | Warning states | Muted amber |
| `--bad` | #B8554A | Error states | Dusty red-brown |

### Light Mode Overrides

| Token | Hex | Notes |
|-------|-----|-------|
| `--ground` | #F5F1EA | Off-white (inverted) |
| `--ground-raised` | #FBF8F2 | Slightly whiter |
| `--ground-sunken` | #EEE8DC | Light beige |
| `--ink` | #17140F | Very dark brown |
| `--ink-dim` | #5F5B54 | Stays same (mid taupe) |
| `--ink-faint` | #8C8880 | Lighter taupe |
| `--ink-whisper` | #E3DED4 | Light beige divider |
| `--accent-ink` | #F5F1EA | Off-white on accent |

---

## Contrast & Accessibility

### WCAG Compliance

- **Primary text on ground:** Dark mode has very high contrast (off-white #F5F1EA on #0A0A0A).
- **Secondary text on ground:** `--ink-dim` (#A8A29A) meets WCAG AA for normal text.
- **Accent buttons:** Coral #E8623D on near-black #0A0A0A meets AAA.
- **Small labels:** Use `--ink-faint` (#5F5B54) only in non-critical contexts (section numbers, timestamps).

### Focus & Hover States

- Links and buttons use `color` and `border-color` transitions.
- Accent buttons add extra glow/shadow on hover to indicate interactivity.
- All transitions are smooth (140–240ms) to avoid jarring UX.

---

## Responsive Design Notes

### Mobile-First Approach

The site uses `clamp()` for fluid typography that scales between min and max sizes across viewports:

```css
.hero-tagline {
  font-size: clamp(38px, 5vw, 68px);
}

.section-title {
  font-size: clamp(38px, 5vw, 64px);
}
```

This eliminates the need for many breakpoint-specific font-size rules.

### Key Breakpoint: 720px

At `max-width: 720px`:
- Gutter reduces from 32px to 20px.
- Section grids stack to single column.
- Section head goes from 120px + 1fr to full width.
- Hero grid stacks (left content above chart).
- Navigation links often hide; mobile menu may take over (not shown in this extract).

### Hero Section at Mobile

- Still full-height; maintains emotional impact.
- Gap chart scales with viewport while preserving aspect ratio.
- CTA buttons wrap if needed.

---

## Using This in Artefacts

### Quick Start Template

```html
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Workroom Artefact</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Geist:wght@300;400;500;600;700&family=Geist+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    :root {
      /* Paste the entire token block from above */
      --ink: #F5F1EA;
      --ink-dim: #A8A29A;
      /* ... etc ... */
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      background: var(--ground);
      color: var(--ink);
      font-family: var(--f-sans);
      font-size: 16px;
      line-height: 1.55;
      font-feature-settings: "ss01", "ss02", "cv01";
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }

    /* Paste component styles as needed */
  </style>
</head>
<body>
  <!-- Your artefact content -->
</body>
</html>
```

### Choosing a Light/Dark Theme

Artefacts inherit the user's Cowork theme preference. If you want to force one:

```html
<html data-theme="light">  <!-- or "dark" -->
```

Light mode is less commonly used; dark mode is the default and matches the marketing site.

---

## Distinctive Brand Traits

### Vibe & Emotional Register

1. **Intellectual but Warm:** Serif headlines (Instrument Serif) create editorial sophistication; warm colour palette (#E8623D terracotta, off-white #F5F1EA) softens the rigour. Not corporate or sterile.

2. **Consultant's Workbook Aesthetic:** Dark background, clear hierarchy, restrained use of accent colour. Feels like a thoughtful operations manual rather than a SaaS splash page.

3. **Motion with Purpose:** Reveals and transitions are confident and smooth but not excessive. A pulsing dot, a chart that draws itself, cards that slide—all deliberate moments, no frenzy.

4. **High Contrast by Design:** Near-black background with warm off-white text creates visual impact and legibility. The coral accent is the only "bright" colour; it commands attention without noise.

5. **Type-Forward:** Typography carries the brand. The pairing of serif (Instrument) with geometric sans (Geist) creates tension—traditional meets modern. Small details like tightened letter-spacing on headlines and monospace labels in ALL CAPS reinforce precision.

### Not Designed Like:

- A typical SaaS (no gradients, no frosted glass on every element, no animations that bounce).
- A design system showcase (focused, purposeful, not exhaustive).
- A creative agency site (too restrained; calm takes precedence).

### Strongest Signal: The Accent Colour

The terracotta #E8623D is **the** brand colour. It appears on:
- Primary buttons (with glowing shadow on hover).
- Hero meta pulse dot.
- Emphasized text in headings (`<em>` tags).
- Chart lines and markers (the "Gap" chart).
- Icons (slight opacity).

Everything else is monochromatic or dimmed. This restraint makes the accent land harder.

---

## Asset Guidance

### Google Fonts

Load explicitly in every artefact:

```html
<link href="https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Geist:wght@300;400;500;600;700&family=Geist+Mono:wght@400;500&display=swap" rel="stylesheet">
```

Do not rely on system fallbacks; the serif needs to be the serif.

### Icons

- Inline SVGs, 14px–18px.
- Stroke-based, 1.3–1.5px stroke width.
- Use `currentColor` to inherit text colour.
- Common icons: arrow (right), signal, calendar, wrench, chat, plus.

### Images

Very few on the marketing site (mostly data viz and avatar placeholders). When used:
- Maintain dark background.
- Subtle border and shadow (1px border + 0 40px 80px -30px shadow).
- Use accent colour sparingly (e.g., outline borders, glow effects).

---

## Final Checklist for Artefact Creation

- [ ] **Theme:** Paste the `:root { }` token block into `<style>`.
- [ ] **Fonts:** Load Google Fonts via `<link>` in `<head>`.
- [ ] **Text Hierarchy:** Use Instrument Serif for headings, Geist for body, Geist Mono for meta/labels.
- [ ] **Spacing:** Reference the scale above; favour multiples of 8px or 4px.
- [ ] **Buttons:** Copy `.btn-primary` and `.btn-ghost` styles; customise only if necessary.
- [ ] **Cards:** Use `--ground-raised` background, 1px `--ink-whisper` border, `--radius-lg` corners.
- [ ] **Reveals:** Wrap sections in `.reveal` for scroll animations.
- [ ] **Accent:** Use `--accent` (#E8623D) sparingly; it should feel special.
- [ ] **Motion:** Keep transitions under 300ms; favour `var(--ease-out)`.
- [ ] **Dark Mode:** Test with `data-theme="dark"`; light mode optional.

---

*This design system was extracted from useworkroom.com on 2026-04-21. Fonts and colours are production values; use exactly as specified for brand consistency.*
