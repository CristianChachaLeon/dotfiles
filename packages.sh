#!/bin/bash
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing dependencies...${NC}"

# ─── Detect distro ────────────────────────────────────────

if command -v apt &>/dev/null; then
  PKG_MANAGER="apt"
  INSTALL_CMD="sudo apt install -y"
elif command -v dnf &>/dev/null; then
  PKG_MANAGER="dnf"
  INSTALL_CMD="sudo dnf install -y"
elif command -v pacman &>/dev/null; then
  PKG_MANAGER="pacman"
  INSTALL_CMD="sudo pacman -S --noconfirm"
elif command -v brew &>/dev/null; then
  PKG_MANAGER="brew"
  INSTALL_CMD="brew install"
else
  echo "No package manager detected. Install manually."
  exit 1
fi

echo "Package manager: $PKG_MANAGER"

# ─── Base tools ────────────────────────────────────────────

echo -e "\n${BLUE}── Base tools ──${NC}"
for pkg in git curl wget unzip; do
  if ! command -v $pkg &>/dev/null; then
    echo "Installing $pkg..."
    $INSTALL_CMD $pkg
  else
    echo -e "${GREEN}$pkg already installed${NC}"
  fi
done

# ─── Fish shell ───────────────────────────────────────────

if ! command -v fish &>/dev/null; then
  echo -e "\n${BLUE}── Installing Fish ──${NC}"
  if [ "$PKG_MANAGER" = "apt" ]; then
    sudo apt-add-repository -y ppa:fish-shell/release-4
    sudo apt update
  fi
  $INSTALL_CMD fish
  chsh -s $(which fish)
fi

# ─── Zellij ────────────────────────────────────────────────

if ! command -v zellij &>/dev/null; then
  echo -e "\n${BLUE}── Installing Zellij ──${NC}"
  if [ "$PKG_MANAGER" = "apt" ]; then
    $INSTALL_CMD zellij
  elif [ "$PKG_MANAGER" = "brew" ]; then
    $INSTALL_CMD zellij
  else
    echo "Downloading latest Zellij from GitHub..."
    ZELLIJ_VERSION=$(curl -s "https://api.github.com/repos/zellij-org/zellij/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/zellij.tar.gz "https://github.com/zellij-org/zellij/releases/download/v${ZELLIJ_VERSION}/zellij-x86_64-unknown-linux-musl.tar.gz"
    tar xf /tmp/zellij.tar.gz -C /tmp
    sudo install /tmp/zellij /usr/local/bin
    rm /tmp/zellij /tmp/zellij.tar.gz
  fi
fi

# ─── Neovim (latest stable) ────────────────────────────────

if ! command -v nvim &>/dev/null; then
  echo -e "\n${BLUE}── Installing Neovim (latest) ──${NC}"
  LATEST_NVIM=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
  echo "Downloading $LATEST_NVIM ..."
  curl -LO "https://github.com/neovim/neovim/releases/download/$LATEST_NVIM/nvim-linux-x86_64.appimage"
  chmod +x nvim-linux-x86_64.appimage
  sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
fi

# ─── Starship prompt ──────────────────────────────────────

if ! command -v starship &>/dev/null; then
  echo -e "\n${BLUE}── Installing Starship ──${NC}"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ─── Lazygit ──────────────────────────────────────────────

if ! command -v lazygit &>/dev/null; then
  echo -e "\n${BLUE}── Installing Lazygit ──${NC}"
  if [ "$PKG_MANAGER" = "apt" ]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
  else
    $INSTALL_CMD lazygit
  fi
fi

# ─── Ghostty  ───────────────────────────────

if ! command -v ghostty &>/dev/null; then
  echo -e "\n${YELLOW}Ghostty not available via package manager${NC}"
  echo "  Download from: https://ghostty.org/download"
fi

# ─── Result ────────────────────────────────────────────────

echo ""
echo -e "${GREEN}Dependencies installed!${NC}"
echo "Run ./install.sh to link the configs."
