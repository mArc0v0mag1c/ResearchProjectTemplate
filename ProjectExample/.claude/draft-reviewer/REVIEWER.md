# Draft Reviewer — Multi-Agent Paper Review

Orchestrate specialized reviewers for academic paper drafts. Supports three thoroughness levels.

## When to Use

Activate **only for working papers** in `WorkingPaper/`:
- User says "review my draft", "check my paper", "review this section"
- User is iterating on a `.tex` or `draft.md` file inside `WorkingPaper/`

**Do NOT use for:**
- Working journal entries in `Notes/WorkingJournal/` (use report-checker agent instead)
- Reports in `Reports/` (use report-checker agent instead)
- Any other notes or documentation

## Thoroughness Levels

### Quick (1 agent, ~2 min)
Single-pass review using the writing-clarity reviewer only.
```
"Give my draft a quick review"
```

### Standard (3 agents, sequential, ~5 min)
Key reviewers in sequence: mathematical → writing-clarity → consistency-checker.
```
"Review my draft" (default)
```

### Deep (all 7 agents, parallel, ~10 min)
All reviewers run in parallel with diverse perspectives. Use for near-final drafts.
```
"Do a deep review of my paper"
```

## Reviewers

Each reviewer lives in `reviewers/` and can be invoked as a subagent:

| Reviewer | Focus | File |
|---|---|---|
| mathematical | Proofs, derivations, notation consistency | `reviewers/mathematical.md` |
| writing-clarity | Prose quality, flow, jargon, readability | `reviewers/writing-clarity.md` |
| proofreader | Typos, grammar, formatting, LaTeX errors | `reviewers/proofreader.md` |
| consistency-checker | Cross-section consistency, notation, terminology | `reviewers/consistency-checker.md` |
| citation-checker | Citation completeness, format, bibliography | `reviewers/citation-checker.md` |
| argument-logic | Logical flow, claim support, gap detection | `reviewers/argument-logic.md` |
| code-paper-consistency | Code/output matches paper claims and tables | `reviewers/code-paper-consistency.md` |

## Orchestration Workflow

1. **Ask user** for thoroughness level (default: standard)
2. **Read the draft** — determine if it's a `.tex` file, `draft.md`, or section
3. **Launch reviewers** according to level
4. **Aggregate findings** by severity:
   - **Critical**: Incorrect math, unsupported claims, factual errors
   - **Major**: Logic gaps, unclear writing, missing citations
   - **Minor**: Typos, formatting, style suggestions
5. **Present summary** with actionable fixes
6. **Optionally generate fix tasks** via TodoWrite

## Output Format

```markdown
## Draft Review Summary

**Document:** [path]
**Level:** [quick/standard/deep]
**Reviewers:** [list]

### Critical Issues ([count])
- [Reviewer]: [Issue with location]

### Major Issues ([count])
- [Reviewer]: [Issue with location]

### Minor Issues ([count])
- [Reviewer]: [Issue with location]

### Strengths
- [Notable positives]

### Recommendation
[READY / REVISE / MAJOR REVISION]
```
