#!/bin/bash
# One-time setup for the headless Raspberry Pi (rtes-pi) used for RTES coursework.
# Shell + Neovim only: no desktop configs (i3, rofi, Ghostty, VS Code) on the Pi.
# Safe to re-run.
# Usage (on the Pi): bash ~/dotfiles/pi-setup.sh
set -e
DOTFILES="$HOME/dotfiles"

echo "== apt packages =="
sudo apt update
sudo apt install -y \
    zsh git curl unzip tmux build-essential gdb \
    ripgrep fd-find clangd nodejs npm \
    htop sysstat rsyslog stress-ng

echo "== Neovim (latest arm64 release; apt's is too old for this config) =="
tmp="$(mktemp -d)"
curl -fL -o "$tmp/nvim.tar.gz" \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
sudo rm -rf /opt/nvim-linux-arm64
sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
sudo ln -sf /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim
rm -rf "$tmp"

echo "== oh-my-zsh =="
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
    sudo chsh -s "$(command -v zsh)" "$USER"
fi

echo "== link dotfiles =="
mkdir -p "$HOME/.config" "$HOME/.oh-my-zsh/custom/themes"
ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/kphoen.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/kphoen.zsh-theme"

echo "== Neovim plugins (pinned by lazy-lock.json; a few minutes on the Pi) =="
nvim --headless "+Lazy! restore" +qa

echo "== coursework folders =="
mkdir -p "$HOME/rtes/course-1/module-"{1,2,3,4}

echo ""
echo "Done. $(nvim --version | head -1). Log out and back in to start zsh."
