#!/usr/bin/env python3
"""Render all 46 component and preset preview PNGs for Floe documentation.

Compiles individual component snippets at 220 PPI and copies them to both
`assets/examples/` (for root README.md) and `docs/assets/examples/` (for Docsify).
"""

from __future__ import annotations

import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
ASSETS_DIR = ROOT_DIR / "assets" / "examples"
DOCS_ASSETS_DIR = ROOT_DIR / "docs" / "assets" / "examples"

PREAMBLE = """#import "/lib.typ": *
#set page(width: 15.5cm, height: auto, margin: 8pt, fill: white)
#set text(font: fonts.serif, size: 10pt, fill: slate-900, lang: "en")
#set par(justify: true, leading: 0.62em)
#show: with-code-theme
#show: with-math-theme
"""

SNIPPETS: dict[str, str] = {
    "tokens_palette": """
#item-grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 6pt,
  above: 0pt,
  below: 0pt,
  item-card(title: "#0F172A", label: "floe-navy", color: floe-navy)[Primary Structural Ink],
  item-card(title: "#0284C7", label: "c-term-1 • floe-cyan", color: c-term-1)[Term 1 (`#t1`) & Accent],
  item-card(title: "#7C3AED", label: "c-term-2 • floe-purple", color: c-term-2)[Term 2 (`#t2`) & Lemmas],
  item-card(title: "#D97706", label: "c-term-3 • floe-amber", color: c-term-3)[Term 3 (`#t3`) & Theorems],
  item-card(title: "#059669", label: "c-term-4 • floe-green", color: c-term-4)[Term 4 (`#t4`) & Anchors],
  item-card(title: "#DC2626", label: "c-term-5 • floe-red", color: c-term-5)[Term 5 (`#t5`) & Pitfalls],
  item-card(title: "#DB2777", label: "c-term-6 • Deep Rose", color: c-term-6)[Term 6 (`#t6`) & Auxiliary],
  item-card(title: "#64748B", label: "floe-muted", color: floe-muted)[Captions & Running Chrome],
)
""",
    "chemistry_ce": """
#card(
  title: "Multi-Science Notation Engine",
  badge-label: "core/chemistry.typ",
  badge-variant: "info",
  above: 0pt,
  below: 0pt,
)[
  - *Chemical Parser (`#ce`):* #ce("2H2 + O2 -> 2H2O"), #h(6pt) #ce("SO4^2-(aq) + Ba^2+(aq) <=> BaSO4(s)"), #h(6pt) #ce("[Co(NH3)6]^3+")
  - *Physics Calculus (`physica`):* $dv(L, q) - dv(, t) pdv(L, dot(q)) = 0, quad curl vb(B) = mu_0 vb(J) + mu_0 epsilon_0 pdv(vb(E), t), quad braket(psi, hat(H), psi)$
  - *SI Metrology (`unify`):* Thermal conductivity $k = qty("385", "W/(m.K)")$, pressure $P = qty("101.325", "kPa")$.
]
""",
    "equal_grid": """
#equal-grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 0pt,
  card(
    title: "Short Sibling",
    badge-label: "1 LINE",
    badge-variant: "info",
    footer: [Pinned to bottom],
  )[
    Minimal content.
  ],
  card(
    title: "Medium Sibling",
    badge-label: "3 LINES",
    badge-variant: "purple",
    footer: [Pinned to bottom],
  )[
    Automatically grows to match the tallest card in the row.
  ],
  card(
    title: "Tallest Sibling",
    badge-label: "5 LINES",
    badge-variant: "success",
    footer: [Pinned to bottom],
  )[
    Parent `#equal-grid` measures all siblings in `context` and distributes vertical slack above `#metadata("floe-footer")`.
  ],
)
""",
    "card": """
#card(
  title: "Structural Card Primitive",
  description: "Header with subtitle, top-right badge, body, and slate-100 footer bar",
  badge-label: "ATOMIC",
  badge-variant: "info",
  footer: [Footer metadata stays flush at the bottom of the card container.],
  above: 0pt,
  below: 0pt,
)[
  `#card` provides a zero-domain container with subtle hairline borders, rounded corners (`radii.md`), and optional header/footer sections.
]
""",
    "alert_primitive": """
#equal-grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 0pt,
  alert(variant: "info", title: "Info Variant")[Sky-blue informational callout.],
  alert(variant: "success", title: "Success Variant")[Emerald verification callout.],
  alert(variant: "warning", title: "Warning Variant")[Amber caution callout.],
  alert(variant: "danger", title: "Danger Variant")[Crimson critical boundary.],
  alert(variant: "tip", title: "Tip Variant")[Violet insight callout.],
  alert(variant: "neutral", title: "Neutral Variant")[Slate structural note.],
)
""",
    "plaque": """
#plaque(
  tag: "THEOREM",
  num: "2.1",
  title: "First-Order Necessary Condition",
  accent: floe-amber,
  header-fill: floe-navy,
  footer: [#text(weight: "bold")[Key Takeaway:] The gradient vanishes at every interior local extremum.],
  above: 0pt,
  below: 0pt,
)[
  If $x^*$ is an interior local minimizer of $f in C^1(RR^n)$, then $grad f(x^*) = 0$.
]
""",
    "figure_card": """
#figure-grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  title: "Equal-Height Multi-Panel Figure Grid",
  badge-label: "FIGURE-GRID",
  footer: [Figure 1: Native vector diagrams rendered via CeTZ, Fletcher, and Zap inside `#figure-grid`.],
  above: 0pt,
  below: 0pt,
  figure-card(
    title: "CeTZ Vector Canvas",
    badge-label: "CETZ",
    badge-variant: "info",
    footer: [Unit circle & phasor],
  )[
    #cetz.canvas(length: 0.72cm, {
      import cetz.draw: *
      grid((-1.4, -1.4), (1.4, 1.4), step: 0.7, stroke: 0.25pt + slate-200)
      line((-1.5, 0), (1.5, 0), mark: (end: ">"), stroke: 0.5pt + slate-500)
      line((0, -1.5), (0, 1.5), mark: (end: ">"), stroke: 0.5pt + slate-500)
      circle((0, 0), radius: 1.1, stroke: 1.1pt + floe-cyan)
      line((0, 0), (0.78, 0.78), mark: (end: ">"), stroke: 1.2pt + floe-red)
    })
  ],
  figure-card(
    title: "Fletcher Block Diagram",
    badge-label: "FLETCHER",
    badge-variant: "purple",
    footer: [Closed-loop feedback],
  )[
    #fletcher.diagram(
      node-stroke: 0.6pt + floe-navy,
      node-fill: slate-50,
      spacing: (10pt, 10pt),
      fletcher.node((0, 0), [$K(s)$], corner-radius: 3pt),
      fletcher.edge((0, 0), (1, 0), "->", [$u$]),
      fletcher.node((1, 0), [$G(s)$], corner-radius: 3pt),
    )
  ],
  figure-card(
    title: "Zap Circuit Schematic",
    badge-label: "ZAP",
    badge-variant: "warning",
    footer: [Low-pass RC network],
  )[
    #zap.circuit({
      import zap: *
      resistor("r1", (0, 0), (1.8, 0), label: $R$)
      capacitor("c1", (1.8, 0), (1.8, -1.3), label: $C$)
      wire((0, -1.3), (1.8, -1.3))
      wire((0, 0), (0, -1.3))
    })
  ],
)
""",
    "item_grid": """
#item-grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 0pt,
  item-card(title: "Hilbert State", label: $ket(psi) in cal(H)$, color: c-term-1, footer: [Unit Norm: $braket(psi, psi) = 1$])[Quantum state vector in a separable complex Hilbert space.],
  item-card(title: "Hamiltonian Operator", label: $hat(H) = hat(H)^dagger$, color: c-term-2, footer: [Spectrum: $lambda_n in RR$])[Self-adjoint generator of unitary time evolution.],
  item-card(title: "Partition Function", label: $Z = tr(e^(-beta hat(H)))$, color: c-term-3, footer: [Inverse Temp: $beta = 1/(k_B T)$])[Canonical ensemble normalization over microstates.],
)
""",
    "stepper": """
#stepper(
  above: 0pt,
  below: 0pt,
  steps: (
    (1, "Formulate Condensed QP", [Eliminate state trajectory variables $x_k$ via batch transition recursion.]),
    (2, "Factorize Regulated Hessian", [Compute Cholesky decomposition $H = L L^top$ offline for fast backsolve.]),
    (3, "Iterate Active-Set Solver", [Update primal-dual working set until KKT residual satisfies $epsilon <= 10^(-6)$.]),
  ),
)
""",
    "timeline": """
#timeline(
  ("t = 0.0 ms • IMU & Magnetometer Sample", [Acquire 1 kHz body angular velocity and magnetic field vector.]),
  ("t = 0.4 ms • Multiplicative EKF Update", [Propagate quaternion kinematics and update error-state covariance.]),
  ("t = 1.1 ms • Actuator Dipole Allocation", [Project optimal torque onto magnetorquer rods within saturation bounds.]),
)
""",
    "badges": """
#card(title: "Inline Micro-Primitives", above: 0pt, below: 0pt)[
  - *Badges (`#badge`):* #badge("neutral", variant: "neutral") #h(3pt) #badge("info", variant: "info") #h(3pt) #badge("success", variant: "success") #h(3pt) #badge("warning", variant: "warning") #h(3pt) #badge("danger", variant: "danger") #h(3pt) #badge("purple", variant: "purple") #h(3pt) #badge("dark", variant: "dark") #h(3pt) #badge("outline", variant: "outline")
  - *Keycaps (`#kbd`):* Press #kbd("Ctrl") + #kbd("Shift") + #kbd("B") to build or #kbd("Cmd") + #kbd("K") to search.
  - *Status Dots (`#status-dot`):* #status-dot(color: floe-green) #h(3pt) Nominal #h(10pt) #status-dot(color: floe-amber) #h(3pt) Degraded #h(10pt) #status-dot(color: floe-red) #h(3pt) Saturated
]
""",
    "divider": """
#card(title: "All 8 Semantic Divider Variants", above: 0pt, below: 0pt)[
  #grid(
    columns: (1.2fr, 2.8fr),
    column-gutter: 12pt,
    row-gutter: 9pt,
    align: (left + horizon, horizon),
    [`#divider()`], [#divider(above: 0pt, below: 0pt)],
    [`#dotted-divider()`], [#dotted-divider(above: 0pt, below: 0pt)],
    [`#dashed-divider()`], [#dashed-divider(above: 0pt, below: 0pt)],
    [`#fade-divider()`], [#fade-divider(above: 0pt, below: 0pt)],
    [`#gradient-divider()`], [#gradient-divider(above: 0pt, below: 0pt)],
    [`#text-divider(...)`], [#text-divider("PURE TEXT LABEL", above: 0pt, below: 0pt)],
    [`#chip-divider(...)`], [#chip-divider("PILL CHIP BADGE", above: 0pt, below: 0pt)],
    [`#icon-divider(...)`], [#icon-divider(icon: "✦", above: 0pt, below: 0pt)],
  )
]
""",
    "code_block": """
#equal-grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 0pt,
  figure-card(
    title: "Syntax-Highlighted Code Window",
    badge-label: "```rust",
    badge-variant: "dark",
    footer: [Styled automatically by `with-code-theme`.],
  )[
    ```rust
    pub fn riccati_step(a: &Mat, p: &Mat, q: &Mat) -> Mat {
        a.transpose() * p * a - p + q
    }
    ```
  ],
  figure-card(
    title: "Native Mermaid Diagram",
    badge-label: "```mermaid",
    badge-variant: "purple",
    footer: [Rendered natively via `@preview/merman`.],
  )[
    ```mermaid
    flowchart LR
      R["r(t)"] --> E(("e(t)"))
      E --> K["K(s)"]
      K --> G["G(s)"]
      G --> Y["y(t)"]
      Y -->|"-1"| E
    ```
  ],
)
""",
    "gfm_alerts": """
#equal-grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 8pt,
  gfm-note[GitHub-style `#gfm-note` callout (`[!NOTE]`).],
  gfm-tip[GitHub-style `#gfm-tip` callout (`[!TIP]`).],
  gfm-important[GitHub-style `#gfm-important` callout (`[!IMPORTANT]`).],
  gfm-warning[GitHub-style `#gfm-warning` callout (`[!WARNING]`).],
)
#gfm-caution[GitHub-style `#gfm-caution` callout (`[!CAUTION]`) for high-risk actions or instability boundaries.]
""",
    "theorem": """
#theorem(
  num: "4.1",
  title: "Lyapunov Global Asymptotic Stability Criterion",
  takeaway: [A radially unbounded energy function $V(x) > 0$ with strictly negative orbital derivative $dot(V)(x) < 0$ guarantees global asymptotic stability.],
)[
  Let $x = 0$ be an equilibrium of $dot(x) = f(x)$ on $RR^n$. If there exists a radially unbounded function $V in C^1(RR^n, RR)$ such that $V(0) = 0$, $V(x) > 0$ for all $x != 0$, and $grad V(x)^top f(x) < 0$ for all $x != 0$, then $x = 0$ is globally asymptotically stable.
]
""",
    "definition": """
#definition(
  num: "4.1",
  title: "Radially Unbounded Storage Function",
  tag: "NONLINEAR SYSTEMS",
)[
  A scalar function $V: RR^n -> RR$ is *radially unbounded* (coercive) if $lim_(norm(x) -> oo) V(x) = +oo$, ensuring that every sublevel set $Omega_c = {x in RR^n : V(x) <= c}$ is compact.
]
""",
    "lemma_corollary": """
#equal-grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 0pt,
  lemma(num: "4.1", title: "Schur Complement Positive-Definiteness")[
    For symmetric $M = mat(A, B; B^top, C)$ with $C succ 0$, $M succ 0$ if and only if $A - B C^(-1) B^top succ 0$.
  ],
  corollary(title: "Linear Matrix Inequality Convexity")[
    Quadratic matrix inequalities in $P$ reduce to linear affine inequalities via the Schur complement.
  ],
)
""",
    "algorithm": """
#algorithm(num: "4.1", title: "Primal-Dual Interior-Point Newton Step")[
  1. *Input:* Strictly feasible iterate $(x_k, lambda_k, s_k)$ with $x_k, s_k > 0$ and barrier parameter $mu_k = (x_k^top s_k) / n$.
  2. *Solve Newton KKT System:* Compute affine-scaling and centering search direction $(Delta x, Delta lambda, Delta s)$.
  3. *Line Search:* Choose maximum step length $alpha_k in (0, 1]$ preserving $x_(k+1) > 0$ and $s_(k+1) > 0$.
]
""",
    "proof": """
#proof(title: "Full Rigorous Proof (sketch: false, default)")[
  Along any trajectory $x(t)$ of $dot(x) = f(x)$, the chain rule yields $dv(V(x(t)), t) = grad V(x)^top f(x) < 0$ for all $x != 0$. Because $V(x)$ is bounded below by $0$ and strictly decreasing, $V(x(t)) -> 0$ as $t -> oo$.
]
#proof(sketch: true, title: "Compact Sublevel Set Invariance (sketch: true)")[
  Radial unboundedness guarantees $Omega_(V(x(0)))$ is compact and positively invariant, ruling out finite escape time.
]
""",
    "pitfall": """
#pitfall(
  title: "Confusing Necessary Stationary Points with Sufficient Minima",
  mistake: [
    Claiming $grad f(x^*) = 0 ==> x^*$ is a local minimum without checking the Hessian $nabla^2 f(x^*)$.
  ],
  correct: [
    Verify $grad f(x^*) = 0$ AND $nabla^2 f(x^*) succ 0 ==> x^*$ is a strict isolated local minimum.
  ],
)[
  On closed-book exams, always verify second-order sufficiency ($nabla^2 f(x^*) succ 0$ or convexity of $f$) after solving $grad f(x^*) = 0$.
]
""",
    "alerts": """
#equal-grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 0pt,
  exam-alert(title: "Memorize the 2x2 Inverse & Characteristic Polynomial")[
    For $A = mat(a, b; c, d)$, $det(s I - A) = s^2 - tr(A) s + det(A)$.
  ],
  note(title: "Hilbert Space Adjoint Convention")[
    In complex Hilbert spaces $CC^n$, the inner product uses the conjugate transpose $x^dagger y$.
  ],
  tip(title: "Exploit Triangular Structure")[
    Solve $(s I - A)^(-1) B$ by forward/backward substitution whenever $A$ is triangular.
  ],
  warning(title: "Actuator Windup Under Integral Action")[
    Unclamped integrators accumulate windup error when control inputs saturate at $plus.minus u_(\"max\")$.
  ],
)
""",
    "formula_breakdown": """
#formula-breakdown(
  title: "Discrete-Time Kalman Filter Innovation & Posterior Update",
  formula: $#t1($hat(x)_(k|k)$) = hat(x)_(k|k-1) + #t2($K_k$) (#t3($y_k - C hat(x)_(k|k-1)$)), quad #t2($K_k$) = P_(k|k-1) C^top (C P_(k|k-1) C^top + #t4($R$))^(-1)$,
  symbols: (
    ($hat(x)_(k|k)$, "Posterior State Estimate", [Minimum-variance unbiased estimate in $RR^n$]),
    ($K_k$, "Optimal Kalman Gain", [Weights prior uncertainty $P_(k|k-1)$ against sensor noise $R$]),
    ($y_k - C hat(x)_(k|k-1)$, "Innovation Residual", [White zero-mean prediction error in $RR^p$]),
    ($R succ 0$, "Sensor Noise Covariance", [Measurement noise covariance $EE[v_k v_k^top] in RR^(p times p)$]),
  ),
  arithmetic: [
    In the scalar case ($C = 1, P_(k|k-1) = 4, R = 1$), the Kalman gain is $K_k = 4 / (4 + 1) = 0.8$, weighting the sensor measurement at $80%$.
  ],
)
""",
    "derivation_stepper": """
#derivation-stepper(
  title: "Completing the Square for the Linear-Quadratic Optimal Control Law",
  above: 0pt,
  below: 0pt,
  steps: (
    (
      "Expand the Hamiltonian Quadratic Form",
      $dot(V)(x) + x^top Q x + u^top R u = x^top (A^top P + P A + Q) x + 2 x^top P B u + u^top R u$,
      "Group all terms quadratic and linear in the control input u.",
    ),
    (
      "Complete the Square in the Control Input u",
      $2 x^top P B u + u^top R u = (u + R^(-1) B^top P x)^top R (u + R^(-1) B^top P x) - x^top P B R^(-1) B^top P x$,
      "Since R > 0 is symmetric positive-definite, the squared norm is minimized when it vanishes.",
    ),
    (
      "Extract Optimal Feedback Gain K* and Algebraic Riccati Equation",
      $u^*(t) = -R^(-1) B^top P x(t), quad A^top P + P A - P B R^(-1) B^top P + Q = 0$,
      "Setting the square to zero yields the optimal state-feedback law and the CARE.",
    ),
  ),
)
""",
    "physical_anchor": """
#physical-anchor(
  title: "Free Energy Minimization as an Energy-Entropy Tradeoff",
  domain: "THERMODYNAMICS & STATISTICAL MECHANICS",
  system: "Boltzmann Canonical Ensemble",
)[
  Minimizing the Helmholtz free energy $F = U - T S$ at constant temperature $T$ is physically identical to regularized optimization: at low temperature ($T -> 0$), the system locks into the minimum internal energy ground state $U$, whereas at high temperature ($T -> oo$), entropic exploration $-T S$ dominates.
]
""",
    "worked_example": """
#worked-example(
  title: "Checking Positive-Definiteness and Minimizer of a Bivariate Quadratic",
  problem: [
    Determine whether $f(x_1, x_2) = 2 x_1^2 - 2 x_1 x_2 + x_2^2 - 4 x_1 + 2 x_2 + 5$ has a unique global minimum, and compute $x^*$ and $f(x^*)$.
  ],
  solution: [
    $x^* = vec(1, 0)$ with global minimum value $f(1, 0) = 3$.
  ],
)[
  1. *Extract Hessian $H$ and Linear Vector $c$:* Writing $f(x) = 1/2 x^top H x + c^top x + 5$ gives $H = mat(4, -2; -2, 2)$ and $c = vec(-4, 2)$.
  2. *Sylvester's Criterion:* Leading principal minors are $Delta_1 = 4 > 0$ and $Delta_2 = det(H) = 8 - 4 = 4 > 0$, so $H succ 0$.
  3. *Stationarity $H x^* = -c$:* Solving $mat(4, -2; -2, 2) vec(x_1^*, x_2^*) = vec(4, -2)$ yields $x_1^* = 1, x_2^* = 0$.
]
""",
    "plot_2d": """
#plot-2d(
  title: "Underdamped Second-Order Step Response",
  subtitle: "Simultaneous analytic function evaluation and discrete scatter data series",
  badge-label: "components/science.typ",
  xlabel: $t " (s)"$,
  ylabel: $y(t)$,
  domain: (0, 8),
  yrange: (-0.8, 1.1),
  width: 10.5,
  height: 3.8,
  functions: (
    (fn: t => calc.exp(-0.4 * t) * calc.cos(2.8 * t), label: [Underdamped $e^(-0.4 t) cos(2.8 t)$], color: floe-cyan),
    (fn: t => calc.exp(-0.4 * t), label: [Envelope $plus.minus e^(-0.4 t)$], color: floe-red, dash: "dashed"),
    (fn: t => -calc.exp(-0.4 * t), label: none, color: floe-red, dash: "dashed"),
  ),
  series: (
    (
      points: ((0, 1.0), (1.1, -0.64), (2.2, 0.41), (3.3, -0.26), (4.4, 0.17), (5.5, -0.11), (6.6, 0.07)),
      label: [Sampled Data $y[k]$],
      color: floe-amber,
      mode: "scatter",
    ),
  ),
  footer: [Figure 4.1: Rendered natively in Typst via `#plot-2d` with auto-ticks, gridlines, and legend.],
  above: 0pt,
  below: 0pt,
)
""",
    "reaction": """
#reaction(
  "2SO2(g) + O2(g) <=> 2SO3(g)",
  title: "Contact Process Sulfur Trioxide Oxidation",
  conditions: "V2O5 Catalyst • 450 °C • 2 atm",
  delta-h: $-197.8 " kJ mol"^(-1)$,
  delta-g: $-141.6 " kJ mol"^(-1)$,
  keq: $1.7 times 10^2$,
  num: "4.1",
  above: 0pt,
  below: 0pt,
)
""",
    "split_view": """
#split-view(
  titles: ("Time-Domain State-Space", "Frequency-Domain Transfer Function"),
  badges: ("MODERN CONTROL", "CLASSICAL CONTROL"),
  above: 0pt,
  below: 0pt,
  [Models internal state vector $x(t) in RR^n$ directly via coupled ODEs $dot(x) = A x + B u$, handling MIMO systems and nonzero initial conditions $x(0)$ naturally.],
  [Models input-output rational operator $G(s) = C(s I - A)^(-1) B + D$ assuming zero initial conditions $x(0) = 0$, ideal for SISO loop shaping.],
)
""",
    "pro_con": """
#pro-con(
  title: "Model Predictive Control (MPC) vs Linear-Quadratic Regulator (LQR)",
  pros: (
    [Handles hard state and actuator constraints ($u_(\"min\") <= u_k <= u_(\"max\")$) explicitly.],
    [Exploits preview lookahead of future reference trajectories and disturbances.],
  ),
  cons: (
    [Requires solving a constrained Quadratic Program (QP) online at every sampling instant $T_s$.],
    [Recursive feasibility and stability require terminal cost and terminal set design.],
  ),
)
""",
    "bento_grid": """
#bento-grid(
  columns: (1.3fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 0pt,
  bento-cell(
    title: "Asymmetric Bento Cell A",
    subtitle: "1.3fr wider column",
    badge-label: "PRIMARY",
    badge-variant: "info",
    footer: [Bottom-aligned bento footer],
  )[
    `#bento-grid` delegates row measurement to `#equal-grid`, so every cell in a row automatically stretches to match its tallest sibling.
  ],
  bento-cell(
    title: "Bento Cell B",
    subtitle: "1.0fr column",
    badge-label: "SECONDARY",
    badge-variant: "purple",
    footer: [Matches height of Cell A],
  )[
    Shorter text still stretches cleanly to match Cell A.
  ],
)
""",
    "feature_grid": """
#feature-grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  above: 0pt,
  below: 0pt,
  (icon: "⚡", title: "Zero-Alias API", desc: [Every component has one canonical name across the entire package.]),
  (icon: "📐", title: "Equal-Height Rows", desc: [Parent-driven row measurement stretches every card in a row natively.]),
  (icon: "🧪", title: "Multi-Science Ready", desc: [Built-in chemistry (`#ce`, `#reaction`), physics (`physica`, `unify`), and 2D plots (`#plot-2d`).]),
)
""",
    "key_value_grid": """
#key-value-grid(
  above: 0pt,
  below: 0pt,
  items: (
    ("Package Identifier", "@local/floe:0.2.0 (Universal Typst Package)"),
    ("Row Layout Engine", "#equal-grid with floe-footer slack distribution"),
    ("Diagram Backends", "CeTZ 0.5.2 • Fletcher 0.5.8 • Merman 0.1.0 • Zap 0.5.0"),
  ),
)
""",
    "duality_grid": """
#duality-grid(
  left-title: "Controllability (Reachability)",
  right-title: "Observability (Constructibility)",
  left-badge: "PRIMAL (A, B)",
  right-badge: "DUAL (A^T, C^T)",
  above: 0pt,
  below: 0pt,
  rows: (
    ("Kalman Matrix", $cal(C) = mat(B, A B, dots, A^(n-1) B)$, "Observability Matrix", $cal(O) = mat(C; C A; dots.v; C A^(n-1))$),
    ("Gramian", $W_c = integral_0^oo e^(A tau) B B^top e^(A^top tau) dd(tau)$, "Gramian", $W_o = integral_0^oo e^(A^top tau) C^top C e^(A tau) dd(tau)$),
    ("Synthesis Problem", "State-Feedback Pole Placement u = -K x", "Synthesis Problem", "Luenberger State Observer Gain L"),
  ),
)
""",
    "tables": """
#data-table(
  columns: (1.2fr, 1.2fr, 1fr, 0.9fr),
  headers: ("Method", "Iteration Complexity", "Memory Footprint", "Sparsity"),
  align: (left + horizon, center + horizon, center + horizon, center + horizon),
  above: 0pt,
  below: 0pt,
  [Gradient Descent], [$cal(O)(1 / epsilon)$], [$cal(O)(n)$], badge-no,
  [Newton Method], [$cal(O)(log log(1 / epsilon))$], [$cal(O)(n^2)$], badge-yes,
  [Primal-Dual Interior-Point], [$cal(O)(sqrt(n) log(1 / epsilon))$], [$cal(O)(n^3)$], badge-opt,
)
""",
    "spec_table": """
#spec-table(
  above: 0pt,
  below: 0pt,
  ("with-running-chrome", [Applies Hydra-powered running headers (`header-left`, `header-right`) and page footers.]),
  ("with-heading-theme", [Applies `Inter` typography, sticky anti-orphan protection (`sticky: true`), and hierarchical numbering.]),
  ("with-code-theme", [Styles ```` ```lang ```` blocks as macOS windows and intercepts ```` ```mermaid ```` blocks via `@preview/merman`.]),
)
""",
    "comparison_table": """
#comparison-table(
  headers: ("Solver / Method", "Global Optimum", "Handles Nonconvex", "Uses Gradient"),
  above: 0pt,
  below: 0pt,
  ([Simplex / Interior-Point LP], badge-yes, badge-no, badge-yes),
  ([Sequential Quadratic Programming (SQP)], badge-no, badge-yes, badge-yes),
  ([Branch-and-Bound MILP], badge-yes, badge-opt, badge-no),
)
""",
    "chapter_header": """
#chapter-header(
  num: 1,
  title: "First-Order Optimality Conditions",
  subtitle: "Unconstrained minimization, stationary points, and descent directions",
  eyebrow: "CHAPTER",
  badge-label: "CORE THEORY",
  slides-ref: "Lecture 01",
  reader-ref: "Sections 1.1–1.4",
  teardown-ref: "Lab 01: Gradient Flow",
  pagebreak-before: false,
)
""",
    "cover_hero": """
#cover-hero(
  eyebrow: "FLOE ACADEMIC SERIES",
  badge-label: "#cover-hero",
  title: "Grand Cover & Monograph Masthead",
  subtitle: "High-impact dark-navy display banner with corner-anchored pills and bottom metadata strip",
  meta: (
    ("Layer", "Layer 3 — components/hero.typ"),
    ("Geometry", "Corner-Anchored Bean Row + Stacked Title"),
    ("Edition", "Zero-Alias Specification"),
  ),
  above: 0pt,
  below: 0pt,
)
""",
    "split_hero": """
#split-hero(
  tag: "SPLIT HERO",
  badge-label: "#split-hero",
  title: "Two-Column Narrative + Visual Hero",
  subtitle: "Pairs a dark-navy headline column on the left with a vertically centered equation or figure canvas on the right.",
  highlights: (
    [Equal-height left & right columns via `#equal-grid`.],
    [Vertically centered visual canvas on the right.],
  ),
  visual: [
    $ A = Q Lambda Q^top = sum_(i=1)^n lambda_i q_i q_i^top $
    #v(4pt)
    #text(size: 7.8pt, fill: slate-600)[Orthogonal spectral decomposition of symmetric $A in RR^(n times n)$.]
  ],
  above: 0pt,
  below: 0pt,
)
""",
    "stat_hero": """
#stat-hero(
  tag: "SYSTEM SPECIFICATION",
  badge-label: "#stat-hero",
  title: "Executive KPI & Specification Strip Hero",
  subtitle: "Combines a corner-anchored hero header with an equal-height bottom strip of KPI metric tiles",
  stats: (
    ("5 Layers", "Strict DAG Hierarchy", "Zero circular imports"),
    ("12 Heroes", "Header Archetypes", "In components/hero.typ"),
    ("6 Terms", "Universal Math Palette", "c-term-1 .. c-term-6"),
    ("0 Aliases", "Clean Public API", "Single canonical names"),
  ),
  above: 0pt,
  below: 0pt,
)
""",
    "editorial_header": """
#editorial-header(
  num: 4,
  eyebrow: "EDITORIAL MAGAZINE HEADER",
  title: "Spectral Methods & Fast Transforms",
  subtitle: "With reading-time indicator and learning goals pill bar",
  read-time: "12 min read",
  goals: ("DFT Matrix Factorization", "Radix-2 Butterfly", "Circulant Diagonalization"),
  above: 0pt,
  below: 0pt,
)
""",
    "banner_header": """
#banner-header(
  tag: "PART II • CONTINUUM MECHANICS",
  badge-label: "#banner-header",
  title: "Dark Navy Banner Part Opener",
  subtitle: "In-page major part or topic transition card with corner-anchored pills and stacked title",
  above: 0pt,
  below: 0pt,
)
""",
    "section_header": """
#section-header(
  tag: "SECTION 4.7",
  badge-label: "TOPIC SHIFT",
  title: "Section Header Banner",
  subtitle: "Clean in-page section divider with corner-anchored beans, title, and cyan rule",
  above: 0pt,
  below: 0pt,
)
""",
    "subchapter_card": """
#subchapter-card(
  tag: "SUBCHAPTER ROADMAP",
  badge-label: "PREREQUISITES",
  title: "Subchapter Syllabus Preview Card",
  above: 0pt,
  below: 0pt,
)[
  Used at the start of a section to summarize key topics, prerequisites, or reading roadmaps before diving into derivations.
]
""",
    "document_header": """
#document-header(
  tag: "TECHNICAL REPORT",
  badge-label: "FINAL",
  title: "System Identification & Spectral Audit",
  subtitle: "Clean executive document masthead with structured metadata strip",
  metadata: (("Author", "Floe Labs"), ("Status", "Approved"), ("Version", "v0.2.0")),
  above: 0pt,
  below: 0pt,
)
""",
    "keynote_hero": """
#keynote-header(
  tag: "KEYNOTE SLIDE HEADER",
  badge-label: "16:9 SLIDES",
  title: "16:9 Keynote Display Header",
  subtitle: "Used on presentation slide openers and executive report section dividers.",
  above: 0pt,
  below: 0pt,
)
""",
    "math_helpers": """
#card(
  title: "Universal Equation Dissection & Auto-Colored Legend",
  badge-label: "components/math.typ",
  badge-variant: "info",
  above: 0pt,
  below: 0pt,
)[
  $
    #math-annot($rho (pdv(bold(u), t) + (bold(u) dot grad) bold(u))$, "Convective Acceleration", color: c-term-1) =
    #math-annot-top($-grad p$, "Pressure Gradient", color: c-term-2) +
    #math-annot($mu laplacian bold(u)$, "Viscous Diffusion", color: c-term-3) +
    #math-annot($bold(f)_("ext")$, "Body Force", color: c-term-4)
  $
  #eq-legend(
    ($rho (pdv(bold(u), t) + (bold(u) dot grad) bold(u))$, "Inertial & convective momentum transport per unit volume"),
    ($-grad p$, "Isotropic normal stress driving fluid from high to low pressure"),
    ($mu laplacian bold(u)$, "Internal shear stress dissipation governed by dynamic viscosity"),
    ($bold(f)_("ext")$, "Gravitational, Lorentz, or buoyancy force density"),
  )
]
""",
}

