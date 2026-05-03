# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input must go above this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

WORDCHARS=${WORDCHARS//[.\/]/}

# PATH
export PATH="$HOME/local/nvim/bin:$PATH"
export PATH="$HOME/.nodebrew/current/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="/Users/th13/.opencode/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# --- ls colors ---
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
alias ls='ls --color=auto'

# bun completions
[ -s "/Users/th13/.bun/_bun" ] && source "/Users/th13/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# WezTerm: cwd継承（split/tabで現在ディレクトリを引き継ぐためOSC 7を送る）
if [[ ${TERM_PROGRAM:-} == WezTerm ]]; then
  __wezterm_osc7() {
    printf '\e]7;file://%s/%s\e\\' "${HOST:-$(hostname)}" "${PWD#/}"
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd __wezterm_osc7
  add-zsh-hook precmd __wezterm_osc7
  __wezterm_osc7
fi

source ~/code/dotfiles/shell/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/code/dotfiles/shell/.p10k.zsh ]] && source ~/code/dotfiles/shell/.p10k.zsh
