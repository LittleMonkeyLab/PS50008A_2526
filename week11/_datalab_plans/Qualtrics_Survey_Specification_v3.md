# DataLab Qualtrics Survey Specification
## Complete Variable Dictionary and Survey Build Guide
### Version 3.0 - Updated Station Design

---

## Survey Structure Overview

The DataLab survey uses a **multi-block design** with **pre-post mood measurement** to capture the effect of participation on wellbeing:

| Section | Timing | Content |
|---------|--------|---------|
| **Part 1** (Blocks 1-5) | Session start (15 min) | Consent, ID, Sleep/Lifestyle, **Mood PRE**, TIPI, demographics |
| **Station Blocks** (6-11) | During rotations (90 min) | Data entry after each station |
| **Part 2** (Block 12) | Session end (10 min) | **Mood POST**, experience ratings, feedback |

### Key Design Features
- **Pre-Post Mood**: Allows within-subjects analysis of mood/energy/stress change
- **Personality × Performance**: TIPI scores can predict station performance
- **Multimodal Estimation**: Time, visual (lines), and tactile (strings) estimation

### Embedded Data (Set in Survey Flow)
Set these at the start based on Lab assignment:

| Variable | Lab A Value | Lab B Value |
|----------|-------------|-------------|
| `lab_condition` | A | B |
| `music_condition` | silence | music |

**Note**: Distance condition and word type condition have been removed from this version.

---

## PART 1: PRE-SESSION

### Block 1: Welcome & Consent

| Variable | Type | Question | Options/Validation |
|----------|------|----------|-------------------|
| `consent` | MC Single | I confirm I have read the information sheet and consent to participate... | 1=Yes, I consent / 0=No, I do not consent |
| `participant_id` | Text Entry | Enter your participant number (from your card) | Validation: Integer, 1-60 |
| `lab_room` | MC Single | Which lab room are you in? | A=Lab A (Room 101) / B=Lab B (Room 102) |
| `group_colour` | MC Single | What colour is your group card? | Red/Blue/Green/Yellow/Orange/Purple/Pink/White/Solo |

**Logic**: If consent = 0, skip to end of survey with thank you message.

---

### Block 2: Sleep & Lifestyle

These questions come early to capture baseline state before any tasks.

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `sleep_hours` | Slider | How many hours of sleep did you get last night? | 0-14, step 0.5 |
| `sleep_quality` | MC Single | How would you rate your sleep quality last night? | 1=Very poor / 2 / 3 / 4 / 5=Excellent |
| `caffeine_today` | Slider | How many cups of tea or coffee have you had today? | 0-10 |
| `exercise_week` | Slider | How many days did you exercise in the past week? | 0-7 |
| `screen_estimate` | Slider | Estimate your average daily phone screen time (hours) | 0-16, step 0.5 |

---

### Block 3: Mood PRE (Baseline Measurement)

**Block Title**: "How are you feeling right now?"

**Instruction Text**: "Please rate how you feel at this moment, before we begin the activities."

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `mood_pre` | Slider | How would you rate your current mood? | 1 (Very negative) to 10 (Very positive) |
| `energy_pre` | Slider | How energetic do you feel right now? | 1 (Exhausted) to 10 (Full of energy) |
| `stress_pre` | Slider | How stressed do you feel right now? | 1 (Not at all stressed) to 10 (Extremely stressed) |

**Display**: Use visual slider with emoji anchors if desired:
- Mood: 😢 -------- 😊
- Energy: 😴 -------- ⚡
- Stress: 😌 -------- 😰

---

### Block 4: TIPI (Ten Item Personality Inventory)

**Stem**: "I see myself as..."
**Scale**: 1-7 (1=Disagree strongly, 4=Neither agree nor disagree, 7=Agree strongly)
**Format**: Matrix table

