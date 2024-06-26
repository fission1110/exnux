# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gnzh"


# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# alias xclip="xclip -selection c"

# Set this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often to auto-update? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to the command execution time stamp shown 
# in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
  gitfast
  vi-mode
  dirhistory
  pip
  nmap
  fzf
  zsh-autosuggestions
)
COLORTERM=truecolor

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_BASE=/usr/local/src/fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export HISTFILE=~/.cache/zsh/.zsh_history

source $ZSH/oh-my-zsh.sh

# User configuration
# vim like auto suggestions and history search
bindkey '^l' autosuggest-accept
bindkey '^n' history-search-forward
bindkey '^p' history-search-backward
bindkey '^o' fzf-file-widget

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export PATH=$HOME/bin:/usr/local/bin:$PATH
PATH=$PATH:$HOME/.composer/vendor/bin
PATH=$HOME/.rbenv/bin:/usr/local/src/rbenv/.rbenv/shims:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$PATH:/usr/local/src/ansible/bin
# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
 export EDITOR='vim'
else
 export EDITOR='nvim'
fi

ssh () {
    tmux rename-window "ssh $*"
    command ssh "$@"
    tmux rename-window "$(basename $SHELL)"
}

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

#vi mode
bindkey -v

alias vvim=/usr/bin/vim
alias vim=/usr/local/bin/nvim
alias cat="bat"
alias ls="exa -g --git"
alias l="exa -lg --git --icons"
alias ll="exa -lg --git --icons"
alias la="exa -lag --icons"
alias cd="z"
eval "$(rbenv init - zsh)"
export _ZO_DATA_DIR=$HOME/.cache/zoxide
eval "$(zoxide init zsh)"
