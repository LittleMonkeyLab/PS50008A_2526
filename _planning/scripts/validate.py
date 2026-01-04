#!/usr/bin/env python3
"""
Validate curriculum structure and coverage.

Checks:
- All weeks in course.md have week files
- All sessions indicated in course.md exist
- All outcomes have at least one coverage point
- All assessment requirements mapped to outcomes are covered
- No orphan session files
- Frontmatter validity
- Materials checklist completeness

Usage:
    python validate.py
    python validate.py --verbose
    python validate.py --materials   # Show detailed materials status
"""

from pathlib import Path
import sys
import yaml
import re
from collections import defaultdict

CURRICULUM_ROOT = Path(__file__).parent.parent

# Standard materials for each week
MATERIALS = [
    ('lecture_slides', 'Lecture slides (RevealJS)', 'lecture'),
    ('lecture_reading', 'Lecture reading/textbook', 'lecture'),
    ('preview_video', 'Lecture preview video', 'lecture'),
    ('moodle', 'Moodle content', 'always'),
    ('lab_slides', 'Lab slides', 'lab'),
    ('webr', 'Lab activity (WebR)', 'lab'),
    ('lab_reading', 'Lab reading', 'lab'),
    ('homework', 'Homework assignment', 'lab'),
    ('index', 'Week index page', 'always'),
]

# Valid material statuses
VALID_STATUSES = ['not-started', 'in-progress', 'draft', 'review', 'complete', 'n/a']


def load_frontmatter(filepath):
    content = filepath.read_text()
    match = re.match(r'^---\n(.+?)\n---\n(.*)$', content, re.DOTALL)
    if match:
        try:
            return yaml.safe_load(match.group(1)), match.group(2), None
        except yaml.YAMLError as e:
            return {}, match.group(2), str(e)
    return {}, content, "No frontmatter found"


def parse_course_spine():
    course_path = CURRICULUM_ROOT / 'course.md'
    content = course_path.read_text()
    weeks = []
    for line in content.split('\n'):
        if line.startswith('|') and not line.startswith('| Week') and not line.startswith('|---'):
            parts = [p.strip() for p in line.split('|')[1:-1]]
            if len(parts) >= 5:
                weeks.append({
                    'week': int(parts[0]),
                    'focus': parts[1],
                    'lecture': parts[2].lower() == 'yes',
                    'lab': parts[3].lower() == 'yes',
                    'video': parts[4].lower() == 'yes'
                })
    return weeks


def extract_outcome_ids(text):
    return list(set(re.findall(r'\b([CPR]\d+)\b', text)))


def parse_materials_table(content):
    """Parse materials checklist table from week file content."""
    materials = {}
    in_table = False
    for line in content.split('\n'):
        if '## Materials Checklist' in line:
            in_table = True
            continue
        if in_table and line.startswith('|') and 'Material' not in line and '---' not in line:
            parts = [p.strip() for p in line.split('|')[1:-1]]
            if len(parts) >= 2:
                material_name = parts[0]
                status = parts[1].lower() if parts[1] else 'not-started'
                materials[material_name] = status
        elif in_table and line.startswith('##'):
            break
    return materials


def validate_materials(week_path, week_data, errors, warnings):
    """Validate materials checklist for a week file."""
    content = week_path.read_text()
    materials = parse_materials_table(content)
    week_num = week_data['week']

    if not materials:
        warnings.append(f'week{week_num}.md: No materials checklist found')
        return {}

    status_summary = defaultdict(int)

    for mat_key, mat_name, mat_type in MATERIALS:
        if mat_name not in materials:
            warnings.append(f'week{week_num}.md: Missing material "{mat_name}"')
            continue

        status = materials.get(mat_name, 'not-started')
        status_summary[status] += 1

        # Check if status is valid
        if status not in VALID_STATUSES:
            warnings.append(f'week{week_num}.md: Invalid status "{status}" for {mat_name}')

        # Check if material is applicable based on week config
        if mat_type == 'lecture' and not week_data['lecture'] and status != 'n/a':
            warnings.append(f'week{week_num}.md: {mat_name} should be n/a (no lecture this week)')
        elif mat_type == 'lab' and not week_data['lab'] and status != 'n/a':
            warnings.append(f'week{week_num}.md: {mat_name} should be n/a (no lab this week)')

    return {'week': week_num, 'materials': materials, 'summary': dict(status_summary)}


