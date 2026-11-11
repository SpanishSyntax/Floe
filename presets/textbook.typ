// ============================================================================
// FLOE DESIGN SYSTEM — TEXTBOOK PRESET (presets/textbook.typ)
// Optional Convenience Wrapper for Single-Column Course Companions
// ============================================================================
#import "../core/lib.typ": *
#import "../mixins/lib.typ": *

/// Full single-column deep-reader textbook companion layout
#let textbook(
  title: "Course Title",
  subtitle: "Comprehensive Companion Reader & Closed-Book Exam Guide",
  course-code: "SC42000",
  institution: "Systems & Control Institute • Academic Series",
  edition: "Comprehensive Companion Edition",
  cover-page: none,
  toc: true,
  body,
) = {
  set document(title: course-code + " — " + title, author: course-code + " Study Companion")

  set page(
    paper: "a4",
    columns: 1,
    margin: (top: 2.4cm, bottom: 2.4cm, left: 2.6cm, right: 2.6cm),
  )

  set text(font: fonts.serif, size: 10.3pt, fill: slate-900, lang: "en")
  set par(justify: true, leading: 0.66em, spacing: 1.05em)

  show: with-code-theme
  show: with-heading-theme.with(numbering: "1.1")
  show: with-math-theme
  show: with-running-chrome.with(
    header-left: context {
      let ch = hydra(1)
      [*#course-code* #if ch != none [ • #ch] else [ • #title]]
    },
    header-right: context {
      let sec = hydra(2)
      if sec != none [#sec] else [Companion Reader]
    },
    suppress-pages: 2,
  )

  // Clean table defaults
  set table(
    stroke: strokes.border + slate-300,
    inset: (x: 7pt, y: 5.5pt),
    fill: (_, y) => if y == 0 { slate-100 } else if calc.even(y) { rgb("#FAFAFA") } else { white },
  )

  // Cover Page
  if cover-page != none {
    cover-page
  }

  // Table of Contents
  if toc {
    page[
      #heading(level: 1, numbering: none, outlined: false)[Contents]
      #line(length: 100%, stroke: 1.2pt + floe-cyan)
      #v(0.4em)
      #outline(title: none, indent: 1.4em, depth: 2)
    ]
  }

  body
}
