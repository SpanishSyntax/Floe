// ============================================================================
// FLOE DESIGN SYSTEM — PEDAGOGICAL EXPLAINERS (components/pedagogical.typ)
// Canva-Style Explainer Cards, Stepper Notebooks & Visual Dissection Canvases
// ============================================================================
#import "../core/lib.typ": *
#import "../primitives/lib.typ": card, badge
#import "academic.typ": _parse-args

/// Physical & Control Anchor: Grounding abstract math in physical engineering mechanics
/// Features: Editorial magazine card, emerald theme, system badge, and physical context.
#let physical-anchor(..args) = {
  let (title, body) = _parse-args(args)
  let system = if "system" in args.named() { args.named().system } else { none }

  block(
    width: 100%,
    breakable: true,
    stroke: strokes.border + rgb("#A7F3D0"),
    radius: radii.md,
    fill: rgb("#F8FAF9"),
    clip: true,
    above: 1.25em,
    below: 1.25em,
  )[
    // Header
    #block(
      width: 100%,
      fill: rgb("#ECFDF5"),
      stroke: (bottom: strokes.hairline + rgb("#D1FAE5")),
      inset: (x: 12pt, y: 7pt),
      above: 0pt,
      below: 0pt,
    )[
      #grid(
        columns: (auto, 1fr, auto),
        gutter: 8pt,
        align: (horizon, horizon, horizon),
        [
          #box(
            fill: floe-green,
            inset: (x: 5pt, y: 2.2pt),
            radius: radii.sm,
            text(font: fonts.sans, size: 7.8pt, weight: "bold", fill: white, tracking: 0.08em)[
              PHYSICAL ANCHOR
            ]
          )
        ],
        [
          #if title != none [
            #text(font: fonts.sans, size: 9.8pt, weight: "bold", fill: floe-navy)[#title]
          ]
        ],
        [
          #if system != none [
            #badge(system, variant: "outline")
          ]
        ]
      )
    ][
      #set par(justify: true)
      #body
    ]
  ]
}

/// Hand-Worked Step-by-Step Numerical Example (Notebook Card)
#let worked-example(..args) = {
  let (title, body) = _parse-args(args)
  let problem = if "problem" in args.named() { args.named().problem } else { none }
  let solution = if "solution" in args.named() { args.named().solution } else { none }

  block(
    width: 100%,
    breakable: true,
    stroke: strokes.border + rgb("#FDE68A"),
    radius: radii.md,
    fill: white,
    clip: true,
    above: 1.25em,
    below: 1.25em,
  )[
    // Header
    #block(
      width: 100%,
      fill: rgb("#FFFBEB"),
      stroke: (bottom: strokes.hairline + rgb("#FEF3C7")),
      inset: (x: 12pt, y: 7pt),
      above: 0pt,
      below: 0pt,
    )[
      #grid(
        columns: (auto, 1fr),
        gutter: 8pt,
        align: (horizon, horizon),
        [
          #box(
            fill: floe-amber,
            inset: (x: 5pt, y: 2.2pt),
            radius: radii.sm,
            text(font: fonts.sans, size: 7.8pt, weight: "bold", fill: white, tracking: 0.08em)[
              WORKED NUMERICAL EXAMPLE
            ]
          )
        ],
        [
          #if title != none [
            #text(font: fonts.sans, size: 9.8pt, weight: "bold", fill: floe-navy)[#title]
          ]
        ]
      )
    ]

    // Body
    #block(
      width: 100%,
      inset: (x: 13pt, y: 10pt),
      above: 0pt,
      below: 0pt,
    )[
      #if problem != none [
        #block(fill: slate-50, inset: 8pt, radius: radii.sm, stroke: strokes.hairline + slate-200)[
          #text(font: fonts.sans, size: 8pt, weight: "bold", fill: slate-600)[PROBLEM STATEMENT:]
          #v(2pt)
          #problem
        ]
        #v(6pt)
      ]
      #body
      #if solution != none [
        #v(6pt)
        #block(fill: rgb("#F0FDF4"), inset: 8pt, radius: radii.sm, stroke: strokes.hairline + rgb("#BBF7D0"))[
          #text(font: fonts.sans, size: 8pt, weight: "bold", fill: rgb("#15803D"))[FINAL RESULT:]
          #h(6pt)
          #solution
        ]
      ]
    ]
  ]
}
#let worked(..args) = worked-example(..args)

#let _render-symbol-card(s-color, s-label, s-name, s-desc, h: auto) = block(
  width: 100%,
  height: h,
  inset: (x: 4pt, y: 4pt),
)[
  // Top Row: Bean & Title
  #grid(
    columns: (auto, 1fr),
    gutter: 7pt,
    align: (horizon, horizon),
    box(
      fill: s-color.lighten(88%),
      stroke: strokes.hairline + s-color.lighten(35%),
      inset: (x: 6pt, y: 2.5pt),
      radius: radii.sm,
      text(font: fonts.sans, size: 8.5pt, weight: "bold", fill: s-color)[#s-label]
    ),
    text(font: fonts.sans, size: 9pt, weight: "bold", fill: floe-navy)[#s-name]
  )
  // Bottom Description: Full width, zero left padding/indent
  #if s-desc != none [
    #v(3pt)
    #block(width: 100%)[
      #set text(size: 8.2pt, fill: slate-700)
      #s-desc
    ]
  ]
]

