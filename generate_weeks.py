#!/usr/bin/env python3
"""
Generate week folder structure for RM0 module.
Run from the GS_RM0_2526 directory.

Usage:
    cd /Users/gordonwright/GS_RMTeaching_2526/GS_RM0_2526
    python3 generate_weeks.py
"""

import os
from pathlib import Path

# Week content data
WEEKS = {
    11: {
        "date": "2026-01-12",
        "lab_date": "2026-01-14",
        "hw_due": "2026-01-18",
        "lecture_topic": "Introduction to Designing Good Experiments",
        "lab_topic": "Observation of Human Behaviour",
        "labels_lecture": ["experimental-design"],
        "labels_lab": ["data-collection", "observation"]
    },
    12: {
        "date": "2026-01-19",
        "lab_date": "2026-01-21",
        "hw_due": "2026-01-25",
        "lecture_topic": "Reporting Your Findings",
        "lab_topic": "Descriptive Statistics",
        "labels_lecture": ["apa-style", "writing"],
        "labels_lab": ["descriptives", "statistics"]
    },
    13: {
        "date": "2026-01-26",
        "lab_date": "2026-01-28",
        "hw_due": "2026-02-01",
        "lecture_topic": "Correlational Designs",
        "lab_topic": "Correlational Analysis",
        "labels_lecture": ["correlation", "research-design"],
        "labels_lab": ["correlation", "r-programming"]
    },
    14: {
        "date": "2026-02-02",
        "lab_date": "2026-02-04",
        "hw_due": "2026-02-08",
        "lecture_topic": "Probabilities & Distributions",
        "lab_topic": "Plotting Data with R",
        "labels_lecture": ["statistics", "probability"],
        "labels_lab": ["r-programming", "visualisation"]
    },
    15: {
        "date": "2026-02-09",
        "lab_date": "2026-02-11",
        "hw_due": "2026-02-15",
        "lecture_topic": "Significance Testing & Research Plan Briefing",
        "lab_topic": "Running T-Tests with R",
        "labels_lecture": ["statistics", "t-test"],
        "labels_lab": ["t-test", "r-programming"]
    },
    # Reading week 16 Feb - skip
    16: {
        "date": "2026-02-23",
        "lab_date": "2026-02-25",
        "hw_due": "2026-03-01",
        "lecture_topic": "Practice Assignment",
        "lab_topic": "Project Groups: Literature Review",
        "labels_lecture": ["assessment"],
        "labels_lab": ["project", "literature-review"]
    },
    17: {
        "date": "2026-03-02",
        "lab_date": "2026-03-04",
        "hw_due": "2026-03-08",
        "lecture_topic": "Practice MCQ Test",
        "lab_topic": "Project Groups: Methodology",
        "labels_lecture": ["assessment"],
        "labels_lab": ["project", "methodology"]
    },
    18: {
        "date": "2026-03-09",
        "lab_date": "2026-03-11",
        "hw_due": "2026-03-15",
        "lecture_topic": "Running Experiments Ethically and Effectively",
        "lab_topic": "Project Groups: Procedure",
        "labels_lecture": ["ethics", "experimental-design"],
        "labels_lab": ["project", "procedure"]
    },
    19: {
        "date": "2026-03-16",
        "lab_date": "2026-03-18",
        "hw_due": "2026-03-22",
        "lecture_topic": "In-class MCQ Test",
        "lab_topic": "Live Data Collection",
        "labels_lecture": ["assessment"],
        "labels_lab": ["data-collection", "project"]
    },
    20: {
        "date": "2026-03-23",
        "lab_date": "2026-03-25",
        "hw_due": "2026-03-29",
        "lecture_topic": "MCQ Feedback + Lab Report Briefing",
        "lab_topic": "Data Analysis and Reporting",
        "labels_lecture": ["assessment", "writing"],
        "labels_lab": ["statistics", "apa-style"]
    }
}

def create_index(week, data):
    short_title = data['lecture_topic'].split(' & ')[0] if ' & ' in data['lecture_topic'] else data['lecture_topic'][:35]
    return f'''---
title: "Week {week}: {short_title}"
subtitle: "PS50008A Research Methods | {data['date']}"
author: "Gordon Wright"
date: "{data['date']}"
format:
  html:
    toc: true
    toc-depth: 2
taskmistress:
  id: rm0-w{week}-index
  subtype: index
  status: backlog
  priority: 2
  due: "{data['date']}"
  labels: {data['labels_lecture']}
  blocks:
    - rm0-w{week}-lecture-slides
    - rm0-w{week}-lab-slides
  version:
    number: "0.1"
    status: draft
    changelog:
      - "2026-01-03: Initial structure"
---

## Overview

**Lecture**: {data['lecture_topic']}

**Lab**: {data['lab_topic']}

## Learning Objectives

By the end of this week, you will be able to:

- TBC
- TBC
- TBC

## Schedule

| Session | Topic | Materials |
|---------|-------|-----------|
| Lecture | {data['lecture_topic']} | [Slides](lecture/slides.qmd) \\| [Reading](lecture/reading.qmd) \\| [Video](lecture/video.qmd) |
| Lab | {data['lab_topic']} | [Slides](lab/slides.qmd) \\| [Activity](lab/activity.qmd) \\| [Reading](lab/reading.qmd) |
| Homework | Week {week} Exercises | [Homework](lab/homework.qmd) |

## Preparation

Before the lecture:

1. Watch the preview video
2. Complete the pre-lecture reading

## Key Concepts

- TBC
- TBC
- TBC

## Resources

- [Week {week} Lecture Slides](lecture/slides.qmd)
- [Lab Activity](lab/activity.qmd)
- [Homework](lab/homework.qmd)
'''

