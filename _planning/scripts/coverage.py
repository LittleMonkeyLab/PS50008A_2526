#!/usr/bin/env python3
"""
Generate coverage.md showing which outcomes and assessment requirements
are addressed in which sessions, plus materials completion status.

Usage:
    python coverage.py
"""

from pathlib import Path
from datetime import date
import yaml
import re
from collections import defaultdict

CURRICULUM_ROOT = Path(__file__).parent.parent

# Standard materials for each week
MATERIALS = [
    ('Lecture slides (RevealJS)', 'lecture'),
    ('Lecture reading/textbook', 'lecture'),
    ('Lecture preview video', 'lecture'),
    ('Moodle content', 'always'),
    ('Lab slides', 'lab'),
    ('Lab activity (WebR)', 'lab'),
    ('Lab reading', 'lab'),
    ('Homework assignment', 'lab'),
    ('Week index page', 'always'),
]


def load_frontmatter(filepath):
    content = filepath.read_text()
    match = re.match(r'^---\n(.+?)\n---\n(.*)$', content, re.DOTALL)
    if match:
        return yaml.safe_load(match.group(1)), match.group(2)
    return {}, content


def extract_outcome_ids(text):
    """Find outcome IDs like C1, P3, R2 in text."""
    return list(set(re.findall(r'\b([CPR]\d+)\b', text)))


def parse_outcomes():
    """Parse outcomes.md into structured dict."""
    outcomes_path = CURRICULUM_ROOT / 'outcomes.md'
    content = outcomes_path.read_text()
    outcomes = {}
    current_category = None
    
    for line in content.split('\n'):
        if line.startswith('## '):
            current_category = line[3:].strip()
        elif line.startswith('- '):
            match = re.match(r'- ([CPR]\d+): (.+)', line)
            if match:
                outcomes[match.group(1)] = {
                    'category': current_category,
                    'description': match.group(2)
                }
    return outcomes


def parse_assessments():
    """Parse assessments.md for required coverage."""
    assessments_path = CURRICULUM_ROOT / 'assessments.md'
    content = assessments_path.read_text()
    assessments = {}
    current_assessment = None
    in_coverage = False

    for line in content.split('\n'):
        if line.startswith('## '):
            current_assessment = line[3:].split('(')[0].strip()
            assessments[current_assessment] = {'outcomes': []}
            in_coverage = False
        elif 'Coverage required:' in line or 'Coverage:' in line:
            in_coverage = True
        elif in_coverage and line.startswith('  - '):
            oids = extract_outcome_ids(line)
            if oids and current_assessment:
                assessments[current_assessment]['outcomes'].extend(oids)
        elif in_coverage and line.startswith('- ') and not line.startswith('  - '):
            in_coverage = False

    return assessments


def parse_course_spine():
    """Parse course.md into week dictionaries."""
    course_path = CURRICULUM_ROOT / 'course.md'
    content = course_path.read_text()
    weeks = []
    for line in content.split('\n'):
        if line.startswith('|') and not line.startswith('| Week') and not line.startswith('|---'):
            parts = [p.strip() for p in line.split('|')[1:-1]]
            if len(parts) >= 5:
                try:
                    week_num = int(parts[0])
                    weeks.append({
                        'week': week_num,
                        'focus': parts[1],
                        'lecture': parts[2].lower() == 'yes',
                        'lab': parts[3].lower() == 'yes',
                        'video': parts[4].lower() == 'yes'
                    })
                except ValueError:
                    continue
    return weeks


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
                location = parts[2] if len(parts) > 2 else ''
                notes = parts[3] if len(parts) > 3 else ''
                materials[material_name] = {'status': status, 'location': location, 'notes': notes}
        elif in_table and line.startswith('##'):
            break
    return materials


def gather_materials_status():
    """Gather materials status from all week files."""
    weeks_dir = CURRICULUM_ROOT / 'weeks'
    weeks_data = parse_course_spine()
    all_materials = {}

    for w in weeks_data:
        week_num = w['week']
        week_path = weeks_dir / f'week{week_num}.md'
        if not week_path.exists():
            continue

        content = week_path.read_text()
        materials = parse_materials_table(content)
        all_materials[week_num] = {
            'focus': w['focus'],
            'has_lecture': w['lecture'],
            'has_lab': w['lab'],
            'materials': materials
        }

    return all_materials


