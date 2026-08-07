#!/bin/bash
# Reap AeroSpace ghost windows safely. Debounced: only closes window-ids that
# were empty-title on two consecutive runs AND aren't focused — so a loading or
# just-opened window is never closed. Workaround for #1615.
AS=/opt/homebrew/bin/aerospace
STATE="$HOME/.cache/aerospace/ghost-prev"
mkdir -p "$(dirname "$STATE")"

empties=$("$AS" list-windows --all --json 2>/dev/null \
  | jq -r '.[] | select(."window-title"=="") | ."window-id"' | sort -u)

prev=$(cat "$STATE" 2>/dev/null)
printf '%s\n' "$empties" > "$STATE"            # remember this check for next time
focused=$("$AS" list-windows --focused --format '%{window-id}' 2>/dev/null | tr -d ' ')

comm -12 <(printf '%s\n' "$empties") <(printf '%s\n' "$prev" | sort -u) \
  | { [ -n "$focused" ] && grep -vx "$focused" || cat; } \
  | while IFS= read -r id; do
      [ -n "$id" ] && "$AS" close --window-id "$id" 2>/dev/null
    done
