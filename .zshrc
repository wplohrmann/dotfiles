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


eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
alias vim=nvim
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

export LDFLAGS="-L/opt/homebrew/opt/openblas/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openblas/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

