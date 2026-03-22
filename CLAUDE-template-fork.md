
# Academic Research Project Instructions for Claude

## Reading Order (Priority)

1. **`PROGRESS.md`** — Read FIRST. Current project status, active plan, history.
2. **`.claude/instructions/lessons.md`** — Project-specific lessons learned. Review for patterns to follow.
3. **This file (`CLAUDE.md`)** — Project structure, coding style, conventions.
4. **`Plans/`** — If PROGRESS.md shows an active plan, read the corresponding plan log.
5. **`.claude/skills/`** — Available skills (pdf, progress-tracker, work-summary, zotero-paper-reader).
6. **`.claude/agents/`** — Specialized agents (code-reviewer, report-checker, results-summarizer, unit-tester).

## Working Directory Context

You are working in the `ProjectExample/WORKSPACE_PLACEHOLDER/` folder, which is a research workspace inside a forked Git repository. This folder contains:
- Git-tracked folders: `Code/`, `Figures/`, `Tables/`, `WorkingPaper/`, `Literature/`, `Slides/`, `Reports/`, `Plans/`
- Symlinked folders: `Data`, `Notes`, `Output` (these link to `../../ProjectExample-Share/` which is outside the Git repo)

The parent folder `ProjectExample/` contains the original forked repository codebase. Your research workspace is separate from the original code.

You can access all folders normally - the symlinks are transparent. Files in symlinked folders are NOT tracked by Git but are synced via cloud storage (e.g., Dropbox, Google Drive).

## Project Structure

This project follows a two-folder structure designed for academic research on top of a forked repository:

### Git Repository (ProjectExample/)
- Original forked codebase at the repo root
- `WORKSPACE_PLACEHOLDER/Code/` - All analysis scripts organized by task (e.g., DataCleaning/)
- `WORKSPACE_PLACEHOLDER/Figures/` - Final presentable charts and visualizations (version-tracked)
- `WORKSPACE_PLACEHOLDER/Tables/` - Final presentable results and summary statistics (version-tracked)
- `WORKSPACE_PLACEHOLDER/WorkingPaper/` - LaTeX documents for academic working papers
- `WORKSPACE_PLACEHOLDER/Literature/` - Bibliography files (.bib) and literature review materials (version-tracked)
- `WORKSPACE_PLACEHOLDER/Slides/` - LaTeX presentations
- `WORKSPACE_PLACEHOLDER/Reports/` - LaTeX reports (one subfolder per report, uses `\usepackage{marcoreport}`)
- `WORKSPACE_PLACEHOLDER/Data`, `WORKSPACE_PLACEHOLDER/Notes`, `WORKSPACE_PLACEHOLDER/Output` - Symlinks to ProjectExample-Share/

### Cloud Storage Folder (ProjectExample-Share/)
- `Data/` - Raw and processed datasets (read-only, not version-tracked)
- `Notes/` - Research notes and documentation
- `Output/` - Intermediate results organized by task matching Code/ structure

## Subfolder Organization

### Code/ Directory
Organize scripts by research tasks, not by individual runs. Examples:
- `Code/DataCleaning/` - Scripts for data preparation and cleaning
- `Code/Analysis/` - Main analysis scripts
- `Code/Robustness/` - Robustness checks and sensitivity analyses
- `Code/Visualization/` - Scripts generating figures and tables

**Important**: Edit existing scripts rather than creating new ones for variations of the same task.

### Output/ Directory
Mirror the Code/ structure with corresponding output folders:
- `Output/DataCleaning/` - Cleaned datasets, processing logs
- `Output/Analysis/` - Regression results, statistical outputs
- `Output/Robustness/` - Alternative specification results
- `Output/Visualization/` - Draft figures and tables (not final versions)

Within each Output subfolder, optionally organize by script name:
- `Output/Analysis/main_regression.py/` - Outputs from main_regression.py
- `Output/Analysis/heterogeneity.py/` - Outputs from heterogeneity.py

## Working Papers

- Working papers live in `WorkingPaper/` as LaTeX documents
- When iterating on a working paper draft, use the **draft-reviewer** (`.claude/draft-reviewer/REVIEWER.md`) to get multi-agent review feedback
- Follow **Writing Standards** (below) for all paper content

## Literature

- `Literature/` is the central location for all literature-related files
  - `Literature/*.pdf` — raw paper PDFs (gitignored via `*.pdf` rule, stored locally or cloud-synced)
  - `Literature/references.bib` — shared BibTeX bibliography (git-tracked)
  - `Literature/Extracted/` — PDF-to-markdown conversions with extracted images (git-tracked)
