from __future__ import annotations

import json
import os
import subprocess
import sys
from typing import Optional

from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.containers import Container
from textual.screen import ModalScreen
from textual.widgets import Button, Footer, Input, Label, ListItem, ListView, Static

STATE_FILE = sys.argv[1] if len(sys.argv) > 1 else "/tmp/workspace-state.json"
CMD_FILE = sys.argv[2] if len(sys.argv) > 2 else "/tmp/workspace-tui-cmd"


class RenameScreen(ModalScreen[str]):
    def __init__(self, current_name: str) -> None:
        super().__init__()
        self.current_name = current_name

    def compose(self) -> ComposeResult:
        with Container(id="rename-box"):
            yield Label("Rename terminal")
            yield Input(value=self.current_name, id="rename-input")
            yield Static("↵ confirm  esc cancel", id="rename-hint")

    def on_input_submitted(self, event: Input.Submitted) -> None:
        self.dismiss(event.value.strip() or self.current_name)

    def on_key(self, event) -> None:
        if event.key == "escape":
            self.dismiss(self.current_name)


class TerminalEntry(ListItem):
    def __init__(self, term_id: str, name: str, active: bool) -> None:
        super().__init__()
        self.term_id = term_id
        self.term_name = name
        self.active = active

    def compose(self) -> ComposeResult:
        bullet = "●" if self.active else " "
        yield Static(f" {bullet} >_ {self.term_name}")


