#import "../lib.typ": *

#show: memo.with(
  title: "Real-Time Embedded Solver Selection for GNC",
  to: "Guidance & Control Engineering Board",
  from: "Flight Software Architecture Team",
  date: "November 2026",
  subject: "Trade Study: Active-Set vs. Primal-Dual Interior-Point QP Solvers",
  summary: [
    *Recommendation:* Adopt condensed primal-dual active-set quadratic program (QP) solver `qpOASES` with fixed hot-starting. On the target STM32H753ZI (ARM Cortex-M7 @ 480 MHz), the worst-case solve latency across $1000$ hardware-in-the-loop monte-carlo runs is *1.42 ms*, well within the *5.0 ms (200 Hz)* flight deadline margin (+71.6%).
  ],
)

= Context & Constraints

The satellite attitude determination and control subsystem executes an active magnetic detumbling and target pointing loop at 200 Hz. Spacecraft torque rod actuators operate under hard current limits:

$ |tau_i| <= tau_text("max") = 0.05 "N" dot "m", quad i in {x, y, z} $

= Architecture Tradeoff Analysis

#pro-con(
  title: "Condensed Active-Set (qpOASES) vs. Sparse Interior-Point (OSQP)",
  pro-label: "ACTIVE-SET",
  con-label: "INTERIOR-POINT",
  pros: (
    [Deterministic solve time under warm-starting with known active set.],
    [Zero heap memory allocation (`malloc` free, MISRA-C compliant).],
    [Solves exactly to machine precision without penalty tuning.],
  ),
  cons: (
    [Combinatorial worst-case iteration bound in cold-start edge cases.],
    [Dense Hessian inversion cost scales as $cal(O)(m^3 N^3)$ with horizon length.],
    [Prone to cycling without Bland anti-cycling pivot rule.],
  ),
)

#v(8pt)

= Verified Benchmark Matrix

#data-table(
  headers: ("Solver Engine", "Algorithm", "Worst-Case Time", "Flash Usage", "RAM Allocation"),
  columns: (1.2fr, 1.2fr, 1fr, 1fr, 1fr),
  "qpOASES", "Parametric Active-Set", "1.42 ms", "48 kB", "14 kB (Static)",
  "OSQP", "ADMM Operator Splitting", "2.85 ms", "36 kB", "18 kB (Static)",
  "CVXGEN", "Primal-Dual IP", "1.10 ms", "124 kB", "32 kB (Static)",
)

#note(title: "Hardware Decision")[
  All code builds with `arm-none-eabi-gcc -O3 -mcpu=cortex-m7 -mfpu=fpv5-d16`. Heap instrumentation confirms zero dynamic allocations during flight loop cycles.
]
