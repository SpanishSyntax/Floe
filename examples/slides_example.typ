#import "../lib.typ": *

#show: slides.with(
  title: "Convex Optimization in Embedded Control",
  theme: "dark",
)

#keynote-header(
  tag: "LECTURE 04",
  title: "Karush-Kuhn-Tucker Conditions",
  subtitle: "Primal optimality, dual feasibility, and complementary slackness",
)

#v(1em)

#grid(
  columns: (1fr, 1fr),
  gutter: 18pt,
  bento-cell(
    title: "Primal Feasibility",
    badge-label: "PRIMAL",
    badge-variant: "info",
    fill: rgb("#111827"),
    stroke: rgb("#1F2937"),
  )[
    State and actuator trajectories must satisfy affine constraints:
    $ G u <= W + S x_0 $
  ],
  bento-cell(
    title: "Stationarity (Vanishing Gradient)",
    badge-label: "OPTIMALITY",
    badge-variant: "success",
    fill: rgb("#111827"),
    stroke: rgb("#1F2937"),
  )[
    Lagrangian gradient vanishes at the saddle-point solution:
    $ nabla_u cal(L)(u^*, lambda^*) = H u^* + F x_0 + G^T lambda^* = 0 $
  ],
)