| Variable | Item | Trait | Direction |
|----------|------|-------|-----------|
| `tipi_1` | Extraverted, enthusiastic | Extraversion | + |
| `tipi_2` | Critical, quarrelsome | Agreeableness | − |
| `tipi_3` | Dependable, self-disciplined | Conscientiousness | + |
| `tipi_4` | Anxious, easily upset | Emotional Stability | − |
| `tipi_5` | Open to new experiences, complex | Openness | + |
| `tipi_6` | Reserved, quiet | Extraversion | − |
| `tipi_7` | Sympathetic, warm | Agreeableness | + |
| `tipi_8` | Disorganized, careless | Conscientiousness | − |
| `tipi_9` | Calm, emotionally stable | Emotional Stability | + |
| `tipi_10` | Conventional, uncreative | Openness | − |

**Scoring Formulas** (create as embedded data):
```
extraversion = (tipi_1 + (8 - tipi_6)) / 2
agreeableness = ((8 - tipi_2) + tipi_7) / 2
conscientiousness = (tipi_3 + (8 - tipi_8)) / 2
emotional_stability = ((8 - tipi_4) + tipi_9) / 2
openness = (tipi_5 + (8 - tipi_10)) / 2
```

---

### Block 5: Basic Demographics

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `age` | Text Entry | What is your age in years? | Validation: Integer, 16-100 |
| `gender` | MC Single | What is your gender? | Woman / Man / Non-binary / Prefer to self-describe / Prefer not to say |
| `gender_other` | Text Entry | If self-describe: | Display logic: gender = "Prefer to self-describe" |
| `handedness` | MC Single | Which hand do you write with? | Left / Right / Ambidextrous |
| `vision` | MC Single | Do you have normal or corrected-to-normal vision? | Yes / No |
| `hearing` | MC Single | Do you have normal hearing? | Yes / No |

---

## STATION DATA BLOCKS (6-11)

**Navigation Note**: Each station block should be accessible from a central "hub" page. Students complete these as they rotate through stations.

---

### Block 6: Station 1 - Ruler Drop Reaction Time

| Variable | Type | Question | Options/Validation |
|----------|------|----------|-------------------|
| `rt_hand` | MC Single | Which hand did you use to catch? | Dominant / Non-dominant |
| `rt_trial1_cm` | Slider | Trial 1: Distance caught (cm) | 0-30, step 0.5 |
| `rt_trial2_cm` | Slider | Trial 2: Distance caught (cm) | 0-30, step 0.5 |
| `rt_trial3_cm` | Slider | Trial 3: Distance caught (cm) | 0-30, step 0.5 |
| `rt_trial4_cm` | Slider | Trial 4: Distance caught (cm) | 0-30, step 0.5 |
| `rt_trial5_cm` | Slider | Trial 5: Distance caught (cm) | 0-30, step 0.5 |
| `rt_missed` | MC Multi | Did you miss any catches? (Select all) | Trial 1 / Trial 2 / Trial 3 / Trial 4 / Trial 5 / No misses |

**Calculated Variables** (embedded data):
```
rt_trial1_ms = sqrt(2 * rt_trial1_cm/100 / 9.81) * 1000
rt_trial2_ms = sqrt(2 * rt_trial2_cm/100 / 9.81) * 1000
rt_trial3_ms = sqrt(2 * rt_trial3_cm/100 / 9.81) * 1000
rt_trial4_ms = sqrt(2 * rt_trial4_cm/100 / 9.81) * 1000
rt_trial5_ms = sqrt(2 * rt_trial5_cm/100 / 9.81) * 1000
rt_mean_ms = (rt_trial1_ms + rt_trial2_ms + rt_trial3_ms + rt_trial4_ms + rt_trial5_ms) / 5
rt_best_ms = min(rt_trial1_ms, rt_trial2_ms, rt_trial3_ms, rt_trial4_ms, rt_trial5_ms)
rt_improvement = rt_trial1_ms - rt_trial5_ms
```

---