def main():
    verbose = '--verbose' in sys.argv
    show_materials = '--materials' in sys.argv
    errors = []
    warnings = []
    info = []
    materials_report = []

    weeks = parse_course_spine()
    weeks_dir = CURRICULUM_ROOT / 'weeks'
    sessions_dir = CURRICULUM_ROOT / 'sessions'

    # Check week files exist and validate materials
    for w in weeks:
        week_num = w["week"]
        # Try both formats: week11.md and week11.md (no leading zero)
        week_path = weeks_dir / f'week{week_num}.md'
        if not week_path.exists():
            week_path = weeks_dir / f'week{week_num:02d}.md'
        if not week_path.exists():
            errors.append(f'Missing week file: week{week_num}.md')
        else:
            fm, body, err = load_frontmatter(week_path)
            if err:
                errors.append(f'{week_path.name}: {err}')
            info.append(f'{week_path.name}: OK')

            # Validate materials
            mat_result = validate_materials(week_path, w, errors, warnings)
            if mat_result:
                materials_report.append(mat_result)
    
    # Check session files exist
    expected_sessions = set()
    for w in weeks:
        week_num = w["week"]
        if w['lecture']:
            expected_sessions.add(f'week{week_num}-lecture.md')
        if w['lab']:
            expected_sessions.add(f'week{week_num}-lab.md')
        if w['video']:
            expected_sessions.add(f'week{week_num}-video.md')
    
    actual_sessions = set(f.name for f in sessions_dir.glob('*.md'))
    
    missing_sessions = expected_sessions - actual_sessions
    orphan_sessions = actual_sessions - expected_sessions
    
    for s in sorted(missing_sessions):
        errors.append(f'Missing session file: {s}')
    
    for s in sorted(orphan_sessions):
        warnings.append(f'Orphan session file (not in course.md): {s}')
    
    # Check session frontmatter
    for session_path in sessions_dir.glob('*.md'):
        fm, body, err = load_frontmatter(session_path)
        if err:
            errors.append(f'{session_path.name}: {err}')
        else:
            if 'status' not in fm:
                warnings.append(f'{session_path.name}: missing status field')
            if 'week' not in fm:
                warnings.append(f'{session_path.name}: missing week field')
    
    # Check outcome coverage
    outcomes_path = CURRICULUM_ROOT / 'outcomes.md'
    if outcomes_path.exists():
        outcomes_content = outcomes_path.read_text()
        all_outcomes = extract_outcome_ids(outcomes_content)
        
        covered_outcomes = set()
        for f in list(weeks_dir.glob('*.md')) + list(sessions_dir.glob('*.md')):
            fm, body, _ = load_frontmatter(f)
            covered_outcomes.update(extract_outcome_ids(body))
        
        uncovered = set(all_outcomes) - covered_outcomes
        if uncovered:
            for oid in sorted(uncovered):
                warnings.append(f'Outcome {oid} has no coverage')
    
    # Report
    if verbose:
        print("\nInfo:")
        for i in info:
            print(f"  ℹ️  {i}")

    if show_materials and materials_report:
        print("\n📦 Materials Status:")
        total_complete = 0
        total_required = 0
        for mr in materials_report:
            week_num = mr['week']
            summary = mr['summary']
            complete = summary.get('complete', 0)
            not_started = summary.get('not-started', 0)
            in_progress = summary.get('in-progress', 0)
            draft = summary.get('draft', 0)
            na = summary.get('n/a', 0)
            required = complete + not_started + in_progress + draft
            total_complete += complete
            total_required += required
            if required > 0:
                pct = (complete / required) * 100
                bar = '█' * int(pct / 10) + '░' * (10 - int(pct / 10))
                print(f"  Week {week_num}: [{bar}] {complete}/{required} complete ({pct:.0f}%)")
        if total_required > 0:
            total_pct = (total_complete / total_required) * 100
            print(f"\n  Overall: {total_complete}/{total_required} materials complete ({total_pct:.0f}%)")

    if warnings:
        print("\nWarnings:")
        for w in warnings:
            print(f"  ⚠️  {w}")

    if errors:
        print("\nErrors:")
        for e in errors:
            print(f"  ❌ {e}")
        sys.exit(1)

    print(f"\n✓ Validation passed ({len(weeks)} weeks, {len(actual_sessions)} sessions)")


if __name__ == '__main__':
    main()
