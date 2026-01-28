#!/usr/bin/env bash

if hyprctl clients | grep -q "class: ${BROWSER}"; then
    $XDG_CONFIG_HOME/hypr/scripts/handlers/rofi-bookmarks.sh
else
    nohup $BROWSER >/dev/null 2>&1 &
fi
