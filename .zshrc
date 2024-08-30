export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh

alias gs="git status"
alias gd="git diff"
alias gb="git branch"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias cat="bat"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export BAT_THEME="Nord"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH="/Users/liam/Library/Python/3.11/bin/:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

eval "$(zoxide init --cmd cd zsh)"
eval $(thefuck --alias heck)
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/Users/liam/.local/bin:$PATH"
