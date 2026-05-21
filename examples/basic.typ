#import "../lib.typ": month-grid

#set page(paper: "a4")

= June 2026

#month-grid(2026, 6)

#pagebreak()

= February 2024 (leap day)

#month-grid(2024, 2)

#pagebreak()

= Sunday-first, smaller cells

#month-grid(2026, 1, week-start: "sun", cell-height: 1.8cm, cell-width: 2.5cm)

#pagebreak()

= Custom cell content

#let rotation = ("KB-S&C", "KB-cond", "Cardio", "Gym", "Hyrox", "rest", "rest")

#month-grid(2026, 6, cell-height: 2.2cm, cell-content: day => [
  #text(8pt, weight: "bold")[#day]
  #v(2pt)
  #text(7pt, fill: luma(120))[#rotation.at(calc.rem(day - 1, 7))]
])
