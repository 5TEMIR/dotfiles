#!/usr/bin/env bash

[ -f $XDG_DATA_HOME/rofi/rofi-bookmarks ] || touch "$XDG_DATA_HOME/rofi/rofi-bookmarks"
BOOKMARKS_FILE="$XDG_DATA_HOME/rofi/rofi-bookmarks"

NAMES_TEMP=$(mktemp)
sed 's/ : .*//' $BOOKMARKS_FILE > $NAMES_TEMP

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

selected_bookmark_name=$(cat $NAMES_TEMP | rofi -theme-str "$ROFI_THEME" -dmenu -p "Bookmarks:")
rm $NAMES_TEMP

if [[ -n $selected_bookmark_name ]]; then
    selected_bookmark=$(rg -F "$selected_bookmark_name : " $BOOKMARKS_FILE | cut -d':' -f2- | tr -d ' ')
    $BROWSER "$selected_bookmark" >/dev/null
    hyprctl dispatch focuswindow "class:${BROWSER}" >/dev/null
fi
