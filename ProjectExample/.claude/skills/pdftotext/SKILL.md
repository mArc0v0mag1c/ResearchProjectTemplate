---
name: pdftotext
description: Extract PDF to plain text using the local `pdftotext` CLI (Poppler). Default extraction method for research papers — captures footnotes, body text, and preserves layout. Faster and more complete than OCR for text-based PDFs. Use this by default; fall back to mistral-pdf-to-markdown only if you need image extraction or the PDF is scanned.
---

# PDF to Text (pdftotext)

Extract PDF content to plain text using `pdftotext` (Poppler library). This is the **default** extraction method for research papers in this project.

## Why default over mistral?

- **Captures footnotes** — Mistral OCR silently drops academic paper footnotes (verified on Stanford MCC paper, footnote 5 which contains the key methodology finding)
- **Complete text** — no OCR dropouts, no hallucinated formatting
- **Fast and local** — no API calls, no cost, no rate limits
- **Preserves layout** — `-layout` flag maintains column structure and spacing

## When to use mistral-pdf-to-markdown instead

- PDF is scanned (image-based, not text-based)
- You need image extraction with references
- You need complex table structure preserved as markdown tables
- The document has multi-column layout that confuses pdftotext

## Quick Start

```bash
# Default extraction (layout preserved)
pdftotext -layout Literature/author_year.pdf Literature/Extracted/author_year/author_year.txt

# Or from the project root, batch-extract all PDFs in Literature/
for pdf in Literature/*.pdf; do
    name=$(basename "$pdf" .pdf)
    mkdir -p "Literature/Extracted/$name"
    pdftotext -layout "$pdf" "Literature/Extracted/$name/$name.txt"
done
```

## File Structure Convention

Each paper gets its own subfolder under `Literature/Extracted/`:

```
Literature/
├── author_year.pdf
└── Extracted/
    └── author_year/
        └── author_year.txt
```

## Verification

After extraction, grep for key terms to verify content is captured:

```bash
# Check footnotes are present (Mistral typically drops these)
grep -n "^[0-9] " Literature/Extracted/author_year/author_year.txt | head

# Check tables captured
grep -A 5 "Table 1" Literature/Extracted/author_year/author_year.txt
```
