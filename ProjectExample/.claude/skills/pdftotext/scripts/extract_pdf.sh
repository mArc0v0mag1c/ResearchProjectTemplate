#!/bin/bash
# Extract a PDF to text using pdftotext with layout preservation.
#
# Usage:
#   extract_pdf.sh <input.pdf> <output.txt>
#
# Creates the output directory if it doesn't exist.

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input.pdf> <output.txt>" >&2
    exit 1
fi

input_pdf="$1"
output_txt="$2"

if [ ! -f "$input_pdf" ]; then
    echo "Input file not found: $input_pdf" >&2
    exit 1
fi

mkdir -p "$(dirname "$output_txt")"
pdftotext -layout "$input_pdf" "$output_txt"

lines=$(wc -l < "$output_txt" | tr -d ' ')
chars=$(wc -c < "$output_txt" | tr -d ' ')
echo "✓ Extracted $lines lines, $chars chars"
echo "  Output: $output_txt"
