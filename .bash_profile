[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

echo "Logged in as $USER at $(hostname)"

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
# export LSCOLORS=ExGxFxdxCxDxDxaccxaeex
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
# Force ls to use colors (G) and use humanized file sizes (h)
alias ls='ls -1Gh'

# Force grep to always use the color option and show line numbers
export GREP_OPTIONS='--color=auto'

# Set vim as the default editor as is correct
export EDITOR="vim"


# Useful aliases

# Edit this file
alias bp="vim ~/.bash_profile"
# Reload this file
alias reload='source ~/.bash_profile'

# Open the current directory in Finder - this used to be helpful
alias f='open -a Finder ./'

# Reduce the characters you have to type
alias gs="git status"
alias gd='git diff'

# Start up Tmux correctly
alias tmux="TERM=screen-256color-bce tmux"

# List the jobs you CRTL+Z'd
alias jj="jobs"

# Genuinely don't remember what this was for
test -d /usr/local/bin && export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"

# virtualenvwrapper config
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

export VIRTUALENV_PYTHON=/usr/local/bin/python

# freetds@0.91 Config
export PATH="/usr/local/opt/freetds@0.91/bin:$PATH"
export LDFLAGS=-L/usr/local/opt/freetds@0.91/lib
export CPPFLAGS=-I/usr/local/opt/freetds@0.91/include

# Magic Monty Git Prompt Config
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_THEME=Solarized

# bootstrap direnv 
eval "$(direnv hook bash)"
