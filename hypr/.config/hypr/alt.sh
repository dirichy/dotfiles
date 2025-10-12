if hyprctl activewindow -j | jq -e '.class == "kitty"' >/dev/null; then
  hyprctl dispatch sendshortcut CTRL SHIFT,$1,activewindow
else
  hyprctl dispatch sendshortcut CTRL,$1,activewindow
fi
