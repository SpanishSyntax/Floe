// ============================================================================
// FLOE DESIGN SYSTEM — DIVIDERS (primitives/divider.typ)
// Subtle Themed Separators, Labeled Chips, Dotted, Faded & Icon Breakers
// ============================================================================
#import "../core/lib.typ": *

/// 1. Subtle horizontal hairline rule
#let divider(
  color: slate-200,
  thickness: strokes.hairline,
  above: 0.8em,
  below: 0.8em,
) = block(
  above: above,
  below: below,
  line(length: 100%, stroke: thickness + color),
)

/// 2. Horizontal separator with centered pure text label (zero box / clean text)
#let text-divider(
  label,
  color: slate-200,
  thickness: strokes.hairline,
  text-color: floe-muted,
  above: 0.9em,
  below: 0.9em,
) = block(
  width: 100%,
  above: above,
  below: below,
)[
  #grid(
    columns: (1fr, auto, 1fr),
    gutter: 10pt,
    align: (horizon, horizon, horizon),
    line(length: 100%, stroke: thickness + color),
    text(font: fonts.sans, size: text-scale.xs, weight: "bold", fill: text-color, tracking: 0.08em)[#label],
    line(length: 100%, stroke: thickness + color),
  )
]

/// 3. Horizontal separator with centered chip pill badge (subtle boxed fill & border)
#let chip-divider(
  label,
  color: slate-200,
  thickness: strokes.hairline,
  text-color: floe-muted,
  badge-fill: slate-100,
  above: 0.9em,
  below: 0.9em,
) = block(
  width: 100%,
  above: above,
  below: below,
)[
  #grid(
    columns: (1fr, auto, 1fr),
    gutter: 10pt,
    align: (horizon, horizon, horizon),
    line(length: 100%, stroke: thickness + color),
    box(
      fill: badge-fill,
      stroke: strokes.hairline + color,
      radius: radii.sm,
      inset: (x: 6.5pt, y: 2.5pt),
      text(font: fonts.sans, size: text-scale.xs, weight: "bold", fill: text-color)[#label]
    ),
    line(length: 100%, stroke: thickness + color),
  )
]

/// 4. Horizontal separator with centered label (pure text by default, or boxed: true)
#let labeled-divider(
  label,
  color: slate-200,
  thickness: strokes.hairline,
  text-color: floe-muted,
  badge-fill: none,
  boxed: false,
  above: 0.9em,
  below: 0.9em,
) = {
  if boxed or badge-fill != none {
    chip-divider(
      label,
      color: color,
      thickness: thickness,
      text-color: text-color,
      badge-fill: if badge-fill != none { badge-fill } else { slate-100 },
      above: above,
      below: below,
    )
  } else {
    text-divider(
      label,
      color: color,
      thickness: thickness,
      text-color: text-color,
      above: above,
      below: below,
    )
  }
}

/// 3. Dotted divider line
#let dotted-divider(
  color: slate-300,
  thickness: 1.0pt,
  above: 0.8em,
  below: 0.8em,
) = block(
  width: 100%,
  above: above,
  below: below,
  line(length: 100%, stroke: (paint: color, thickness: thickness, dash: "dotted")),
)

/// 4. Dashed divider line
#let dashed-divider(
  color: slate-300,
  thickness: 0.8pt,
  above: 0.8em,
  below: 0.8em,
) = block(
  width: 100%,
  above: above,
  below: below,
  line(length: 100%, stroke: (paint: color, thickness: thickness, dash: "dashed")),
)

/// 5. Gradient fade divider (fades in from left edge, solid in center, fades out on right)
#let fade-divider(
  color: slate-400,
  thickness: strokes.hairline,
  above: 0.8em,
  below: 0.8em,
) = block(
  width: 100%,
  above: above,
  below: below,
  line(
    length: 100%,
    stroke: thickness + gradient.linear(
      color.transparentize(100%),
      color,
      color.transparentize(100%),
    ),
  ),
)

/// 6. Icon / glyph divider with centered emblem
#let icon-divider(
  icon: "✦",
  color: slate-200,
  icon-color: floe-cyan,
  size: 8.5pt,
  above: 0.9em,
  below: 0.9em,
) = block(
  width: 100%,
  above: above,
  below: below,
)[
  #grid(
    columns: (1fr, auto, 1fr),
    gutter: 10pt,
    align: (horizon, horizon, horizon),
    line(length: 100%, stroke: strokes.hairline + color),
    text(font: fonts.sans, size: size, fill: icon-color)[#icon],
    line(length: 100%, stroke: strokes.hairline + color),
  )
]

/// 7. Brand gradient accent rule
#let gradient-divider(
  from-color: floe-cyan,
  to-color: floe-navy,
  thickness: 1.5pt,
  above: 0.9em,
  below: 0.9em,
) = block(
  width: 100%,
  above: above,
  below: below,
  line(length: 100%, stroke: thickness + gradient.linear(from-color, to-color)),
)
