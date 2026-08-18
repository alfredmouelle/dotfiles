# Dotfiles

Personal configuration and developer environment for macOS, managed declaratively with [chezmoi](https://www.chezmoi.io/).

---

## What is included

- **Shell**: Zsh (`.zshrc`) with concise aliases (`g`, `p`, `cc`, `ag`, `tk`, `tks`) and runtimes (`fnm`, `bun`, `pnpm`).
- **Multiplexer & Workspaces**: Tmux (`.tmux.conf`) with Catppuccin theme, auto-bootstrapped TPM plugins (`resurrect`, `continuum`), and universal workspace launcher (`~/.local/bin/dev`).
- **Terminal & Font**: Ghostty configuration (`~/.config/ghostty/config`) and `GeistMono Nerd Font Mono`.
- **Git**: Global `.gitconfig` and `git-delta`.
- **Editors**:
  - **Vim**: Minimal `.vimrc` with Catppuccin Mocha theme and `vim-plug`.
  - **Zed**: Custom `settings.json` and `keymap.json`.
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
*Automatically deploys configs, installs Homebrew packages (`Brewfile`), configures Node.js via `fnm`, installs `bun`, Claude Code, Antigravity CLI, creates `~/Developer` directories, installs Vim plugins, and auto-bootstraps Tmux TPM plugins on first launch.*

---

## Daily Workflow

### Dotfiles Management

| Action | Command | Description |
| :--- | :--- | :--- |
| **Track / Update file** | `dota ~/.filename` | Track or update file in chezmoi |
| **Preview diff** | `dotd` | View diff against repository |
| **Update from remote** | `dot update` | Pull remote changes and reload shell |
| **Commit & push** | `dotp "message"` | Stage all changes, commit, and push |

### Workspace & Tmux

| Action | Command / Shortcut | Description |
| :--- | :--- | :--- |
| **Open workspace** | `dev <project>` | Launch or attach 2-window session (`Agents` + `Server & Commands`) |
| **Switch windows** | `Option + Tab` | Instant toggle between the 2 active windows |
| **Switch panes** | `Ctrl + h / j / k / l` | Navigate left, down, up, right |
| **Quick action menu** | `Ctrl-a Space` | Visual popup menu for splits, tabs, and sessions |
| **Kill session** | `tk <project>` | Kill specific project session |
| **Kill server** | `tks` | Kill entire tmux server |
