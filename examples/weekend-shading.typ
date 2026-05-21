// Demonstrates shading weekends by computing the weekday inside
// the cell-content callback. The callback receives the day number;
// year and month are captured from the surrounding scope.

#import "../lib.typ": month-grid

#set page(paper: "a4", margin: 2cm)

#let year = 2026
#let month = 6

#align(center, text(16pt, weight: "bold")[June 2026])

#v(0.3cm)

#month-grid(
  year, month,
  cell-width: 1fr,
  cell-height: 2cm,
  cell-content: day => {
    let weekday = datetime(year: year, month: month, day: day).weekday()
    let is-weekend = weekday >= 6
    if is-weekend {
      table.cell(fill: luma(240))[#text(8pt, weight: "bold", fill: luma(110))[#day]]
    } else {
      text(8pt, weight: "bold")[#day]
    }
  },
)
