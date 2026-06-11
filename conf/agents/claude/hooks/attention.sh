#!/usr/bin/env bash

set -euo pipefail

readonly BADGE_PREFIX='[!] '
readonly NAME_STATE_KEY='@ai_attention_original_name'

has_tmux() {
  command -v tmux >/dev/null 2>&1 && [[ -n "${TMUX:-}" ]]
}

current_window_target() {
  if [[ -n "${TMUX_PANE:-}" ]]; then
    tmux display-message -p -t "${TMUX_PANE}" '#{session_name}:#{window_index}'
  else
    tmux display-message -p '#{session_name}:#{window_index}'
  fi
}

window_is_active() {
  local target="$1"
  local active
  active="$(tmux display-message -p -t "${target}" '#{window_active}' 2>/dev/null || printf '0')"
  [[ "${active}" == "1" ]]
}

window_name() {
  local target="$1"
  tmux display-message -p -t "${target}" '#W'
}

mark_window_pending() {
  local target="$1"
  local current_name saved_name

  current_name="$(window_name "${target}")"
  saved_name="$(tmux show-window-option -qv -t "${target}" "${NAME_STATE_KEY}" 2>/dev/null || true)"

  if [[ -n "${saved_name}" ]]; then
    return 0
  fi

  if [[ "${current_name}" == "${BADGE_PREFIX}"* ]]; then
    tmux set-window-option -q -t "${target}" "${NAME_STATE_KEY}" "${current_name#${BADGE_PREFIX}}" || true
    return 0
  fi

  tmux set-window-option -q -t "${target}" "${NAME_STATE_KEY}" "${current_name}" || true
  tmux rename-window -t "${target}" "${BADGE_PREFIX}${current_name}" || true
}

clear_window_pending() {
  local target="$1"
  local saved_name current_name

  saved_name="$(tmux show-window-option -qv -t "${target}" "${NAME_STATE_KEY}" 2>/dev/null || true)"
  if [[ -n "${saved_name}" ]]; then
    tmux rename-window -t "${target}" "${saved_name}" || true
    tmux set-window-option -qu -t "${target}" "${NAME_STATE_KEY}" || true
    return 0
  fi

  current_name="$(window_name "${target}")"
  if [[ "${current_name}" == "${BADGE_PREFIX}"* ]]; then
    tmux rename-window -t "${target}" "${current_name#${BADGE_PREFIX}}" || true
  fi
}

mark_pending_if_inactive() {
  local target
  target="$(current_window_target)" || return 1
  if window_is_active "${target}"; then
    return 1
  fi
  mark_window_pending "${target}"
  return 0
}

clear_pending_current_window() {
  local target
  target="$(current_window_target)" || return 0
  clear_window_pending "${target}"
}

json_key() {
  local key="$1"
  local input="$2"
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg key "${key}" '.[$key] // empty' <<<"${input}" 2>/dev/null || true
  fi
}

install_tmux_hooks() {
  tmux set-hook -g after-select-window "run-shell '$HOME/.claude/hooks/attention.sh clear'"
  tmux set-hook -g after-select-pane "run-shell '$HOME/.claude/hooks/attention.sh clear'"
}

handle_attention_events() {
  local payload event_name
  payload="$(cat || true)"
  event_name="$(json_key "hook_event_name" "${payload}")"

  case "${event_name}" in
    UserPromptSubmit)
      clear_pending_current_window
      ;;
    Notification|PermissionRequest|Stop|SubagentStop)
      mark_pending_if_inactive || true
      ;;
    *)
      ;;
  esac
}

handle_codex() {
  local payload event_name
  payload="$(cat || true)"
  event_name="$(json_key "hook_event_name" "${payload}")"

  case "${event_name}" in
    UserPromptSubmit)
      clear_pending_current_window
      ;;
    PermissionRequest|Stop)
      mark_pending_if_inactive || true
      ;;
    *)
      ;;
  esac
}

main() {
  has_tmux || exit 0

  local mode="${1:-claude}"
  shift || true

  case "${mode}" in
    setup)
      install_tmux_hooks
      ;;
    clear)
      clear_pending_current_window
      ;;
    claude)
      handle_attention_events
      ;;
    codex)
      handle_codex
      ;;
    *)
      handle_attention_events
      ;;
  esac
}

main "$@"
