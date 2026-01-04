#!/usr/bin/env python3
"""
Cascade changes from parent to child documents.

Usage:
    python cascade.py week 11          # Regenerate week11.md from course.md
    python cascade.py sessions 11      # Regenerate week11 sessions from week11.md
    python cascade.py all              # Full cascade, respects status flags
    python cascade.py init             # Create all week and session stubs
"""

import sys
import os
from pathlib import Path
from datetime import date
import yaml
import re

CURRICULUM_ROOT = Path(__file__).parent.parent

# Standard materials for each week
MATERIALS = [
    ('lecture_slides', 'Lecture slides (RevealJS)'),
    ('lecture_reading', 'Lecture reading/textbook'),
    ('preview_video', 'Lecture preview video'),
    ('moodle', 'Moodle content'),
    ('lab_slides', 'Lab slides'),
    ('webr', 'Lab activity (WebR)'),
    ('lab_reading', 'Lab reading'),
    ('homework', 'Homework assignment'),
    ('index', 'Week index page'),
]


def load_frontmatter(filepath):
    """Extract YAML frontmatter from markdown file."""
    content = filepath.read_text()
    match = re.match(r'^---\n(.+?)\n---\n(.*)$', content, re.DOTALL)
    if match:
        return yaml.safe_load(match.group(1)), match.group(2)
    return {}, content


def save_with_frontmatter(filepath, frontmatter, body):
    """Write markdown file with YAML frontmatter."""
    frontmatter['last_updated'] = str(date.today())
    frontmatter['version'] = frontmatter.get('version', 0) + 1
    content = f"---\n{yaml.dump(frontmatter, default_flow_style=False, sort_keys=False)}---\n{body}"
    filepath.write_text(content)


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


def get_default_material_status(week_data, material_key):
    """Determine default status for a material based on week configuration."""
    # Materials that depend on having a lecture
    lecture_materials = ['lecture_slides', 'lecture_reading', 'preview_video']
    # Materials that depend on having a lab
    lab_materials = ['lab_slides', 'webr', 'lab_reading', 'homework']
    # Materials always required
    always_materials = ['moodle', 'index']

    if material_key in lecture_materials:
        return 'not-started' if week_data['lecture'] else 'n/a'
    elif material_key in lab_materials:
        return 'not-started' if week_data['lab'] else 'n/a'
    elif material_key in always_materials:
        return 'not-started'
    else:
        return 'not-started'


def cascade_week(week_num, force=False):
    """Regenerate week file from course spine."""
    weeks = parse_course_spine()
    week_data = next((w for w in weeks if w['week'] == week_num), None)
    if not week_data:
        print(f"Week {week_num} not found in course.md")
        return

    template_path = CURRICULUM_ROOT / 'templates' / 'week.md'
    week_path = CURRICULUM_ROOT / 'weeks' / f'week{week_num}.md'

    if week_path.exists() and not force:
        existing_fm, existing_body = load_frontmatter(week_path)
        existing_fm['focus'] = week_data['focus']
        save_with_frontmatter(week_path, existing_fm, existing_body)
        print(f"Updated weeks/week{week_num}.md")
    else:
        template = template_path.read_text()
        content = template.replace('{{week_number}}', str(week_num))
        content = content.replace('{{focus}}', week_data['focus'])
        content = content.replace('{{lecture_bool}}', 'yes' if week_data['lecture'] else 'no')
        content = content.replace('{{lab_bool}}', 'yes' if week_data['lab'] else 'no')
        content = content.replace('{{video_bool}}', 'yes' if week_data['video'] else 'no')
        content = content.replace('{{date}}', str(date.today()))

        # Replace material status placeholders
        for mat_key, mat_name in MATERIALS:
            status = get_default_material_status(week_data, mat_key)
            content = content.replace(f'{{{{{mat_key}_status}}}}', status)

        week_path.write_text(content)
        print(f"Created weeks/week{week_num}.md")


def cascade_sessions(week_num, force=False):
    """Regenerate session files from week file."""
    weeks = parse_course_spine()
    week_data = next((w for w in weeks if w['week'] == week_num), None)
    if not week_data:
        print(f"Week {week_num} not found in course.md")
        return
    
    week_path = CURRICULUM_ROOT / 'weeks' / f'week{week_num}.md'
    if not week_path.exists():
        print(f"Week file not found: {week_path}")
        print(f"Run 'python cascade.py week {week_num}' first")
        return
    
    sessions_dir = CURRICULUM_ROOT / 'sessions'
    
    session_types = []
    if week_data['lecture']:
        session_types.append('lecture')
    if week_data['lab']:
        session_types.append('lab')
    if week_data['video']:
        session_types.append('video')
    
    for session_type in session_types:
        session_path = sessions_dir / f'week{week_num}-{session_type}.md'
        template_path = CURRICULUM_ROOT / 'templates' / f'session-{session_type}.md'
        
        if session_path.exists() and not force:
            existing_fm, existing_body = load_frontmatter(session_path)
            if existing_fm.get('status') in ['draft', 'complete']:
                print(f"Skipping {session_path.name} (status: {existing_fm['status']})")
                continue
            existing_fm['derived_from'] = f'weeks/week{week_num}.md'
            save_with_frontmatter(session_path, existing_fm, existing_body)
            print(f"Updated {session_path.name}")
        else:
            if not template_path.exists():
                print(f"Template not found: {template_path}")
                continue
            template = template_path.read_text()
            content = template.replace('{{week_number}}', str(week_num))
            content = content.replace('{{date}}', str(date.today()))
            session_path.write_text(content)
            print(f"Created {session_path.name}")


def init_all():
    """Create all week and session stubs."""
    weeks = parse_course_spine()
    for w in weeks:
        cascade_week(w['week'])
        cascade_sessions(w['week'])


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return
    
    command = sys.argv[1]
    force = '--force' in sys.argv
    
    if command == 'week' and len(sys.argv) >= 3:
        cascade_week(int(sys.argv[2]), force)
    elif command == 'sessions' and len(sys.argv) >= 3:
        cascade_sessions(int(sys.argv[2]), force)
    elif command == 'all':
        weeks = parse_course_spine()
        for w in weeks:
            cascade_week(w['week'], force)
            cascade_sessions(w['week'], force)
    elif command == 'init':
        init_all()
    else:
        print(__doc__)


if __name__ == '__main__':
    main()
