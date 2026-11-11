// ============================================================================
// FLOE DESIGN SYSTEM — ADAPTIVE TABLES (components/tables.typ)
// Proportional Data Tables, Specs, and Matrix Comparison Grids
// ============================================================================
#import "../core/lib.typ": *
#import "../primitives/lib.typ": badge

/// Safe, proportional data table with automatic fractional column distribution,
/// zebra striping, centered header text, and semantic table.header repetition.
#let data-table(
  columns: none,
  headers: (),
  align: auto,
  stroke: strokes.border + slate-300,
  inset: (x: 7pt, y: 5.5pt),
  fill: (_, y) => if y == 0 { slate-100 } else if calc.even(y) { rgb("#FAFAFA") } else { white },
  ..cells,
) = {
  let resolved-cols = columns
  if resolved-cols == none {
    if headers.len() > 0 {
      resolved-cols = (1fr,) * headers.len()
    } else {
      resolved-cols = 1
    }
  }

  let resolved-align = if align != auto {
    align
  } else {
    (col, row) => if row == 0 { center + horizon } else { left + horizon }
  }

  table(
    columns: resolved-cols,
    align: resolved-align,
    stroke: stroke,
    inset: inset,
    fill: fill,
    if headers.len() > 0 {
      table.header(..headers.map(h => table.cell(align: center + horizon)[*#h*]))
    },
    ..cells.pos()
  )
}

/// Clean 2-column parameter / specification key-value table
#let spec-table(
  columns: (1fr, 2.2fr),
  align: (right + horizon, left + horizon),
  stroke: strokes.border + slate-200,
  inset: (x: 8pt, y: 5.5pt),
  ..pairs,
) = {
  table(
    columns: columns,
    align: align,
    stroke: stroke,
    inset: inset,
    fill: (_, y) => if calc.even(y) { slate-50 } else { white },
    ..pairs.pos().map(item => {
      if type(item) == array and item.len() == 2 {
        ([*#item.at(0)*], item.at(1))
      } else {
        item
      }
    }).flatten()
  )
}

/// Comparison grid with status chips (e.g. #badge-yes, #badge-no, #badge-opt)
#let badge-yes = badge("YES", variant: "success")
#let badge-no  = badge("NO",  variant: "danger")
#let badge-opt = badge("OPT", variant: "purple")

#let comparison-table(
  columns: none,
  headers: (),
  ..cells,
) = data-table(
  columns: columns,
  headers: headers,
  align: center + horizon,
  ..cells,
)
