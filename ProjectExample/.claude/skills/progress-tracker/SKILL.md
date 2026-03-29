---
name: progress-tracker
description: Track project progress across sessions. Read/update PROGRESS.md and plan logs in Plans/. Use when starting sessions, checking status, beginning or completing plans. Ensures continuity across Claude sessions.
---

# Progress Tracker Skill

Maintain project progress state across Claude sessions using `PROGRESS.md` and plan log files in `Plans/`.

## When to Use

Activate when:
- Starting a new session (read status)
- User asks "where are we?", "what's the status?", or "what have we done?"
- Beginning a new plan or task
- Completing a plan or significant milestone
- User asks to "wrap up", "commit the plan", or "update progress"

## Files

- `PROGRESS.md` — Compact status tracker (current phase, active plan, plan history)
- `Plans/YYYY-MM-DD-description.md` — Detailed log per plan (steps, files, outcome)

## Instructions

### Reading Status (Session Start / "Where Are We?")

1. Read `PROGRESS.md`
2. If an active plan exists, read the corresponding plan log in `Plans/`
3. Report: current phase, active plan, and recent history

### Starting a New Plan

1. Read `PROGRESS.md` for context
2. Create two files:
   - `Plans/YYYY-MM-DD-description.md` — **plan log** (clean, scannable: steps, status, files, one-line summaries)
   - `Plans/YYYY-MM-DD-description-ref.md` — **reference log** (raw verification commands, test outputs, design decisions, debug traces)

   The plan log links to the ref log for evidence. This keeps the plan readable while preserving full audit trail.

3. Plan log template:

```markdown
---
plan: "Plan Title"
status: in_progress
started: YYYY-MM-DD
completed:
commit:
---

# Plan: [Title]

## Prior State
[Where the project was — reference PROGRESS.md]

## Objective
[What we're doing and why]

## Steps

### Step 1: [Description]
- **Status**: pending
- **Files**: [files to touch]
- **Notes**:

## Outcome
[Fill when complete]

## Reference
[Ref log](YYYY-MM-DD-description-ref.md)
```

3. Update `PROGRESS.md`:
   - Set **Active Plan** to the plan title
   - Add a new entry in Plan History with status "In Progress"
   - Update **Last Updated** date

### During Plan Execution

- Update step status in the plan log as each step is completed
- Add notes about key decisions, debugging, or changes to approach

### Completing a Plan ("Wrap Up" / "Commit")

1. Update plan log:
   - Mark all steps as done
   - Fill in the **Outcome** section
   - Update front matter: `status: completed`, `completed: YYYY-MM-DD`

2. Update `PROGRESS.md`:
   - Set **Active Plan** to "None"
   - Update plan history entry: status to "Completed", add one-line summary
   - Update **Last Updated** date

3. **Check branch and commit** — follow **Git Rules** in CLAUDE.md (never commit to `main`, include `#NNN` in message). Use this commit format:

```
[Plan Title]: [one-line summary] #NNN

Prior state: [where the project was before this plan]
Motivation: [why this plan was needed]

Steps completed:
1. [Step summary]
2. [Step summary]

Key files changed:
- [file]: [what changed]

See Plans/YYYY-MM-DD-description.md for detailed walkthrough.
```

4. Update plan log front matter with commit hash

5. Update `PROGRESS.md` plan history entry with commit hash
