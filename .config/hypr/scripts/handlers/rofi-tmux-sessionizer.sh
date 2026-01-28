#!/usr/bin/env bash

ROFI_THEME='
element {
    children: [element-text];
}
window {
    transparency: "real";
    width: 600px;
}
listview {
    lines: 10;
}
element-text {
    padding: 4px 8px;
}
'

SEARCH_DIRS=(
    $HOME/devel/repos/
    $HOME/devel/learn/
    $HOME/devel/study/
    $HOME/devel/scratch/
    $HOME/.config/
    $HOME/.local/
)

ONE_DIRS=(
    $HOME/docs/reports/
    $HOME/docs/notes/
)

SPECIAL_DIRS=(
    $HOME/docs/reports/
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    combined_dirs=($(fd . "${SEARCH_DIRS[@]}" -d 1 -t d))
    combined_dirs+=("${ONE_DIRS[@]}")

    selected=$(
        printf '%s\n' "${combined_dirs[@]}" \
        | sed "s|^$HOME/||" \
        | rofi -theme-str "$ROFI_THEME" -dmenu -p ">"
    )
    [[ -z $selected ]] && exit 0
fi

selected="$HOME/$selected"
selected_name=$(basename "$selected" | tr . _)

if printf '%s\n' "${SPECIAL_DIRS[@]}" | rg -Fxq -- "$selected"; then
    selected_dir=$(fd . $selected -d 1 -t d \
        | sed "s|^$HOME/||" \
        | rofi -theme-str "$ROFI_THEME" -dmenu -p ">"
    )
    [[ -z $selected_dir ]] && exit 0
else
    selected_dir=$selected
fi

tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected_dir
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected_dir
fi

if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
fi

current_window=$(hyprctl activewindow | grep -oP "title: \K.*" | head -1)
if [[ $current_window != $TERMINAL ]]; then
    hyprctl dispatch focuswindow "title:$TERMINAL"
fi