### Block 7: Station 2 - Memory & Distraction

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `mem_total` | Slider | How many words did you correctly recall? | 0-10 |
| `mem_pos1` | MC Single | Did you recall word 1? | Yes / No / Unsure |
| `mem_pos2` | MC Single | Did you recall word 2? | Yes / No / Unsure |
| `mem_pos3` | MC Single | Did you recall word 3? | Yes / No / Unsure |
| `mem_pos4` | MC Single | Did you recall word 4? | Yes / No / Unsure |
| `mem_pos5` | MC Single | Did you recall word 5? | Yes / No / Unsure |
| `mem_pos6` | MC Single | Did you recall word 6? | Yes / No / Unsure |
| `mem_pos7` | MC Single | Did you recall word 7? | Yes / No / Unsure |
| `mem_pos8` | MC Single | Did you recall word 8? | Yes / No / Unsure |
| `mem_pos9` | MC Single | Did you recall word 9? | Yes / No / Unsure |
| `mem_pos10` | MC Single | Did you recall word 10? | Yes / No / Unsure |
| `mem_intrusions` | Slider | How many words did you write that WEREN'T on the original list? | 0-10 |
| `mem_strategy` | Text Entry | Did you use any strategy to remember the words? | Open text |

---

### Block 8: Station 3 - Time & Estimation

| Variable | Type | Question | Options/Validation |
|----------|------|----------|-------------------|
| `time_estimate_sec` | Text Entry | How many seconds passed when you said "stop"? | Validation: Number, 20-120 |
| `line_a_estimate_cm` | Slider | Your estimate for Line A length (cm) | 1-25, step 0.1 |
| `line_b_estimate_cm` | Slider | Your estimate for Line B length (cm) | 1-25, step 0.1 |
| `string1_estimate_cm` | Slider | Your estimate for String 1 length (cm) | 1-40, step 0.5 |
| `string2_estimate_cm` | Slider | Your estimate for String 2 length (cm) | 1-40, step 0.5 |
| `time_counting` | MC Single | Did you count in your head during the time estimation? | Yes, steadily / Yes, sometimes / No, just felt it |

**Note**: `music_condition` is automatically set via embedded data.

**Actual Values (for facilitator/analysis)**:
- Line A: 12.7 cm
- Line B: 8.3 cm
- String 1: 15 cm
- String 2: 23 cm

**Calculated Variables**:
```
time_error = time_estimate_sec - 60
line_a_error = line_a_estimate_cm - 12.7
line_b_error = line_b_estimate_cm - 8.3
string1_error = string1_estimate_cm - 15
string2_error = string2_estimate_cm - 23
```

---

### Block 9: Station 4 - Psychic Staring

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `stare_t1_actual` | MC Single | Trial 1: Was your partner actually staring? | Staring / Not staring |
| `stare_t1_guess` | MC Single | Trial 1: What did you guess? | Staring / Not staring |
| `stare_t1_conf` | MC Single | Trial 1: How confident were you? | 1 (Guessing) / 2 / 3 / 4 / 5 (Certain) |
| `stare_t2_actual` | MC Single | Trial 2: Was your partner actually staring? | Staring / Not staring |
| `stare_t2_guess` | MC Single | Trial 2: What did you guess? | Staring / Not staring |
| `stare_t2_conf` | MC Single | Trial 2: How confident were you? | 1-5 |
| `stare_t3_actual` | MC Single | Trial 3: Was your partner actually staring? | Staring / Not staring |
| `stare_t3_guess` | MC Single | Trial 3: What did you guess? | Staring / Not staring |
| `stare_t3_conf` | MC Single | Trial 3: How confident were you? | 1-5 |
| `stare_t4_actual` | MC Single | Trial 4: Was your partner actually staring? | Staring / Not staring |
| `stare_t4_guess` | MC Single | Trial 4: What did you guess? | Staring / Not staring |
| `stare_t4_conf` | MC Single | Trial 4: How confident were you? | 1-5 |
| `stare_t5_actual` | MC Single | Trial 5: Was your partner actually staring? | Staring / Not staring |
| `stare_t5_guess` | MC Single | Trial 5: What did you guess? | Staring / Not staring |
| `stare_t5_conf` | MC Single | Trial 5: How confident were you? | 1-5 |
| `stare_t6_actual` | MC Single | Trial 6: Was your partner actually staring? | Staring / Not staring |
| `stare_t6_guess` | MC Single | Trial 6: What did you guess? | Staring / Not staring |
| `stare_t6_conf` | MC Single | Trial 6: How confident were you? | 1-5 |
| `stare_solo` | MC Single | Did you complete this as a solo participant? | Yes (video version) / No (with partner) |

