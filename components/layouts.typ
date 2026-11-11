// ============================================================================
// FLOE DESIGN SYSTEM — LAYOUT PRIMITIVES (components/layouts.typ)
// Split Views, Architectural Tradeoffs, Bento Grids, and Key-Value Grids
// ============================================================================
#import "../core/lib.typ": *
#import "../primitives/lib.typ": card, badge

// ----------------------------------------------------------------------------
// 1. Split-View & Pro-Con Tradeoff Grids
// ----------------------------------------------------------------------------

#let _render-split-col(title, badge-label, badge-variant, body, h: auto) = block(
  fill: white,
  stroke: strokes.border + slate-200,
  radius: radii.md,
  inset: 10pt,
  width: 100%,
  height: h,
)[
  #if title != none or badge-label != none [
    #grid(
      columns: (1fr, auto),
      align: (horizon, horizon),
      if title != none [
        #text(font: fonts.sans, size: 9pt, weight: "bold", fill: floe-navy)[#title]
      ],
      if badge-label != none [
        #badge(badge-label, variant: badge-variant)
      ]
    )
    #v(4pt)
    #line(length: 100%, stroke: strokes.hairline + slate-100)
    #v(4pt)
  ]
  #body
]

/// Split Two-Column Layout (Theory vs Implementation, Primal vs Dual)
/// Guarantees equal height across both columns in the comparison row.
#let split-view(
  left,
  right,
  fractions: (1fr, 1fr),
  gutter: 12pt,
  titles: (none, none),
  badges: (none, none),
  above: 1.1em,
  below: 1.1em,
) = block(
  width: 100%,
  above: above,
  below: below,
  breakable: true,
)[
  #layout(size => {
    let col-w = (size.width - gutter) / 2
    context {
      let m1 = measure(block(width: col-w, _render-split-col(titles.at(0), badges.at(0), "info", left)))
      let m2 = measure(block(width: col-w, _render-split-col(titles.at(1), badges.at(1), "warning", right)))
      let max-h = calc.max(m1.height, m2.height)

      grid(
        columns: fractions,
        gutter: gutter,
        _render-split-col(titles.at(0), badges.at(0), "info", left, h: max-h),
        _render-split-col(titles.at(1), badges.at(1), "warning", right, h: max-h),
      )
    }
  })
]

#let _render-pro-con-box(fill-c, stroke-c, badge-txt, badge-var, marker-char, marker-c, items, h: auto) = block(
  fill: fill-c,
  stroke: strokes.border + stroke-c,
  radius: radii.sm,
  inset: 9pt,
  width: 100%,
  height: h,
)[
  #block(below: 6pt)[
    #badge(badge-txt, variant: badge-var)
  ]
  #list(
    marker: text(fill: marker-c, weight: "bold")[#marker-char],
    ..items
  )
]

/// High-Design Pros vs. Cons (Advantages vs Tradeoffs) Card
/// Enforces equal height between the pros and cons panels.
#let pro-con(
  pros: (),
  cons: (),
  title: "Architectural Tradeoffs",
  pro-label: "ADVANTAGES",
  con-label: "LIMITATIONS",
) = block(
  width: 100%,
  stroke: strokes.border + slate-200,
  radius: radii.md,
  fill: white,
  clip: true,
  above: 1.2em,
  below: 1.2em,
  breakable: true,
)[
  #if title != none [
    #block(
      width: 100%,
      fill: slate-100,
      stroke: (bottom: strokes.hairline + slate-200),
      inset: (x: 12pt, y: 7pt),
      above: 0pt,
      below: 0pt,
    )[
      #text(font: fonts.sans, size: 9.5pt, weight: "bold", fill: floe-navy)[#title]
    ]
  ]
  #block(
    width: 100%,
    inset: 10pt,
    above: 0pt,
    below: 0pt,
  )[
    #layout(size => {
      let col-w = (size.width - 10pt) / 2
      context {
        let m-pro = measure(block(width: col-w, _render-pro-con-box(rgb("#F0FDF4"), rgb("#BBF7D0"), pro-label, "success", "✓", rgb("#16A34A"), pros)))
        let m-con = measure(block(width: col-w, _render-pro-con-box(rgb("#FEF2F2"), rgb("#FECDD3"), con-label, "danger", "✕", rgb("#DC2626"), cons)))
        let max-h = calc.max(m-pro.height, m-con.height)

        grid(
          columns: (1fr, 1fr),
          gutter: 10pt,
          _render-pro-con-box(rgb("#F0FDF4"), rgb("#BBF7D0"), pro-label, "success", "✓", rgb("#16A34A"), pros, h: max-h),
          _render-pro-con-box(rgb("#FEF2F2"), rgb("#FECDD3"), con-label, "danger", "✕", rgb("#DC2626"), cons, h: max-h),
        )
      }
    })
  ]
]

