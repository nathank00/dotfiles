#!/bin/bash

DOTFILES="$HOME/dotfiles"

echo "🔧 Setting up dotfiles..."

# Neovim
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
echo "✓ Neovim config linked"

# VSCode - Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    ln -sf "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    echo "✓ VSCode settings linked (Mac)"
fi

# VSCode - WSL2
if grep -q microsoft /proc/version 2>/dev/null; then
    WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
    VSCODE_WIN="/mnt/c/Users/$WIN_USER/AppData/Roaming/Code/User"
    mkdir -p "$VSCODE_WIN"
    cp "$DOTFILES/vscode/settings.json" "$VSCODE_WIN/settings.json"
    echo "✓ VSCode settings copied (Windows)"

# VSCode - Native Linux (not WSL2)
elif [[ "$OSTYPE" == "linux"* ]]; then
    mkdir -p "$HOME/.config/Code/User"
    ln -sf "$DOTFILES/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
    echo "✓ VSCode settings linked (Linux)"
fi

# WezTerm
ln -sf "$DOTFILES/wezterm.lua" "$HOME/.wezterm.lua"
echo "✓ WezTerm config linked"

# Zsh
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
echo "✓ Zshrc linked"

# SSH config
mkdir -p "$HOME/.ssh"
ln -sf "$DOTFILES/ssh/config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
echo "✓ SSH config linked"

echo ""
echo "✅ Done. Restart your terminal."
