#import "../lib.typ": month-grid

#set page(paper: "a4", margin: 1cm)
#set text(size: 6.5pt)

#align(center, text(20pt, weight: "bold")[2026])

#v(0.3cm)

#let month-name(m) = datetime(year: 2026, month: m, day: 1).display("[month repr:long]")

#grid(
  columns: (1fr, 1fr, 1fr),
  rows: (auto,) * 4,
  column-gutter: 0.4cm,
  row-gutter: 0.5cm,
  ..range(1, 13).map(m => [
    #align(center, text(9pt, weight: "bold")[#month-name(m)])
    #v(2pt)
    #month-grid(
      2026, m,
      cell-width: 1fr,
      cell-height: 0.55cm,
      inset: 1pt,
    )
  ])
)
