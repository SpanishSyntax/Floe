# Contributing to Floe

Thank you for contributing to **Floe**, the five-layer typographic design system and component architecture for [Typst](https://typst.app).

---

## 1. Architectural Invariants

Every contribution must strictly respect Floe's unidirectional five-layer dependency graph (`L0 → L1 → L2 → L3 → L4`):

1. **Layer 0 (`core/`)**: Design tokens (`core/tokens.typ`), third-party package hub (`core/packages.typ`), and zero-dependency chemical notation (`core/chemistry.typ`).
   - **Token Decoupling Rule**: UI chrome tokens (`floe-navy`, `floe-cyan`, `floe-purple`, `floe-amber`, `floe-green`, `floe-red`) are strictly decoupled from mathematical equation dissection tokens (`c-term-1`..`c-term-6`, `term-palette`). Components that color equations (`#formula-breakdown`, `#eq-legend`) must default to `palette: term-palette` and accept `palette: brand-term-palette` (or custom arrays) on demand.
2. **Layer 1 (`primitives/`)**: Zero-domain structural hardware (`#equal-grid`, `#stretch-cell`, `#card`, `#alert`, `#plaque`, `#figure-card`, `#item-card`, `#stepper`, `#timeline`, `#badge`, `#divider`).
   - **Equal-Height Row Contract**: Never hardcode heights on cards or plaques. Emit `#metadata("floe-footer")` before footer bars or `#metadata("floe-stretch-center")` around centered media so `#equal-grid` and `#stretch-cell` can equalize sibling heights automatically.
   - **Standardized Badge Height Rule**: Never hand-roll `box(...)` pills for tags or beans. Always invoke `#badge(...)` (`primitives/badge.typ`), which locks `top-edge: "cap-height"` and `bottom-edge: "baseline"` so badges with descenders (`g`, `p`, `y`) have the exact same vertical height as badges without descenders.
   - **Corner-Anchored Header Beans**: When a header displays left/right badges alongside a title, place the badges on their own top row (`grid(columns: (1fr, auto))`) above the title unless `title-inline: true` is explicitly requested.
3. **Layer 2 (`mixins/`)**: Scoped `#show` rules (`with-code-theme`, `with-math-theme`, `with-gfm-alerts`, `with-rich-tables`).
4. **Layer 3 (`components/`)**: Semantic academic blocks (`#theorem`, `#definition`, `#lemma`, `#corollary`, `#algorithm`, `#worked-example`), alerts (`#pitfall`, `#exam-alert`, `#note`, `#tip`, `#warning`), layouts (`#bento-grid`, `#split-view`, `#pro-con`), tables (`#data-table`), equation dissection (`#formula-breakdown`, `#eq-legend`), plots/diagrams (`#canvas`, `#diagram`, `#plot`), and 12 hero/header cards (`components/hero.typ`).
5. **Layer 4 (`presets/`)**: Full-document `#show` presets (`textbook`, `report`, `slides`, `cheatsheet`, `memo`).

---

## 2. Branching & Pull Request Workflow

Direct pushes to `main` are restricted. All changes must flow through a short-lived branch and Pull Request:

1. **Create a branch** using a semantic prefix:
   - `feat/<slug>` — New components, presets, or capabilities
   - `fix/<slug>` — Bug fixes, spacing alignment, or visual polish
   - `docs/<slug>` — Documentation, showcase, or preview updates
   - `chore/<slug>` — Tooling, CI, schema, or version bumps
2. **Verify locally before pushing**:
   ```bash
   # 1. Regenerate machine-readable schema
   python3 scripts/generate_schema.py

   # 2. Re-render all 54 documentation preview PNGs
   python3 scripts/render_previews.py

   # 3. Compile all 6 example templates
   for f in examples/*.typ; do typst compile --root . "$f" "/tmp/$(basename "$f" .typ).pdf"; done
   ```
3. **Open a Pull Request** against `main` using [Conventional Commits](https://www.conventionalcommits.org/) (`feat(hero): ...`, `fix(badge): ...`, `chore(release): bump version to 0.2.1`).
4. **Squash and merge** once the `Typst Compilation Check` CI workflow passes.

---

## 3. Versioning Policy (SemVer `0.y.z`)

While in the `0.y.z` series:
- **Patch (`0.2.0` → `0.2.1`)**: Visual bug fixes, badge height standardization, spacing refinements, token decoupling, and additive optional parameters with 100% backwards-compatible signatures.
- **Minor (`0.2.x` → `0.3.0`)**: New Layer 1–4 components, new document presets, or signature restructurings.
- **Major (`1.0.0`)**: Stable public API lock for submission to the official [Typst Universe](https://typst.app/universe) registry.

Use `scripts/bump_version.py` to bump versions across `typst.toml`, `floe.json`, documentation, and local Typst package symlinks in one atomic step:

```bash
python3 scripts/bump_version.py 0.2.1
```
