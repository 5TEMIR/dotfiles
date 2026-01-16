#!/usr/bin/env bash

set -eu

current_window=$(hyprctl activewindow | grep -oP "title: \K.*" | head -1)

if hyprctl clients | grep -q "title: ${TERMINAL}"; then
    if [[ "$current_window" == "${TERMINAL}" ]]; then
        tmux display-popup -E "~/.local/bin/tmux-sessionizer"
    fi
else
    exec "${TERMINAL}"
fi