def create_lecture_slides(week, data):
    return f'''---
title: "{data['lecture_topic']}"
subtitle: "PS50008A Week {week} Lecture"
author: "Gordon Wright"
date: "{data['date']}"
format:
  revealjs:
    theme: [default, ../../assets/gs-theme.scss]
    slide-number: true
    progress: true
    hash: true
    transition: fade
    center: false
    code-fold: true
    width: 1280
    height: 720
    embed-resources: true
taskmistress:
  id: rm0-w{week}-lecture-slides
  subtype: lecture-slides
  status: backlog
  priority: 2
  due: "{data['date']}"
  labels: {data['labels_lecture']}
  depends_on:
    - rm0-w{week}-index
  blocks:
    - rm0-w{week}-lab-slides
    - rm0-w{week}-lab-activity
  version:
    number: "0.1"
    status: draft
    changelog:
      - "2026-01-03: Initial structure"
  properties:
    estimated_duration: 50min
    delivery_date: "{data['date']}"
---

## Learning Objectives

By the end of this lecture, you will be able to:

::: {{.incremental}}
- TBC
- TBC
- TBC
:::

---

## Overview

TBC - Lecture content to be developed

---

## Summary

::: {{.incremental}}
- Key point 1
- Key point 2
- Key point 3
:::

---

## Next Week

TBC - Preview of next week's content
'''

def create_lecture_reading(week, data):
    return f'''---
title: "Week {week} Lecture Reading"
subtitle: "{data['lecture_topic']}"
author: "Gordon Wright"
date: "{data['date']}"
format:
  html:
    toc: true
    toc-depth: 2
taskmistress:
  id: rm0-w{week}-lecture-reading
  subtype: reading
  status: backlog
  priority: 3
  due: "{data['date']}"
  labels: {data['labels_lecture'] + ['reading']}
  depends_on:
    - rm0-w{week}-index
  version:
    number: "0.1"
    status: draft
    changelog:
      - "2026-01-03: Initial structure"
---

## Required Reading

TBC - Textbook chapter or article details

## Reading Guide

### Key Points to Focus On

1. TBC
2. TBC
3. TBC

### Questions to Consider

- TBC
- TBC
- TBC

## Additional Resources

- TBC
'''

def create_lecture_video(week, data):
    return f'''---
title: "Week {week} Preview Video"
subtitle: "{data['lecture_topic']}"
author: "Gordon Wright"
date: "{data['date']}"
format:
  html:
    toc: false
taskmistress:
  id: rm0-w{week}-lecture-video
  subtype: lecture-notes
  status: backlog
  priority: 3
  due: "{data['date']}"
  labels: {data['labels_lecture'] + ['video']}
  depends_on:
    - rm0-w{week}-index
  version:
    number: "0.1"
    status: draft
    changelog:
      - "2026-01-03: Initial structure"
---

## Preview Video

Watch this video before attending the lecture.

::: {{.callout-note}}
## Video
Video embed or link TBC
:::

## Duration

Approximately X minutes

## Key Points Covered

1. TBC
2. TBC
3. TBC
'''

def create_lab_slides(week, data):
    return f'''---
title: "{data['lab_topic']}"
subtitle: "PS50008A Week {week} Lab"
author: "Gordon Wright"
date: "{data['lab_date']}"
format:
  revealjs:
    theme: [default, ../../assets/gs-theme.scss]
    slide-number: true
    progress: true
    transition: fade
    width: 1280
    height: 720
    embed-resources: true
taskmistress:
  id: rm0-w{week}-lab-slides
  subtype: lab-slides
  status: backlog
  priority: 2
  due: "{data['lab_date']}"
  labels: {data['labels_lab']}
  depends_on:
    - rm0-w{week}-lecture-slides
  blocks:
    - rm0-w{week}-lab-activity
  version:
    number: "0.1"
    status: draft
    changelog:
      - "2026-01-03: Initial structure"
  properties:
    estimated_duration: 20min
    delivery_date: "{data['lab_date']}"
---

## Today's Lab

**{data['lab_topic']}**

::: {{.incremental}}
- TBC
- TBC
- TBC
:::

---

## Learning Objectives

By the end of this lab, you will be able to:

- TBC
- TBC
- TBC

---

## Lab Structure

| Time | Activity |
|------|----------|
| 0-20 min | Introduction |
| 20-60 min | Main activity |
| 60-80 min | Analysis |
| 80-90 min | Wrap-up |

---

# Let's Begin! {{.center background-color="#1a1a2e"}}

Move to the [Lab Activity](activity.qmd)
'''

