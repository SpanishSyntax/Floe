// ============================================================================
// FLOE DESIGN SYSTEM — HERO BANNERS & EDITORIAL HEADERS (components/hero.typ)
// Chapter Openers, Presentation Cards, Section Heros, Figures & Side-by-Side
// ============================================================================
#import "../core/lib.typ": *
#import "../primitives/lib.typ": badge

// ----------------------------------------------------------------------------
// 1. Chapter Openers & Course Heros
// ----------------------------------------------------------------------------

/// Chapter Header Banner with syllabus mapping, slide reference, and interactive lab tracking
#let chapter-header(
  num: 1,
  title: "",
  subtitle: none,
  eyebrow: "CHAPTER",
  slides-ref: "",
  reader-ref: "",
  teardown-ref: "",
) = {
  pagebreak(weak: true)
  counter(heading).update((num, 0))
  block(width: 100%, below: 1.4em)[
    #block(below: 0.35em)[
      #text(font: fonts.sans, size: 9.5pt, weight: "bold", fill: floe-cyan, tracking: 0.08em)[
        #if eyebrow != "" [#upper(eyebrow) #num] else [CHAPTER #num]
      ]
    ]
    #heading(level: 1, numbering: none)[#num. #title]
    #if subtitle != none [
      #v(-0.2em)
      #text(font: fonts.sans, size: 10.5pt, fill: slate-600)[#subtitle]
    ]
    #v(0.2em)
    #line(length: 100%, stroke: 1.5pt + floe-cyan)
    #v(0.25em)
    #if slides-ref != "" or reader-ref != "" or teardown-ref != "" [
      #block(
        width: 100%,
        fill: slate-50,
        stroke: strokes.border + slate-200,
        radius: radii.base,
        inset: (x: 10pt, y: 6pt),
      )[
        #set text(font: fonts.sans, size: 8.2pt, fill: floe-slate)
        #if slides-ref != "" [*Official Course Mapping:* #h(4pt) #slides-ref]
        #if reader-ref != "" [ #h(8pt) | #h(8pt) #reader-ref ]
        #if teardown-ref != "" [
          #h(8pt) | #h(8pt) *Interactive Lab:* #teardown-ref
        ]
      ]
    ]
  ]
}

/// Canva / Editorial Magazine Chapter Opener Header
#let editorial-header(
  num: none,
  eyebrow: "MODULE OVERVIEW",
  title: "",
  subtitle: none,
  read-time: none,
  authors: (),
  goals: (),
  above: 0pt,
  below: 1.6em,
) = block(
  width: 100%,
  above: above,
  below: below,
)[
  #grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    [
      #box(fill: floe-cyan.lighten(85%), inset: (x: 6pt, y: 2.5pt), radius: radii.sm)[
        #text(font: fonts.sans, size: 7.8pt, weight: "bold", fill: floe-navy, tracking: 0.08em)[
          #if num != none [CHAPTER #num • ] #upper(eyebrow)
        ]
      ]
    ],
    if read-time != none [
      #text(font: fonts.sans, size: 8pt, fill: slate-400)[⏱ #read-time]
    ]
  )
  #v(4pt)
  #heading(level: 1, numbering: none)[#title]
  #if subtitle != none [
    #v(-0.2em)
    #text(font: fonts.sans, size: 10.5pt, fill: slate-600)[#subtitle]
  ]
  #v(4pt)
  #line(length: 100%, stroke: 1.5pt + floe-cyan)
  #v(2pt)

  // Learning Outcomes / Goals Pill Grid
  #if goals.len() > 0 [
    #block(
      width: 100%,
      fill: slate-50,
      stroke: strokes.border + slate-200,
      radius: radii.base,
      inset: (x: 10pt, y: 6pt),
    )[
      #grid(
        columns: (auto, 1fr),
        gutter: 8pt,
        align: (top, top),
        text(font: fonts.sans, size: 7.8pt, weight: "bold", fill: floe-navy)[LEARNING GOALS:],
        [
          #set text(font: fonts.sans, size: 8pt, fill: slate-700)
          #goals.join([ #h(6pt)•#h(6pt) ])
        ]
      )
    ]
  ]
]

/// Minimalist Breadcrumb Header (Clean Editorial Monograph)
#let minimal-header(
  title: "",
  breadcrumbs: (),
  date: none,
  below: 1.4em,
) = block(width: 100%, below: below)[
  #if breadcrumbs.len() > 0 [
    #text(font: fonts.sans, size: 7.8pt, fill: slate-400, tracking: 0.06em)[
      #breadcrumbs.join(" / ")
    ]
    #v(2pt)
  ]
  #heading(level: 1, numbering: none)[#title]
  #v(2pt)
  #line(length: 100%, stroke: strokes.hairline + slate-300)
]

