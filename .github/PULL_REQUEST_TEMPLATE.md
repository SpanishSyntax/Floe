## Summary

<!-- Briefly describe the purpose of this Pull Request and what layer(s) it touches. -->

## Affected Architecture Layers

- [ ] **Layer 0 (`core/`)**: Design tokens, third-party package hub, or chemical parser
- [ ] **Layer 1 (`primitives/`)**: Zero-domain structural hardware (`grid`, `card`, `plaque`, `figure`, `item`, `stepper`, `timeline`, `badge`, `divider`)
- [ ] **Layer 2 (`mixins/`)**: Scoped `#show` rules (`code`, `math`, `alerts`, `tables`)
- [ ] **Layer 3 (`components/`)**: Semantic academic, pedagogical, layout, table, math, figure, and hero blocks
- [ ] **Layer 4 (`presets/`)**: Full-document `#show` presets (`textbook`, `report`, `slides`, `cheatsheet`, `memo`)
- [ ] **Documentation & Tooling (`docs/`, `scripts/`, `floe.json`)**

## Pre-Merge Verification Checklist

- [ ] All 6 example templates in `examples/*.typ` compile with zero warnings or errors
- [ ] All left/right pills and tags route through `#badge(...)` (`top-edge: "cap-height", bottom-edge: "baseline"`)
- [ ] Equal-height row children use `#stretch-cell` / `#metadata("floe-footer")` or `#metadata("floe-stretch-center")` without hardcoding height
- [ ] `python3 scripts/generate_schema.py` has been run and `floe.json` is up to date
- [ ] `python3 scripts/render_previews.py` has been run if any visual component or token changed
- [ ] Documentation headings in `docs/*.md` contain zero parenthetical `(extra text)` suffixes
