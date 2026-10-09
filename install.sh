#!/bin/bash

DOTFILES="$HOME/dotfiles"

echo "🔧 Setting up dotfiles..."

# Neovim
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"
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

# Ghostty
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"
echo "✓ Ghostty config linked"

# i3 + rofi - native Linux only (not WSL2, not Mac)
if [[ "$OSTYPE" == "linux"* ]] && ! grep -q microsoft /proc/version 2>/dev/null; then
    mkdir -p "$HOME/.config/i3" "$HOME/.config/rofi"
    ln -sf "$DOTFILES/i3/config" "$HOME/.config/i3/config"
    ln -sf "$DOTFILES/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
    mkdir -p "$HOME/.config/gtk-3.0"
    ln -sf "$DOTFILES/gtk/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
    echo "✓ i3, rofi and GTK dark setting linked"
    # extra launcher entries (rofi reads ~/.local/share/applications)
    mkdir -p "$HOME/.local/share/applications"
    ln -sf "$DOTFILES/applications/system-settings.desktop" "$HOME/.local/share/applications/system-settings.desktop"
    echo "✓ System Settings launcher entry linked"
    # the desktop widget (conky/), lock screen and window-snap scripts are
    # used by the i3 config straight from $DOTFILES; the wallpaper is a
    # local file at ~/Pictures/wallpaper.jpg and is not managed here
fi

# Zsh
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
echo "✓ Zshrc linked"

# SSH config
mkdir -p "$HOME/.ssh"
ln -sf "$DOTFILES/ssh/config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
echo "✓ SSH config linked"

echo ""

# Custom oh-my-zsh theme
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
ln -sf "$DOTFILES/kphoen.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/kphoen.zsh-theme"
echo "✓ Custom zsh theme linked"
echo "✅ Done. Restart your terminal."
