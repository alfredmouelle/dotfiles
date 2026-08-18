# Dotfiles

Personal configuration and developer environment for macOS, managed declaratively with [chezmoi](https://www.chezmoi.io/).

---

## What is included

- **Shell**: Zsh configuration (`.zshrc`) with optimized aliases (`dot`, `g`, `p`, etc.) and tools (`fnm`, `bun`, `pnpm`).
- **Git**: Global `.gitconfig` settings.
- **Editors**:
  - **Vim**: Minimal `.vimrc` with Nord theme and `vim-plug`.
  - **Zed**: Custom `settings.json` and `keymap.json`.
- **Terminal & Font**: Ghostty configuration (`~/.config/ghostty/config`) and `GeistMono Nerd Font Mono`.
- **AI & Agents**: Antigravity / Claude Code skills, subagents, and guidelines (`~/.agents/`).

---

## Quick Start (New Machine)

### 1. Install Homebrew & Chezmoi
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
```

### 2. Apply Dotfiles (Automatic Bootstrap)
```bash
chezmoi init --apply alfredmouelle
```
*This automatically deploys configs, installs Homebrew packages (`Brewfile`), configures Node.js 24.19.0 via `fnm`, installs `bun`, Claude Code, Antigravity CLI (`agy`), creates standard `~/Developer` directories, and installs Vim plugins.*

---

## Daily Workflow

Shorthand aliases included in `.zshrc`:

| Action | Command | Description |
| :--- | :--- | :--- |
| **Track a new file** | `dota ~/.filename` | Track and import file into chezmoi |
| **Edit a tracked file** | `dote ~/.filename` | Edit directly and apply on save |
| **Preview diff** | `dotd` | View diff between home and dotfiles repo |
| **Apply changes** | `dot` / `dot apply` | Apply repository state to machine |
| **Check status** | `dots` | Show modified / untracked status |
| **List tracked files** | `dotl` | List all tracked files (`managed`) |
| **Update from remote** | `dotu` | Pull remote changes and apply |
| **Open repo directory** | `dotc` | Spawn subshell inside the dotfiles repo |
| **Quick commit & push** | `dotp "message"` | Stage all changes, commit, and push |

