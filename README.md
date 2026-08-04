# Liam's dotfiles

Personal macOS configuration for Zsh, Git, Neovim, Starship, and iTerm2. The
repository is intentionally small and uses direct symlinks rather than an
installer or dotfile manager.

## What's included

| Path | Purpose |
| --- | --- |
| [`.zshrc`](.zshrc) | Zsh history, completion, Neovim aliases, Starship, Homebrew, and NVM setup |
| [`.gitconfig`](.gitconfig) | Git defaults, Delta paging, identity, and workflow aliases |
| [`.githelpers`](.githelpers) | Pretty logs, branch cleanup, and upstream-push helpers |
| [`.gitignore_global`](.gitignore_global) | Global ignores for local, generated, and environment files |
| [`.config/nvim/`](.config/nvim/) | Neovim configuration and pinned `vim.pack` plugin revisions |
| [`.config/starship.toml`](.config/starship.toml) | Catppuccin Mocha powerline-style prompt |

## Requirements

The configuration is designed for macOS and currently assumes:

- Homebrew is installed under `/opt/homebrew` (the Apple Silicon default).
- Zsh is the login shell.
- Neovim supports the built-in `vim.pack` API (Neovim 0.12 or newer).
- A [Nerd Font](https://www.nerdfonts.com/) is selected in the terminal so the
  Starship and Neovim icons render correctly.
- `starship`, `git-delta`, and `nvim` are available on `PATH`.
- NVM is installed at `~/.nvm` if Node version management is wanted. Its setup
  in `.zshrc` is optional and safely skipped when NVM is absent.

Install the core command-line dependencies with Homebrew:

```sh
brew install git git-delta neovim starship
```


## Installation

Clone the repository, then create symlinks from the home directory:

```sh
git clone https://github.com/liammccartney/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles

mkdir -p ~/.config
ln -s "$PWD/.zshrc" ~/.zshrc
ln -s "$PWD/.gitconfig" ~/.gitconfig
ln -s "$PWD/.githelpers" ~/.githelpers
ln -s "$PWD/.gitignore_global" ~/.gitignore_global
ln -s "$PWD/.config/nvim" ~/.config/nvim
ln -s "$PWD/.config/starship.toml" ~/.config/starship.toml
```

These commands deliberately fail instead of replacing an existing file. Back
up or remove each existing target you intend to replace, then rerun its `ln`
command.

Before linking `.gitconfig` on another machine, update its `[user]` name and
email. Its `core.excludesfile` also currently points to
`/Users/liam/.gitignore_global`; change that path when the macOS account name is
different.

Restart the shell (or run `exec zsh`) after linking the files.

## Neovim

The Neovim setup started from
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and now uses the
built-in `vim.pack` package manager. On first launch, Neovim downloads its
plugins, Mason installs the configured language tooling, and Treesitter installs
parsers as needed. Plugin revisions are recorded in
`.config/nvim/nvim-pack-lock.json`.

Highlights include:

- Catppuccin styling, Gitsigns, Mini statusline/text objects, and rendered Markdown
- Telescope file, text, buffer, help, and LSP search
- LSP support for Angular, C/C++, C#, JSON, Lua, Odin, Python, TOML, and TypeScript
- Blink completion with LuaSnip, Conform formatting, and Treesitter parsing
- Oil directory editing with `-`

The leader key is comma. Useful mappings include:

| Mapping | Action |
| --- | --- |
| `<C-f>` | Find files |
| `<C-b>` | Find open buffers |
| `<leader>sg` | Live grep |
| `<leader>sd` | Search diagnostics |
| `<leader>w` | Save the current buffer |
| `<leader><leader>` | Switch to the alternate buffer |
| `gd` / `gr` / `grt` | Definition / references without tests / all references |
| `<space>f` | Format the current buffer or selection |
| `-` | Open the parent directory in Oil |

Inside Neovim, inspect package updates without network access or update them
with:

```vim
:lua vim.pack.update(nil, { offline = true })
:lua vim.pack.update()
```

Use `:Mason` to inspect language tools and `:checkhealth` to diagnose the local
setup. `make` is optional but enables native builds for Telescope FZF and
LuaSnip.

## Git shortcuts

The shell provides `gs` for `git status` and `gd` for `git diff`. The Git config
adds, among others:

- `git lg` and `git l` for compact graph logs
- `git ci`, `git amend`, and `git noamend` for commit workflows
- `git stage` and `git unstage` for index changes
- `git cb` for the current branch name
- `git cu [branch]` to update a main branch, prune the remote, and delete merged
  local branches whose upstreams are gone
- `git push-this [remote]` to push the current branch and set its upstream

`git cu` mutates local branches, so review its behavior in `.githelpers` before
using it in a repository with branches you need to retain.
