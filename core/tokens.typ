// ============================================================================
// FLOE DESIGN SYSTEM — DESIGN TOKENS (core/tokens.typ)
// Single Source of Truth for Palettes, Typography, Spacing, Radii & Strokes
// ============================================================================

// 1. Floe Brand Palette
#let floe-cyan   = rgb("#00A6D6")
#let floe-navy   = rgb("#0C2340")
#let floe-slate  = rgb("#334155")
#let floe-muted  = rgb("#64748B")
#let floe-green  = rgb("#059669")
#let floe-amber  = rgb("#B45309")
#let floe-red    = rgb("#DC2626")
#let floe-purple = rgb("#6D28D9")

// 2. Neutral Monochromatic Scale (Tailwind Zinc/Slate compatible)
#let slate-50   = rgb("#F8FAFC")
#let slate-100  = rgb("#F1F5F9")
#let slate-200  = rgb("#E2E8F0")
#let slate-300  = rgb("#CBD5E1")
#let slate-400  = rgb("#94A3B8")
#let slate-500  = rgb("#64748B")
#let slate-600  = rgb("#475569")
#let slate-700  = rgb("#334155")
#let slate-800  = rgb("#1E293B")
#let slate-900  = rgb("#0F172A")
#let slate-950  = rgb("#020617")

// 3. Semantic Status Tints (Subtle background + deep foreground)
#let semantic = (
  info:    (bg: rgb("#F0F9FF"), border: floe-cyan,   text: floe-navy),
  success: (bg: rgb("#ECFDF5"), border: floe-green,  text: rgb("#065F46")),
  warning: (bg: rgb("#FFFBEB"), border: floe-amber,  text: rgb("#92400E")),
  danger:  (bg: rgb("#FEF2F2"), border: floe-red,    text: rgb("#991B1B")),
  purple:  (bg: rgb("#F5F3FF"), border: floe-purple, text: rgb("#5B21B6")),
  neutral: (bg: slate-50,       border: slate-300,  text: slate-800),
)

// 4. Universal Equation & Term Dissection Palette (Domain-Agnostic)
#let c-term-1  = rgb("#0284C7")  // Term 1 (Sky Blue)
#let c-term-2  = rgb("#7C3AED")  // Term 2 (Royal Purple)
#let c-term-3  = rgb("#D97706")  // Term 3 (Warm Amber)
#let c-term-4  = rgb("#059669")  // Term 4 (Emerald Green)
#let c-term-5  = rgb("#DC2626")  // Term 5 (Crimson Red)
#let c-term-6  = rgb("#DB2777")  // Term 6 (Deep Rose)

#let term-palette = (c-term-1, c-term-2, c-term-3, c-term-4, c-term-5, c-term-6)

// 5. Cross-Platform Typography Stacks
#let fonts = (
  serif: ("New Computer Modern", "DejaVu Serif", "Times New Roman"),
  sans: ("Liberation Sans", "DejaVu Sans", "Inter"),
  display: ("Liberation Sans", "Inter"),
  mono: ("DejaVu Sans Mono", "Source Code Pro", "Consolas"),
)

// 6. Typographic Scale Ratios
#let text-scale = (
  xs: 7.5pt,
  sm: 8.5pt,
  base: 10pt,
  md: 11pt,
  lg: 12.8pt,
  xl: 16pt,
  title: 18pt,
  hero: 24pt,
)

// 7. Radii & Stroke Scale
#let radii = (
  "none": 0pt,
  sm: 2pt,
  base: 3.5pt,
  md: 6pt,
  lg: 10pt,
  full: 9999pt,
)

#let strokes = (
  hairline: 0.35pt,
  border: 0.5pt,
  card: 0.75pt,
  accent: 3.0pt,
  heavy: 4.5pt,
)
