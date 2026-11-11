// ============================================================================
// SNOWPACK DESIGN SYSTEM — BADGES & KEYBOARD CHIPS (primitives/badge.typ)
// Semantic Status Tags, Category Chips, and Keycap Primitives
// ============================================================================
#import "../core/lib.typ": *

/// Inline pill/badge chip with semantic variants
#let badge(
  label,
  variant: "neutral",
  fill: none,
  text-color: none,
  weight: "bold",
  size: text-scale.xs,
  radius: radii.sm,
) = {
  let v-map = (
    "info":    (bg: rgb("#E0F2FE"), fg: rgb("#0369A1")),
    "success": (bg: rgb("#DCFCE7"), fg: rgb("#15803D")),
    "warning": (bg: rgb("#FEF3C7"), fg: rgb("#B45309")),
    "danger":  (bg: rgb("#FEE2E2"), fg: rgb("#B91C1C")),
    "purple":  (bg: rgb("#EDE9FE"), fg: rgb("#6D28D9")),
    "neutral": (bg: slate-100,      fg: slate-700),
    "outline": (bg: white,          fg: slate-700),
  )

  let theme-conf = v-map.at(variant, default: v-map.neutral)
  let final-fill = if fill != none { fill } else { theme-conf.bg }
  let final-color = if text-color != none { text-color } else { theme-conf.fg }
  let stroke = if variant == "outline" { strokes.hairline + slate-300 } else { none }

  box(
    fill: final-fill,
    stroke: stroke,
    radius: radius,
    inset: (x: 5pt, y: 2.2pt),
    baseline: 14%,
  )[#text(font: fonts.sans, size: size, weight: weight, fill: final-color)[#label]]
}

/// Keyboard keycap visualization (e.g. #kbd("Ctrl") + #kbd("C"))
#let kbd(key) = box(
  fill: slate-100,
  stroke: (
    top: strokes.border + slate-200,
    left: strokes.border + slate-200,
    right: strokes.border + slate-300,
    bottom: 1.2pt + slate-300,
  ),
  radius: radii.sm,
  inset: (x: 4pt, y: 1.5pt),
  outset: (y: 0.5pt),
)[
  #text(font: fonts.mono, size: 7.5pt, weight: "bold", fill: slate-800)[#key]
]

/// Status dot indicator (e.g. #status-dot(color: floe-green) Stable)
#let status-dot(color: floe-green, size: 5pt) = box(
  width: size,
  height: size,
  radius: radii.full,
  fill: color,
  baseline: 10%,
)
