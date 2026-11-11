# Layer 0: Core Foundation

[Overview](README.md) • [Getting Started](getting-started.md) • [Core](core.md) • [Primitives](primitives.md) • [Mixins](mixins.md) • [Components](components.md) • [Presets](presets.md)

---

The core layer defines the single source of truth for all palettes, typography scales, strokes, and radii across Floe, as well as unified bindings to third-party drawing and layout engines.

---

## Design Tokens

### Floe Brand Palette

| Token | Color | Hex Value | Usage |
| :--- | :--- | :--- | :--- |
| `floe-cyan` | `#00A6D6` | `rgb("#00A6D6")` | Primary accent, chapter rules, active links |
| `floe-navy` | `#0C2340` | `rgb("#0C2340")` | Deep headings, primary titles, hero banners |
| `floe-slate` | `#334155` | `rgb("#334155")` | Body text, secondary headers |
| `floe-muted` | `#64748B` | `rgb("#64748B")` | Captions, metadata labels, breadcrumbs |
| `floe-green` | `#059669` | `rgb("#059669")` | Success badges, verification strips, physical anchors |
| `floe-amber` | `#B45309` | `rgb("#B45309")` | Theorem accents, warning notices, exam alerts |
| `floe-red` | `#DC2626` | `rgb("#DC2626")` | Pitfalls, danger alerts, input constraints |
| `floe-purple` | `#6D28D9` | `rgb("#6D28D9")` | Lemma accents, disturbance variables, optional tags |

### Semantic Equation Color Roles

Floe provides standardized color tokens for equation dissections:

- `c-state`: `#0284C7` (Sky Blue) — Internal dynamics, state vector $x$, autonomous drift.
- `c-input`: `#DC2626` (Crimson Red) — Actuator authority, control input $u$, input saturation.
- `c-cost`: `#D97706` (Amber) — Cost weights $Q, R$, Lagrange multipliers $\lambda$, objective functions.
- `c-sensor`: `#059669` (Emerald Green) — Sensor measurements $y$, output matrices $C$, references.
- `c-noise`: `#7C3AED` (Royal Purple) — Disturbances $w$, measurement noise $v$, dual multipliers $\mu$.
- `c-est`: `#DB2777` (Deep Pink) — State estimates $\hat{x}$, residuals, Kalman gains.

---

## Typography & Metric Scales

### Font Stacks

```typst
#fonts.serif    // ("New Computer Modern", "DejaVu Serif", "Times New Roman")
#fonts.sans     // ("Liberation Sans", "DejaVu Sans", "Inter")
#fonts.mono     // ("DejaVu Sans Mono", "Source Code Pro", "Consolas")
```

### Typographic Scale

- `xs`: `7.5pt` — Badges, keycaps, footer notes
- `sm`: `8.5pt` — Callout body text, table cells, captions
- `base`: `10pt` — Standard textbook body text
- `md`: `11pt` — Subsection lead text
- `lg`: `12.8pt` — Section headers (`==`)
- `xl`: `16pt` — Subchapter titles
- `title`: `18pt` — Level-1 chapter titles (`=`)
- `hero`: `24pt` — Presentation slide titles

### Radii & Strokes

```typst
#radii.sm       // 2pt
#radii.base     // 3.5pt
#radii.md       // 6pt
#radii.lg       // 10pt
#radii.full     // 9999pt (pill shapes)

#strokes.hairline // 0.35pt (delicate inner dividers)
#strokes.border   // 0.5pt (card borders)
#strokes.card     // 0.75pt (outer containers)
#strokes.accent   // 3.0pt (left callout bars)
```
