
# Academic Research Project Instructions for Claude

## Reading Order (Priority)

1. **`PROGRESS.md`** — Read FIRST. Current project status, active plan, history.
2. **`.claude/instructions/lessons.md`** — Project-specific lessons learned. Review for patterns to follow.
3. **This file (`CLAUDE.md`)** — Project structure, coding style, conventions.
4. **`Plans/`** — If PROGRESS.md shows an active plan, read the corresponding plan log.
5. **`.claude/skills/`** — Available skills (method-tracker, pdf, progress-tracker, research-junshi, work-summary, zotero-paper-reader).
6. **`.claude/agents/`** — Specialized agents (code-reviewer, report-checker, results-summarizer, unit-tester).

## Working Directory Context

You are working in the `ProjectExample/` folder, which is a Git repository. This folder contains:
- Git-tracked folders: `Code/`, `Figures/`, `Tables/`, `WorkingPaper/`, `Literature/`, `Slides/`, `Reports/`
- Symlinked folders: `Data`, `Notes`, `Output` (these link to `../ProjectExample-Share/` which is outside the Git repo)

You can access all folders normally - the symlinks are transparent. Files in symlinked folders are NOT tracked by Git but are synced via cloud storage (e.g., Dropbox, Google Drive).

## Project Structure

This project follows a two-folder structure designed for academic research collaboration:

### Git Repository (ProjectExample/)
- `Code/` - All analysis scripts organized by task (e.g., DataCleaning/)
- `Figures/` - Final presentable charts and visualizations (version-tracked)
- `Tables/` - Final presentable results and summary statistics (version-tracked)
- `WorkingPaper/` - LaTeX documents for academic working papers
- `Literature/` - Bibliography files (.bib) and literature review materials (version-tracked)
- `Slides/` - LaTeX presentations
- `Reports/` - LaTeX reports (one subfolder per report, uses `\usepackage{marcoreport}`)
- `Data`, `Notes`, `Output` - Symlinks to corresponding folders in ProjectExample-Share/

### Cloud Storage Folder (ProjectExample-Share/)
- `Data/` - Raw and processed datasets (read-only, not version-tracked)
- `Notes/` - Research notes and documentation
  - `Notes/Brainstorm/` - Research-junshi digests and brainstorm captures (auto-generated)
- `Output/` - Intermediate results organized by task matching Code/ structure

## Subfolder Organization

### Code/ Directory
Organize scripts by function. Standard subfolders:
- `Code/Utils/` - Shared configuration, helpers, constants
- `Code/DataPrep/` - Data ingestion, cleaning, transformation
- `Code/Analysis/` - Main analysis scripts (estimation, testing)
- `Code/Robustness/` - Robustness checks and sensitivity analyses
- `Code/Visualization/` - Scripts generating figures and tables
- `Code/_archive/` - Deprecated scripts kept for reference (optional)

**Important**: Edit existing scripts rather than creating new ones for variations of the same task.

### Output/ Directory
Mirror the Code/ structure with corresponding output folders:
- `Output/DataPrep/` - Cleaned datasets, processing logs
- `Output/Analysis/` - Regression results, statistical outputs
- `Output/Robustness/` - Alternative specification results
- `Output/Visualization/` - Draft figures and tables (not final versions)

Within each Output subfolder, optionally organize by script name:
- `Output/Analysis/main_regression.py/` - Outputs from main_regression.py
- `Output/Analysis/heterogeneity.py/` - Outputs from heterogeneity.py

## Working Papers

- Working papers live in `WorkingPaper/` as LaTeX documents
- When iterating on a working paper draft, use the **draft-reviewer** (`.claude/draft-reviewer/REVIEWER.md`) to get multi-agent review feedback
- Follow **Writing Standards** (see `~/.claude/CLAUDE.md`) for all paper content

## Literature

- `Literature/` is the central location for all literature-related files
  - `Literature/*.pdf` — raw paper PDFs (gitignored via `*.pdf` rule)
  - `Literature/references.bib` — shared BibTeX bibliography (git-tracked)
  - `Literature/Extracted/` — PDF-to-markdown conversions with extracted images (git-tracked)
- **Zotero workflow**: Use the **zotero-paper-reader** skill to fetch papers → download to `Literature/` → convert to `Literature/Extracted/`
- **Manual PDFs**: When the user places PDFs in `Literature/`, use the **mistral-pdf-to-markdown** skill to OCR-convert them to `Literature/Extracted/`
- API keys (`mistral_api_key`, Zotero keys) are in `.env` at the project root (gitignored)
- Filename convention: `Author_Year.md` (e.g., `Du_et_al_2023.md`)

### Running Mistral PDF-to-Markdown

See `~/.claude/CLAUDE.md` for Mistral conventions. Key point for fork projects: always run from **repo root** (not from `_myworkspace/`), and prefix paths with `_myworkspace/`.

## Reports

