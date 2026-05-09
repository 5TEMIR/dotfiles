#!/usr/bin/env bash

name="note"
dir="$HOME/docs/notes/"

terminal_running=$(hyprctl clients | grep $TERMINAL)
client_connecting=$(tmux list-clients)

if [[ -z $terminal_running ]]; then
    ${TERMINAL} -e tmux new-session -As $name -c $dir "zk new inbox --no-input"
    exit 0
fi

if [[ -z $client_connecting ]]; then
    notify-send "Sessionizer" "No connection to tmux"
    exit 0
fi

if ! tmux has-session -t=$name 2> /dev/null; then
    tmux new-session -ds $name -c $dir "zk new inbox --no-input"
fi

tmux run-shell "tmux switch-client -t $name"

current_window=$(hyprctl activewindow | grep -oP "title: \K.*" | head -1)
if [[ $current_window != $TERMINAL ]]; then
    hyprctl dispatch focuswindow "title:$TERMINAL"
fi