**Calculated Variables**:
```
stare_correct_total = sum of (actual == guess) across trials
stare_hit_rate = (staring trials where guess = staring) / (total staring trials)
stare_fa_rate = (not staring trials where guess = staring) / (total not staring trials)
```

---

### Block 10: Station 5 - Randomness & Dice

**Random Number Generation**:

| Variable | Type | Question | Validation |
|----------|------|----------|------------|
| `rand_num1` - `rand_num20` | Text Entry (Matrix) | Enter your 20 "random" numbers (1-10) | Integer, 1-10 each |

**Alternative**: Single text field with comma-separated values:

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `rand_all` | Text Entry | Enter all 20 numbers separated by commas | Validation: format check |

**Dice Rolling**:

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `dice_predict` | MC Single | Before rolling: Do you think you'll get more 6s than expected by chance? | Yes / No / Unsure |
| `dice_roll1` - `dice_roll10` | MC Single | Roll 1-10 outcome | 1 / 2 / 3 / 4 / 5 / 6 |

**Coin Flipping**:

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `coin_flip1` - `coin_flip10` | MC Single | Flip 1-10 | Heads / Tails |
| `coin_longest_run` | Slider | What was your longest run of the same outcome? | 1-10 |

**Calculated Variables**:
```
rand_mean = mean of rand_num1-20
rand_repeats = count of consecutive repeats
rand_mode = most frequent number
dice_sixes = count where dice_roll = 6
dice_expected_sixes = 10/6 = 1.67
coin_heads = count where coin_flip = Heads
```

---

### Block 11: Station 6 - Motor Skills (Metacognition)

| Variable | Type | Question | Options/Validation |
|----------|------|----------|-------------------|
| `throw_self_rating` | Slider | Before throwing: Rate your throwing ability | 1-10, step 1 |
| `throw_dom_success` | Slider | Dominant hand: How many did you get in? | 0-10 |
| `throw_nondom_success` | Slider | Non-dominant hand: How many did you get in? (if completed) | 0-5 / Did not attempt |
| `throw_dom_hand` | MC Single | Which is your dominant hand? | Left / Right |

**Calculated Variables**:
```
throw_accuracy_pct = throw_dom_success / 10 * 100
throw_calibration = throw_dom_success - throw_self_rating
```

**Teaching Point**: Calibration score reveals overconfidence (negative) or underconfidence (positive).

---

## PART 2: POST-SESSION

### Block 12: Mood POST & Feedback

**Block Title**: "How are you feeling now?"

**Instruction Text**: "Please rate how you feel at this moment, now that the activities are complete."

#### Mood POST (Matched to PRE for paired comparison)

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `mood_post` | Slider | How would you rate your current mood? | 1 (Very negative) to 10 (Very positive) |
| `energy_post` | Slider | How energetic do you feel right now? | 1 (Exhausted) to 10 (Full of energy) |
| `stress_post` | Slider | How stressed do you feel right now? | 1 (Not at all stressed) to 10 (Extremely stressed) |

#### Session Feedback

| Variable | Type | Question | Options |
|----------|------|----------|---------|
| `enjoyed_overall` | Slider | How much did you enjoy DataLab overall? | 1-10 |
| `fav_station` | MC Single | Which station was your favourite? | 1-Ruler Drop / 2-Memory / 3-Time / 4-Staring / 5-Randomness / 6-Throwing |
| `least_fav_station` | MC Single | Which station was your least favourite? | 1-Ruler Drop / 2-Memory / 3-Time / 4-Staring / 5-Randomness / 6-Throwing |
| `comments` | Text Entry | Any comments or feedback? | Open text, optional |

---

## CALCULATED CHANGE SCORES

Create these as embedded data or calculate in analysis:

```
mood_change = mood_post - mood_pre
energy_change = energy_post - energy_pre
stress_change = stress_post - stress_pre
```

