# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A tmux-based workspace launcher that creates an integrated Neovim + terminal manager layout. It splits the screen into three panes: Neovim (top), active terminal (bottom-left), and a Textual TUI sidebar (right) for managing named terminal tabs.

## Setup & Running

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Launch the full workspace (kills any existing "workspace" tmux session)
./launch.sh
```

No test framework or linter is configured.

## Architecture

**`launch.sh`** — entry point. Kills any existing `workspace` tmux session, creates the three-pane layout, writes initial state to `/tmp/workspace-state.json`, and starts both nvim and `tui.py`.

**`tui.py`** — the Textual TUI sidebar app. Key classes:
- `TerminalTUI`: root app, polls `CMD_FILE` every 100ms for Ctrl+T signals from tmux
- `TerminalEntry`: list item widget displaying terminal name + active indicator (`●`)
- `RenameScreen`: modal dialog for renaming a terminal

**State** is a JSON file at `/tmp/workspace-state.json` with pane IDs, display names, and a `next_index` counter. `tui.py` reads and writes this file directly; `launch.sh` initializes it.

**tmux integration**: all terminal operations (create, close, swap, select) are `subprocess` calls to `tmux split-window`, `tmux swap-pane`, `tmux kill-pane`, etc.

**Ctrl+T flow**: tmux binds Ctrl+T globally to append a line to `CMD_FILE`. The TUI polls this file and opens a new terminal when it detects a write — this is how the keyboard shortcut crosses the tmux→TUI boundary.