ADR_DOC_SNIPPET = """#import "/lib.typ": *

#show: adr.with(
  title: "ADR-004: Event-Driven State-Space Telemetry Architecture",
  status: "accepted",
  date: "2026-11-11",
  deciders: ("Lead Architect", "Principal Control Engineer"),
  summary: [
    Migrating real-time telemetry streaming from synchronous pull-based polling to asynchronous ring-buffered UDP packet publishing.
  ],
  mode: "document",
)

= Context and Problem Statement

Real-time estimation of 4-DoF robotic manipulators requires streaming state vectors $x(t) in RR^8$ at $1000 upright("Hz")$. Synchronous HTTP/REST polling introduced intolerable jitter ($> 15 upright("ms")$), causing state observer divergence.

= Decision Outcome

We adopt a lock-free, zero-copy UDP ring buffer. Observer nodes subscribe to state broadcast packets and reconstruct the Kalman state estimate asynchronously.

#pro-con(
  title: "UDP Streaming vs Polling REST API",
  pros: (
    [Sub-millisecond latency: jitter reduced to $< 0.2 upright("ms")$],
    [Deterministic memory consumption on embedded DSP targets],
  ),
  cons: (
    [Requires out-of-order sequence numbering in application layer],
    [Packet drop on lossy WiFi networks requires state-extrapolation fallback],
  ),
)
"""

