# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

plugins=(git fzf)

export FZF_BASE=/opt/homebrew/opt/fzf

source $ZSH/oh-my-zsh.sh

setopt IGNORE_EOF

# Ctrl+D at an empty prompt inside a tmux-session workspace: close this
# terminal the same way `x` in the TUI sidebar does.
_close_tui_terminal_or_delete() {
  if [[ -n $BUFFER ]]; then
    zle delete-char-or-list
    return
  fi
  if [[ -n $TMUX_PANE ]]; then
    local session cmd_file
    session=$(tmux display-message -p '#{session_name}' 2>/dev/null)
    cmd_file="/tmp/workspace-tui-cmd-${session}"
    if [[ -w $cmd_file ]]; then
      print "close_terminal:$TMUX_PANE" >> $cmd_file
    fi
  fi
}
zle -N _close_tui_terminal_or_delete
bindkey '^D' _close_tui_terminal_or_delete


eval "$(/opt/homebrew/bin/brew shellenv)"

export PYTHONDONTWRITEBYTECODE="no, thank you"

if [ -f ~/.passwords ]; then
    source ~/.passwords
fi

export EDITOR=nvim

if [ "$TERM_PROGRAM" = "vscode" ]; then
    export PSEUDOVIM=code
else
    export PSEUDOVIM=nvim
fi

function vimgrep()
{
    $PSEUDOVIM $(git grep -l "$@")
}

function vimdiff()
{
    $PSEUDOVIM $(git diff "origin/$@" --name-only | uniq)
}

alias vimresolve='$PSEUDOVIM $(git diff --name-only | uniq)'
alias vim=nvim
alias gg='git status'
alias ff='git diff'
alias ss='git diff --staged'
alias ll='ls -alh'
alias dev='~/src/dotfiles/tmux-session/launch.sh'

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm


. "$HOME/.local/bin/env"

export PATH="$HOME/.cargo/bin:$PATH"
