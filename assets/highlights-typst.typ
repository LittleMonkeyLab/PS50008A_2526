// highlights-typst.typ
// Typst function definitions for academic highlights.
// Paired with highlights.css (HTML) and highlight-spans.lua (filter).
//
// Include in Quarto YAML:
//   format:
//     typst:
//       include-before-body:
//         - file: assets/highlights-typst.typ

// =============================================================================
// SEMANTIC HIGHLIGHTS
// =============================================================================

#let hlTerm(content) = box(
  fill: rgb("#d4e4f1"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  underline(stroke: 2pt + rgb("#275882"), offset: 2pt, text(weight: "bold", content))
)

#let hlEmphasis(content) = box(
  fill: rgb("#FFF3CD"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlStat(content) = box(
  fill: rgb("#D1E7DD"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlWarning(content) = box(
  fill: rgb("#F8D7DA"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlExample(content) = box(
  fill: rgb("#E8EAF6"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlCite(content) = box(
  fill: rgb("#FFF8DC").transparentize(40%),
  inset: (x: 3pt, y: 1pt),
  underline(
    stroke: (dash: "dotted", paint: rgb("#B8860B"), thickness: 1pt),
    offset: 3pt,
    content
  )
)

#let hlNew(content) = box(
  fill: rgb("#CFE2FF"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlRemoved(content) = box(
  fill: rgb("#F8D7DA"),
  inset: (x: 3pt, y: 1pt),
  text(fill: rgb("#666666"), strike(stroke: 2pt + rgb("#DC3545"), content))
)

// =============================================================================
// COLOUR HIGHLIGHTS
// =============================================================================

#let hlYellow(content) = box(
  fill: rgb("#FFF3CD"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlBlue(content) = box(
  fill: rgb("#CFE2FF"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlGreen(content) = box(
  fill: rgb("#D1E7DD"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlRed(content) = box(
  fill: rgb("#F8D7DA"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlPurple(content) = box(
  fill: rgb("#E8EAF6"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlOrange(content) = box(
  fill: rgb("#FFE5CC"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

#let hlGray(content) = box(
  fill: rgb("#E9ECEF"),
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  content
)

// =============================================================================
// STYLE VARIANTS
// =============================================================================

#let hlMarker(content) = box(
  fill: rgb("#FFF3CD"),
  inset: (x: 5pt, y: 2pt),
  radius: (left: 2pt, right: 6pt, top: 3pt, bottom: 1pt),
  content
)

#let hlMarkerBlue(content) = box(
  fill: rgb("#BBDEFB"),
  inset: (x: 5pt, y: 2pt),
  radius: (left: 2pt, right: 6pt, top: 3pt, bottom: 1pt),
  content
)

#let hlMarkerRed(content) = box(
  fill: rgb("#FFCDD2"),
  inset: (x: 5pt, y: 2pt),
  radius: (left: 2pt, right: 6pt, top: 3pt, bottom: 1pt),
  content
)

#let hlUnderline(content) = underline(
  stroke: 3pt + rgb("#EA8439"),
  offset: 2pt,
  content
)

#let hlBox(content) = box(
  fill: rgb("#FFF8DC"),
  stroke: 2pt + rgb("#FFC107"),
  inset: (x: 6pt, y: 3pt),
  radius: 6pt,
  text(weight: "bold", content)
)
