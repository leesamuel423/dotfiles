#!/usr/bin/env bash

# shellcheck source=/dev/null
source "$CONFIG_DIR/colors.sh"

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
OCCUPIED="$(aerospace list-workspaces --monitor focused --empty no)"

# One batched call: an IPC round trip per workspace would visibly lag the switch.
args=()
for sid in $(aerospace list-workspaces --all); do
  if [ "$sid" = "$FOCUSED" ]; then
    args+=(--set "space.$sid" drawing=on background.drawing=on label.color="$ACCENT_COLOR")
  elif grep -qx -- "$sid" <<<"$OCCUPIED"; then
    args+=(--set "space.$sid" drawing=on background.drawing=off label.color="$LABEL_COLOR")
  else
    args+=(--set "space.$sid" drawing=off background.drawing=off)
  fi
done

sketchybar "${args[@]}"
