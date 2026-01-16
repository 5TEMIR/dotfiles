#!/usr/bin/env bash

set -eu

if hyprctl clients | grep -q "class: ${BROWSER}"; then
    $XDG_CONFIG_HOME/hypr/scripts/rofi-bookmarks/rofi-bookmarks.sh
else
    exec "${BROWSER}"
fi
