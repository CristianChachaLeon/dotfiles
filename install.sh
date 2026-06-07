#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🏠 Dotfiles installer${NC}"
echo -e "   Source: ${DOTFILES_DIR}"
echo ""

# ─── Functions ─────────────────────────────────────────────

backup_and_link() {
  local src="$DOTFILES_DIR/$1"
  local dst="$HOME/$1"

  if [ ! -e "$src" ]; then
    echo -e "${YELLOW}⚠  does not exist: $1${NC}"
    return
  fi

  # Backup if something already exists
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$1")"
    mv "$dst" "$BACKUP_DIR/$1"
    echo -e "${YELLOW}Backup: $1${NC}"
  fi

  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$dst")"

  # Create symlink
  ln -sf "$src" "$dst"
  echo -e "${GREEN}Link: $1${NC}"
}

# ─── Configs to install ───────────────────────────────────

echo -e "${BLUE}── Linking configs ──${NC}"
# backup_and_link ".tmux.conf"   # replaced by zellij
backup_and_link ".config/nvim"
backup_and_link ".config/ghostty"
backup_and_link ".config/fish"
backup_and_link ".config/zellij"

# ─── Result ────────────────────────────────────────────

echo ""
echo -e "${GREEN}Done!${NC}"

if [ -d "$BACKUP_DIR" ]; then
  echo -e "${YELLOW}Backups at: $BACKUP_DIR${NC}"
fi

echo ""
echo "Next steps:"
echo "  1. Install dependencies (see packages.sh)"
echo "  2. Run nvim → LazyVim auto-installs"
echo "  3. In fish: source ~/.config/fish/config.fish"
