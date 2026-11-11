#import "../lib.typ": *

#show: cheatsheet.with(
  title: "Convex Optimization Quick Reference",
  course-code: "SC42056",
  columns-num: 3,
  paper: "a4",
  orientation: "landscape",
)

= 1. Convex Sets & Cones

A set $C subset.eq RR^n$ is convex if:
$ forall x, y in C, theta in [0, 1] : theta x + (1 - theta)y in C $

*Hyperplane:* $H = {x | a^T x = b}$ \
*Halfspace:* $H_minus = {x | a^T x <= b}$ \
*Affine hull:* $text("aff")(C) = {sum theta_i x_i | sum theta_i = 1}$ \
*Convex hull:* $text("conv")(C) = {sum theta_i x_i | theta_i >= 0, sum theta_i = 1}$

== Dual Cones
$ K^* = {y in RR^n | x^T y >= 0 quad forall x in K} $
- Nonnegative orthant: $(RR_+^n)^* = RR_+^n$ (self-dual)
- Positive semidefinite cone: $(bb(S)_+^n)^* = bb(S)_+^n$

= 2. Duality & KKT

*Primal Problem:*
$ min f_0(x) quad "s.t." quad f_i(x) <= 0, quad h_j(x) = 0 $

*Lagrangian:*
$ cal(L)(x, lambda, nu) = f_0(x) + sum lambda_i f_i(x) + sum nu_j h_j(x) $

*Dual Function:*
$ g(lambda, nu) = inf_x cal(L)(x, lambda, nu) $
Always concave even if primal is non-convex!

*KKT Conditions (Zero Duality Gap):*
1. Primal feasibility: $f_i(x^*) <= 0, quad h_j(x^*) = 0$
2. Dual feasibility: $lambda_i^* >= 0$
3. Complementary slackness: $lambda_i^* f_i(x^*) = 0$
4. Stationarity: $nabla f_0(x^*) + sum lambda_i^* nabla f_i(x^*) + sum nu_j^* nabla h_j(x^*) = 0$

= 3. Solvers & Convergence

#data-table(
  headers: ("Method", "Rate", "Step Cost"),
  columns: (1fr, 0.9fr, 0.9fr),
  "Subgradient", $cal(O)(1/sqrt(k))$, $cal(O)(n)$,
  "Gradient", $cal(O)(1/k)$, $cal(O)(n)$,
  "Fast Grad", $cal(O)(1/k^2)$, $cal(O)(n)$,
  "Newton", "Quad", $cal(O)(n^3)$,
)

== Descent Safeguards
*Armijo Backtracking Rule:*
$ f(x + t Delta x) <= f(x) + alpha t nabla f(x)^T Delta x $
Typical parameters: $alpha in [0.01, 0.3]$, $beta in [0.1, 0.8]$.
