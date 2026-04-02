# Agent sandbox aliases — source this from ~/.zshrc

_safe_agent="${HOME}/dotfiles/sandbox-profiles/safe-agent.sh"

safe-claude() { "$_safe_agent" claude --dangerously-skip-permissions "$@"; }