ADR_SLIDES_SNIPPET = """#import "/lib.typ": *

#show: adr.with(
  title: "ADR-004: Event-Driven Telemetry",
  status: "accepted",
  date: "2026-11-11",
  deciders: ("Lead Architect", "Principal Control Engineer"),
  mode: "slides",
)

#pro-con(
  title: "Architecture Tradeoffs: UDP Ring Buffer vs REST Polling",
  pros: (
    [Sub-millisecond latency: jitter $< 0.2 upright("ms")$],
    [Deterministic memory consumption on embedded targets],
    [Zero lock contention across estimator threads],
  ),
  cons: (
    [Out-of-order sequence tracking needed in application layer],
    [Packet drop requires discrete-time state-extrapolation fallback],
  ),
)
"""


def compile_snippet(typ_source: str, out_png: Path, page_num: int | None = None) -> None:
    """Compile a Typst snippet string to a PNG image."""
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_path = Path(tmpdir)
        typ_file = ROOT_DIR / f"_tmp_preview_{out_png.stem}.typ"
        try:
            typ_file.write_text(typ_source, encoding="utf-8")
            if page_num is not None:
                pattern = str(tmp_path / "page_{p}.png")
                subprocess.run(
                    [
                        "typst",
                        "compile",
                        "--root",
                        str(ROOT_DIR),
                        "--ppi",
                        "200",
                        str(typ_file),
                        pattern,
                    ],
                    check=True,
                )
                rendered = tmp_path / f"page_{page_num}.png"
                shutil.copyfile(rendered, out_png)
            else:
                subprocess.run(
                    [
                        "typst",
                        "compile",
                        "--root",
                        str(ROOT_DIR),
                        "--ppi",
                        "200",
                        str(typ_file),
                        str(out_png),
                    ],
                    check=True,
                )
        finally:
            if typ_file.exists():
                typ_file.unlink()


