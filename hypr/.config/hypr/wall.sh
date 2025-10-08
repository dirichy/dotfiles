#!/bin/zsh
        hyprctl hyprpaper wallpaper ",~/wallpaper/wallpaper$(hyprctl monitors | grep "active workspace" | sed -E 's/.*workspace: ([0-9]+) .*/\1/').JPG"
