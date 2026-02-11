
# Academic Research Project Instructions for Claude

## Reading Order (Priority)

1. **`PROGRESS.md`** — Read FIRST. Current project status, active plan, history.
2. **This file (`CLAUDE.md`)** — Project structure, coding style, conventions.
3. **`Plans/`** — If PROGRESS.md shows an active plan, read the corresponding plan log.
4. **`.claude/skills/`** — Available skills (pdf, progress-tracker, work-summary, zotero-paper-reader).
5. **`.claude/agents/`** — Specialized agents (code-reviewer, report-checker, results-summarizer).

## Working Directory Context

You are working in the `ProjectExample/WORKSPACE_PLACEHOLDER/` folder, which is a research workspace inside a forked Git repository. This folder contains:
- Git-tracked folders: `Code/`, `Figures/`, `Tables/`, `Paper/`, `Slides/`, `Plans/`
- Symlinked folders: `Data`, `Notes`, `Output` (these link to `../../ProjectExample-Share/` which is outside the Git repo)

The parent folder `ProjectExample/` contains the original forked repository codebase. Your research workspace is separate from the original code.

You can access all folders normally - the symlinks are transparent. Files in symlinked folders are NOT tracked by Git but are synced via Dropbox.

## Project Structure

This project follows a two-folder structure designed for academic research on top of a forked repository:

### Git Repository (ProjectExample/)
- Original forked codebase at the repo root
- `WORKSPACE_PLACEHOLDER/Code/` - All analysis scripts organized by task (e.g., DataCleaning/)
- `WORKSPACE_PLACEHOLDER/Figures/` - Final presentable charts and visualizations (version-tracked)
- `WORKSPACE_PLACEHOLDER/Tables/` - Final presentable results and summary statistics (version-tracked)
- `WORKSPACE_PLACEHOLDER/Paper/` - LaTeX documents for academic papers
- `WORKSPACE_PLACEHOLDER/Slides/` - LaTeX presentations
- `WORKSPACE_PLACEHOLDER/Data`, `WORKSPACE_PLACEHOLDER/Notes`, `WORKSPACE_PLACEHOLDER/Output` - Symlinks to ProjectExample-Share/

### Dropbox Folder (ProjectExample-Share/)
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


## Coding Style

- Code is for academic research and **NOT** meant for production-ready. Therefore, write **concise** and efficient code without safety check (`try...catch...`, `if...else`) unless it's necessary or specifically requested
- Due to the exploratory nature, **DO** write interactive code that can be evaluated line-by-line
- Document only when necessary, but be concise
- When producing outputs, save in `Output/` following the subfolder convention. Do **NOT** save outputs in `Figures/` or `Tables/` unless explicitly requested
- The project is version controlled with Git. Hence, when adding new analysis, Do **NOT** create a new script per task, but **DO** edit the existing files directly
- Always execute at the project root rather than `cd` into subfolders

## Python Environment

- Uses `uv` for dependency management
- Virtual environment located at `~/.venvs/ProjectExample`
- Run commands with `uv run <command>` (e.g., `uv run python script.py`)
- Add dependencies with `uv add package`

Whenever calling Python-related programs, use `uv` unless it is infeasible.

## Git Branching

- **Never commit directly to `main`**. All work happens on a working branch (e.g., `test`, `feature/xyz`).
- `main` stays clean — it represents the last stable/accepted state and tracks upstream for this forked repo.
- When changes are ready to be permanent, create a **pull request** from the working branch to `main`.
- Before committing, check you're on the right branch (`git branch`). If on `main`, create/switch to a working branch first.

## Progress Tracking

This project tracks progress across sessions using two files:

### Files
- `PROGRESS.md` — Compact status tracker. **Read this first** when starting a new session or when asked for status.
- `Plans/` — Detailed plan logs, one file per plan.

### Workflow
1. **Session start**: Read `PROGRESS.md` for context on current phase and recent work.
2. **New plan**: Create `Plans/YYYY-MM-DD-description.md`, update `PROGRESS.md` (set Active Plan).
3. **During work**: Update plan log steps as completed.
4. **Plan done** (user says "wrap up" / "commit"):
   - Update plan log Outcome section
   - Update `PROGRESS.md` (status → Completed, clear Active Plan)
   - Commit with detailed message:
     ```
     [Title]: one-line summary

     Prior state: ...
     Motivation: ...
     Steps: 1. ... 2. ...
     Key files: ...
     See Plans/YYYY-MM-DD-desc.md for details.
     ```
5. **"Where are we?"**: Read and report from `PROGRESS.md`.
