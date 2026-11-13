# Dotfiles

Personal macOS setup managed with [chezmoi](https://www.chezmoi.io/).

## Stack

- **Terminal & shell**: Ghostty (GeistMono Nerd Font), Zsh, and runtimes (`fnm`, `bun`, `pnpm` via corepack).
- **Git & editors**: Delta diff pager, Vim (`.vimrc`), and Zed.
- **AI agents**: Shared skills and configurations in `~/.agents/` symlinked for Claude Code and Codex.

## Install on a fresh Mac

```bash
# Install Homebrew and chezmoi
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# Apply dotfiles and run bootstrap
chezmoi init --apply alfredmouelle
```

The bootstrap script installs packages from `Brewfile`, sets up Node with `fnm`, installs Bun, links agent configs, and sets up `~/Developer`.

Codex rewrites `~/.codex/config.toml`, so it stays untracked. Set this line in it by hand so the `prompt` rules in `~/.codex/rules/guard.rules` ask before running:

```toml
approval_policy = { granular = { sandbox_approval = false, rules = true, skill_approval = false, request_permissions = false, mcp_elicitations = false } }
```

## Daily commands

### Dotfiles

| Command | Action |
| :--- | :--- |
| `dota <path>` | Track or update file in chezmoi |
| `dotd` | View diff against repository |
| `dot update` | Pull remote changes and reload shell |
| `dotp "message"` | Stage, commit, and push |