// ----------------------------------------------------------------------------
// 2. Bento Grid
// ----------------------------------------------------------------------------

/// Individual Bento Box Cell
#let bento-cell(
  title: none,
  subtitle: none,
  badge-label: none,
  badge-variant: "neutral",
  icon: none,
  fill: white,
  stroke: slate-200,
  radius: radii.md,
  inset: 12pt,
  body,
) = block(
  width: 100%,
  height: auto,
  fill: fill,
  stroke: strokes.border + stroke,
  radius: radius,
  inset: inset,
)[
  #if title != none or badge-label != none or icon != none [
    #grid(
      columns: (auto, 1fr, auto),
      gutter: 6pt,
      align: (horizon, horizon, horizon),
      if icon != none [
        #box(fill: slate-100, inset: 4pt, radius: radii.sm)[#icon]
      ],
      [
        #if title != none [
          #text(font: fonts.sans, size: 9.5pt, weight: "bold", fill: floe-navy)[#title]
        ]
        #if subtitle != none [
          #v(1pt)
          #text(font: fonts.sans, size: 7.8pt, fill: slate-500)[#subtitle]
        ]
      ],
      if badge-label != none [
        #badge(badge-label, variant: badge-variant)
      ]
    )
    #v(6pt)
    #line(length: 100%, stroke: strokes.hairline + slate-100)
    #v(4pt)
  ]
  #body
]

/// Bento Grid (2-column, 3-column, or asymmetric layout)
#let bento-grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  above: 1.1em,
  below: 1.1em,
  ..cells,
) = block(
  width: 100%,
  above: above,
  below: below,
  breakable: true,
)[
  #grid(
    columns: columns,
    gutter: gutter,
    ..cells.pos()
  )
]

// ----------------------------------------------------------------------------
// 3. Feature & Key-Value Grids
// ----------------------------------------------------------------------------

/// Key-Value Parameter Definition Grid (e.g. Hyperparameters, System Limits)
#let key-value-grid(
  items: (),
  columns: (auto, 1fr),
  gutter: 8pt,
  zebra: true,
  above: 1.0em,
  below: 1.0em,
) = block(
  width: 100%,
  stroke: strokes.border + slate-200,
  radius: radii.md,
  fill: white,
  above: above,
  below: below,
  breakable: true,
)[
  #table(
    columns: columns,
    stroke: none,
    fill: (_, y) => if zebra and calc.even(y) { rgb("#F8FAFC") } else { white },
    inset: (x: 10pt, y: 6pt),
    align: (left + horizon, left + horizon),
    ..items.map(it => (
      text(font: fonts.sans, size: 8.5pt, weight: "bold", fill: floe-navy)[#it.at(0)],
      text(font: fonts.mono, size: 8.3pt, fill: slate-800)[#it.at(1)],
    )).flatten()
  )
]

/// Feature Cards Grid (Canva/Shadcn landing-style component display)
#let feature-grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  above: 1.1em,
  below: 1.1em,
  ..items,
) = block(
  width: 100%,
  above: above,
  below: below,
  breakable: true,
)[
  #grid(
    columns: columns,
    gutter: gutter,
    ..items.pos().map(it => block(
      fill: white,
      stroke: strokes.border + slate-200,
      radius: radii.md,
      inset: 10pt,
      width: 100%,
    )[
      #if "icon" in it [
        #box(fill: slate-100, inset: 4.5pt, radius: radii.sm)[#it.icon]
        #v(4pt)
      ]
      #if "title" in it [
        #text(font: fonts.sans, size: 9.2pt, weight: "bold", fill: floe-navy)[#it.title]
        #v(2pt)
      ]
      #if "desc" in it [
        #set text(font: fonts.sans, size: 8pt, fill: slate-600)
        #it.desc
      ]
    ])
  )
]