- Reports live in `Reports/<name>/main.tex` using `\usepackage{marcoreport}`
- **You MUST read `Reports/STYLE-GUIDE.md` before writing any report** — do not proceed without reading it first
- **Draft-first workflow** — do NOT generate LaTeX until the user explicitly approves the draft:
  1. Write overview first (structure, key findings, section outline)
  2. User reviews → revisions
  3. Write full content to `Reports/<name>/draft.md` (plain text + markdown)
  4. Iterate on draft until user says "proceed to tex"
  5. Convert `draft.md` → `main.tex`
- Follow **Writing Standards** (see `~/.claude/CLAUDE.md`) for all report content

## Coding Style

- Code is for academic research and **NOT** meant for production-ready. Therefore, write **concise** and efficient code without safety check (`try...catch...`, `if...else`) unless it's necessary or specifically requested
- Due to the exploratory nature, **DO** write interactive code that can be evaluated line-by-line
- Document only when necessary, but be concise
- The project is version controlled with Git. Hence, when adding new analysis, Do **NOT** create a new script per task, but **DO** edit the existing files directly

### Coding Checklist (enforce every time)
- [ ] **Project root**: Always execute from the project root. Never `cd` into subfolders.
- [ ] **Output location**: Save outputs in `Output/` following the subfolder convention. Do **NOT** save in `Figures/` or `Tables/` unless explicitly requested by the user.
- [ ] **Relative paths**: Use `Data/`, `Output/`, `Code/` — never absolute paths like `/Users/.../`.
- [ ] **Interactive cells**: Use `# %%` cell separators for interactive evaluation.

## Writing Standards

See `~/.claude/CLAUDE.md` for the full writing standards (factual language, prohibited language, cite everything). All agents and skills follow those rules.

## Python Environment

See `~/.claude/CLAUDE.md` for Python/uv conventions. Project-specific: virtual environment at `~/.venvs/ProjectExample`.

## Git Rules

### Branching
- A `test` branch is **auto-created** during project setup. Quick or unlinked work happens on `test`.
- For issue-linked work, create feature branches: `issue_NNN_description` (e.g., `issue_012_clean_returns`).
- **Never commit directly to `main`**. `main` stays clean — it represents the last stable/accepted state (and tracks upstream for forked repos).
- When changes are ready to be permanent, create a **pull request** from the working branch to `main`.
- Before committing, check you're on the right branch (`git branch`). If on `main`, switch to `test` first.

### Commit Messages
- **All commit messages must include an issue number** (`#NNN`) — enforced by git hook.
- Keep the summary line under 80 characters (excluding the issue number).
- For plan completions, use the detailed format from the progress-tracker skill.

### Git Hooks (auto-configured)
- `commit-msg`: Blocks commits without an issue number (`#NNN`) or "Merg" keyword. If blocked, add the relevant issue number to your message.
- `pre-commit`: (1) Scans staged files for leaked secrets (API keys, passwords, private keys) — blocks commit if found. (2) Runs `ruff check` on staged `.py` files. Fix lint errors before committing.
- Hooks location: `.githooks/`. Configured via `git config core.hooksPath .githooks`.

## Progress Tracking

This project tracks progress via `PROGRESS.md` and `Plans/`. Use the **progress-tracker skill** (`.claude/skills/progress-tracker/SKILL.md`) for all progress operations — it is the authoritative reference for the workflow.

Quick reference:
- **Session start**: Read `PROGRESS.md`, then check for active plan in `Plans/`.
- **"Where are we?"**: Read and report from `PROGRESS.md`.
- **New plan / plan completion**: Follow the progress-tracker skill instructions.

## Workflow Orchestration

See `~/.claude/CLAUDE.md` for workflow orchestration (plan first, subagent strategy, self-improvement loop, proactive saving, verification).

Project-specific save locations: `Notes/` for research notes, `Output/` for analysis results.

## For Codex Only

### Skills available

- `method-tracker`: Track methods and techniques learned from projects and readings; maintains inventory in ResearchHub (`.claude/skills/method-tracker`).
- `mistral-pdf-to-markdown`: Convert PDFs to Markdown with Mistral OCR, including image extraction (`.claude/skills/mistral-pdf-to-markdown`).
- `pdf`: Comprehensive toolkit for programmatic PDF extraction, creation, merging, and form handling (`.claude/skills/pdf`).
- `progress-tracker`: Track project progress across sessions via `PROGRESS.md` and `Plans/` (`.claude/skills/progress-tracker`).
- `research-junshi`: Research advisor (军师) — scans arXiv/venues, reads brainstorm notes, generates idea digests in `Notes/Brainstorm/` (`.claude/skills/research-junshi`).
- `work-summary`: Generate factual working journal entries in `Notes/WorkingJournal/` once analysis is done (`.claude/skills/work-summary`).

Use these skills whenever the user requests the corresponding workflow; refer to each `SKILL.md` for command details.
