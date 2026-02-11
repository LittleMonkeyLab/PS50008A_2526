#!/bin/bash
# Decktape slides to PDF
# Usage: ./scripts/decktape-slides.sh [week_number]
# Example: ./scripts/decktape-slides.sh 15
#          ./scripts/decktape-slides.sh all

set -e

DOCS_DIR="docs"
OUTPUT_DIR="files/slides_pdf"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

convert_slide() {
    local html_file="$1"
    local week=$(echo "$html_file" | grep -o 'week[0-9]*')
    local type=$(echo "$html_file" | grep -oE '(lecture|lab)')
    local pdf_name="${week}-${type}.pdf"

    echo "Converting: $html_file -> $OUTPUT_DIR/$pdf_name"
    npx decktape reveal "$html_file" "$OUTPUT_DIR/$pdf_name" --size 1920x1080
}

if [ "$1" = "all" ]; then
    # Convert all slides
    for slides in "$DOCS_DIR"/week*/lecture/slides.html "$DOCS_DIR"/week*/lab/slides.html; do
        [ -f "$slides" ] && convert_slide "$slides"
    done
elif [ -n "$1" ]; then
    # Convert specific week
    week="week$1"
    for slides in "$DOCS_DIR/$week"/lecture/slides.html "$DOCS_DIR/$week"/lab/slides.html; do
        [ -f "$slides" ] && convert_slide "$slides"
    done
else
    echo "Usage: $0 <week_number|all>"
    echo "  $0 15      # Convert week 15 slides"
    echo "  $0 all     # Convert all weeks"
    exit 1
fi

echo "Done! PDFs saved to $OUTPUT_DIR/"
