if hyprctl activewindow -j | jq -e '.class == "kitty" and (.title | endswith(" - Nvim"))'>/dev/null; then
  hyprctl dispatch sendshortcut CTRL,$1,activewindow
else
  hyprctl dispatch movefocus $(echo "$1"|tr "hjkl" "ldur")
fi