/// Full-Width Hero Section Banner (Dividing Major Topic Shifts)
#let section-hero(
  title: "",
  subtitle: none,
  badge-label: "DEEP DIVE",
  icon: "✦",
  accent: floe-navy,
) = block(
  width: 100%,
  fill: accent,
  radius: radii.md,
  inset: (x: 14pt, y: 12pt),
  above: 1.6em,
  below: 1.4em,
)[
  #grid(
    columns: (auto, 1fr),
    gutter: 10pt,
    align: (horizon, horizon),
    box(
      width: 22pt,
      height: 22pt,
      fill: white.transparentize(85%),
      radius: radii.full,
      align(center + horizon)[#text(size: 11pt, fill: floe-cyan)[#icon]]
    ),
    [
      #text(font: fonts.sans, size: 7.5pt, weight: "bold", fill: floe-cyan, tracking: 0.1em)[#upper(badge-label)]
      #v(1pt)
      #text(font: fonts.sans, size: 12.5pt, weight: "bold", fill: white)[#title]
      #if subtitle != none [
        #v(1pt)
        #text(font: fonts.sans, size: 8.5pt, fill: slate-300)[#subtitle]
      ]
    ]
  )
]

/// Subchapter syllabus preview card
#let subchapter-card(
  title: "",
  body,
) = block(
  width: 100%,
  fill: slate-100,
  stroke: (left: strokes.accent + floe-navy),
  radius: (right: radii.base),
  inset: (x: 12pt, y: 8pt),
  above: 1.2em,
  below: 1.2em,
)[
  #text(font: fonts.sans, size: 9.5pt, weight: "bold", fill: floe-navy)[#title]
  #v(0.3em)
  #set text(font: fonts.sans, size: text-scale.sm, fill: slate-700)
  #body
]

/// Presentation 16:9 keynote hero card
#let keynote-hero(
  title: "",
  subtitle: "",
  tag: none,
) = block(
  width: 100%,
  fill: floe-navy,
  radius: radii.md,
  inset: (x: 20pt, y: 22pt),
  above: 1em,
  below: 1em,
)[
  #if tag != none [
    #text(font: fonts.sans, size: 8.5pt, weight: "bold", fill: floe-cyan, tracking: 0.12em)[#upper(tag)]
    #v(0.4em)
  ]
  #text(font: fonts.sans, size: 20pt, weight: "bold", fill: white)[#title]
  #if subtitle != "" [
    #v(0.3em)
    #text(font: fonts.sans, size: 11pt, fill: slate-300)[#subtitle]
  ]
]

/// Executive Document Header Banner (Clean Header for Reports & Memos)
#let document-hero(
  title: "",
  subtitle: "",
  metadata: (),
  accent: floe-cyan,
) = block(
  width: 100%,
  below: 1.5em,
)[
  #line(length: 100%, stroke: 2.5pt + accent)
  #v(0.4em)
  #text(font: fonts.sans, size: 20pt, weight: "bold", fill: floe-navy)[#title]
  #if subtitle != "" [
    #v(0.2em)
    #text(font: fonts.sans, size: 11pt, fill: floe-muted)[#subtitle]
  ]
  #if metadata.len() > 0 [
    #v(0.6em)
    #grid(
      columns: (1fr,) * calc.min(metadata.len(), 4),
      gutter: 10pt,
      ..metadata.map(item => [
        #text(font: fonts.sans, size: text-scale.xs, weight: "bold", fill: floe-muted)[#upper(item.at(0))] \
        #text(font: fonts.sans, size: text-scale.sm, fill: slate-800)[#item.at(1)]
      ])
    )
  ]
  #v(0.4em)
  #line(length: 100%, stroke: strokes.hairline + slate-200)
]

// ----------------------------------------------------------------------------
// 2. Figures & Graphic Layouts
// ----------------------------------------------------------------------------

/// High-resolution figure wrapper with automatic path normalization across Snowpack & Lantern
#let reader-fig(
  path,
  caption: none,
  width: 88%,
  alt: none,
) = {
  let img-path = path
  if type(path) == str {
    if path.starts-with("/reader/figures/") {
      img-path = "figures/" + path.slice("/reader/figures/".len())
    } else if path.starts-with("/site/content/figures/") {
      img-path = "../site/content/figures/" + path.slice("/site/content/figures/".len())
    } else if path.starts-with("../figures/") {
      img-path = "figures/" + path.slice("../figures/".len())
    }
  }

  figure(
    block(
      width: 100%,
      inset: (y: 4pt),
      align(center, if type(img-path) == str {
        image(img-path, width: width, alt: alt)
      } else {
        img-path
      }),
    ),
    caption: caption,
  )
}

/// Side-by-side comparative layout for multi-panel plots, diagrams, or math vs code
#let side-by-side(
  columns: (1fr, 1fr),
  gutter: 12pt,
  ..items,
) = {
  grid(
    columns: columns,
    gutter: gutter,
    align: top,
    ..items.pos()
  )
}
