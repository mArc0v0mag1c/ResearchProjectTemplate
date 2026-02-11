
# Project Guide for Claude

## Reading Order (Priority)

1. **`WORKSPACE_PLACEHOLDER/PROGRESS.md`** — Read FIRST. Current project status, active plan, history.
2. **`WORKSPACE_PLACEHOLDER/CLAUDE.md`** — Project structure, coding style, conventions.
3. **`WORKSPACE_PLACEHOLDER/Plans/`** — If PROGRESS.md shows an active plan, read the plan log.
4. **`.claude/skills/`** — Available skills (pdf, progress-tracker, work-summary, zotero-paper-reader).
5. **`.claude/agents/`** — Specialized agents (code-reviewer, report-checker, results-summarizer).

## Project Layout

This is a **forked repository** with a research workspace overlay:
- **Repo root** — Original codebase (do not modify unless explicitly asked)
- **`WORKSPACE_PLACEHOLDER/`** — Your research workspace (Code, Figures, Tables, Paper, Slides)
- **`ProjectExample-Share/`** — Shared data folder (symlinked into workspace as Data/, Notes/, Output/)

## Key Rules

- Always read `WORKSPACE_PLACEHOLDER/PROGRESS.md` at session start
- When asked "where are we?", refer to PROGRESS.md
- **Never commit to `main`** — all work on a working branch (e.g., `test`). PR to `main` when permanent.
- After completing a plan, update PROGRESS.md and commit (see progress-tracker skill)
- Follow coding style in `WORKSPACE_PLACEHOLDER/CLAUDE.md`
