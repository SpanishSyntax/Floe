<p align="center">
  <img src="assets/banner.png" alt="Polar bear resting on an ice floe amidst arctic waters" width="100%" />
</p>

# Floe ❄️

[Overview](README.md) • [Getting Started](getting-started.md) • [Core](core.md) • [Primitives](primitives.md) • [Mixins](mixins.md) • [Components](components.md) • [Presets](presets.md)

---

> The Composable UI Design System & Component Library for [Typst](https://typst.app).

Floe brings the modularity, atomic design hierarchy, and thoughtful aesthetics of modern web design systems to technical documents: course readers, lecture notes, textbook companions, engineering reports, and presentation slides.

<p align="center">
  <img src="../assets/preview.png" alt="Floe Design System Preview" width="480" />
</p>

---

## Why "Floe"? (The Lore)

> **ice floe** (`/floʊ/`) — *noun:* A flat, buoyant sheet of sea ice drifting independently across open arctic waters, providing sure-footed footing and refuge without the immovable, submerged bulk of a glacier.

In document engineering and academic publishing, most templates behave like **icebergs**: massive, rigid monoliths where 90% of the complexity is submerged underwater. If you want to change a heading font or widen a table margin, you collide with hundreds of lines of brittle, interconnected macros that pull your layout down into the deep.

**Floe is designed as an archipelago of ice floes:**

- **Flat, Visible & Buoyant**: What you see is what you get. Every primitive is lightweight, self-contained, and floats on top of your document without hidden side effects.
- **Step Across Freely**: You don't have to adopt an entire opinionated universe. A polar bear doesn't need the entire arctic ice sheet to cross the ocean—it just needs a stable floe to step on. You can use a single `#card`, `#formula-breakdown`, or `#text-divider` floe in your document and leave everything else untouched.

---

## Architecture

Floe decouples styling into five distinct layers:

1. **Layer 0 — Core Foundation**: Design tokens (palettes, typography scales, strokes, radii) and unified third-party engine bindings (`CeTZ`, `Hydra`, `Fletcher`).
2. **Layer 1 — Atomic Primitives**: Zero-domain layout geometry (`card`, `plaque`, `stepper`, `badge`, `divider`, `item-card`) that handle borders, paddings, and alignment without imposing content assumptions.
3. **Layer 2 — Composable Mixins**: Pure `#show` rules that transform headings, code blocks, running headers, and tables without breaking raw Markdown or Typst content.
4. **Layer 3 — Domain Components**: High-level pedagogical tools built on Layer 1 atoms (`theorem`, `definition`, `pitfall`, `formula-breakdown`, `split-view`, `data-table`, `chapter-header`).
5. **Layer 4 — Document Presets**: Ready-to-use document templates (`textbook`, `report`, `slides`, `cheatsheet`, `memo`).

You can use the high-level presets, or cherry-pick individual components into any existing document without unwanted side effects.

---

## Documentation Navigation

- [Installation & Quick Start](getting-started.md)
- [Design Tokens & Core](core.md)
- [Atomic Primitives](primitives.md)
- [Composable Mixins](mixins.md)
- [Academic & Pedagogical Components](components.md)
- [Master Document Presets](presets.md)
