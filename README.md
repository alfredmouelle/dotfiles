# Dotfiles

Personal macOS setup managed with [chezmoi](https://www.chezmoi.io/).

## Stack

- **Terminal & shell**: Ghostty (GeistMono Nerd Font), Zsh, and runtimes (`fnm`, `bun`, `pnpm`).
- **Multiplexer**: Tmux with Catppuccin theme, TPM plugins, and a `dev` workspace launcher.
- **Git & editors**: Delta diff pager, Vim (`.vimrc`), and Zed.
- **AI agents**: Shared skills and configurations in `~/.agents/` symlinked for Claude Code and Antigravity.

## Install on a fresh Mac

```bash
# Install Homebrew and chezmoi
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# Apply dotfiles and run bootstrap
chezmoi init --apply alfredmouelle
```

The bootstrap script installs packages from `Brewfile`, sets up Node with `fnm`, installs Bun, links agent configs, and sets up `~/Developer`.

## Daily commands

### Dotfiles

| Command | Action |
| :--- | :--- |
| `dota <path>` | Track or update file in chezmoi |
| `dotd` | View diff against repository |
| `dot update` | Pull remote changes and reload shell |
| `dotp "message"` | Stage, commit, and push |

### Tmux & workspaces

| Shortcut / Command | Action |
| :--- | :--- |
| `dev <project>` | Open or attach project session |
| `Option + 1...9` | Jump directly to window 1 to 9 |
| `Option + Tab` | Toggle last active window |
| `Ctrl + h / j / k / l` | Focus pane (left, down, up, right) |
| `Ctrl-a Space` | Action menu for splits, tabs, and sessions |
| `tk <project>` | Kill project session |
| `tks` | Kill entire tmux server |
