#!/usr/bin/env bash

[ -f $XDG_DATA_HOME/rofi/rofi-bookmarks ] || touch "$XDG_DATA_HOME/rofi/rofi-bookmarks"
BOOKMARKS_FILE="$XDG_DATA_HOME/rofi/rofi-bookmarks"

ROFI_THEME='
element {
    children: [element-text];
}
window {
    transparency: "real";
    width: 400px;
}
element-text {
    padding: 4px 8px;
}
'

selected=$(sed 's/ : .*//' $BOOKMARKS_FILE \
    | rofi -theme-str "$ROFI_THEME" -dmenu -p "Bookmarks:")

[[ -z $selected ]] && exit 0

selected_bookmark=$(rg "^$selected : " $BOOKMARKS_FILE | cut -d':' -f2- | tr -d ' ')
nohup $BROWSER "$selected_bookmark" >/dev/null 2>&1 &

current_window=$(hyprctl activewindow | grep -oP "class: \K.*" | head -1)
if [[ $current_window != $BROWSER ]]; then
    hyprctl dispatch focuswindow "class:$BROWSER"
fi
