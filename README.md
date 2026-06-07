# Dotfiles

My configs for: Neovim (LazyVim), Tmux, Fish, Ghostty.

## Quick install
```bash
git clone https://github.com/CristianChachaLeon/dotfiles.git ~/dotfiles
cd dotfiles

# 1. Install dependencies
chmod +x packages.sh install.sh
./packages.sh

# 2. Link configs (backs up existing ones)
./install.sh
```

## Contents

| Config         | Includes                          |
|---------------|-----------------------------------|
| `.config/nvim`   | LazyVim + custom plugins       |
| `.config/fish`   | Fish shell + aliases           |
| `.config/ghostty`| Ghostty terminal               |
| `.tmux.conf`     | Tmux config                    |

## Post-install

1. Open `nvim` -> LazyVim auto-installs
2. In fish: PATHs are loaded automatically

## Backups

The `install.sh` script automatically backs up your existing configs to:
```
~/.dotfiles-backup-YYYYMMDD-HHMMSS/
```
