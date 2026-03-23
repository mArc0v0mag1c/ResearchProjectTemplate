---
name: method-tracker
description: Track methods and techniques learned from projects and readings. Scans Notes for method discussions, maintains structured inventory in ResearchHub. Trigger on "track method", "add method", "what methods do I know", "methods I know", "method inventory", "update methods", "learned methods", "method list".
---

# Method Tracker

Scans your Notes for discussions of methods, techniques, and approaches. Builds and maintains a structured inventory at `~/vscodeproject/ResearchHub/method-tracker/methods.md`.

Designed to match your scholarly note-taking style — extracts methods from comparative tables, theoretical grounding, logic chains, and code implementations.

---

## Configuration

- **Methods inventory**: `~/vscodeproject/ResearchHub/method-tracker/methods.md`
- **Scan locations**: `Notes/*.md`, `Notes/**/*.md`, `Code/` (for applied methods)

---

## When to Run

- User says "track method", "add method", "update methods", "what methods do I know", "method inventory"
- After completing a reading session — suggest: "Want me to check for new methods to track?"
- After a significant analysis in a research project
- User says "run method-tracker"

---

## What to Look For

The skill searches Notes and Code for method-related content using these patterns:

1. **Explicit method names**: regression techniques (OLS, IV, GMM, DiD, RDD, synthetic control), estimators, algorithms, statistical tests
2. **Comparative tables**: tables contrasting multiple frameworks, approaches, or models (the user frequently uses these)
3. **Logic chains**: numbered steps describing how a technique works or why it produces certain results
4. **Theoretical grounding**: references to established frameworks ("following [Author]'s framework...", "Montague's algebraic framework", etc.)
5. **Testable predictions / Limitations**: sections discussing what a method can and cannot do — indicate understood methodology
6. **Code implementations**: Python/R code blocks showing usage of specific packages or techniques (e.g., `statsmodels`, `linearmodels`, `sklearn`)
7. **Formulas and equations**: mathematical descriptions of estimators or models

---

## Workflow

### Step 1: Read current inventory
Read `~/vscodeproject/ResearchHub/method-tracker/methods.md` to know what's already tracked.

### Step 2: Scan Notes
Use Grep and Read to search `Notes/*.md` and `Notes/**/*.md` for method-related content (using the patterns above). For each match, read the surrounding context to understand:
- What method is being discussed?
- Where did the user learn it? (check for paper citations, project references)
- How deeply do they understand it? (just reading about it, or applying it?)

### Step 3: Scan Code (research projects only)
Scan `Code/` directories for:
- Import statements revealing libraries and techniques used
- Applied statistical methods, models, or algorithms
- This helps determine proficiency — if they wrote code using a method, they've "Applied" it

### Step 4: Cross-reference
Compare found methods against the existing inventory:
- Skip methods already tracked (unless they have new usage to report)
- For existing methods used in a new project: update "Used in" field
- For existing methods with new evidence of deeper understanding: consider upgrading proficiency

### Step 5: Present to user
Show the user what you found. For each new method:

```markdown
**Found: [Method Name]**
- Source: [where you found it — file path and context]
- Suggested entry:
  - What: [description]
  - Source: [paper/project]
  - Proficiency: [Learning / Applied once / Comfortable / Fluent]
  - Category: [field]
```

**Always confirm with the user before appending.** Never silently modify methods.md.

### Step 6: Update inventory
After user confirmation, append new entries to `~/vscodeproject/ResearchHub/method-tracker/methods.md` following the established format:

```markdown
### [Method Name]
- **What**: [1-2 sentence description]
- **Source**: [Where learned — project name, paper citation, or course]
- **Key reference**: [Paper/textbook with page numbers if applicable]
- **When added**: [Date]
- **Proficiency**: [Learning / Applied once / Comfortable / Fluent]
- **Used in**: [List of projects where applied]
- **Notes**: [Key insight, gotcha, or connection to other methods]
```

Place the entry under the appropriate category heading. If no matching category exists, create a new one.

### Step 7: Report upgrades
If a method was already tracked but evidence shows increased proficiency or new usage:
- Show the user the current entry and the new evidence
- Suggest the update (e.g., "Upgrade from 'Learning' to 'Applied once'?")
- Update after confirmation

---

## Proficiency Levels

- **Learning**: Read about it, understand the concept, haven't applied it yet
- **Applied once**: Used it in one project or exercise
- **Comfortable**: Used it across multiple projects, can implement without reference
- **Fluent**: Deep understanding, can teach it, know edge cases and limitations

---

## Integration with Research-Junshi

Research-junshi reads `methods.md` to generate better ideas:
- When it finds a paper using a method you know → highlights the connection
- When it finds a method you don't know → suggests adding it to learning goals
- Leverages your method strengths for cross-pollination ideas

---

## Tone

Be precise and factual when identifying methods. Match the user's scholarly style — reference specific papers, page numbers, and project names. Don't inflate proficiency levels — be honest about the difference between reading about a method and actually implementing it.
