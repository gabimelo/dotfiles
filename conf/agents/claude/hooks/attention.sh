#!/usr/bin/env bash
# Rings the terminal bell in Claude's tmux pane so `monitor-bell` flags the
# window, matching Codex's `notification_method = 'bel'`.

set -euo pipefail

[[ -n "${TMUX:-}" && -n "${TMUX_PANE:-}" ]] || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

pane_tty="$(tmux display-message -p -t "${TMUX_PANE}" '#{pane_tty}' 2>/dev/null || true)"
[[ -w "${pane_tty}" ]] || exit 0

printf '\a' >"${pane_tty}"
