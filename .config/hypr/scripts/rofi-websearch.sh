#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

ROFI_THEME='
element {
    children: [element-text];
}
window {
    transparency: "real";
    width: 1200px;
}
listview {
    lines: 3;
}
'

rofi -theme-str "$ROFI_THEME" -no-sort -modi blocks -show blocks -blocks-wrap handlers/websearch-history.sh -display-blocks "Web Search:" 2>/dev/null
