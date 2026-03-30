# Report Style Guide

## LaTeX Setup

- Each report lives in `Reports/YYYY-MM-DD-<report-name>/main.tex` (date-prefixed folder name)
- Use `\usepackage{marcoreport}` (shared style at `~/Library/TinyTeX/texmf-local/tex/latex/marco/`)
- Build: `latexmk -pdf main.tex` from within the report subfolder

### Title Page

Every report must include author and date:
```latex
\title{Report Title}
\author{Marco Zhang}
\date{Month DD, YYYY}
```

### References

Use `biblatex` with numeric citation style and `biber` backend:
```latex
\usepackage[backend=biber,style=numeric,sorting=nyt]{biblatex}
\addbibresource{references.bib}
```

- Citations render as numbered brackets: `[1]`, `[2,3]`
- Use `\autocite{key}` for parenthetical `[1]` and `\textcite{key}` for narrative "Author [1]"
- Place `\printbibliography` before `\end{document}`
- Each report has its own `references.bib` in the report folder
- Biber binary is at `~/Library/TinyTeX/bin/universal-darwin/biber` — ensure it's on PATH when compiling

### TinyTeX Package Installation

TinyTeX ships with a minimal set of packages. `marcoreport.sty` requires these additional packages:

```bash
# If TinyTeX is outdated vs the remote repo, point to the matching historic archive:
# tlmgr option repository https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2024/tlnet-final
# tlmgr update --self

# Core packages for marcoreport.sty
tlmgr install setspace titlesec fancyhdr mathtools pgf tcolorbox \
  environ fp trimspaces tikzfill pdfcol \
  listings listingsutf8 minted fvextra upquote lineno csquotes \
  varwidth needspace adjustbox collectbox colortbl oberdiek
```

After installing `marcoreport.sty` to `~/Library/TinyTeX/texmf-local/tex/latex/marco/`, run:

```bash
texhash ~/Library/TinyTeX/texmf-local
```

Verify with:

```bash
kpsewhich marcoreport.sty
# Should print: ~/Library/TinyTeX/texmf-local/tex/latex/marco/marcoreport.sty
```

### Available Commands from `marcoreport.sty`

| Command | Purpose | Example |
|---------|---------|---------|
| `\vct{x}` | Bold vector | $\boldsymbol{x}$ |
| `\mat{A}` | Bold matrix | $\mathbf{A}$ |
| `\RR` | Real numbers | $\mathbb{R}$ |
| `\EE` | Expectation | $\mathbb{E}$ |
| `\var` | Variance | $\text{Var}$ |
| `\argmin` | Argmin operator | $\mathrm{argmin}$ |
| `\argmax` | Argmax operator | $\mathrm{argmax}$ |

| Environment | Purpose |
|-------------|---------|
| `theorem`, `lemma` | Numbered theorems (plain style) |
| `definition` | Numbered definitions |
| `remark` | Unnumbered remarks |
| `remarkbox[Title]` | Blue highlighted box for key insights |
| `mynote` (tcolorbox) | Gray note box via `\begin{tcolorbox}[mynote, title=...]` |

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
- **Inside remarkbox**: Add `\setlength{\parindent}{1.5em}` after `\begin{remarkbox}[...]`. Use `\medskip` between paragraphs and `\indent` at the start of each paragraph after the first.

## What NOT to Do

- Don't invent content beyond what was provided
- Don't add unnecessary caveats or hedging
- Don't create separate boxes when items can be nested
- Don't switch notation mid-section
- Don't generate the next section until explicitly told

## Workflow

### Report-level workflow

```
1. Write a short OVERVIEW first (structure, key findings, section outline)
2. User reviews overview → requests revisions
3. Write full content to Reports/<name>/draft.md (plain text + markdown tables)
4. Iterate on draft.md until user says "all good" / "proceed to tex"
5. Convert draft.md → main.tex (single pass, full report)
6. User reviews PDF → iterative fixes directly on main.tex
7. Compile, commit when done
```

**Important**: Claude must NOT generate LaTeX code until the user explicitly approves the draft. The draft-first step ensures content is correct before formatting.

### Section-level workflow (within a draft)

```
1. User specifies section/topic
2. User provides: structure + raw content + annotations
3. Claude replies with a PLAIN TEXT DRAFT (not LaTeX) — outlining the content,
   flow, and key equations in readable form
4. User reviews the draft → requests revisions
5. User approves: "yes, do latex" → Claude writes the .tex code
6. User inspects live in VS Code (LaTeX Workshop auto-rebuilds on save)
7. User says "move on" → next section
```

**Important**: Claude must NOT generate LaTeX code until the user explicitly approves the draft. The draft-first step ensures content is correct before formatting.

## Live Preview Setup

Install the **LaTeX Workshop** extension in VS Code for auto-build and live PDF preview:

```bash
code --install-extension James-Yu.latex-workshop
```

Once installed, open any `.tex` file and press `Cmd+Shift+P` → "LaTeX Workshop: View LaTeX PDF". The PDF panel auto-refreshes on every save — no manual `latexmk` needed.

This replaces the build-inspect-rebuild cycle: just edit the `.tex`, save, and the preview updates instantly.
