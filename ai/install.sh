#!/bin/sh
# Local AI chat for ITX. Everything runs and stays on this machine.
#
#   Ollama      runs the model on the GPU
#   Open WebUI  browser chat with saved history and memory (http://localhost:8080)
#
# Run as your normal user (it asks for your password where needed):
#     sh ~/dotfiles/ai/install.sh
# Use a different model:
#     sh ~/dotfiles/ai/install.sh gemma4:12b
# Safe to run again; it updates what is already installed.
set -e

MODEL="${1:-gpt-oss:20b}"
CONTEXT=8192      # how much conversation the model holds at once; Ollama's
                  # default on a 16 GB card is 4096, too small once memory is on

echo "== Ollama =="
if ! command -v ollama >/dev/null 2>&1; then
    curl -fsSL https://ollama.com/install.sh | sh
fi
sudo mkdir -p /etc/systemd/system/ollama.service.d
printf '[Service]\nEnvironment="OLLAMA_CONTEXT_LENGTH=%s"\n' "$CONTEXT" \
    | sudo tee /etc/systemd/system/ollama.service.d/itx.conf >/dev/null
sudo systemctl daemon-reload
sudo systemctl restart ollama

echo "== uv (installs Open WebUI into its own Python environment) =="
if command -v uv >/dev/null 2>&1; then
    UV="$(command -v uv)"
else
    [ -x "$HOME/.local/bin/uv" ] || curl -LsSf https://astral.sh/uv/install.sh | sh
    UV="$HOME/.local/bin/uv"
fi

echo "== Open WebUI (several GB the first time) =="
if [ -x "$HOME/.local/bin/open-webui" ]; then
    "$UV" tool upgrade open-webui
else
    "$UV" tool install --python 3.12 open-webui
fi

echo "== start Open WebUI in the background, now and at every boot =="
mkdir -p "$HOME/.open-webui" "$HOME/.config/systemd/user" "$HOME/.local/share/applications"
ln -sf "$HOME/dotfiles/ai/open-webui.service" "$HOME/.config/systemd/user/open-webui.service"
ln -sf "$HOME/dotfiles/applications/local-chat.desktop" "$HOME/.local/share/applications/local-chat.desktop"
systemctl --user daemon-reload
systemctl --user enable open-webui.service
systemctl --user restart open-webui.service
sudo loginctl enable-linger "$USER"

echo "== model: $MODEL (a large download the first time) =="
ollama pull "$MODEL"

echo ""
echo "Done. Open http://localhost:8080 (or Mod+d, type: chat)."
echo "The first start takes about a minute before the page loads."