def main() -> None:
    ASSETS_DIR.mkdir(parents=True, exist_ok=True)
    DOCS_ASSETS_DIR.mkdir(parents=True, exist_ok=True)

    for name, body in SNIPPETS.items():
        out_png = ASSETS_DIR / f"{name}.png"
        print(f"Rendering {name}.png ...")
        compile_snippet(PREAMBLE + "\n" + body.strip() + "\n", out_png)
        shutil.copyfile(out_png, DOCS_ASSETS_DIR / f"{name}.png")

    print("Rendering preset_adr_doc.png ...")
    out_adr_doc = ASSETS_DIR / "preset_adr_doc.png"
    compile_snippet(ADR_DOC_SNIPPET, out_adr_doc)
    shutil.copyfile(out_adr_doc, DOCS_ASSETS_DIR / "preset_adr_doc.png")

    print("Rendering preset_adr_slides.png ...")
    out_adr_slides = ASSETS_DIR / "preset_adr_slides.png"
    compile_snippet(ADR_SLIDES_SNIPPET, out_adr_slides)
    shutil.copyfile(out_adr_slides, DOCS_ASSETS_DIR / "preset_adr_slides.png")

    # Sync any existing preset PNGs as well
    for png in ASSETS_DIR.glob("*.png"):
        shutil.copyfile(png, DOCS_ASSETS_DIR / png.name)

    print(f"✔ Rendered and synced {len(list(ASSETS_DIR.glob('*.png')))} preview PNGs!")


if __name__ == "__main__":
    main()
