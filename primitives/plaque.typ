// ============================================================================
// FLOE DESIGN SYSTEM — MASTER PLAQUE PRIMITIVE (primitives/plaque.typ)
// Unified Container for Theorems, Definitions, Lemmas, Algorithms & Axioms
// Features: Flexible Header, title-below for long titles, takeaway footer
// ============================================================================
#import "../core/lib.typ": *
#import "badge.typ": badge

/// Master Generalized Plaque Primitive
/// Unifies theorems, definitions, lemmas, corollaries, and algorithms into a single atomic primitive.
#let plaque(
  tag: none,
  num: none,
  title: none,
  subtitle: none,
  badge-label: none,
  badge-variant: "outline",
  accent: floe-navy,
  header-fill: auto,
  title-below: false,
  footer: none,
  border-color: auto,
  radius: radii.md,
  above: 1.15em,
  below: 1.15em,
  breakable: true,
  body,
) = {
  let resolved-border = if border-color != auto {
    border-color
  } else if header-fill == floe-navy or header-fill == slate-800 {
    slate-300
  } else {
    accent.lighten(65%)
  }

  let resolved-header-fill = if header-fill != auto {
    header-fill
  } else {
    slate-100
  }

  let is-dark-header = (
    header-fill == floe-navy or
    header-fill == slate-800 or
    header-fill == slate-900 or
    header-fill == rgb("#0B1E36")
  )

  let tag-text-color = if is-dark-header { white } else { accent }
  let title-text-color = if is-dark-header { white } else { floe-navy }

  block(
    width: 100%,
    breakable: breakable,
    stroke: strokes.border + resolved-border,
    radius: radius,
    fill: white,
    clip: true,
    above: above,
    below: below,
  )[
    // Header Bar (if tag, title, or badge present)
    #if tag != none or title != none or badge-label != none [
      #block(
        width: 100%,
        fill: resolved-header-fill,
        stroke: (bottom: strokes.hairline + resolved-border),
        inset: (x: 10pt, y: if title-below { 6pt } else { 6.5pt }),
        above: 0pt,
        below: 0pt,
      )[
        #if title-below [
          // Tag and Badges on Top Row
          #grid(
            columns: (auto, 1fr, auto),
            gutter: 6pt,
            align: (horizon, horizon, horizon),
            if tag != none [
              #box(
                fill: accent,
                inset: (x: 5pt, y: 2pt),
                radius: radii.sm,
                text(font: fonts.sans, size: 7.5pt, weight: "bold", fill: white, tracking: 0.08em)[
                  #upper(tag)#if num != none [ #num]
                ]
              )
            ],
            [
              #if subtitle != none [
                #text(
                  font: fonts.sans,
                  size: 7.8pt,
                  fill: if is-dark-header { slate-300 } else { slate-500 },
                )[#subtitle]
              ]
            ],
            if badge-label != none [
              #badge(badge-label, variant: badge-variant)
            ]
          )
          // Title on its own dedicated full-width line below
          #if title != none [
            #v(4pt)
            #text(font: fonts.sans, size: 9.8pt, weight: "bold", fill: title-text-color)[#title]
          ]
        ] else [
          // Inline Header: Tag, Title, and Badge on the same line
          #grid(
            columns: (auto, 1fr, auto),
            gutter: 8pt,
            align: (horizon, horizon, horizon),
            if tag != none [
              #box(
                fill: accent,
                inset: (x: 5pt, y: 2pt),
                radius: radii.sm,
                text(font: fonts.sans, size: 7.5pt, weight: "bold", fill: white, tracking: 0.08em)[
                  #upper(tag)#if num != none [ #num]
                ]
              )
            ],
            [
              #if title != none [
                #text(font: fonts.sans, size: 9.2pt, weight: "bold", fill: title-text-color)[#title]
              ]
              #if subtitle != none [
                #h(6pt)
                #text(
                  font: fonts.sans,
                  size: 8pt,
                  fill: if is-dark-header { slate-300 } else { slate-500 },
                )[#subtitle]
              ]
            ],
            if badge-label != none [
              #badge(badge-label, variant: badge-variant)
            ]
          )
        ]
      ]
    ]
    #block(
      width: 100%,
      inset: (x: 11pt, top: 8.5pt, bottom: if footer != none { 5pt } else { 8.5pt }),
      above: 0pt,
      below: 0pt,
    )[
      #show math.equation.where(block: true): it => block(above: 0.55em, below: 0.45em, it)
      #set par(justify: true)
      #body
    ]
    #if footer != none [
      #block(
        width: 100%,
        fill: rgb("#FFFBEB"),
        stroke: (top: strokes.hairline + if is-dark-header { rgb("#FDE68A") } else { resolved-border }),
        inset: (x: 11pt, y: 6.5pt),
        above: 0pt,
        below: 0pt,
      )[
        #set text(font: fonts.sans, size: text-scale.xs, fill: rgb("#92400E"))
        #footer
      ]
    ]
  ]
}
