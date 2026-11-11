// ============================================================================
// FLOE DESIGN SYSTEM — MATHEMATICAL COMPONENTS (components/math.typ)
// Systems, Control, Matrix Calculus Notation & Semantic Equation Dissection
// ============================================================================
#import "../core/lib.typ": *

// ----------------------------------------------------------------------------
// 1. Canonical Operators & Spaces
// ----------------------------------------------------------------------------

#let argmin  = math.op("arg min", limits: true)
#let argmax  = math.op("arg max", limits: true)
#let diag    = math.op("diag")
#let rank    = math.op("rank")
#let tr      = math.op("tr")
#let sign    = math.op("sign")
#let epi     = math.op("epi")
#let conv    = math.op("conv")
#let dom     = math.op("dom")
#let Vol     = math.op("Vol")
#let span-op = math.op("span")
#let col     = math.op("col")
#let null-op = math.op("null")
#let ker     = math.op("ker")
#let im-op   = math.op("im")
#let Re      = math.op("Re")
#let Im      = math.op("Im")
#let ddot(x) = math.dot.double(x)

// Canonical spaces and relation shorthand
#let st      = $quad "s.t." quad$
#let Rn      = $RR^n$
#let Rm      = $RR^m$
#let Rp      = $RR^p$
#let Rnxn    = $RR^(n times n)$
#let Rnxm    = $RR^(n times m)$
#let Rpxn    = $RR^(p times n)$
#let Rpxm    = $RR^(p times m)$

// ----------------------------------------------------------------------------
// 2. Equation Dissection & Semantic Color Coding
// ----------------------------------------------------------------------------

// Math term semantic color wrappers
#let math-state(x)   = text(fill: c-state, weight: "bold")[$#x$]
#let math-input(x)   = text(fill: c-input, weight: "bold")[$#x$]
#let math-cost(x)    = text(fill: c-cost, weight: "bold")[$#x$]
#let math-sensor(x)  = text(fill: c-sensor, weight: "bold")[$#x$]
#let math-noise(x)   = text(fill: c-noise, weight: "bold")[$#x$]
#let math-est(x)     = text(fill: c-est, weight: "bold")[$#x$]

// Annotated Underbrace / Overbrace helpers with matching label colors
#let math-annot(term, label, color: c-state) = {
  $underbrace(#text(fill: color)[$#term$], #text(fill: color, size: text-scale.xs, font: fonts.sans)[#label])$
}
#let math-annot-top(term, label, color: c-state) = {
  $overbrace(#text(fill: color)[$#term$], #text(fill: color, size: text-scale.xs, font: fonts.sans)[#label])$
}

// Equation Color Legend Box (Q2 Professor Style)
#let eq-legend(..items) = {
  block(
    width: 100%,
    fill: slate-50,
    stroke: strokes.border + slate-300,
    radius: radii.base,
    inset: (x: 10pt, y: 7pt),
    above: 0.6em,
    below: 1.0em,
  )[
    #set text(font: fonts.sans, size: 8.3pt)
    #grid(
      columns: (auto, 1fr),
      gutter: 8pt,
      ..items.pos().map(it => (
        [#box(width: 8pt, height: 8pt, fill: it.at(0), radius: radii.sm)],
        [*#it.at(1):* #h(4pt) #it.at(2)]
      )).flatten()
    )
  ]
}
