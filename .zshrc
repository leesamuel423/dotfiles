
# ---------> OH MY ZSH CONFIGURATION <---------
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="simple"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# ---------> PLUGINS <---------
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ---------> ALIASES <---------
# Editor aliases
alias v="nvim"
alias t="tmux"
alias cd="z"
alias ls="eza"
alias python="python3"
alias gs="git status --short"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gu="git pull"
alias gl="git log"
alias opengh="./scripts/open-gh.sh"


# Application aliases
alias ow-serve="cd ~/open-webui && source open-webui-env/bin/activate && open-webui serve"

# ---------> OTHER CONFIGS <---------
# fzf config
source <(fzf --zsh)

# zoxide config
eval "$(zoxide init zsh)"

# ---------> LANGUAGE & DEVELOPMENT <---------
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go
export PATH=$PATH:~/go/bin

# java
export PATH="$(brew --prefix)/opt/openjdk@17/bin:$PATH"

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