**Interpretation**:
- **Positive mood_change**: Mood improved during DataLab
- **Positive energy_change**: Energy increased
- **Negative stress_change**: Stress decreased (improvement)

---

## DATA DICTIONARY SUMMARY

### Participant Identifiers
| Variable | Type | Description | Range/Coding |
|----------|------|-------------|--------------|
| participant_id | Integer | Unique participant number | 1-60 |
| lab_room | Categorical | Lab assignment | A, B |
| group_colour | Categorical | Group assignment | Red/Blue/Green/Yellow/Orange/Purple/Pink/White/Solo |
| session_date | Date | Auto-captured | ISO format |

### Sleep & Lifestyle (Block 2)
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| sleep_hours | Continuous | Hours of sleep last night | 0-14 |
| sleep_quality | Ordinal | Sleep quality rating | 1-5 |
| caffeine_today | Count | Cups of tea/coffee today | 0-10 |
| exercise_week | Count | Exercise days this week | 0-7 |
| screen_estimate | Continuous | Daily phone use estimate (hrs) | 0-16 |

### Mood PRE (Block 3 - BASELINE)
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| mood_pre | Ordinal | Baseline mood | 1-10 |
| energy_pre | Ordinal | Baseline energy | 1-10 |
| stress_pre | Ordinal | Baseline stress | 1-10 |

### Personality (TIPI)
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| extraversion | Continuous | Computed scale score | 1-7 |
| agreeableness | Continuous | Computed scale score | 1-7 |
| conscientiousness | Continuous | Computed scale score | 1-7 |
| emotional_stability | Continuous | Computed scale score | 1-7 |
| openness | Continuous | Computed scale score | 1-7 |

### Station 1: Reaction Time
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| rt_trial1_cm - rt_trial5_cm | Continuous | Catch distance per trial | 0-30 cm |
| rt_trial1_ms - rt_trial5_ms | Continuous | RT per trial (calculated) | ~100-300 ms |
| rt_mean_ms | Continuous | Average RT | ~100-300 ms |
| rt_best_ms | Continuous | Best (lowest) RT | ~100-250 ms |
| rt_improvement | Continuous | Trial 1 - Trial 5 | -100 to +100 ms |

### Station 2: Memory
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| mem_total | Count | Words correctly recalled | 0-10 |
| mem_pos1-10 | Binary | Recalled each position | Yes/No/Unsure |
| mem_intrusions | Count | False memories | 0-10 |

### Station 3: Estimation
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| time_estimate_sec | Continuous | 60-sec estimation | ~30-90 sec |
| time_error | Continuous | Actual - 60 | -30 to +30 sec |
| line_a_estimate_cm | Continuous | Line A estimate | 1-25 cm |
| line_b_estimate_cm | Continuous | Line B estimate | 1-25 cm |
| line_a_error | Continuous | Line A error | ±10 cm |
| line_b_error | Continuous | Line B error | ±10 cm |
| string1_estimate_cm | Continuous | String 1 estimate (tactile) | 1-40 cm |
| string2_estimate_cm | Continuous | String 2 estimate (tactile) | 1-40 cm |
| string1_error | Continuous | String 1 error | ±15 cm |
| string2_error | Continuous | String 2 error | ±15 cm |
| music_condition | Categorical | Condition | silence, music |

### Station 4: Psychic Staring
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| stare_correct_total | Count | Correct detections | 0-6 |
| stare_hit_rate | Proportion | P(detect|staring) | 0-1 |
| stare_fa_rate | Proportion | P(detect|not staring) | 0-1 |

### Station 5: Randomness
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| rand_mean | Continuous | Mean of generated numbers | 1-10 |
| rand_repeats | Count | Adjacent repeats | 0-19 |
| dice_sixes | Count | 6s rolled | 0-10 |
| coin_heads | Count | Heads flipped | 0-10 |
| coin_longest_run | Count | Max consecutive same | 1-10 |

### Station 6: Motor Skills
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| throw_dom_success | Count | Throws successful | 0-10 |
| throw_accuracy_pct | Percentage | Success rate | 0-100% |
| throw_self_rating | Ordinal | Self-rated ability | 1-10 |
| throw_calibration | Continuous | Accuracy - Rating | -10 to +10 |

