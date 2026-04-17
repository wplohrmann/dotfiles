#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SESSION="workspace"
STATE_FILE="/tmp/workspace-state.json"
CMD_FILE="/tmp/workspace-tui-cmd"

tmux kill-session -t "$SESSION" 2>/dev/null || true
rm -f "$CMD_FILE"
touch "$CMD_FILE"

# Create session
tmux new-session -d -s "$SESSION" -n main

# Capture the initial (nvim) pane
NVIM_PANE=$(tmux display-message -t "$SESSION:main" -p '#{pane_id}')

# Split: bottom 35% becomes the terminal area
TERM_PANE=$(tmux split-window -v -p 35 -t "$SESSION:main.$NVIM_PANE" -P -F '#{pane_id}')

# Split terminal area: right 30% for TUI
TUI_PANE=$(tmux split-window -h -p 30 -t "$SESSION:main.$TERM_PANE" -P -F '#{pane_id}')

# Hidden background window for inactive terminals
tmux new-window -d -t "$SESSION" -n _bg
BG_BASE_PANE=$(tmux display-message -t "$SESSION:_bg" -p '#{pane_id}')

# Write initial state
cat > "$STATE_FILE" << EOF
{
  "session": "$SESSION",
  "display_pane": "$TERM_PANE",
  "bg_base_pane": "$BG_BASE_PANE",
  "next_index": 2,
  "terminals": [
    {"id": "$TERM_PANE", "name": "Terminal 1"}
  ]
}
EOF

# Ctrl+T creates a new terminal via the command file
tmux bind-key -n C-t run-shell "echo new_terminal >> '$CMD_FILE'"

# Launch nvim in the top pane
tmux send-keys -t "$SESSION:main.$NVIM_PANE" "nvim" Enter

# Launch TUI in the right pane
tmux send-keys -t "$SESSION:main.$TUI_PANE" \
  "python3 '$SCRIPT_DIR/tui.py' '$STATE_FILE' '$CMD_FILE'" Enter

exec tmux attach-session -t "$SESSION"
