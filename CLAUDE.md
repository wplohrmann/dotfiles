# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for Will Lohrmann. No install scripts — files are symlinked or used directly from `~/src/dotfiles`. The primary active config is Neovim (`nvim/`).

## Neovim Config Architecture

**Entry point**: `nvim/init.lua` — contains all settings, keybindings, LSP setup, and mini.nvim module configuration inline.

**Plugin management**: Lazy.nvim, bootstrapped in `nvim/lua/config/lazy.lua`, plugins declared in `nvim/lua/plugins.lua`.

**Core plugin stack**:
- `mini.nvim` — provides completion, pairs, diff, git signs, icons, statusline, tabline, comments
- `telescope.nvim` — fuzzy finder for files (`<C-p>`), live grep (`<C-f>`), LSP references/definitions
- `nvim-treesitter` — syntax highlighting
- `flash.nvim` — motion navigation (`s`/`S`)
- `vim-surround`, `vim-commentary`

**LSP**: BasedPyright for Python, configured directly in `init.lua` via `vim.lsp.config`.

**Leader key**: `,`

**Key non-obvious keybindings**:
- `<Space>` → enter insert mode
- `<CR>` → save file
- `l` / `h` → next/previous buffer
- `<C-w>` → delete buffer
- `:Config` (custom command) → open dotfiles dir in Telescope

## Other Configs

**Ghostty** (`config.ghostty`): Launches tmux as shell; remaps `Cmd+p/f//` to `Ctrl+p/f//` so macOS shortcuts pass through to Neovim keybindings inside tmux.

**Zsh** (`.zshrc`): oh-my-zsh with robbyrussell theme; plugins: git, fzf. Key aliases: `vim`→nvim, `gg`→git status, `ff`→git diff, `ss`→git diff --staged. Custom functions: `vimgrep`, `vimdiff`, `vimresolve` open matched/changed/conflicted files in editor.

**Tmux** (`.tmux.conf`): mouse on, vi copy-mode, 50k history, yank to clipboard via xclip.
