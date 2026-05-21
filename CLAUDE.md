# CLAUDE.md

This file provides guidance to Claude Code working in the **calendaring**
Typst package repository.

## Project Overview

`calendaring` is a small Typst package published on Typst Universe that lays
out month calendar grids from `(year, month)`. Designed for personal planners
and training logs — not for displaying scheduled events (see `cineca` for
that). Source of truth for the API is `lib.typ` (~150 lines).

Public surface:
- `month-grid(year, month, ...)` — main entry point. Renders one month as a
  7-column grid with optional rotation, custom cells, weekday-name override,
  events, today highlight, and ISO 8601 week-number column.
- `year-grid(year, columns: 3, ...)` — composes twelve `month-grid` instances
  on one page.
- `is-leap-year(year)` — Gregorian leap-year predicate.

## Repository Layout

```
calendaring/
├── lib.typ              # package source (single file)
├── typst.toml           # package manifest
├── README.md            # user docs (shown on Typst Universe)
├── CHANGELOG.md         # Keep-a-Changelog format
├── LICENSE              # MIT
├── CLAUDE.md            # this file
└── examples/            # focused use-case demos
    ├── basic.typ
    ├── workout-log.typ
    ├── habit-tracker.typ
    ├── weekend-shading.typ
    ├── training-calendar.typ   # events + today
    ├── wall-calendar.typ       # ISO 8601 week numbers
    ├── leap-year.typ
    └── year-at-a-glance.typ    # year-grid()
```

## Build & Test

There is no automated test framework. Verification is done by compiling each
example and visually checking the PDF:

```bash
# From the repo root — examples import from ../lib.typ, so --root is needed
typst compile --root . examples/basic.typ

# Compile all examples in a loop
for f in examples/*.typ; do typst compile --root . "$f"; done
```

## Releasing a new version

1. Bump `version` in `typst.toml` and update `CHANGELOG.md`. Commit and push
   to `main`.
2. Reinstall locally for testing — copy `lib.typ`, `typst.toml`, `LICENSE`,
   `README.md` into `%APPDATA%\typst\packages\local\calendaring\<version>\`
   (Windows) or `$XDG_DATA_HOME/typst/packages/local/calendaring/<version>/`
   (Linux).
3. Recompile every example and any downstream consumer (e.g. the user's
   monthly planner at `~/personal/workout_planning/monthly-planning/`).
4. Sync to the typst-packages fork at `~/typst-packages` (sparse-checked-out
   fork of `typst/packages`):
   ```bash
   cd ~/typst-packages
   git checkout -b add-calendaring-<version> main
   mkdir -p packages/preview/calendaring/<version>
   cp ~/calendaring/{typst.toml,lib.typ,LICENSE,README.md} \
      packages/preview/calendaring/<version>/
   git add packages/preview/calendaring/<version>/ \
     && git commit -m "calendaring:<version>: <summary>"
   git push -u origin add-calendaring-<version>
   gh pr create --repo typst/packages --base main \
     --head TAJD:add-calendaring-<version> --title "calendaring:<version>"
   ```
5. PR title must be `name:version`. Body: tick "new package" for the first
   submission, "update for a package" thereafter. Describe what changed.
6. Once merged, downstream `@local/calendaring:<version>` imports can switch
   to `@preview/calendaring:<version>`. Merged versions are **immutable**;
   bugs require a new version, never an in-place edit.

`CLAUDE.md` and `examples/*.pdf` are not included in the submission — only
`lib.typ`, `typst.toml`, `README.md`, and `LICENSE` get copied to the
`packages/preview/...` directory.

## Typst Universe submission rules

- **Naming.** Canonical names are rejected (`calendar`, `slides`). Riffs
  (`calendaring`, `sliding`) or coined names are fine. The PR template
  requires explaining the choice.
- **License.** SPDX-valid; the `LICENSE` file must match the manifest.
- **README.** Must include working examples with absolute imports
  (`@preview/calendaring:<version>`, not `../lib.typ`). Version numbers in
  README imports must match the manifest version.
- **Bundle hygiene.** Exclude PDFs and large assets via `typst.toml`'s
  `exclude` field, but never exclude `LICENSE`.

## Design notes

The API was shaped by patterns from established LaTeX calendar packages:
- **TikZ calendar** — `cell-content` receives a `datetime` (like
  `if (Monday) { ... }`), `events` parameter (like `\if (equals: <date>)`),
  `year-grid` (like `month list` layout).
- **wallcalendar** — `today` highlight, `weekday-names` for localization,
  ISO 8601 week-number column.

`_iso-week(date)` snaps to the row's Thursday (the ISO 8601 anchor) and
divides by 7 from year-start. Handles year-boundary weeks correctly —
e.g. Mon Dec 29 2025 belongs to ISO week 1 of 2026.

## Open PR

PR #4910 — initial 0.1.0 submission — <https://github.com/typst/packages/pull/4910>.
Awaiting maintainer review. Push commits to the same `add-calendaring-0.1.0`
branch on the `TAJD/packages` fork to update the PR.
