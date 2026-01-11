# Document Style Guide

This guide covers text emphasis, callouts, and styled elements for PS50008A course materials. These styles work in both HTML and Typst output.

**Snippets available**: All elements below have VS Code/Positron snippets. Type the prefix and press Tab.

---

## Text Highlights

Use highlights for inline emphasis. Works in both HTML and PDF.

| Prefix | Color | Use Case |
|--------|-------|----------|
| `hly` | Yellow | General emphasis |
| `hlyb` | Yellow Bold | Strong emphasis |
| `hlb` | Blue | Information |
| `hlg` | Green | Success, correct |
| `hlr` | Red | Warning, error |
| `hlgr` | Gray | Neutral, code-like |

**Syntax**:
```markdown
[highlighted text]{style="background-color: #FFF3CD"}
```

**Example**:
```markdown
The [key concept]{style="background-color: #FFF3CD"} is that variables can take different values.
```

---

## Text Colors

Use colored text for semantic meaning.

| Prefix | Color | Use Case |
|--------|-------|----------|
| `txtdanger` | Red | Errors, critical warnings |
| `txtsuccess` | Green | Correct answers, success |
| `txtwarning` | Yellow | Cautions, attention needed |
| `txtinfo` | Blue | Notes, additional info |
| `txtmuted` | Gray | Secondary info, dates |

**Syntax**:
```markdown
[Error: Check your data]{style="color: #DC3545; font-weight: bold"}
```

---

## Badges

Use badges for labels and status indicators.

| Prefix | Style | Use Case |
|--------|-------|----------|
| `badgenew` | Blue | New content |
| `badgedeprecated` | Red | Outdated content |
| `badgebeta` | Yellow | Experimental |
| `badgeversion` | Gray | Version numbers |
| `badge` | Custom | Any label |

**Syntax**:
```markdown
[NEW]{style="background-color: #0D6EFD; color: white; font-weight: bold"} This section was just added.
```

---

## Quarto Callouts (Preferred)

Use native Quarto callouts for most purposes. These render well across all formats.

| Prefix | Type | Use Case |
|--------|------|----------|
| `qnote` | Note | Additional information |
| `qwarning` | Warning | Important cautions |
| `qimportant` | Important | Critical information |
| `qtip` | Tip | Helpful suggestions |
| `qcaution` | Caution | Collapsible content |

**Syntax**:
```markdown
::: {.callout-note}
## Note Title

Content here.
:::
```

**Collapsible**:
```markdown
::: {.callout-tip collapse="true"}
## Show Answer

Hidden content revealed on click.
:::
```

---

## Styled Callout Blocks

Alternative to Quarto callouts when you need custom colors or emoji headers.

| Prefix | Background | Use Case |
|--------|------------|----------|
| `calloutinfo` | Blue | Information |
| `calloutwarning` | Yellow | Warning |
| `calloutdanger` | Red | Critical |
| `calloutsuccess` | Green | Success |
| `callouttip` | Gray | Tips |

**Syntax**:
```markdown
::: {style="background-color: #CFE2FF;"}
**ℹ️ Information**

Content here.
:::
```

---

## Pedagogical Boxes (Slides)

These classes are defined in `slides.scss` for RevealJS presentations.

| Prefix | Class | Use Case |
|--------|-------|----------|
| `objbox` | `.objectives-box` | Learning objectives |
| `defbox` | `.definition-box` | Key definitions |
| `pollbox` | `.poll-box` | Questions, polls |
| `step1-4` | `.step-1` to `.step-4` | Sequential steps |

**Syntax**:
```markdown
::: {.objectives-box}
**Learning Objectives**

- Objective 1
- Objective 2
:::

::: {.definition-box}
**Variable**: Something that can take different values.
:::
```

---

## Code Elements

### Code Chunks

| Prefix | Language | Notes |
|--------|----------|-------|
| `coder` | R | With label and options |
| `codepy` | Python | With label and options |
| `codewebr` | WebR | Interactive browser R |
| `codeannotate` | Any | With line annotations |

**WebR Example**:
````markdown
```{webr-r}
# Interactive code here
mean(c(1, 2, 3, 4, 5))
```
````

### Inline Code Styling

| Prefix | Use Case |
|--------|----------|
| `codevar` | Variable references |
| `codefile` | File paths |
| `kbd` | Keyboard shortcuts |

**Syntax**:
```markdown
Press [Cmd+S]{style="background-color: #212529; color: #fff"} to save.
```

---

## Tables

| Prefix | Features |
|--------|----------|
| `table` | Basic 3-column table |
| `tablecap` | Table with caption and label |

**With Cross-Reference**:
```markdown
| Col 1 | Col 2 |
|-------|-------|
| A | B |

: Table caption {#tbl-example}

See @tbl-example for details.
```

---

## RevealJS-Specific

These work only in RevealJS presentations.

| Prefix | Purpose |
|--------|---------|
| `2col` | Two-column layout |
| `slide` | New slide |
| `slidebg` | Slide with background color |
| `slidesection` | Section header (Navy) |
| `notes` | Speaker notes |
| `fragment` | Appear on click |
| `incremental` | Step-by-step list |
| `pause` | Pause marker (`. . .`) |

**Two Columns**:
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

**Section Header**:
```markdown
# Section Title {background-color="#275882"}
```

---

## YAML Headers

| Prefix | Document Type |
|--------|---------------|
| `yamlhtml` | HTML document |
| `yamlreveal` | RevealJS slides (RM0 theme) |
| `yamlwebr` | WebR lab activity |

---

## Workflow Elements

| Prefix | Purpose |
|--------|---------|
| `todo` | HTML comment TODO marker |
| `ai` | AI instruction flag (`« instruction »`) |
| `draft` | Draft content block |
| `dougalsays` | Dougal the dog reminder 🐕 |

---

## Brand Colors Reference

| Name | Hex | Use |
|------|-----|-----|
| Navy | `#275882` | Primary, headers, objectives |
| Orange | `#EA8439` | Accent, definitions |
| Teal | `#17A2B8` | Secondary steps |
| Green | `#28A745` | Success, step 3 |
| Yellow | `#FFC107` | Warnings |
| Red | `#DC3545` | Danger, errors |
| Gray | `#6C757D` | Muted content |

---

## Quick Reference

### Most Common Snippets

```
qnote      → Quarto note callout
qtip       → Quarto tip callout (use collapse="true" for answers)
qimportant → Quarto important callout
hly        → Yellow highlight
defbox     → Definition box (slides)
objbox     → Objectives box (slides)
step1-4    → Sequential steps (slides)
codewebr   → WebR code chunk
2col       → Two columns (slides)
pause      → RevealJS pause (. . .)
```

### File Organization

- **Readings**: Use `qnote`, `qtip`, highlights, tables
- **Slides**: Use pedagogical boxes, `2col`, `pause`, section headers
- **Lab Activities**: Use `codewebr`, `qtip collapse="true"` for answers
- **Self-Assessment**: Use `qtip collapse="true"` extensively for hidden answers
