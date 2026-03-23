# Global Research Workspace

## Who I Am

<!-- Edit this section to describe your research identity -->
Researcher working across multiple projects. ResearchHub bridges them all.

## ResearchHub

Location: `~/vscodeproject/ResearchHub/`
- `profile.md`, `interests.md` — user-curated, **never modify without confirmation**
- `method-tracker/methods.md` — structured methods inventory (append-only for new entries)
- `research-junshi/digests/` — historical digest archive (append-only)
- `Brainstorm/cross-project/` — cross-project connection digests
- `lessons.md` — cross-project lessons learned (append-only)

## Writing Standards

All written outputs (working journal entries, reports, summaries) must follow these rules.

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
Every factual claim must link to supporting evidence: `[descriptive text](../../path/to/file)`.

## Python Environment

- Uses `uv` for dependency management
- Run commands with `uv run <command>`
- Add dependencies with `uv add package`
- Whenever calling Python-related programs, use `uv` unless it is infeasible.

## Workflow Orchestration

### Plan First
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Write detailed specs upfront to reduce ambiguity

### Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- One task per subagent for focused execution

### Self-Improvement Loop
- When the user corrects your approach, ask: "Should I add this to lessons.md?"
- Don't silently update — confirm with the user first
- For project-specific lessons: save to `.claude/instructions/lessons.md`
- For cross-project lessons: save to `~/vscodeproject/ResearchHub/lessons.md`

### Proactive Saving
- When generating long-form output, save to a markdown file rather than only printing to chat

### Verification Before Done
- Never mark a task complete without proving it works
- Run the code, check outputs, diff behavior when relevant

## Mistral PDF-to-Markdown

1. **Always run from repo root** (where `.env` lives)
2. **Use system `python3`**, not `uv run` — those create isolated envs that may not find `mistralai`
3. **Each paper gets its own subfolder** under `Literature/Extracted/` (or `Extracted/` for reading projects) to avoid image filename collisions

```bash
python3 .claude/skills/mistral-pdf-to-markdown/scripts/convert_pdf_to_markdown.py \
  "Literature/Author_Year.pdf" \
  "Literature/Extracted/Author_Year/Author_Year.md"
```
