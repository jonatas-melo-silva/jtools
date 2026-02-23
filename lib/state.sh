#!/usr/bin/env bash

STATE_FILE="$HOME/.jtools/state.json"

init_state() {
  mkdir -p "$HOME/.jtools"
  [ -f "$STATE_FILE" ] || echo '{}' > "$STATE_FILE"
}

state_get() {
  jq -r ".\"$1\".version // empty" "$STATE_FILE"
}

state_set() {
  tmp=$(mktemp)
  jq ". + {\"$1\": {\"version\": \"$2\"}}" "$STATE_FILE" > "$tmp"
  mv "$tmp" "$STATE_FILE"
}

state_remove() {
  tmp=$(mktemp)
  jq "del(.\"$1\")" "$STATE_FILE" > "$tmp"
  mv "$tmp" "$STATE_FILE"
}

state_list() {
  jq -r 'to_entries[]? | "\(.key)@\(.value.version)"' "$STATE_FILE"
}
