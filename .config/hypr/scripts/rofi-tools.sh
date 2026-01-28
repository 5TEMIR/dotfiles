#!/usr/bin/env bash

[ -f $XDG_DATA_HOME/rofi/rofi-bookmarks ] || touch "$XDG_DATA_HOME/rofi/rofi-bookmarks"
BOOKMARKS_FILE="$XDG_DATA_HOME/rofi/rofi-bookmarks"

ROFI_THEME='
element {
    children: [element-text];
}
window {
    transparency: "real";
    width: 250px;
}
listview {
    lines: 2;
}
element-text {
    padding: 4px 8px;
}
'

menu_dialog="add bookmark\nremove bookmark"

selected=$(echo -e $menu_dialog | rofi -theme-str "$ROFI_THEME" -dmenu -p ">")

add_bookmark(){
    ROFI_THEME='
    mainbox {
        children: [inputbar];
    }
    '
    hyprctl dispatch focuswindow "class:${BROWSER}" 2>/dev/null
    hyprctl dispatch sendshortcut ",escape," 2>/dev/null
    hyprctl dispatch sendshortcut ",escape," 2>/dev/null
    hyprctl dispatch sendshortcut ",Y," 2>/dev/null
    hyprctl dispatch sendshortcut ",Y," 2>/dev/null
    sleep 0.1
    url=$(wl-paste)
    added=$(sed 's/.* : //' $BOOKMARKS_FILE | rg -Fx "$url")
    if [[ -n "$added" ]]; then
        notify-send "Bookmarks" "Already bookmarked"
    else
        name_bookmark=$(rofi -theme-str "$ROFI_THEME" -dmenu -p "Bookmark name:")
        if [[ -n $name_bookmark ]]; then
            echo "$name_bookmark : $url" >> $BOOKMARKS_FILE
            notify-send "Bookmarks" "Bookmark added"
        else
            notify-send "Bookmarks" "Bookmark not added"
        fi
    fi
}

remove_bookmark(){
    ROFI_THEME='
    element {
        children: [element-text];
    }
    element-text {
        padding: 4px 8px;
    }
    '

    selected_bookmark_name=$(sed 's/ : .*//' $BOOKMARKS_FILE | rofi -theme-str "$ROFI_THEME" -dmenu -p "Bookmarks:")

    if [[ -n "$selected_bookmark_name" ]]; then
        rg -Fv "$selected_bookmark_name : " $BOOKMARKS_FILE > temp
        mv temp $BOOKMARKS_FILE
        notify-send "Bookmark removed" "$selected_bookmark_name"
    fi
}


case "$selected" in
    "add bookmark" ) add_bookmark;;
    "remove bookmark" ) remove_bookmark;;
esac
