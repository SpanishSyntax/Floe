# Layer 4: Document Presets

[Overview](README.md) • [Getting Started](getting-started.md) • [Core](core.md) • [Primitives](primitives.md) • [Mixins](mixins.md) • [Components](components.md) • [Presets](presets.md)

---

Presets are ready-to-use master document wrappers. They configure paper geometry, margins, typographic hierarchies, anti-orphan heading rules, and running headers in a single `#show` call.

---

## Textbook Companion

Full single-column publication-grade textbook companion:

```typst
#import "@preview/floe:0.1.0": *

#show: textbook.with(
  title: "Optimal Control & Dynamic Programming",
  subtitle: "State-Space Feedback, Riccati Equations & Bellman Optimality",
  course-code: "SC42056",
  institution: "Systems & Control Institute • Academic Series",
  edition: "Comprehensive Companion Edition",
  toc: true,
)

// Document body with #chapter-header(...) and == sections
```

![Textbook Companion Preview](assets/examples/preset_textbook.png)

*Standalone Example:* [`examples/textbook_example.typ`](examples/textbook_example.typ)

---

## Engineering Report

Clean, professional technical report:

```typst
#import "@preview/floe:0.1.0": *

#show: report.with(
  title: "Autonomous Spacecraft Attitude Determination & Control",
  subtitle: "Critical Design Review (CDR) & Subsystem Benchmark",
  author: "Guidance, Navigation & Control Team",
  date: "November 2026",
)
```

![Engineering Report Preview](assets/examples/preset_report.png)

*Standalone Example:* [`examples/report_example.typ`](examples/report_example.typ)

---

## Presentation Slides

16:9 widescreen presentation slide deck with dark and light theme options:

```typst
#import "@preview/floe:0.1.0": *

#show: slides.with(
  title: "Convex Optimization in Embedded Control",
  theme: "dark", // or "light"
)

#keynote-hero(
  tag: "LECTURE 04",
  title: "Karush-Kuhn-Tucker Conditions",
  subtitle: "Primal optimality, dual feasibility, and complementary slackness",
)
```

![Presentation Slides Preview](assets/examples/preset_slides.png)

*Standalone Example:* [`examples/slides_example.typ`](examples/slides_example.typ)

---

## Formula Cheatsheet

High-density 2- or 3-column landscape revision sheet for closed-book exams:

```typst
#import "@preview/floe:0.1.0": *

#show: cheatsheet.with(
  title: "Convex Optimization Quick Reference",
  course-code: "SC42056",
  columns-num: 3,
  paper: "a4",
  orientation: "landscape",
)
```

![Formula Cheatsheet Preview](assets/examples/preset_cheatsheet.png)

*Standalone Example:* [`examples/cheatsheet_example.typ`](examples/cheatsheet_example.typ)

---

## Decision Memo

Executive technical brief with a metadata header plaque:

```typst
#import "@preview/floe:0.1.0": *

#show: memo.with(
  title: "Real-Time Embedded Solver Selection for GNC",
  to: "Guidance & Control Engineering Board",
  from: "Flight Software Architecture Team",
  date: "November 2026",
  subject: "Trade Study: Active-Set vs. Primal-Dual Interior-Point QP Solvers",
  summary: [
    *Recommendation:* Adopt condensed primal-dual active-set quadratic program (QP) solver `qpOASES` with fixed hot-starting.
  ],
)
```

![Decision Memo Preview](assets/examples/preset_memo.png)

*Standalone Example:* [`examples/memo_example.typ`](examples/memo_example.typ)
