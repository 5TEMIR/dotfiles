#!/usr/bin/env bash

if hyprctl clients | grep -q "title: ${TERMINAL}"; then
    tmux run-shell "$XDG_CONFIG_HOME/hypr/scripts/handlers/rofi-tmux-sessionizer.sh"
else
    ${TERMINAL} &
fi
