# Getting Started

[Overview](README.md) • [Getting Started](getting-started.md) • [Core](core.md) • [Primitives](primitives.md) • [Mixins](mixins.md) • [Components](components.md) • [Presets](presets.md)

---

## Installation

### Typst Universe

Import Floe directly in any Typst document:

```typst
#import "@preview/floe:0.1.0": *
```

### Local Development

To link Floe into your local Typst package store:

```bash
mkdir -p ~/.local/share/typst/packages/local/floe
ln -s /path/to/Floe ~/.local/share/typst/packages/local/floe/0.1.0
```

Then import the local package:

```typst
#import "@local/floe:0.1.0": *
```

---

## Quick Start

Create a `main.typ` document with a textbook layout, chapter opener, theorem, and exam pitfall:

```typst
#import "@preview/floe:0.1.0": *

#show: textbook.with(
  title: "Optimal Control & Dynamic Programming",
  course-code: "SC42056",
  institution: "Systems & Control Institute • Academic Series",
)

#chapter-header(
  num: 1,
  title: "First-Order Optimality Conditions",
  subtitle: "Unconstrained minimization, stationary points, and descent directions",
  eyebrow: "FOUNDATION SPECIFICATION",
)

== Necessary Conditions

#theorem(
  num: "1.1",
  title: "First-Order Necessary Condition (FONC)",
  takeaway: [If $nabla f(x^*) eq.not 0$, the negative gradient $d = -nabla f(x^*)$ is a strict descent direction.],
)[
  Let $f: bb(R)^n -> bb(R)$ be continuously differentiable over an open set $cal(D) subset.eq bb(R)^n$.
  If $x^*$ is a local minimizer of $f$, then:
  $ nabla f(x^*) = 0 $
]

#pitfall(
  title: "Vanishing Gradient Fallacy",
  mistake: [$nabla f(x^*) = 0 arrow.double x^*$ is a local minimum],
  correct: [Check $nabla f(x^*) = 0$ AND $nabla^2 f(x^*) succ.eq 0$ (SONC)],
)[
  $nabla f(x) = 0$ identifies stationary points, not minimizers. Saddle points and local maximizers also satisfy FONC.
]
```

![Rendered Quick Start Output](assets/examples/theorem.png)

Compile with:

```bash
typst compile main.typ output.pdf
```

---

## Architecture

Floe is structured into four decoupled layers. You can use high-level presets (`textbook`, `report`, `slides`), cherry-pick individual components (`theorem`, `formula-breakdown`, `data-table`), or compose pure layout atoms (`card`, `plaque`, `stepper`) with zero external side effects:

```
Floe/
├── core/                      # Tokens, metrics, palettes & package bindings
├── primitives/                # Zero-domain layout geometry, cards, badges, steppers
├── mixins/                    # Pure show rules: headings, chrome, code, math, tables
├── components/                # Academic plaques, alerts, formula breakdown, layouts, tables
└── presets/                   # Master document templates: textbook, report, slides, memo
```

Every module exposes a `lib.typ` entrypoint, allowing either whole-library or layer-specific imports:

```typst
// Import the entire library
#import "@preview/floe:0.1.0": *

// Or import only specific layers:
#import "@preview/floe:0.1.0/primitives": card, badge, stepper
#import "@preview/floe:0.1.0/mixins": with-heading-theme, with-code-theme
#import "@preview/floe:0.1.0/components": theorem, definition, pitfall
#import "@preview/floe:0.1.0/presets": textbook, report
```
