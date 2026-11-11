#import "../lib.typ": *

#show: textbook.with(
  title: "Floe Design System: Architectural Anatomy",
  subtitle: "Three-Layer Architecture: Primitives, Mixins & High-Level Domain Presets",
  course-code: "FLOE-CORE",
  institution: "Frost / Icebergs Ecosystem • Pyrite Labs",
  toc: true,
)

// Apply Mixins for this document
#show: with-code-theme

#chapter-header(
  num: 1,
  title: "Layer 1: Atomic Primitives",
  slides-ref: "Deck 01: Atoms & Layouts",
  reader-ref: "Ch 1: Pure Atoms",
  teardown-ref: "Lab 01: Unstyled Primitives",
)

Primitives have *zero domain opinion*. They handle boxing, borders, layout geometry, metrics, and flush attachment. Everything in Floe is constructed from these atoms.

== Structural Containers

#card(
  title: "Shadcn Card Primitive",
  description: "Segmented container with subtle border and flush header/content/footer attachment",
  badge-label: "PRIMITIVE",
  badge-variant: "info",
  icon: text(size: 11pt)[⚙],
  footer: [Card Footer: 100% full-width attachment with hairline dividing stroke],
)[
  The `#card` primitive accepts arbitrary body content. It enforces structural separation with zero vertical gaps between filled child blocks.
]

#v(8pt)

#plaque(
  tag: "PRIMITIVE",
  num: "1.0",
  title: "Master Plaque Container",
  subtitle: "Generalized container for titles, headers, bodies, and footers",
  accent: floe-cyan,
  header-fill: rgb("#F0F9FF"),
  border-color: rgb("#BAE6FD"),
  title-below: false,
  footer: [Plaque Takeaway Footer: Directly attached with top hairline stroke],
)[
  The `#plaque` primitive powers `theorem`, `definition`, `lemma`, `algorithm`, and `corollary`.
]

== Micro-Atoms & Dividers

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  [
    Pill Badges: #badge("INFO", variant: "info") #badge("SUCCESS", variant: "success") #badge("WARNING", variant: "warning") #badge("DANGER", variant: "danger") #badge("PURPLE", variant: "purple") #badge("OUTLINE", variant: "outline") \
    Keycaps: #kbd("Ctrl") + #kbd("Shift") + #kbd("P") or #kbd("⌘") + #kbd("K")
  ],
  [
    #text-divider("CONTINUATION")
    #chip-divider("BOXED CHIP")
    #fade-divider(color: floe-cyan)
  ]
)

== Aligned Stepper & Item Cards

#stepper(
  steps: (
    (1, "Primal Update", [$x^(k+1) = arg min_x cal(L)_rho (x, z^k, y^k)$]),
    (2, "Slack Variable Projection", [$z^(k+1) = Pi_cal(Z) (x^(k+1) + 1/rho y^k)$]),
    (3, "Dual Gradient Ascent", [$y^(k+1) = y^k + rho (x^(k+1) - z^(k+1))$]),
  )
)

#v(6pt)

#item-grid(
  columns: (1fr, 1fr),
  item-card(label: "u(t)", title: "Actuator Input Vector", color: floe-cyan)[
    Physical steering torques, motor coil currents, or thruster gimbal angles ($RR^m$).
  ],
  item-card(label: "x(t)", title: "State Trajectory Vector", color: floe-navy)[
    Rigid body attitude quaternions and angular body rates ($RR^n$).
  ],
)

== Layout Primitives

#split-view(
  titles: ("Theory (Abstract)", "Hardware (Physical)"),
  badges: ("ALGEBRA", "SATELLITE"),
  [Linear state space: $dot(x) = A x + B u$],
  [Torque rods interact with geomagnetic field: $tau = m times B_text("geo")$],
)

#v(8pt)

#pro-con(
  title: "Interior-Point Methods (IPM) vs. Active-Set Solvers",
  pros: ([Polynomial-time worst-case complexity $cal(O)(n^3)$], [Scales exceptionally to $n > 10^5$ sparse variables]),
  cons: ([Combinatorial worst-case iteration counts $2^m$], [Prone to cycling without Bland anti-cycling rule]),
)

#pagebreak()

#chapter-header(
  num: 2,
  title: "Layer 2: Composable Mixins",
  slides-ref: "Deck 02: Show-Rule Mixins",
  reader-ref: "Ch 2: Behavioral Modifiers",
  teardown-ref: "Lab 02: Pipeline Hooks",
)

Mixins are *pure `#show` rules* that transform default Typst and GitHub Markdown syntax into Floe themes without requiring changes to raw Markdown content:

