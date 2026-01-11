#!/usr/bin/env bash

set -eu

current_window=$(hyprctl activewindow | grep -oP "class: \K.*" | head -1)

if hyprctl clients | grep -q "class: ${BROWSER}"; then
    # if [[ "$current_window" == "${BROWSER}" ]]; then
    #     tmux display-popup -E "bash -i ~/.local/bin/tmux-sessionizer"
    # else
        hyprctl dispatch focuswindow "class:${BROWSER}"
    # fi
else
    exec "${BROWSER}"
fi