def main():
    sessions_dir = CURRICULUM_ROOT / 'sessions'
    weeks_dir = CURRICULUM_ROOT / 'weeks'
    
    coverage = defaultdict(list)  # outcome_id -> list of sessions
    week_coverage = defaultdict(list)  # outcome_id -> list of weeks
    
    # Scan session files
    for session_path in sorted(sessions_dir.glob('*.md')):
        fm, body = load_frontmatter(session_path)
        outcomes = extract_outcome_ids(body)
        for oid in outcomes:
            coverage[oid].append(session_path.stem)
    
    # Scan week files
    for week_path in sorted(weeks_dir.glob('*.md')):
        fm, body = load_frontmatter(week_path)
        outcomes = extract_outcome_ids(body)
        for oid in outcomes:
            week_coverage[oid].append(week_path.stem)
    
    # Load outcomes and assessments
    outcomes = parse_outcomes()
    assessments = parse_assessments()
    
    all_outcome_ids = sorted(outcomes.keys(), key=lambda x: (x[0], int(x[1:])))
    
    # Generate coverage.md
    lines = [
        '# Coverage Matrix\n',
        f'Generated: {date.today()}\n',
        '\n## By Outcome\n'
    ]
    
    for oid in all_outcome_ids:
        desc = outcomes.get(oid, {}).get('description', 'Unknown')
        sessions = coverage.get(oid, [])
        weeks = week_coverage.get(oid, [])
        locations = sorted(set(sessions + weeks))
        
        if locations:
            lines.append(f'- **{oid}** ({desc}): {", ".join(locations)}')
        else:
            lines.append(f'- **{oid}** ({desc}): ⚠️ NOT COVERED')
    
    lines.append('\n## By Assessment\n')
    
    for assessment_name, assessment_data in assessments.items():
        lines.append(f'\n### {assessment_name}\n')
        required = assessment_data.get('outcomes', [])
        covered = []
        missing = []
        
        for oid in required:
            if coverage.get(oid) or week_coverage.get(oid):
                covered.append(oid)
            else:
                missing.append(oid)
        
        if covered:
            lines.append(f'Covered: {", ".join(sorted(covered))}')
        if missing:
            lines.append(f'⚠️ Missing: {", ".join(sorted(missing))}')
        if not missing:
            lines.append('✓ All requirements covered')
    
    lines.append('\n## Gaps Summary\n')

    gaps = [oid for oid in all_outcome_ids if not coverage.get(oid) and not week_coverage.get(oid)]
    if gaps:
        lines.append('Outcomes with no coverage:\n')
        for g in gaps:
            desc = outcomes.get(g, {}).get('description', 'Unknown')
            lines.append(f'- {g}: {desc}')
    else:
        lines.append('✓ All outcomes have at least one coverage point.')

    # Materials Status Section
    lines.append('\n## Materials Status\n')
    all_materials = gather_materials_status()

    if all_materials:
        # Summary statistics
        total_complete = 0
        total_required = 0
        total_in_progress = 0

        lines.append('### By Week\n')
        lines.append('| Week | Focus | Complete | In Progress | Not Started |')
        lines.append('|------|-------|----------|-------------|-------------|')

        for week_num in sorted(all_materials.keys()):
            week_data = all_materials[week_num]
            materials = week_data['materials']

            complete = sum(1 for m in materials.values() if m['status'] == 'complete')
            in_progress = sum(1 for m in materials.values() if m['status'] in ['in-progress', 'draft', 'review'])
            not_started = sum(1 for m in materials.values() if m['status'] == 'not-started')
            na = sum(1 for m in materials.values() if m['status'] == 'n/a')

            total_complete += complete
            total_in_progress += in_progress
            total_required += complete + in_progress + not_started

            lines.append(f'| {week_num} | {week_data["focus"]} | {complete} | {in_progress} | {not_started} |')

        lines.append('')
        if total_required > 0:
            pct = (total_complete / total_required) * 100
            lines.append(f'**Overall Progress:** {total_complete}/{total_required} materials complete ({pct:.0f}%)')

        # Detailed breakdown by material type
        lines.append('\n### By Material Type\n')
        lines.append('| Material | Complete | In Progress | Not Started | N/A |')
        lines.append('|----------|----------|-------------|-------------|-----|')

        for mat_name, mat_type in MATERIALS:
            complete = 0
            in_progress = 0
            not_started = 0
            na = 0
            for week_data in all_materials.values():
                materials = week_data['materials']
                if mat_name in materials:
                    status = materials[mat_name]['status']
                    if status == 'complete':
                        complete += 1
                    elif status in ['in-progress', 'draft', 'review']:
                        in_progress += 1
                    elif status == 'not-started':
                        not_started += 1
                    elif status == 'n/a':
                        na += 1
            lines.append(f'| {mat_name} | {complete} | {in_progress} | {not_started} | {na} |')

    else:
        lines.append('No materials data found in week files.')

    coverage_path = CURRICULUM_ROOT / 'coverage.md'
    coverage_path.write_text('\n'.join(lines))
    print(f'Generated {coverage_path}')


if __name__ == '__main__':
    main()
