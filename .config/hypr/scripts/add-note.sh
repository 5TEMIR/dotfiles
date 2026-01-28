#!/usr/bin/env bash

current_window=$(hyprctl activewindow | grep -oP "title: \K.*" | head -1)

if hyprctl clients | grep -q "title: ${TERMINAL}"; then
    tmux run-shell "$XDG_CONFIG_HOME/hypr/scripts/handlers/tmux-add-note.sh"
else
    ${TERMINAL} &
    sleep 0.1
    tmux run-shell "$XDG_CONFIG_HOME/hypr/scripts/handlers/tmux-add-note.sh"
fi
