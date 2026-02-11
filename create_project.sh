#!/bin/bash

# Project template generator for academic research projects
# Creates a new project or overlays template onto an existing forked repo
#
# Usage:
#   ./create_project.sh <project-name-or-path>                        # Fresh project
#   ./create_project.sh --fork <path-to-repo>                         # Overlay onto existing repo
#   ./create_project.sh --fork <path-to-repo> --workspace _research   # Custom workspace name
#   ./create_project.sh --drive <cloud-path> <project-name>          # -Share in cloud storage
#   ./create_project.sh --fork <path-to-repo> --drive <cloud-path>   # Fork + cloud storage

set -e  # Exit on any error

# Get the directory where create_project.sh is located (before changing directories)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ============================================================
# Argument parsing
# ============================================================
MODE="fresh"
WORKSPACE_NAME="_myworkspace"
DRIVE_PATH=""
POSITIONAL_ARG=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --fork)
            MODE="fork"
            shift
            ;;
        --workspace)
            WORKSPACE_NAME="$2"
            shift 2
            ;;
        --drive)
            DRIVE_PATH="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage:"
            echo "  $0 <project-name-or-path>                        # Fresh project"
            echo "  $0 --fork <path-to-repo>                         # Overlay onto existing repo"
            echo "  $0 --fork <path-to-repo> --workspace <name>      # Custom workspace name (default: _myworkspace)"
            echo "  $0 --drive <cloud-path> <project-name>             # Place -Share in cloud storage"
            echo ""
            echo "Options:"
            echo "  --fork        Overlay template onto an existing Git repository"
            echo "  --workspace   Name of workspace subfolder (fork mode only, default: _myworkspace)"
            echo "  --drive       Cloud storage path for -Share folder (e.g., Google Drive, Dropbox)"
            echo "  -h, --help    Show this help message"
            exit 0
            ;;
        *)
            POSITIONAL_ARG="$1"
            shift
            ;;
    esac
done

if [ -z "$POSITIONAL_ARG" ]; then
    echo "Error: No project path provided."
    echo "Run '$0 --help' for usage."
    exit 1
fi

# ============================================================
# Mode-specific setup
# ============================================================

if [ "$MODE" = "fork" ]; then
    # Fork mode: overlay onto existing repo
    FORK_REPO_PATH="$(cd "$POSITIONAL_ARG" 2>/dev/null && pwd)" || {
        echo "Error: Directory '$POSITIONAL_ARG' does not exist"
        exit 1
    }

    if [ ! -d "$FORK_REPO_PATH/.git" ]; then
        echo "Error: '$FORK_REPO_PATH' is not a Git repository"
        exit 1
    fi

    PROJECT_NAME="$(basename "$FORK_REPO_PATH")"
    PROJECT_SHARE_NAME="${PROJECT_NAME}-Share"
    PARENT_DIR="$(dirname "$FORK_REPO_PATH")"

    echo "Fork overlay mode"
    echo "Repository: $FORK_REPO_PATH"
    echo "Workspace:  $WORKSPACE_NAME"
    if [ -n "$DRIVE_PATH" ]; then
        echo "Share folder: $DRIVE_PATH/$PROJECT_SHARE_NAME (cloud storage)"
    else
        echo "Share folder: $PARENT_DIR/$PROJECT_SHARE_NAME"
    fi
    echo ""