- **Zotero workflow**: Use the **zotero-paper-reader** skill to fetch papers → download to `Literature/` → convert to `Literature/Extracted/`
- **Manual PDFs**: When the user places PDFs in `Literature/`, use the **mistral-pdf-to-markdown** skill to OCR-convert them to `Literature/Extracted/`
- API keys (`mistral_api_key`, Zotero keys) are in `.env` at the project root (gitignored)
- Filename convention: `Author_Year.md` (e.g., `Du_et_al_2023.md`)

## Reports

- Reports live in `Reports/<name>/main.tex` using `\usepackage{marcoreport}`
- **You MUST read `Reports/STYLE-GUIDE.md` before writing any report** — do not proceed without reading it first
- **Draft-first workflow** — do NOT generate LaTeX until the user explicitly approves the draft:
  1. Write overview first (structure, key findings, section outline)
  2. User reviews → revisions
  3. Write full content to `Reports/<name>/draft.md` (plain text + markdown)
  4. Iterate on draft until user says "proceed to tex"
  5. Convert `draft.md` → `main.tex`
- Follow **Writing Standards** (below) for all report content

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

All written outputs (working journal entries, reports, summaries) must follow these rules. Agents and skills reference this section as the single source of truth.

### Be Factual and Objective
- State what was done and what was found
- Report numerical results precisely
- Describe methods used
- Link every claim to source (code, output, documentation)

### Prohibited Language
Do not use unless the user explicitly requests interpretation:

- **Speculation**: "suggests", "indicates", "likely", "probably", "appears to", "this means", "implies", "shows that"
- **Causal claims**: "because", "caused by", "due to" (unless describing code logic)
- **Subjective assessments**: "excellent", "poor", "good", "bad", "successful", "failed", "strong", "weak" (without statistical definition)
- **Vague quantifiers**: "significant" (without p-value), "accurate" (without metric)

**Acceptable alternatives**: "difference of X%", "within Y% of benchmark", "classified Z% of cases", "error rate of W%"

### Prohibited Sections
Do not include unless user explicitly requests: Recommendations, Conclusions with interpretation, Strategic Decisions, Implications, Future Work.

### Cite Everything
Every factual claim must link to supporting evidence: `[descriptive text](../../path/to/file)` — code files for methodology, output files for results, documentation for data sources.

## Python Environment

- Uses `uv` for dependency management
- Virtual environment located at `~/.venvs/ProjectExample`
- Run commands with `uv run <command>` (e.g., `uv run python script.py`)
- Add dependencies with `uv add package`

Whenever calling Python-related programs, use `uv` unless it is infeasible.

## Git Rules

### Branching
- A `test` branch is **auto-created** during project setup. Quick or unlinked work happens on `test`.
- For issue-linked work, create feature branches: `issue_NNN_description` (e.g., `issue_012_clean_returns`).
- **Never commit directly to `main`**. `main` stays clean — it represents the last stable/accepted state and tracks upstream for this forked repo.
- When changes are ready to be permanent, create a **pull request** from the working branch to `main`.
- Before committing, check you're on the right branch (`git branch`). If on `main`, switch to `test` first.

### Commit Messages
- **All commit messages must include an issue number** (`#NNN`) — enforced by git hook.
- Keep the summary line under 80 characters (excluding the issue number).
- For plan completions, use the detailed format from the progress-tracker skill.

### Git Hooks (auto-configured)
- `commit-msg`: Blocks commits without an issue number (`#NNN`) or "Merg" keyword. If blocked, add the relevant issue number to your message.
- `pre-commit`: Runs `ruff check` on staged `.py` files. Fix lint errors before committing.
- Hooks location: `.githooks/`. Configured via `git config core.hooksPath .githooks`.

## Progress Tracking

This project tracks progress via `PROGRESS.md` and `Plans/`. Use the **progress-tracker skill** (`.claude/skills/progress-tracker/SKILL.md`) for all progress operations — it is the authoritative reference for the workflow.

Quick reference:
- **Session start**: Read `PROGRESS.md`, then check for active plan in `Plans/`.
- **"Where are we?"**: Read and report from `PROGRESS.md`.
- **New plan / plan completion**: Follow the progress-tracker skill instructions.

## Workflow Orchestration

### Plan First
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately — don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- One task per subagent for focused execution

### Self-Improvement Loop
- When the user corrects your approach, ask: **"Should I add this to lessons.md?"**
- Don't silently update — confirm with the user first
- Save confirmed lessons to `.claude/instructions/lessons.md`
- Review lessons at every session start (it's in the Reading Order)

### Proactive Saving
- When generating long-form output (analysis summaries, literature reviews, detailed explanations), save to a markdown file rather than only printing to chat
- Save location: `Notes/` for research notes, `Output/` for analysis results

### Verification Before Done
- Never mark a task complete without proving it works
- Run the code, check outputs, diff behavior when relevant
- Ask yourself: "Would a senior researcher approve this?"
