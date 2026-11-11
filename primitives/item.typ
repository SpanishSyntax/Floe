// ============================================================================
// FLOE DESIGN SYSTEM — ITEM CARD & GRID PRIMITIVES (primitives/item.typ)
// Atomic Building Blocks: Prominent Top Bean & Title with Full-Width Unpadded Body
// ============================================================================
#import "../core/lib.typ": *

/// Individual Item Card (Top Bean & Title, Full-Width Body Underneath)
#let item-card(
  label: none,
  title: none,
  color: floe-navy,
  fill: slate-50,
  stroke: slate-200,
  radius: radii.sm,
  inset: (x: 8pt, y: 6pt),
  body,
) = block(
  width: 100%,
  fill: fill,
  stroke: strokes.hairline + stroke,
  radius: radius,
  inset: inset,
)[
  // Top Row: Bean & Title
  #if label != none or title != none [
    #block(below: 4pt)[
      #grid(
        columns: (auto, 1fr),
        gutter: 6pt,
        align: (horizon, horizon),
        if label != none [
          #box(
            fill: color.lighten(85%),
            stroke: strokes.hairline + color.lighten(40%),
            inset: (x: 5.5pt, y: 2.2pt),
            radius: radii.sm,
            text(font: fonts.sans, size: 8.5pt, weight: "bold", fill: color)[#label]
          )
        ],
        if title != none [
          #text(font: fonts.sans, size: 8.8pt, weight: "bold", fill: floe-navy)[#title]
        ],
      )
    ]
  ]
  // Full-width unpadded body
  #block(width: 100%)[
    #set text(size: text-scale.base, fill: slate-700)
    #body
  ]
]

/// Grid container for item cards
#let item-grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  above: 0.6em,
  below: 0.6em,
  ..items,
) = block(
  width: 100%,
  above: above,
  below: below,
)[
  #grid(
    columns: columns,
    gutter: gutter,
    ..items.pos()
  )
]