else
    # Fresh mode: create new project (original behavior)
    PROJECT_PATH="$POSITIONAL_ARG"

    if [[ "$PROJECT_PATH" == */* ]]; then
        PROJECT_DIR=$(dirname "$PROJECT_PATH")
        PROJECT_NAME=$(basename "$PROJECT_PATH")
        mkdir -p "$PROJECT_DIR"
        cd "$PROJECT_DIR"
    else
        PROJECT_NAME="$PROJECT_PATH"
        PROJECT_DIR="."
    fi

    PROJECT_SHARE_NAME="${PROJECT_NAME}-Share"

    echo "Creating project template for: $PROJECT_NAME"
    echo "Location: $(pwd)"
fi

# ============================================================
# Resolve -Share parent directory
# ============================================================

if [ -n "$DRIVE_PATH" ]; then
    # Expand ~ if present
    DRIVE_PATH="${DRIVE_PATH/#\~/$HOME}"

    if [ ! -d "$DRIVE_PATH" ]; then
        echo "Error: Drive path '$DRIVE_PATH' does not exist."
        echo "Please create it first, or check that your cloud storage is mounted."
        exit 1
    fi

    SHARE_PARENT_DIR="$DRIVE_PATH"
    echo "Cloud storage: $DRIVE_PATH"
elif [ "$MODE" = "fork" ]; then
    SHARE_PARENT_DIR="$PARENT_DIR"
else
    SHARE_PARENT_DIR="$(pwd)"
fi

SHARE_ABS_PATH="$(cd "$SHARE_PARENT_DIR" && pwd)/$PROJECT_SHARE_NAME"

# ============================================================
# Step 1: Create shared folders (-Share/)
# ============================================================

cd "$SHARE_PARENT_DIR"

mkdir -p "$PROJECT_SHARE_NAME"
cd "$PROJECT_SHARE_NAME"

echo "Creating shared directories..."
mkdir -p Notes Data Output

# Copy .env to Notes/
if [ -f "$SCRIPT_DIR/ProjectExample/Notes/.env" ]; then
    if [ ! -f Notes/.env ]; then
        cp "$SCRIPT_DIR/ProjectExample/Notes/.env" Notes/.env
        sed -i '' "s/ProjectExample/$PROJECT_NAME/g" Notes/.env
        echo "Copied .env template to Notes/"
    else
        echo ".env already exists in Notes/, skipping"
    fi
else
    echo "Warning: ProjectExample/Notes/.env not found"
fi

echo "Created shared folder structure in $PROJECT_SHARE_NAME"

# ============================================================
# Step 2: Create workspace directories
# ============================================================

if [ "$MODE" = "fork" ]; then
    cd "$FORK_REPO_PATH"
    WORK_DIR="$WORKSPACE_NAME"
    mkdir -p "$WORK_DIR"
    cd "$WORK_DIR"
    echo "Creating workspace in $WORKSPACE_NAME/..."
    if [ -n "$DRIVE_PATH" ]; then
        SHARE_RELATIVE="$SHARE_ABS_PATH"
    else
        SHARE_RELATIVE="../../$PROJECT_SHARE_NAME"
    fi
else
    cd ..
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    WORK_DIR="."
    echo "Creating code project directories..."
    if [ -n "$DRIVE_PATH" ]; then
        SHARE_RELATIVE="$SHARE_ABS_PATH"
    else
        SHARE_RELATIVE="../$PROJECT_SHARE_NAME"
    fi
fi

mkdir -p Code Figures Tables Paper Slides Plans

# ============================================================
# Step 3: Progress tracking scaffold
# ============================================================

echo "Creating progress tracking files..."
if [ ! -f PROGRESS.md ]; then
    cat > PROGRESS.md << PROGRESS_EOF
# Project Progress

## Current Status
**Phase**: Setup | **Active Plan**: None | **Last Updated**: $(date +%Y-%m-%d)

## Plan History

_No plans yet. Start your first plan by telling Claude what you want to work on._
PROGRESS_EOF
    echo "Created PROGRESS.md"
fi

if [ ! -f Plans/.gitkeep ]; then
    touch Plans/.gitkeep
fi

# ============================================================
# Step 4: pyproject.toml
# ============================================================

echo "Creating Python environment..."
if [ -f "$SCRIPT_DIR/ProjectExample/pyproject.toml" ]; then
    cp "$SCRIPT_DIR/ProjectExample/pyproject.toml" pyproject.toml
    sed -i '' "s/projectexample/$(echo $PROJECT_NAME | tr '[:upper:]' '[:lower:]' | tr ' ' '-')/g" pyproject.toml
    sed -i '' "s/ProjectExample/$PROJECT_NAME/g" pyproject.toml
else
    echo "Warning: ProjectExample/pyproject.toml not found, creating basic pyproject.toml"
    cat > pyproject.toml << EOF
[project]
name = "$(echo $PROJECT_NAME | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
version = "0.1.0"
description = "Academic research project: $PROJECT_NAME"
readme = "README.md"
requires-python = ">=3.9"
dependencies = []
EOF
fi

# ============================================================
# Step 5: setup_mac.sh
# ============================================================

echo "Creating setup script..."
if [ -f "$SCRIPT_DIR/ProjectExample/setup_mac.sh" ]; then
    cp "$SCRIPT_DIR/ProjectExample/setup_mac.sh" setup_mac.sh
    sed -i '' "s/ProjectExample/$PROJECT_NAME/g" setup_mac.sh
    # Adjust paths for fork mode
    if [ "$MODE" = "fork" ]; then
        sed -i '' "s|\"../${PROJECT_NAME}-Share\"|\"../../${PROJECT_SHARE_NAME}\"|g" setup_mac.sh
        sed -i '' "s|SOURCE_DIR=\"../${PROJECT_NAME}-Share\"|SOURCE_DIR=\"../../${PROJECT_SHARE_NAME}\"|g" setup_mac.sh
        # Fix .venv symlink to use repo name, not workspace name
        sed -i '' 's|ln -s "$HOME/.venvs/$(basename "$PWD")"|ln -s "$HOME/.venvs/'"$PROJECT_NAME"'"|g' setup_mac.sh
        sed -i '' 's|echo "Created .venv -> $HOME/.venvs/$(basename "$PWD") symlink"|echo "Created .venv -> $HOME/.venvs/'"$PROJECT_NAME"' symlink"|g' setup_mac.sh
        # Remove git init block (repo already has .git/)
        sed -i '' '/# Initialize git repository/,/echo "Setup complete!"/{ /# Initialize git/,/^fi$/d; }' setup_mac.sh
    fi
    # Override SOURCE_DIR with absolute cloud storage path if --drive was used
    if [ -n "$DRIVE_PATH" ]; then
        sed -i '' "s|SOURCE_DIR=.*|SOURCE_DIR=\"${SHARE_ABS_PATH}\"|" setup_mac.sh
    fi
else
    echo "Warning: ProjectExample/setup_mac.sh not found, creating basic setup_mac.sh"
    cat > setup_mac.sh << 'SETUP_EOF'
#!/bin/bash
set -e
echo "Setting up PROJECT_NAME_PLACEHOLDER project..."

if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please install Homebrew first: https://brew.sh"
    exit 1
fi

if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    brew install uv
else
    echo "uv is already installed, skipping installation"
fi

export UV_PROJECT_ENVIRONMENT="$HOME/.venvs/PROJECT_NAME_PLACEHOLDER"
uv sync

echo "Setup complete!"
SETUP_EOF
    sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" setup_mac.sh
fi
chmod +x setup_mac.sh

# ============================================================
# Step 6: CLAUDE.md
# ============================================================

echo "Creating CLAUDE.md..."
if [ "$MODE" = "fork" ]; then
    CLAUDE_TEMPLATE="$SCRIPT_DIR/CLAUDE-template-fork.md"
else
    CLAUDE_TEMPLATE="$SCRIPT_DIR/CLAUDE-template.md"
fi

if [ -f "$CLAUDE_TEMPLATE" ]; then
    cp "$CLAUDE_TEMPLATE" CLAUDE.md
    sed -i '' "s/ProjectExample/$PROJECT_NAME/g" CLAUDE.md
    sed -i '' "s/ProjectExample-Share/$PROJECT_SHARE_NAME/g" CLAUDE.md
    if [ "$MODE" = "fork" ]; then
        sed -i '' "s/WORKSPACE_PLACEHOLDER/$WORKSPACE_NAME/g" CLAUDE.md
    fi
    # Replace Dropbox references with cloud storage when --drive is used
    if [ -n "$DRIVE_PATH" ]; then
        sed -i '' 's/synced via cloud storage (e.g., Dropbox, Google Drive)/synced via cloud storage (Google Drive)/g' CLAUDE.md
        sed -i '' 's/Cloud Storage Folder/Google Drive Folder/g' CLAUDE.md
    fi
else
    echo "Warning: CLAUDE template not found, skipping CLAUDE.md creation"
fi

# AGENTS.md symlink
if [ -f "CLAUDE.md" ]; then
    ln -sf CLAUDE.md AGENTS.md
    echo "Created AGENTS.md -> CLAUDE.md symlink"
fi

# ============================================================
# Step 7: .mcp.json
# ============================================================

echo "Copying .mcp.json configuration..."
if [ -f "$SCRIPT_DIR/ProjectExample/.mcp.json" ]; then
    cp "$SCRIPT_DIR/ProjectExample/.mcp.json" .mcp.json
    sed -i '' "s/ProjectExample/$PROJECT_NAME/g" .mcp.json
    sed -i '' "s/ProjectExample-Share/$PROJECT_SHARE_NAME/g" .mcp.json
    echo "Copied .mcp.json configuration"
fi

# ============================================================
# Step 8: .claude/ folder (agents, skills, settings)
# ============================================================

echo "Copying .claude configuration..."
if [ -d "$SCRIPT_DIR/ProjectExample/.claude" ]; then
    if [ "$MODE" = "fork" ]; then
        # Fork mode: .claude/ goes to repo root, merge with existing
        CLAUDE_DEST="$FORK_REPO_PATH/.claude"
        if [ -d "$CLAUDE_DEST" ]; then
            echo "Existing .claude/ found, merging..."
            # Copy agents and skills (don't overwrite existing)
            mkdir -p "$CLAUDE_DEST/agents" "$CLAUDE_DEST/skills"
            cp -rn "$SCRIPT_DIR/ProjectExample/.claude/agents/"* "$CLAUDE_DEST/agents/" 2>/dev/null || true
            cp -rn "$SCRIPT_DIR/ProjectExample/.claude/skills/"* "$CLAUDE_DEST/skills/" 2>/dev/null || true
            # Update settings.local.json if it only has minimal content
            if [ -f "$CLAUDE_DEST/settings.local.json" ]; then
                echo "Note: .claude/settings.local.json already exists. Review and merge manually if needed."
                echo "Template version is at: $SCRIPT_DIR/ProjectExample/.claude/settings.local.json"
            else
                cp "$SCRIPT_DIR/ProjectExample/.claude/settings.local.json" "$CLAUDE_DEST/settings.local.json"
            fi
        else
            cp -r "$SCRIPT_DIR/ProjectExample/.claude" "$CLAUDE_DEST"
        fi
        # Replace project names in .claude files
        find "$CLAUDE_DEST" -type f \( -name "*.md" -o -name "*.json" \) -exec sed -i '' "s/ProjectExample/$PROJECT_NAME/g" {} \;
        find "$CLAUDE_DEST" -type f \( -name "*.md" -o -name "*.json" \) -exec sed -i '' "s/ProjectExample-Share/$PROJECT_SHARE_NAME/g" {} \;
    else
        # Fresh mode: .claude/ in workspace root (same as project root)
        cp -r "$SCRIPT_DIR/ProjectExample/.claude" .claude
        find .claude -type f \( -name "*.md" -o -name "*.json" \) -exec sed -i '' "s/ProjectExample/$PROJECT_NAME/g" {} \;
        find .claude -type f \( -name "*.md" -o -name "*.json" \) -exec sed -i '' "s/ProjectExample-Share/$PROJECT_SHARE_NAME/g" {} \;
    fi
    echo "Copied .claude configuration with agents and skills"
fi

# ============================================================
# Step 9: README (fresh mode only)
# ============================================================

if [ "$MODE" = "fresh" ]; then
    echo "Creating README..."
    if [ -f "$SCRIPT_DIR/README-template.md" ]; then
        cp "$SCRIPT_DIR/README-template.md" README.md
        sed -i '' "s/ProjectExample/$PROJECT_NAME/g" README.md
        sed -i '' "s/ProjectExample-Share/$PROJECT_SHARE_NAME/g" README.md
    else
        echo "# $PROJECT_NAME" > README.md
        echo "" >> README.md
        echo "Academic research project: $PROJECT_NAME" >> README.md
    fi
else
    # Fork mode: create root-level CLAUDE.md as hierarchy guide
    echo "Creating root CLAUDE.md hierarchy guide..."
    ROOT_CLAUDE="$FORK_REPO_PATH/CLAUDE.md"
    if [ ! -f "$ROOT_CLAUDE" ]; then
        if [ -f "$SCRIPT_DIR/CLAUDE-root-fork.md" ]; then
            cp "$SCRIPT_DIR/CLAUDE-root-fork.md" "$ROOT_CLAUDE"
            sed -i '' "s/ProjectExample/$PROJECT_NAME/g" "$ROOT_CLAUDE"
            sed -i '' "s/ProjectExample-Share/$PROJECT_SHARE_NAME/g" "$ROOT_CLAUDE"
            sed -i '' "s/WORKSPACE_PLACEHOLDER/$WORKSPACE_NAME/g" "$ROOT_CLAUDE"
            echo "Created root CLAUDE.md with reading order"
        fi
    else
        echo "Root CLAUDE.md already exists, skipping"
    fi
fi

# ============================================================
# Step 10: PR template (.github/)
# ============================================================

echo "Creating PR template..."
if [ -f "$SCRIPT_DIR/ProjectExample/.github/PULL_REQUEST_TEMPLATE.md" ]; then
    if [ "$MODE" = "fork" ]; then
        GITHUB_DEST="$FORK_REPO_PATH/.github"
    else
        GITHUB_DEST=".github"
    fi
    mkdir -p "$GITHUB_DEST"
    if [ ! -f "$GITHUB_DEST/PULL_REQUEST_TEMPLATE.md" ]; then
        cp "$SCRIPT_DIR/ProjectExample/.github/PULL_REQUEST_TEMPLATE.md" "$GITHUB_DEST/PULL_REQUEST_TEMPLATE.md"
        echo "Created .github/PULL_REQUEST_TEMPLATE.md"
    else
        echo ".github/PULL_REQUEST_TEMPLATE.md already exists, skipping"
    fi
fi

# ============================================================
# Step 11: Symlinks to shared folders
# ============================================================

echo "Creating symlinks..."
if [ -d "$SHARE_RELATIVE" ]; then
    for folder in "$SHARE_RELATIVE"/*; do
        if [ -d "$folder" ]; then
            folder_name=$(basename "$folder")
            if [ -L "./$folder_name" ]; then
                echo "Symlink ./$folder_name already exists, skipping"
            else
                ln -s "$SHARE_RELATIVE/$folder_name" "./$folder_name"
                echo "Created symlink: ./$folder_name -> $SHARE_RELATIVE/$folder_name"
            fi
        fi
    done
else
    echo "Warning: Shared directory $SHARE_RELATIVE not found"
fi

# ============================================================
# Step 12: .gitignore
# ============================================================

if [ "$MODE" = "fork" ]; then
    # Fork mode: append to existing .gitignore
    GITIGNORE_PATH="$FORK_REPO_PATH/.gitignore"
    MARKER="# ===== Research template additions ====="

    if ! grep -q "$MARKER" "$GITIGNORE_PATH" 2>/dev/null; then
        echo "Appending research template rules to .gitignore..."
        cat >> "$GITIGNORE_PATH" << GITIGNORE_EOF

$MARKER

# Symlinked folders (point to ${PROJECT_SHARE_NAME}/)
${WORKSPACE_NAME}/Notes
${WORKSPACE_NAME}/Data
${WORKSPACE_NAME}/Output

# LaTeX auxiliary files
*.aux
*.bbl
*.blg
*.synctex.gz
*.fdb_latexmk
*.fls
*.nav
*.snm
*.vrb
*.bcf
*.run.xml
*-blx.bib
*.dvi
*.ps
*.out
*.toc

# OS files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
desktop.ini

# uv / project
uv.lock
*.tmp
*.bak
.python-version
sync/
GITIGNORE_EOF
        echo "Appended template rules to .gitignore"
    else
        echo ".gitignore already has template rules, skipping"
    fi
else
    # Fresh mode: copy or create .gitignore
    echo "Creating .gitignore..."
    if [ -f "$SCRIPT_DIR/ProjectExample/.gitignore" ]; then
        cp "$SCRIPT_DIR/ProjectExample/.gitignore" .gitignore
    else
        echo "Warning: ProjectExample/.gitignore not found, creating basic .gitignore"
        cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.pytest_cache/
.coverage
.ipynb_checkpoints/
*.ipynb_checkpoints

# LaTeX
*.aux
*.log
*.out
*.toc
*.bbl
*.blg
*.synctex.gz
*.fdb_latexmk
*.fls
*.nav
*.snm
*.vrb
*.bcf
*.run.xml
*-blx.bib
*.dvi
*.ps
*.pdf
!figures/*.pdf

# Environment
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/
.python-version
.Rproj.user

# IDE
.idea/
*.swp
*.swo
*~
*.sublime-*

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
desktop.ini

# Project specific
Notes
Data
Output
sync/
uv.lock
*.tmp
*.bak
EOF
    fi
fi

# ============================================================
# Step 13: Git init (fresh mode only)
# ============================================================

if [ "$MODE" = "fresh" ]; then
    echo "Initializing git repository..."
    git init
    echo "Creating test branch..."
    git checkout -b test
fi

# ============================================================
# Step 14: Create test branch (all modes)
# ============================================================

if [ "$MODE" = "fork" ]; then
    cd "$FORK_REPO_PATH"
    # Only create test branch if it doesn't already exist
    if ! git rev-parse --verify test >/dev/null 2>&1; then
        echo "Creating test branch..."
        git checkout -b test
    else
        echo "test branch already exists, switching to it..."
        git checkout test
    fi
    cd "$WORKSPACE_NAME"
fi
# Fresh mode: test branch was already created in Step 13

# ============================================================
# Step 15: Run setup
# ============================================================

echo ""
echo "Running automatic setup..."
./setup_mac.sh

# ============================================================
# Summary
# ============================================================

echo ""
if [ "$MODE" = "fork" ]; then
    echo "Fork overlay created successfully!"
    echo ""
    echo "Project structure:"
    echo "  $PROJECT_SHARE_NAME/              - Shared folders (for cloud storage)"
    echo "    ├── Notes/                      - Research notes"
    echo "    ├── Data/                       - Datasets"
    echo "    └── Output/                     - Analysis results"
    echo ""
    echo "  $PROJECT_NAME/                    - Forked repository"
    echo "    ├── (original repo files)       - Untouched"
    echo "    ├── .claude/                    - Claude agents & skills"
    echo "    ├── .gitignore                  - Updated with template rules"
    echo "    └── $WORKSPACE_NAME/"
    echo "        ├── Code/                   - Your analysis scripts"
    echo "        ├── Figures/, Tables/        - Final outputs"
    echo "        ├── Paper/, Slides/          - LaTeX documents"
    echo "        ├── Plans/                   - Plan logs"
    echo "        ├── PROGRESS.md              - Progress tracker"
    echo "        ├── CLAUDE.md                - AI instructions"
    echo "        ├── Notes/ -> -Share         - Symlink"
    echo "        ├── Data/ -> -Share          - Symlink"
    echo "        └── Output/ -> -Share        - Symlink"
    echo ""
    echo "Branch: test (auto-created — all work happens here, PR to main when ready)"
    echo ""
    echo "Next steps:"
    echo "1. Review and commit: cd $PROJECT_NAME && git add . && git commit -m 'Add research workspace'"
    echo "2. Fill in API keys: edit $PROJECT_SHARE_NAME/Notes/.env"
    if [ -n "$DRIVE_PATH" ]; then
        echo "3. Share folder is in cloud storage at: $SHARE_ABS_PATH"
    else
        echo "3. Share $PROJECT_SHARE_NAME/ via cloud storage (Dropbox, Google Drive, etc.)"
    fi
else
    echo "Project template created and set up successfully!"
    echo ""
    echo "Project structure:"
    echo "  $PROJECT_SHARE_NAME/       - Shared folders (for cloud storage)"
    echo "    ├── Notes/                 - Research notes"
    echo "    ├── Data/                  - Datasets"
    echo "    └── Output/                - Analysis results"
    echo ""
    echo "  $PROJECT_NAME/             - Code repository (for Git)"
    echo "    ├── Code/                  - Source code"
    echo "    ├── Figures/               - Final figures for papers"
    echo "    ├── Tables/                - Final tables for papers"
    echo "    ├── Paper/                 - Paper materials"
    echo "    ├── Slides/                - Presentation materials"
    echo "    ├── Plans/                 - Plan logs"
    echo "    ├── PROGRESS.md            - Progress tracker"
    echo "    ├── Notes/                 - (symlink to $PROJECT_SHARE_NAME/Notes)"
    echo "    ├── Data/                  - (symlink to $PROJECT_SHARE_NAME/Data)"
    echo "    ├── Output/                - (symlink to $PROJECT_SHARE_NAME/Output)"
    echo "    ├── pyproject.toml         - Python environment"
    echo "    ├── setup_mac.sh           - Setup script"
    echo "    └── README.md              - Setup instructions"
    echo ""
    echo "Branch: test (auto-created — all work happens here, PR to main when ready)"
    echo ""
    echo "Next steps for collaboration:"
    if [ -n "$DRIVE_PATH" ]; then
        echo "1. Share folder is in cloud storage at: $SHARE_ABS_PATH"
    else
        echo "1. Share $PROJECT_SHARE_NAME/ folder with coauthors via cloud storage (Dropbox, Google Drive, etc.)"
    fi
    echo "2. Push $PROJECT_NAME/ repository to GitHub and share with coauthors"
    echo "3. Coauthors should clone the repository and run ./setup_mac.sh to set up their environment"
    echo ""
    echo "Ready to start coding in $PROJECT_NAME/Code/ directory!"
fi
