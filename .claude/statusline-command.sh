#!/usr/bin/env bash

input=$(cat)

# --- Directory ---
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
if [ "$current_dir" = "." ] || [ -z "$current_dir" ]; then
  current_dir=$(pwd)
fi
cd "$current_dir" 2>/dev/null || true
dir_display="~${current_dir#"$HOME"}"
if [ "$current_dir" = "$HOME" ]; then dir_display="~"; fi

# --- Git ---
git_info=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null || echo 'main')
  status=$(git status --porcelain 2>/dev/null)
  if [ -n "$status" ]; then git_status=" x"; else git_status=" v"; fi
  git_info=" ($branch$git_status)"
fi

# --- Context progress bar ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
bar=""
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  filled=$(echo "$used_pct" | awk '{printf "%d", $1 / 10 + 0.5}')
  empty=$((10 - filled))
  bar_inner=""
  for _ in $(seq 1 "$filled"); do bar_inner="${bar_inner}#"; done
  for _ in $(seq 1 "$empty");  do bar_inner="${bar_inner}-"; done
  used_int=$(printf "%.0f" "$used_pct")
  bar=" [${bar_inner}] ${used_int}%"
fi

# --- Compose ---
if [ -n "$bar" ]; then
  printf "%s%s | %s" "$dir_display" "$git_info" "$bar"
else
  printf "%s%s" "$dir_display" "$git_info"
fi
