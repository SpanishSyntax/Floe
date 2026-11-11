// ============================================================================
// FLOE DESIGN SYSTEM — TABLE THEME MIXIN (mixins/tables.typ)
// Composable Show Rule for Shadcn Data Tables
// ============================================================================
#import "../core/lib.typ": *

/// Opt-in show rule to style all native tables with Shadcn styling
#let with-table-theme(body) = {
  set table(
    stroke: strokes.border + slate-200,
    inset: (x: 8pt, y: 6pt),
    fill: (_, y) => if y == 0 { slate-100 } else if calc.even(y) { rgb("#F8FAFC") } else { white },
  )

  show table.cell.where(y: 0): set text(font: fonts.sans, weight: "bold", size: 8.8pt, fill: floe-navy)

  body
}