/// Canva Visual Formula Breakdown Canvas
/// Displays equation prominently on a pedestal, followed by symbol breakdown cards & numerical sanity check.
#let formula-breakdown(
  formula: none,
  symbols: (),
  ascii: "",
  arithmetic: none,
  card-columns: (1fr, 1fr),
  breakable: false,
) = block(
  width: 100%,
  stroke: strokes.border + slate-300,
  radius: radii.md,
  fill: white,
  clip: true,
  above: 1.2em,
  below: 1.3em,
  breakable: breakable,
)[
  // Header
  #block(
    width: 100%,
    fill: slate-100,
    stroke: (bottom: strokes.hairline + slate-200),
    inset: (x: 12pt, y: 6pt),
    above: 0pt,
    below: 0pt,
  )[
    #grid(
      columns: (auto, 1fr),
      gutter: 8pt,
      align: (horizon, horizon),
      [
        #box(fill: slate-800, inset: (x: 5pt, y: 2pt), radius: radii.sm)[
          #text(font: fonts.sans, size: 7.5pt, weight: "bold", fill: white, tracking: 0.08em)[FORMULA BREAKDOWN]
        ]
      ],
      [
        #text(font: fonts.sans, size: 9pt, weight: "bold", fill: floe-navy)[Symbol-by-Symbol Mechanics]
      ]
    )
  ]
  #if formula != none [
    #block(
      width: 100%,
      fill: rgb("#F8FAFC"),
      stroke: (bottom: strokes.hairline + slate-200),
      inset: (y: 10pt),
      above: 0pt,
      below: 0pt,
      align(center)[
        #text(size: 13pt)[
          #if type(formula) == content and formula.func() == math.equation [
            #formula
          ] else if type(formula) == str [
            $#formula$
          ] else [
            #formula
          ]
        ]
      ]
    )
  ]
  #if symbols.len() > 0 [
    #block(
      width: 100%,
      inset: 8pt,
      above: 0pt,
      below: 0pt,
    )[
      #layout(size => {
        let ncols = card-columns.len()
        let gutter = 8pt
        let col-w = (size.width - gutter * (ncols - 1)) / ncols
        let chunks = ()
        let curr = ()
        for s in symbols {
          curr.push(s)
          if curr.len() == ncols {
            chunks.push(curr)
            curr = ()
          }
        }
        if curr.len() > 0 {
          chunks.push(curr)
        }

        context {
          for (row-idx, chunk) in chunks.enumerate() [
            #if row-idx > 0 [ #v(gutter) ]
            #let measured = chunk.map(s => {
              let s-color = s.at(0)
              let s-label = s.at(1)
              let s-name = s.at(2)
              let s-desc = if s.len() >= 4 { s.at(3) } else { none }
              measure(block(width: col-w, _render-symbol-card(s-color, s-label, s-name, s-desc)))
            })
            #let max-h = calc.max(..measured.map(m => m.height))

            #grid(
              columns: card-columns.slice(0, chunk.len()),
              gutter: gutter,
              ..chunk.map(s => {
                let s-color = s.at(0)
                let s-label = s.at(1)
                let s-name = s.at(2)
                let s-desc = if s.len() >= 4 { s.at(3) } else { none }
                _render-symbol-card(s-color, s-label, s-name, s-desc, h: max-h)
              })
            )
          ]
        }
      })
    ]
  ]
  #if ascii != "" and symbols.len() == 0 [
    #block(
      width: 100%,
      inset: 8pt,
      above: 0pt,
      below: 0pt,
      align(center)[
        #raw(ascii, lang: "text")
      ]
    )
  ]
  #if arithmetic != none [
    #block(
      width: 100%,
      fill: rgb("#F0FDF4"),
      stroke: (top: strokes.hairline + slate-200),
      inset: (x: 12pt, y: 7pt),
      above: 0pt,
      below: 0pt,
    )[
      #grid(
        columns: (auto, 1fr),
        gutter: 6pt,
        align: (top, top),
        text(font: fonts.sans, size: 8pt, fill: rgb("#16A34A"))[✓],
        [
          #text(font: fonts.sans, size: 8pt, weight: "bold", fill: rgb("#15803D"))[Concrete Numerical Verification:]
          #h(4pt)
          #set text(size: 8.5pt)
          #arithmetic
        ]
      )
    ]
  ]
]
#let cutting-board = formula-breakdown
#let anatomy = formula-breakdown

/// MATLAB / Numerical Tooling Card
#let matlab-box(..args) = {
  let (title, body) = _parse-args(args)
  card(
    title: if title != none { title } else { "MATLAB / Numerical Practice" },
    badge-label: "MATLAB",
    badge-variant: "warning",
    border-color: slate-200,
    body,
  )
}
