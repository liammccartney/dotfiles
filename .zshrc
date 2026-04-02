export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt autocd
autoload -U compinit; compinit

alias gs="git status"
alias gd="git diff"
alias gb="git branch"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias vv="/Users/liam/nvim-macos-arm64/bin/nvim"
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

# Only load zoxide outside of claude cli sessions
# i hate having to do this but alas
if [[ "$CLAUDECODE" != "1" ]]; then
    eval "$(zoxide init --cmd cd zsh)"
fi
eval $(thefuck --alias heck)
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
# export PATH="/Users/liam/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin/:$PATH"
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.local/bin/:$PATH"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

eval $(thefuck --alias)

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="/Users/liam/Languages/Odin:$PATH"
export PATH="/Users/liam/LSP/ols:$PATH"

autoload -Uz +X compinit && compinit

## case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Entire CLI shell completion
autoload -Uz compinit && compinit && source <(entire completion zsh)

# Agent sandbox aliases
source "$HOME/dotfiles/sandbox-profiles/shell-aliases.zsh"