#data-table(
  columns: (1.2fr, 1.4fr, 2.4fr),
  headers: ("Mixin", "Target Typst Element", "Visual Transformation"),
  "`with-code-theme`", "`raw.where(block: true)`", "macOS terminal window with red/yellow/green traffic dots and language badge",
  "`with-gfm-theme`", "`quote` / `cmarker` callouts", "Maps `> [!NOTE]`, `> [!WARNING]` directly to Floe Shadcn alerts",
  "`with-heading-theme`", "`heading`", "Number formatting, bold typography hierarchy, and subtle hairline dividers",
  "`with-math-theme`", "`math.equation`", "Balanced vertical breathing room and centered equation pedestals",
  "`with-table-theme`", "`table`", "Hairline header separators, alternating zebra rows, and cell padding",
  "`with-running-chrome`", "`page.header` & `page.footer`", "Editorial top running breadcrumbs and bottom page numbering",
  "`with-compact-theme`", "margins & gutters", "Tightens insets and font scales for dense closed-book cheatsheets",
)

== Code Theme in Action

```rust
// Floe terminal code block with automatic syntax highlighting and language badge
pub fn compute_feedback_gain(r: &Matrix, b: &Matrix, p: &Matrix, a: &Matrix) -> Matrix {
    let inv_term = (r + b.transpose() * p * b).inverse().unwrap();
    inv_term * b.transpose() * p * a
}
```

== GFM Direct Callouts

#gfm-note[
  *GitHub Flavored Markdown (`> [!NOTE]`):* Automatically styled as a delicate sky-blue Shadcn callout card with zero thick left-bars!
]

#pagebreak()

#chapter-header(
  num: 3,
  title: "Layer 3: Pedagogical Assemblies & Presets",
  slides-ref: "Deck 03: Assembled Companions",
  reader-ref: "Ch 3: Study Tools",
  teardown-ref: "Lab 03: Master Engines",
)

Layer 3 constructs *complete educational artifacts* by composing Layer 1 atoms and Layer 2 mixins into authentic study tools.

== Canva Visual Dissection Canvas

Composed of: `#plaque` (pedestal container) + `#item-card` (symbol dissections) + verification strip:

#formula-breakdown(
  formula: $#math-cost[min]_u 1/2 #math-input[u]^T #math-cost[H]_text("qp") #math-input[u] + #math-state[x]_0^T F^T #math-input[u] quad "s.t." quad #math-sensor[G] #math-input[u] <= #math-sensor[W] + S #math-state[x]_0$,
  symbols: (
    (c-input, "u", "Decision Vector", [Stacked future control inputs $(u_0, dots, u_(N-1))$]),
    (c-cost, "H_qp", "Condensed Hessian", [Block diagonal positive-definite matrix $R + Gamma^T Q Gamma$]),
    (c-state, "x_0", "Current State", [Real-time sensor state measurement from observer ($RR^n$)]),
    (c-sensor, "G, W", "Constraint Polytopes", [Actuator torque saturation limits and terminal safe invariant set]),
  ),
  arithmetic: [
    For horizon $N = 10$, $n = 4$ states, and $m = 2$ inputs, condensed QP has 20 decision variables, solved in $< 1.8$ ms by `qpOASES`.
  ],
)

== Academic Plaques & Exam Safeguards

#theorem(
  num: "3.1",
  name: "First-Order Necessary Condition (FONC)",
  title: "Vanishing Gradient of Local Minimizer",
  takeaway: [If $nabla f(x^*) != 0$, there exists an explicit descent direction $d = -nabla f(x^*)$ that strictly reduces objective cost!],
)[
  Let $f: RR^n -> RR$ be continuously differentiable ($f in C^1$) over an open set $cal(D) subset.eq RR^n$. If $x^* in cal(D)$ is a local minimizer of $f$, then the gradient vanishes:
  $ nabla f(x^*) = 0 $
]

#pitfall(
  title: "FONC Sufficiency Fallacy",
  mistake: [$nabla f(x^*) = 0 arrow.r.double x^* "is a local minimum"$],
  correct: [Check $nabla f(x^*) = 0$ AND $nabla^2 f(x^*) succ.eq 0$ (SONC)],
)[
  A vanishing gradient is only *necessary* for optimality, never sufficient. In non-convex optimization, stationary points are often saddle points!
]

== 3.3 Document Presets (Complete Engines)

- `#show: textbook.with(...)`: Full A4 study companion with chapter hero cards, margins, TOC, running chrome.
- `#show: cheatsheet.with(columns-num: 3)`: 3-column micro-margin closed-book exam revision sheet.
- `#show: report.with(...)`: Multi-page engineering or thesis research report.
- `#show: memo.with(...)`: 1-to-2 page executive brief.
- `#show: slides.with(...)`: 16:9 widescreen presentation deck.
