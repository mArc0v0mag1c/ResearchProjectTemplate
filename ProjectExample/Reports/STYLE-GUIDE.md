# Report Style Guide

## LaTeX Setup

- Each report lives in `Reports/<report-name>/main.tex`
- Use `\usepackage{marcoreport}` (shared style at `~/Library/TinyTeX/texmf-local/tex/latex/marco/`)
- Build: `latexmk -pdf main.tex` from within the report subfolder

## Structure & Workflow

1. **You provide the structure**: The exact outline, section headings, and content flow. Claude follows it precisely.
2. **You provide the raw material**: Lecture slides, problem set solutions, annotations, and key insights. Claude synthesizes and formats — not invents.
3. **Iterative refinement**: Work section by section. You signal when to move on.
4. **No over-generation**: Claude does not add extra sections, unnecessary remarks, or tangential content. If Claude thinks something should be added, it asks first with reasoning.

## Content Structure

Each section follows this framework:

| Step | Purpose | Example |
|------|---------|---------|
| **Where we at** | Context, current state, what we have so far | "We have the value function defined as an infinite sum..." |
| **Why we get motivated** | Motivation for the next step, what's missing or limiting | "But this solves only for a specific $a_0$. What if we want a rule for any wealth level?" |
| **What we do** | The derivation, method, or procedure | "Separate the first term, re-index, recognize the recursive structure..." |
| **Results and next steps** | Key takeaways, connections, where this leads | "This gives us the Bellman equation. Next: solve it via FOC + envelope theorem." |

## Content Principles

- **Mathematical rigor**: Retain "minor but crucial" steps; don't skip algebra
- **Economic intuition**: Every equation gets an interpretation
- **Connect to prior material**: Use remarkboxes to link new concepts to earlier models

## Notation Conventions

- **Consistency**: Pick one notation and stick with it
- **Time-subscripts preferred**: $a_t, a_{t+1}, c_t^*$ for clarity in dynamic problems
- **Starred variables** for optima: $c_t^*$, not just $c_t$

## Formatting Preferences

- **`itemize`** for unordered lists / cases
- **`enumerate`** for sequential steps / numbered conditions
- **Nested lists** to consolidate related points
- **Boxes**: Only use `remarkbox` for now (key insights, intuition, connections). Other box types (warningbox, definitionbox, examplebox) are available in `marcoreport.sty` but should not be used unless explicitly requested.

## What NOT to Do

- Don't invent content beyond what was provided
- Don't add unnecessary caveats or hedging
- Don't create separate boxes when items can be nested
- Don't switch notation mid-section
- Don't generate the next section until explicitly told

## Workflow

```
1. User specifies section/topic
2. User provides: structure + raw content + annotations
3. Claude drafts LaTeX following the content structure:
   → Where we at → Why motivated → What we do → Results/next steps
4. User reviews → requests revisions
5. User says "move on" → next section
```
