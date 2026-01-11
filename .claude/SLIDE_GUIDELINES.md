# Slide Deck Guidelines

> **Snippets available**: VS Code/Positron snippets for all common patterns are in `.vscode/quarto.code-snippets`. Type the prefix (e.g., `2col`, `defbox`, `qnote`) and press Tab.
>
> **See also**: [DOCUMENT_STYLE_GUIDE.md](DOCUMENT_STYLE_GUIDE.md) for text emphasis and callouts in readings and lab activities.

---

## Brand Identity

### Typography
- **Primary Font**: Atkinson Hyperlegible
- **Body Text**: Black (#000000)
- **Designed for accessibility and readability**

### Color Palette

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| **Base** | Navy Blue | `#275882` | Headers, primary elements, section dividers |
| **Accent** | Orange | `#EA8439` | Highlights, call-to-action, emphasis |
| **Body Text** | Black | `#000000` | All body content |
| **Background** | White | `#FFFFFF` | Slide backgrounds |

### Pedagogical Box Colors

Use these consistently across all slides:

| Box Type | Background | Border | Usage |
|----------|------------|--------|-------|
| **Learning Objectives** | `#E3F2FD` | `#275882` | Start of lecture/section |
| **Definition** | `#E8EAF6` | `#5C6BC0` | Key terms and definitions |
| **Concept** | `#F3E5F5` | `#9C27B0` | Core concepts and principles |
| **Example** | `#E8F5E9` | `#4CAF50` | Worked examples, demonstrations |
| **Exercise** | `#E3F2FD` | `#2196F3` | Practice tasks for students |
| **Solution** | `#E8F5E9` | `#4CAF50` | Answers to exercises |
| **Note/Tip** | Use Quarto `.callout-note` / `.callout-tip` | Native styling |
| **Warning/Caution** | Use Quarto `.callout-warning` / `.callout-caution` | Native styling |
| **Important** | Use Quarto `.callout-important` | Native styling |
| **Poll/Question** | `#FFF8E1` | `#FFC107` | Interactive questions |
| **Discussion** | `#FFF8E1` | `#FFC107` | Open-ended prompts |
| **Theory** | `#E8EAF6` | `#3F51B5` | Theoretical frameworks |
| **Research** | `#E3F2FD` | `#2196F3` | Empirical findings |
| **Case Study** | `#FCE4EC` | `#E91E63` | Real-world examples |

---

## Slide Structure

### Section Headers
Use colored backgrounds for major section transitions:
```markdown
# Section Title {background-color="#275882"}
```

### Standard Content Slides
```markdown
## Slide Title

Content goes here.
```

### Two-Column Layout
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

---

## Using Tabsets

Tabsets are excellent for:
- **Comparing approaches** (e.g., different statistical methods)
- **Step-by-step processes** where each step needs detail
- **Before/After** comparisons
- **Code + Output** pairs
- **Multiple examples** of the same concept
- **Theory vs Practice** splits

### Best Practices
1. **Limit to 3-4 tabs** - too many becomes overwhelming
2. **Short tab labels** - 1-3 words maximum
3. **Consistent content length** across tabs
4. **First tab should be the default/most important**

### Syntax
```markdown
::: {.panel-tabset}

### Tab One
Content for first tab.

### Tab Two
Content for second tab.

:::
```

---

## Fragments and Reveals

### When to Use Incremental Reveals
- Building up complex diagrams step-by-step
- Revealing answers after discussion time
- Preventing students reading ahead of your explanation
- Creating dramatic effect for key points

### When NOT to Use
- Reference slides students need to read at their pace
- Dense information slides
- Slides you'll share as handouts

### Preferred Fragment Types
- `.fragment` - basic fade in
- `.fragment .fade-in` - explicit fade
- `.fragment .highlight-red` / `.highlight-blue` - draw attention

### Avoid
- Transitions between slides (none or fade only)
- Excessive animations that distract from content

---

## Code Presentation

### Static Code (display only)
````markdown
```r
# Your R code here
x <- 1:10
```
````

### Executable Code
````markdown
```{r}
#| echo: true
#| eval: true
x <- 1:10
mean(x)
```
````

### WebR Interactive Code
````markdown
```{webr-r}
# Students can modify and run this
x <- 1:10
mean(x)
```
````

---

## Quarto Callouts

Use native Quarto callouts for consistent styling:

```markdown
::: {.callout-note}
## Note Title
Content here.
:::

::: {.callout-tip}
## Tip
Helpful suggestion.
:::

::: {.callout-warning}
## Warning
Important caveat.
:::

::: {.callout-important}
## Important
Critical information.
:::

::: {.callout-caution collapse="true"}
## Click to Expand
Collapsible content.
:::
```

---

## Images

### Basic Image
```markdown
![Alt text](images/filename.png){width="80%"}
```

### Image with Caption (cross-referenceable)
```markdown
![Caption text](images/filename.png){#fig-label width="80%"}

Reference with @fig-label
```

---

## Embedding Media

### YouTube Video
```markdown
{{< video https://www.youtube.com/watch?v=VIDEO_ID >}}
```

### Local Video
```markdown
{{< video video.mp4 >}}
```

---

## Linking to Slides

### Slides Open in New Tab

All links to slide decks from website pages should open in a new tab. Use `target="_blank"`:

```markdown
[Lecture Slides](lecture/slides.html){target="_blank"}
```

Or in HTML:
```html
<a href="lecture/slides.html" target="_blank">Lecture Slides</a>
```

### Standard Link Pattern

When linking to slides from week index pages, use this pattern:

```markdown
| Resource | Link |
|----------|------|
| Lecture Slides | [View slides](lecture/slides.html){target="_blank"} |
| Lab Slides | [View slides](lab/slides.html){target="_blank"} |
```

---

## SCSS Customization

Include the theme file in your YAML header:

```yaml
format:
  revealjs:
    theme: [default, slides.scss]
```

The brand colors are defined as variables in `slides.scss`:

```scss
$base-color: #275882;        // Navy blue - headers
$accent-color: #EA8439;      // Orange - highlights
$body-color: #000000;        // Black - body text
$background-color: #FFFFFF;  // White - backgrounds
```

---

## Backlog / Future Enhancements

- [ ] Auto-animate transitions for morphing content
- [ ] Custom icon sets for pedagogical elements
- [ ] webexercises integration for interactive quizzes

---

# Quick Reference Cheatsheet

## Slide Structure

| Pattern | Usage |
|---------|-------|
| `# Title {background-color="#275882"}` | Section header |
| `## Slide Title` | Standard slide |
| `## Title {.smaller}` | Smaller text |
| `## Title {.center}` | Centered content |
| `## Title {.scrollable}` | Scrollable content |

## Layouts

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

## Pedagogical Box Classes

| Class | Purpose | Color |
|-------|---------|-------|
| `.objectives-box` | Learning objectives | Blue |
| `.definition-box` | Key terms | Indigo |
| `.concept-box` | Core concepts | Purple |
| `.example-box` | Worked examples | Green |
| `.exercise-box` | Practice tasks | Blue |
| `.solution-box` | Answers | Green |
| `.theory-box` | Theoretical frameworks | Indigo |
| `.research-box` | Empirical findings | Blue |
| `.casestudy-box` | Real-world examples | Pink |
| `.poll-box` | Interactive questions | Yellow |
| `.discussion-box` | Open-ended prompts | Yellow |
| `.reference-box` | Citations/sources | Gray |
| `.equation-box` | Math formulas | Light gray |
| `.construct-box` | Psychology constructs | Purple |
| `.quote-box` | Quotations | Gray |
| `.draft-box` | Draft content | Yellow |

**Usage:**
```markdown
::: {.definition-box}
**Term**: Definition text here.
:::
```

## Comparison & Results

| Class | Purpose |
|-------|---------|
| `.pro-box` | Advantages (green) |
| `.con-box` | Disadvantages (red) |
| `.result-significant` | p < 0.05 (green) |
| `.result-nonsignificant` | p ≥ 0.05 (red) |
| `.significant-text` | Green bold text |
| `.nonsignificant-text` | Red bold text |

## Step Process

| Class | Color |
|-------|-------|
| `.step-1` | Blue |
| `.step-2` | Green |
| `.step-3` | Orange |
| `.step-4` | Pink |

## Inline Styling

| Class | Effect |
|-------|--------|
| `.inverse-box` | Navy background, white text |
| `.accent-box` | Orange background, white text |
| `.hl-yellow` | Yellow highlight |
| `.hl-blue` | Blue highlight |
| `.hl-green` | Green highlight |
| `.hl-red` | Red highlight |
| `.hl-gray` | Gray highlight |
| `.code-var` | Monospace code variable |
| `.kbd` | Keyboard key style |

**Usage:**
```markdown
[key term]{.inverse-box}
[highlight this]{.hl-yellow}
[MAX_RETRIES]{.code-var}
[Cmd+S]{.kbd}
```

## Badges

| Class | Color |
|-------|-------|
| `.badge-new` | Blue |
| `.badge-deprecated` | Red |
| `.badge-beta` | Yellow |
| `.badge-version` | Gray |

**Usage:** `[NEW]{.badge-new}`

## Statistics Display

```markdown
::: {.stat-value}
p < 0.05
:::
::: {.stat-label}
Statistical Significance
:::
```

## Mind Map

```markdown
::: {.mind-map-center}
Central Concept
:::
[Branch 1]{.mind-map-branch}
```

## Fragments

| Class | Effect |
|-------|--------|
| `.fragment` | Basic reveal |
| `.fragment .fade-in` | Fade in |
| `.fragment .fade-out` | Fade out |
| `.fragment .grow` | Scale up |
| `.fragment .shrink` | Scale down |
| `.fragment .highlight-red` | Turn red |
| `.fragment .highlight-blue` | Turn blue |

## Quarto Callouts

```markdown
::: {.callout-note}
## Title
Content
:::
```

Types: `.callout-note`, `.callout-tip`, `.callout-warning`, `.callout-important`, `.callout-caution`

Add `collapse="true"` for expandable.

## Tabsets

```markdown
::: {.panel-tabset}
### Tab One
Content
### Tab Two
Content
:::
```

## Code Blocks

| Syntax | Purpose |
|--------|---------|
| ` ```r ` | Static R code |
| ` ```{r} ` | Executable R code |
| ` ```{webr-r} ` | Interactive WebR |
| ` ```{.r code-line-numbers="true"} ` | With line numbers |
| ` ```{.r code-line-numbers="1-2|4-5"} ` | Stepped highlighting |

## Images & Media

```markdown
![Alt text](image.png){width="80%"}
![Caption](image.png){#fig-label width="80%"}
{{< video https://www.youtube.com/watch?v=ID >}}
```

## Speaker Features

```markdown
::: {.notes}
Speaker notes here
:::
```

| Attribute | Effect |
|-----------|--------|
| `{visibility="hidden"}` | Hide slide |
| `{visibility="uncounted"}` | Don't count slide |
