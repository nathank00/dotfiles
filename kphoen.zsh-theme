# kphoen (custom) — Dracula-tinted
# Username: light purple, Host: orange, Git branch: teal blue, ⚡ when dirty

# --- Color helpers (Dracula-ish) ---
LIGHT_PURPLE="%F{141}"   # #BD93F9
ORANGE="%F{214}"         # #FFB86C
# kphoen (custom) — Dracula-tinted + multi-line venv
# Username: light purple, Host: orange, Path: dark purple, Venv: pink (on line above), Git branch: teal blue, ⚡ when dirty

# --- Colors ---
LIGHT_PURPLE="%F{141}"      # username
LIGHTER_PURPLE="%B%F{105}"  # hostname
DARK_PURPLE="%F{99}"        # path
TEAL_BLUE="%F{45}"          # git branch
PINK="%F{212}"              # venv
RED="%F{160}"
RESET="%f%b"

# --- Git prompt config ---
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY=" ⚡"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"

# --- Virtual environment display (above prompt) ---
venv_prompt() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "${PINK}($(basename "$VIRTUAL_ENV"))${RESET}"
  fi
}

# --- Blank line before each prompt ---
precmd() {
  echo ""  # outputs a newline before every prompt
}

# --- Prompt ---
# First line: optional virtualenv
# Second line: user@host path git
PROMPT='$(venv_prompt)
${ORANGE}%n${RESET}@${LIGHT_PURPLE}%m${RESET} ${DARK_PURPLE}%~${RESET} ${TEAL_BLUE}$(git_prompt_info)${RESET} %# '
RPROMPT='%(?..'"${RED}"'%?'"${RESET}"' ↵)$(git_prompt_status)'

