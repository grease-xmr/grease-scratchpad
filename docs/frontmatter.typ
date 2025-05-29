#import "@preview/drafting:0.2.2"
#let format(doc) = {
  import "@preview/drafting:0.2.2"
  
  set par(
    first-line-indent: 1em,
    justify: true,
  )
  set page(
      paper: "a4",
      margin: (x: 4cm, top: 3cm, bottom: 3cm),
      numbering: "1"
  )
  set text(
    size: 12pt
  )
  show heading: set block(below: 1.5em, above: 2em)
  set par(
      leading: 0.6em,
      spacing: 1.25em,
      justify: true
  )
  show link: set text(blue)
  
  drafting.set-page-properties(margin-left: 4cm, margin-right: 4cm)

 
 
  doc
}


#let CJc = drafting.margin-note.with(stroke: blue)
#let SMc = drafting.margin-note.with(stroke: green)