# Fork Workflow: Setting Up Research Template on an Existing Repository

Use this when you want to fork an existing GitHub repo and add the research template structure around it for your own analysis.

## Quick Start

```bash
# 1. Fork on GitHub (click "Fork" button on the repo page)

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/repo-name.git

# 3. Overlay the template
/path/to/ResearchProjectTemplate/create_project.sh --fork ./repo-name

# 4. Fill in API keys
nano repo-name-Share/Notes/.env

# 5. Commit the overlay
cd repo-name && git add . && git commit -m "Add research workspace"
```

## What Gets Created

```
repo-name-Share/                     (new, for Dropbox)
├── Notes/.env                       API keys template
├── Data/                            Raw datasets
└── Output/                          Intermediate results

repo-name/                           (your forked repo, original files untouched)
├── (original repo files)
├── .claude/                         Claude agents & skills (at repo root)
│   ├── agents/                      code-reviewer, report-checker, results-summarizer
│   ├── skills/                      pdf, mistral-pdf-to-markdown, work-summary, progress-tracker, zotero-paper-reader
│   └── settings.local.json
├── .gitignore                       Appended with template rules
└── _myworkspace/                    Your research workspace
    ├── CLAUDE.md                    AI instructions
    ├── AGENTS.md → CLAUDE.md
    ├── PROGRESS.md                  Progress tracker
    ├── Plans/                       Plan logs
    ├── Code/                        Your analysis scripts
    ├── Figures/                     Final figures (git-tracked)
    ├── Tables/                      Final tables (git-tracked)
    ├── Paper/                       LaTeX papers
    ├── Slides/                      LaTeX presentations
    ├── pyproject.toml               Python dependencies
    ├── setup_mac.sh                 Environment setup
    ├── .mcp.json                    MCP server config
    ├── Notes → repo-name-Share/Notes
    ├── Data → repo-name-Share/Data
    └── Output → repo-name-Share/Output
```

## Options

```bash
# Custom workspace name (default: _myworkspace)
./create_project.sh --fork ./repo-name --workspace _research
```

## How It Differs from Fresh Projects

| Aspect | Fresh (`./create_project.sh MyProject`) | Fork (`./create_project.sh --fork ./repo`) |
|--------|----------------------------------------|-------------------------------------------|
| Starting point | Creates new directory | Uses existing cloned repo |
| Git | Initializes new repo | Uses existing `.git/` |
| Template files | At project root | Inside `_myworkspace/` subfolder |
| Original code | N/A | Untouched at repo root |
| .gitignore | Created from template | Appended to existing |
| README.md | Created from template | Kept as-is |

## Syncing with Upstream

To pull updates from the original repo:

```bash
# Add upstream remote (one-time)
git remote add upstream https://github.com/ORIGINAL_OWNER/repo-name.git

# Fetch and merge upstream changes
git fetch upstream
git merge upstream/main
```

Your `_myworkspace/` files won't conflict with upstream changes since they're in a separate directory.

## Collaborator Setup

1. Share `repo-name-Share/` via Dropbox
2. Push repo to GitHub
3. Collaborators clone and run:
   ```bash
   cd repo-name/_myworkspace
   ./setup_mac.sh
   ```
