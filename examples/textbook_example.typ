#import "../lib.typ": *

#show: textbook.with(
  title: "Optimal Control & Dynamic Programming",
  subtitle: "State-Space Feedback, Riccati Equations & Bellman Optimality",
  course-code: "SC42056",
  institution: "Systems & Control Institute • Academic Series",
  edition: "Comprehensive Companion Edition",
  toc: false,
)

#chapter-header(
  num: 4,
  title: "Linear Quadratic Regulator (LQR)",
  eyebrow: "OPTIMAL STATE FEEDBACK",
  slides-ref: "Deck 04: Continuous Riccati Equations",
  reader-ref: "Chapter 4: LQR & Dynamic Inversion",
  teardown-ref: "Lab 04: Inverted Pendulum Balancing",
)

= Continuous-Time Formulation

Consider a continuous-time linear time-invariant (LTI) dynamic system with state vector $x(t) in RR^n$ and control input vector $u(t) in RR^m$:

$ dot(x)(t) = A x(t) + B u(t), quad x(0) = x_0 $

Our objective is to design a state feedback policy $u(t) = -K x(t)$ that drives perturbations to zero while minimizing the infinite-horizon quadratic cost functional:

#formula-breakdown(
  formula: $#t3($J(u)$) = integral_0^infinity (#t1($x(t)$)^T #t3($Q$) #t1($x(t)$) + #t2($u(t)$)^T #t3($R$) #t2($u(t)$)) dif t$,
  symbols: (
    ($x(t)$, "State Vector", [Deviations from equilibrium operating point ($x in RR^n$)]),
    ($u(t)$, "Actuator Effort", [Physical control input authority ($u in RR^m$)]),
    ($J, Q, R$, "Cost & Weights", [Scalar cost functional with $Q succ.eq 0$ and $R succ 0$]),
  ),
  arithmetic: [
    With $Q = diag(10, 1)$ and $R = 0.1$, state deviation incurs 100x higher penalty than control expenditure.
  ],
)

#theorem(
  num: "4.1",
  name: "Algebraic Riccati Equation (ARE)",
  title: "Optimal Infinite-Horizon Feedback Gain",
  takeaway: [If $(A, B)$ is stabilizable and $(A, Q^(1/2))$ is detectable, there exists a unique positive definite solution $P > 0$.],
)[
  The optimal state-feedback gain matrix is given by $K = R^(-1) B^T P$, where $P = P^T > 0$ satisfies the continuous-time Algebraic Riccati Equation:
  $ A^T P + P A - P B R^(-1) B^T P + Q = 0 $
]

#pitfall(
  title: "Controllability vs. Detectability Trap",
  mistake: [Assuming any state-space pair $(A, B)$ admits an asymptotically stabilizing LQR gain $K$.],
  correct: [Verify algebraic rank condition $rank([B, A B, dots, A^(n-1) B]) = n$ before solving ARE.],
)[
  Uncontrollable modes that lie in the open right-half complex plane cannot be stabilized by state feedback.
]
