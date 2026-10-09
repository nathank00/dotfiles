#!/bin/bash
# One-time software setup for a native Ubuntu machine (ITX).
# Safe to re-run: anything already installed is skipped or refreshed.
# Usage: bash ~/dotfiles/linux-setup.sh
set -e

echo "== apt packages =="
sudo apt update
sudo apt install -y \
    zsh git curl build-essential tmux openssh-server \
    ripgrep fd-find unzip xclip nodejs npm python3-venv \
    fonts-hack fonts-jetbrains-mono extrepo \
    i3 rofi feh dunst arandr conky-all xsecurelock x11-utils

echo "== Neovim (latest release) =="
tmp="$(mktemp -d)"
curl -fL -o "$tmp/nvim.tar.gz" \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm -rf "$tmp"

echo "== Ghostty =="
if ! snap list ghostty >/dev/null 2>&1; then
    sudo snap install ghostty --classic
fi

echo "== LibreWolf =="
if ! dpkg -s librewolf >/dev/null 2>&1; then
    sudo extrepo enable librewolf
    sudo extrepo update librewolf
    sudo apt update
    sudo apt install -y librewolf
fi

echo "== oh-my-zsh =="
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    # install.sh may have created an empty ~/.oh-my-zsh for the theme link,
    # which makes the oh-my-zsh installer refuse to run
    rm -rf "$HOME/.oh-my-zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s "$(command -v zsh)"
fi

echo "== no input-method daemon in X sessions (removes the EN tray icon) =="
if command -v im-config >/dev/null; then
    im-config -n none || true
fi

echo "== dark mode for GTK apps =="
if command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark || true
fi

echo "== link dotfiles =="
bash "$HOME/dotfiles/install.sh"

echo ""
echo "Done. nvim: $(nvim --version | head -1)"
