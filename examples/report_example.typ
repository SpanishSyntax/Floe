#import "../lib.typ": *

#show: report.with(
  title: "Autonomous Spacecraft Attitude Determination & Control",
  subtitle: "Critical Design Review (CDR) & Subsystem Benchmark",
  author: "Guidance, Navigation & Control Team",
  date: "November 2026",
)

#document-hero(
  title: "Flight Software Architecture Benchmark",
  subtitle: "Hardware-in-the-loop numerical evaluation on ARM Cortex-M7",
  metadata: (
    ("Platform", "STM32H753ZI"),
    ("Clock", "480 MHz"),
    ("Loop Rate", "200 Hz"),
    ("Memory", "1024 kB SRAM"),
  ),
)

= Executive Benchmark Summary

The Guidance, Navigation, and Control (GNC) subsystem executes real-time attitude estimation and magnetic detumbling within strict deterministic latency constraints:

#data-table(
  headers: ("Subsystem Routine", "Execution Window", "Worst-Case Time", "Margin"),
  columns: (1.5fr, 1fr, 1fr, 0.8fr),
  "TRIAD Coarse Vector Match", "5.0 ms", "0.42 ms", "+91.6%",
  "Multiplicative EKF Propagation", "5.0 ms", "1.18 ms", "+76.4%",
  "B-Cross Detumbling Law", "5.0 ms", "0.22 ms", "+95.6%",
  "Torque Rod PWM Allocation", "5.0 ms", "0.08 ms", "+98.4%",
)

#v(8pt)

#split-view(
  titles: ("Actuator Torque Budget", "Sensor Accuracy"),
  badges: ("ACTUATORS", "SENSORS"),
  [
    Three-axis magnetic torquer coils deliver nominal dipole moment $m = 0.2$ $text("A" dot "m"^2)$. Maximum magnetic control torque:
    $ tau_text("mag") = m times B_text("geo") $
  ],
  [
    Dual redundant three-axis fluxgate magnetometers provide $0.1$ nT resolution sampled over SPI bus at 1 kHz with deterministic DMA transfers.
  ],
)

== Risk Matrix & Saturation Safeguards

#warning(title: "Geomagnetic Null Space Singularity")[
  Magnetic torquers cannot generate control torque parallel to the local geomagnetic field vector $B_text("geo")$ ($tau perp B_text("geo")$). Three-axis control authority requires orbital inclination $i > 0 degree$.
]
