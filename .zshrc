
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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ---------> ALIASES <---------
# Editor aliases
alias v="nvim"
alias t="tmux"
alias ls="eza -la"
alias python="python3"
alias gs="git status --short"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gu="git pull"
alias gl="git log"
alias opengh="./scripts/open-gh.sh"
alias tree='tree "$@" | tee >(pbcopy)'
alias treeclean='tree -I "node_modules|__pycache__|.git|dist|build|*.pyc" "$@" | tee >(pbcopy)'
alias cat="bat"
alias makef="make -f ~/Makefile"


# Application aliases
alias ow-serve="cd ~/open-webui && source open-webui-env/bin/activate && open-webui serve"

# ---------> OTHER CONFIGS <---------
# fzf config
source <(fzf --zsh)

# zoxide config
eval "$(zoxide init zsh)"

# thefuck config
eval $(thefuck --alias)

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
eval "$(pyenv virtualenv-init -)"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# ---------> LSP SCRIPTS <---------
# Bazel JDTLS setup for Java projects
bazel-jdtls() {
    local script_path="$HOME/scripts/lsp/bazel_jdtls_setup.sh"
    if [ -f "$script_path" ]; then
        bash "$script_path" "${1:-.}"
    else
        echo "Error: bazel_jdtls_setup.sh not found at $script_path"
        return 1
    fi
}
alias bjdtls='bazel-jdtls'
