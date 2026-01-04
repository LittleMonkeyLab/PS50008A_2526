# PS50008A Development Todo List

Last updated: 2026-01-04

## Completed

- [x] Create website core pages (assessments, syllabus, schedule, resources, index)
- [x] Create Week 11 index page
- [x] Create Week 11 preview video page
- [x] Create Week 11 lab slides following slide guidelines
- [x] Create Week 11 lecture slides (for video recording)
- [x] Create Week 11 lab activity (Data Olympics stations) - placeholder
- [x] Set up slide guidelines and assets (slides.scss, SLIDE_GUIDELINES.md)
- [x] Add VLeBooks links for Coolican and Harris textbooks
- [x] Remove Robson reference
- [x] Fix _quarto.yml render list for selective building
- [x] Update attendance policy with SEATS

## In Progress

- [ ] **Confirm and fix Project Timeline in assessments.qmd** - Currently has TODO warning callout
- [ ] **Open access reading alternatives** - TODO comment in resources.qmd

## Pending

### Week 11 (Data Olympics)
- [ ] Create Week 11 video script for recording
- [ ] Finalise Data Olympics station procedures (currently TBC)
- [ ] Create Qualtrics survey for data collection
- [ ] Set up group registration mechanism

### Week 12 (First Full Week)
- [ ] Create Week 12 full suite:
  - [ ] index.qmd
  - [ ] lecture/slides.qmd (Distributions & Variability)
  - [ ] lecture/video.qmd (preview video page)
  - [ ] lab/slides.qmd
  - [ ] lab/activity.qmd (Descriptives in R - WebR)
  - [ ] Readings specification

### Weeks 13-20
- [ ] Week 13: Estimation & CIs
- [ ] Week 14: Inference & t-tests
- [ ] Week 15: Correlation
- [ ] Week 16: Regression
- [ ] Week 17: Interpretation & Credibility
- [ ] Week 18: MCQ Exam
- [ ] Week 19: Project Workshop
- [ ] Week 20: EDS Prep

## Content Notes

### Data Olympics Stations (Week 11)
Need to specify:
1. Simple Reaction Time - procedure, equipment, Qualtrics fields
2. Choice Reaction Time - procedure, equipment, Qualtrics fields
3. Memory Task - procedure, stimuli, Qualtrics fields
4. Estimation Task - procedure, stimuli, Qualtrics fields
5. Group Estimation - procedure, Qualtrics fields
6. Confidence Ratings - procedure, Qualtrics fields

### Report Writing Progression
- Weeks 12-15: Results writing
- Weeks 16-17: Methods & Introduction
- Weeks 18-19: Introduction continued
- Week 20: Discussion

### Key Dates
- Research Plan: Fri 27 Feb 2026 (Week 16)
- MCQ Exam: Mon 9 Mar 2026 (Week 18)
- EDS Assignment: Fri 20 Mar 2026 (Week 20)
- Research Report: Fri 1 May 2026 (Week 22)

## Technical Notes

- Slides use `../../assets/slides.scss` theme
- Follow SLIDE_GUIDELINES.md for all RevealJS content
- WebR for interactive R exercises in labs
- Render list in _quarto.yml controls what gets built
