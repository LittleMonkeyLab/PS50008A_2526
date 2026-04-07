# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PS50008A Research Methods & Experimental Design - A Quarto-based course website for Goldsmiths University of London (Term 2, Spring 2026). The site delivers lectures, labs, and assessments for an undergraduate psychology research methods module.

## Build Commands

```bash
quarto render              # Build entire site to docs/
quarto preview             # Live preview with hot reload
quarto render week11/      # Render a specific week only
```

Output is written to `docs/` which deploys to GitHub Pages.

## Architecture

### Content Structure
Each week follows a strict layout:
```
week{N}/
├── index.qmd           # Week overview page
├── lecture/
│   ├── slides.qmd      # RevealJS presentation
│   └── reading.qmd     # Textbook-style content
└── lab/
    ├── slides.qmd      # Lab presentation
    ├── activity.qmd    # WebR interactive exercises
    ├── reading.qmd     # Lab reading material
    └── data-dictionary.qmd
```

### Key Files
- `_quarto.yml` - Master configuration (navigation, sidebar, rendering)
- `assets/slides.scss` - RevealJS theme with pedagogical box classes
- `assets/custom.css` - HTML theme customization
- `glossary.yml` - Course-wide glossary (auto-linked via extension)

### Extensions
- `_extensions/coatless/webr/` - Interactive R code in browser
- `_extensions/gadenbuie/countdown/` - Timer for activities
- `_extensions/lml/glossary/` - Auto-links glossary terms

## Brand Colors

| Role | Hex | Usage |
|------|-----|-------|
| Navy | `#275882` | Headers, section backgrounds, primary |
| Orange | `#EA8439` | Accents, highlights, emphasis |
| Black | `#000000` | Body text |
| White | `#FFFFFF` | Backgrounds |

Font: Atkinson Hyperlegible (accessibility-focused)

## Styling Guidelines

Detailed styling documentation lives in `.claude/`:
- **SLIDE_GUIDELINES.md** - RevealJS slide formatting, pedagogical box classes, fragments
- **DOCUMENT_STYLE_GUIDE.md** - Text emphasis, callouts, highlights for readings

### Key Patterns

**Section headers** (navy background):
```markdown
# Section Title {background-color="#275882"}
```

**Pedagogical boxes** (slides only):
```markdown
::: {.definition-box}
**Term**: Definition here.
:::
```
In active use: `.objectives-box`, `.definition-box`, `.concept-box`, `.example-box`, `.exercise-box`, `.poll-box`, `.research-box`

Defined but unused: `.solution-box`, `.theory-box`, `.casestudy-box`, `.discussion-box`, `.construct-box`, `.reference-box`, `.equation-box`

**Quarto callouts** (preferred for readings):
```markdown
::: {.callout-tip collapse="true"}
## Show Answer
Hidden content.
:::
```

**WebR interactive code**:
````markdown
```{webr-r}
mean(c(1, 2, 3, 4, 5))
```
````

**Two-column layout**:
```markdown
:::: {.columns}
::: {.column width="50%"}
Left content
:::
::: {.column width="50%"}
Right content
:::
::::
```

## VS Code Snippets

Extensive snippets in `.vscode/quarto.code-snippets` for rapid development. Key prefixes:
- `qnote`, `qtip`, `qwarning` - Quarto callouts
- `defbox`, `objbox`, `pollbox` - Pedagogical boxes
- `hly`, `hlb`, `hlg` - Highlights (yellow/blue/green)
- `2col` - Two-column layout
- `codewebr` - WebR code chunk
- `slide`, `slidesection` - Slide structures

## Content Conventions

- Slides linking from week index pages use `target="_blank"`
- Use `collapse="true"` on callout-tip for hidden answers in activities
- Glossary terms defined in `glossary.yml` auto-link when used
- Lab content often hidden until after class (commented hrefs in `_quarto.yml`)
