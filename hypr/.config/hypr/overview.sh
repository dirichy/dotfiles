if [ -z "$1" ]; then
  hyprctl dispatch hyprexpo:expo off 
  exit 0
fi
if hyprctl activeworkspace -j | jq -e ".id == $1">/dev/null; then
  hyprctl dispatch hyprexpo:expo off 
else
  hyprctl dispatch workspace $1
fi