### Mood POST (Block 12)
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| mood_post | Ordinal | Post-session mood | 1-10 |
| energy_post | Ordinal | Post-session energy | 1-10 |
| stress_post | Ordinal | Post-session stress | 1-10 |

### Mood CHANGE (Calculated)
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| mood_change | Continuous | mood_post - mood_pre | -9 to +9 |
| energy_change | Continuous | energy_post - energy_pre | -9 to +9 |
| stress_change | Continuous | stress_post - stress_pre | -9 to +9 |

### Session Feedback
| Variable | Type | Description | Range |
|----------|------|-------------|-------|
| enjoyed_overall | Ordinal | Overall enjoyment | 1-10 |
| fav_station | Categorical | Favourite station | 1-6 |
| least_fav_station | Categorical | Least favourite | 1-6 |

---

## TEACHING APPLICATIONS

### Pre-Post Design (Paired t-tests)
- **H₀**: Mean mood_change = 0 (no effect of participation)
- **H₁**: Mean mood_change ≠ 0 (DataLab affects mood)
- Same logic for energy_change, stress_change

### Multimodal Estimation Comparison
- Compare visual (lines) vs tactile (strings) estimation accuracy
- Do people show consistent over/under-estimation across modalities?
- Is visual estimation more accurate than tactile?

### Correlation with Change
- Does **extraversion** predict **mood_change**? (Do extroverts enjoy group activities more?)
- Does **baseline stress** predict **stress_change**? (Regression to the mean?)
- Does **sleep_hours** predict **energy_change**?

### Metacognition Analysis
- Calculate **calibration** = actual performance - self-rating
- Positive = underconfident, Negative = overconfident
- Correlate with personality (e.g., do high conscientiousness people calibrate better?)

### Signal Detection (Station 4)
- Calculate hit rate and false alarm rate
- Compute d' (sensitivity) if teaching signal detection theory
- Test against chance (binomial, p = 0.5)

### Music Condition (Between-Lab)
- Compare time_error between Lab A (silence) and Lab B (music)
- Independent samples t-test
- Does music make time feel faster or slower?

---

## Qualtrics Build Notes

### Survey Flow Order
1. Embedded Data block (set lab_condition, music_condition)
2. Block 1: Consent (with skip logic for non-consent)
3. Block 2: Sleep & Lifestyle
4. Block 3: Mood PRE
5. Block 4: TIPI
6. Block 5: Demographics
7. **Page Break: "When you reach this point, wait for station instructions"**
8. Blocks 6-11: Station blocks (can be in any order)
9. **Page Break: "Complete Part 2 when all stations are done"**
10. Block 12: Mood POST + Feedback

### Technical Settings
- **Prevent ballot box stuffing**: Yes
- **Anonymize responses**: No (need participant_id)
- **Allow back button**: Yes (within parts, not between)
- **Progress bar**: Yes
- **Auto-save**: Every page

### QR Code Distribution
Generate two survey links with different embedded data:
- Lab A: `[survey_url]?lab_condition=A&music_condition=silence`
- Lab B: `[survey_url]?lab_condition=B&music_condition=music`

---

## Expected Findings for Teaching

| Analysis | Expected Finding | Teaching Point |
|----------|------------------|----------------|
| Paired t-test: mood_change | Positive (mood improves) | Within-subjects design, effect size |
| Paired t-test: stress_change | Negative (stress decreases) | Directionality of scales |
| Correlation: extraversion × mood_change | Positive (extroverts enjoy more) | Individual differences |
| Regression: baseline → change | Negative (regression to mean) | Statistical artifact vs. real change |
| Visual vs tactile estimation | Visual more accurate | Modality comparison |
| Calibration (Station 6) | Slight overconfidence | Dunning-Kruger adjacent |
| Music × time estimation | Music = underestimate time | Filled-duration illusion |

---

*Document prepared for PS50008A Research Methods & Experimental Design*
*DataLab: Grow Your Own Psychology Data*
*Version 3.0 - Updated Station Design*