class TerminalTUI(App):
    CSS = """
    Screen {
        background: #1e1e1e;
    }

    #header {
        height: 1;
        background: #2d2d2d;
        color: #858585;
        padding: 0 1;
        text-style: bold;
    }

    #terminal-list {
        height: 1fr;
        border: none;
        background: #1e1e1e;
        padding: 0;
    }

    TerminalEntry {
        height: 1;
        background: #1e1e1e;
        color: #cccccc;
    }

    TerminalEntry:hover {
        background: #2a2d2e;
    }

    TerminalEntry.--highlight {
        background: #37373d;
    }

    TerminalEntry.active-terminal Static {
        color: #ffffff;
        text-style: bold;
    }

    #new-btn {
        height: 3;
        width: 100%;
        background: #2d2d2d;
        color: #858585;
        border: none;
    }

    #new-btn:hover {
        background: #094771;
        color: #ffffff;
    }

    #new-btn:focus {
        background: #094771;
        color: #ffffff;
        border: none;
    }

    RenameScreen {
        align: center middle;
    }

    #rename-box {
        background: #252526;
        border: solid #007acc;
        padding: 1 2;
        width: 38;
        height: 9;
    }

    #rename-box Label {
        color: #cccccc;
        margin-bottom: 1;
    }

    #rename-hint {
        color: #858585;
        margin-top: 1;
    }

    #rename-input {
        background: #3c3c3c;
        color: #ffffff;
        border: tall #007acc;
    }

    Footer {
        background: #007acc;
        color: #ffffff;
    }
    """

    BINDINGS = [
        Binding("n", "new_terminal", "New"),
        Binding("r", "rename_terminal", "Rename"),
        Binding("x", "close_terminal", "Close"),
        Binding("enter", "select_terminal", "Select"),
    ]

    def __init__(self) -> None:
        super().__init__()
        self.state = self._load_state()

    def _load_state(self) -> dict:
        with open(STATE_FILE) as f:
            return json.load(f)

    def _save_state(self) -> None:
        with open(STATE_FILE, "w") as f:
            json.dump(self.state, f, indent=2)

    def _tmux(self, *args: str) -> str:
        result = subprocess.run(["tmux"] + list(args), capture_output=True, text=True)
        return result.stdout.strip()

    def compose(self) -> ComposeResult:
        yield Static("TERMINALS", id="header")
        yield ListView(id="terminal-list")
        yield Button("＋  New Terminal", id="new-btn")
        yield Footer()

    def on_mount(self) -> None:
        self._refresh_list()
        self.set_interval(0.1, self._poll_commands)

    def _poll_commands(self) -> None:
        try:
            with open(CMD_FILE, "r+") as f:
                lines = f.readlines()
                if lines:
                    f.seek(0)
                    f.truncate()
            for line in lines:
                cmd = line.strip()
                if cmd == "new_terminal":
                    self.action_new_terminal()
                elif cmd == "prev_terminal":
                    self._cycle_terminal(-1)
                elif cmd == "next_terminal":
                    self._cycle_terminal(1)
                elif cmd.startswith("close_terminal:"):
                    self._close_terminal_by_id(cmd.split(":", 1)[1])
        except (FileNotFoundError, IOError):
            pass

    def _refresh_list(self) -> None:
        lv = self.query_one("#terminal-list", ListView)
        lv.clear()
        for term in self.state["terminals"]:
            active = term["id"] == self.state["display_pane"]
            item = TerminalEntry(term["id"], term["name"], active)
            if active:
                item.add_class("active-terminal")
            lv.append(item)

    def _highlighted(self) -> Optional[TerminalEntry]:
        lv = self.query_one("#terminal-list", ListView)
        child = lv.highlighted_child
        return child if isinstance(child, TerminalEntry) else None

    def _cycle_terminal(self, direction: int) -> None:
        terminals = self.state["terminals"]
        if len(terminals) <= 1:
            return
        ids = [t["id"] for t in terminals]
        try:
            idx = ids.index(self.state["display_pane"])
        except ValueError:
            return
        self._do_switch(ids[(idx + direction) % len(ids)])

    def action_new_terminal(self) -> None:
        idx = self.state["next_index"]
        pane_id = self._tmux(
            "split-window", "-d", "-h",
            "-t", self.state["bg_base_pane"],
            "-P", "-F", "#{pane_id}",
        )
        if not pane_id:
            return
        pane_path = self._tmux("display-message", "-t", pane_id, "-p", "#{pane_current_path}")
        if pane_path and os.path.exists(os.path.join(pane_path, "venv", "bin", "activate")):
            self._tmux("send-keys", "-t", pane_id, "source venv/bin/activate", "Enter")
        self.state["terminals"].append({"id": pane_id, "name": f"Terminal {idx}"})
        self.state["next_index"] = idx + 1
        self._save_state()
        self._refresh_list()

    def action_rename_terminal(self) -> None:
        item = self._highlighted()
        if item is None:
            return

        def on_dismiss(new_name: str | None) -> None:
            if new_name and new_name != item.term_name:
                for term in self.state["terminals"]:
                    if term["id"] == item.term_id:
                        term["name"] = new_name
                        break
                self._save_state()
                self._refresh_list()

        self.push_screen(RenameScreen(item.term_name), on_dismiss)

    def action_close_terminal(self) -> None:
        item = self._highlighted()
        if item is not None:
            self._close_terminal_by_id(item.term_id)

    def _close_terminal_by_id(self, pane_id: str) -> None:
        if len(self.state["terminals"]) <= 1:
            return
        if not any(t["id"] == pane_id for t in self.state["terminals"]):
            return
        if pane_id == self.state["display_pane"]:
            others = [t for t in self.state["terminals"] if t["id"] != pane_id]
            self._do_switch(others[0]["id"])
        self._tmux("kill-pane", "-t", pane_id)
        self.state["terminals"] = [
            t for t in self.state["terminals"] if t["id"] != pane_id
        ]
        self._save_state()
        self._refresh_list()

    def action_select_terminal(self) -> None:
        item = self._highlighted()
        if item:
            self._do_switch(item.term_id)

    def _do_switch(self, target_id: str) -> None:
        if target_id == self.state["display_pane"]:
            return
        self._tmux("swap-pane", "-s", self.state["display_pane"], "-t", target_id)
        self.state["display_pane"] = target_id
        self._save_state()
        self._refresh_list()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "new-btn":
            self.action_new_terminal()

    def on_list_view_selected(self, event: ListView.Selected) -> None:
        if isinstance(event.item, TerminalEntry):
            self._do_switch(event.item.term_id)


if __name__ == "__main__":
    app = TerminalTUI()
    app.run()
