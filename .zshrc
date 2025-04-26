
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