def create_lab_activity(week, data):
    return f'''---
title: "{data['lab_topic']}"
subtitle: "PS50008A Week {week} Lab Activity"
author: "Gordon Wright"
date: "{data['lab_date']}"
format: 
  html:
    toc: true
    toc-depth: 2
    code-fold: false
    theme: cosmo
    embed-resources: true
filters:
  - webr
webr:
  packages: ['dplyr', 'ggplot2']
  show-startup-message: false
taskmistress:
  id: rm0-w{week}-lab-activity
  subtype: lab-activity
  status: backlog
  priority: 2
  due: "{data['lab_date']}"
  labels: {data['labels_lab'] + ['webr']}
  depends_on:
    - rm0-w{week}-lab-slides
  blocks:
    - rm0-w{week}-homework
  version:
    number: "0.1"
    status: draft
    changelog:
      - "2026-01-03: Initial structure"
  properties:
    estimated_duration: 70min
    delivery_date: "{data['lab_date']}"
---

## Overview

TBC - Lab activity introduction

::: {{.callout-important}}
## Before You Begin
Make sure you have attended the Week {week} lecture.
:::

---

## Part 1: Introduction

TBC - Activity content

---

## Part 2: Exercises

TBC - Interactive exercises

```{{webr-r}}
# Example code


```

---

## Key Takeaways

::: {{.callout-important}}
## Summary
1. TBC
2. TBC
3. TBC
:::

---

## Next Steps

- Complete the [Week {week} Homework](homework.qmd)
- Prepare for Week {week + 1 if week < 15 else (16 if week == 15 else week + 1 if week < 20 else "next term")}
'''

def create_lab_reading(week, data):
    return f'''---
title: "Week {week} Lab Reading"
subtitle: "{data['lab_topic']}"
author: "Gordon Wright"
date: "{data['lab_date']}"
format:
  html:
    toc: true
    toc-depth: 2
taskmistress:
  id: rm0-w{week}-lab-reading
  subtype: reading
  status: backlog
  priority: 3
  due: "{data['lab_date']}"
  labels: {data['labels_lab'] + ['reading']}
  depends_on:
    - rm0-w{week}-index
  version:
    number: "0.1"
    status: draft
    changelog:
      - "2026-01-03: Initial structure"
---

## Required Reading

TBC - Lab-specific reading material

## Reading Guide

### Key Points to Focus On

1. TBC
2. TBC
3. TBC

## Additional Resources

- TBC
'''

def create_homework(week, data):
    return f'''---
title: "Week {week} Homework"
subtitle: "{data['lecture_topic']} & {data['lab_topic']}"
author: "Gordon Wright"
date: "{data['lab_date']}"
format:
  html:
    toc: true
    toc-depth: 2
taskmistress:
  id: rm0-w{week}-homework
  subtype: homework
  status: backlog
  priority: 2
  due: "{data['hw_due']}"
  labels: {data['labels_lecture'] + data['labels_lab'] + ['homework']}
  depends_on:
    - rm0-w{week}-lab-activity
  version:
    number: "0.1"
    status: draft
    changelog:
      - "2026-01-03: Initial structure"
  properties:
    deadline: "{data['hw_due']}"
---

## Overview

This homework consolidates your learning from Week {week}.

::: {{.callout-important}}
## Deadline
Complete this homework by {data['hw_due']}.
:::

## Part 1: Conceptual Questions

TBC

## Part 2: Practical Exercises

TBC

## Part 3: Reflection

TBC

## Submission

TBC - Submission instructions

## Marking Criteria

This is a **formative** assignment.
'''

# Main execution
if __name__ == "__main__":
    base_path = Path(".")
    
    for week, data in WEEKS.items():
        week_dir = base_path / f"week{week}"
        lecture_dir = week_dir / "lecture"
        lab_dir = week_dir / "lab"
        
        # Create directories
        lecture_dir.mkdir(parents=True, exist_ok=True)
        lab_dir.mkdir(parents=True, exist_ok=True)
        
        # Create files
        (week_dir / "index.qmd").write_text(create_index(week, data))
        (lecture_dir / "slides.qmd").write_text(create_lecture_slides(week, data))
        (lecture_dir / "reading.qmd").write_text(create_lecture_reading(week, data))
        (lecture_dir / "video.qmd").write_text(create_lecture_video(week, data))
        (lab_dir / "slides.qmd").write_text(create_lab_slides(week, data))
        (lab_dir / "activity.qmd").write_text(create_lab_activity(week, data))
        (lab_dir / "reading.qmd").write_text(create_lab_reading(week, data))
        (lab_dir / "homework.qmd").write_text(create_homework(week, data))
        
        print(f"Created week{week}")
    
    print(f"\nDone! Created {len(WEEKS)} weeks with 8 files each = {len(WEEKS) * 8} files total.")
    print("\nNext: Run 'tm:tm_sync_project' to index all items.")
