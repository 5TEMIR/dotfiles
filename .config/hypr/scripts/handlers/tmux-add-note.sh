#!/usr/bin/env bash

name="note"
dir="$HOME/docs/notes/"

tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $name -c $dir
    exit 0
fi

if ! tmux has-session -t=$name 2> /dev/null; then
    tmux new-session -ds $name -c $dir "zk new inbox --no-input"
fi

if [[ -z $TMUX ]]; then
    tmux attach -t $name
else
    tmux switch-client -t $name
fi

current_window=$(hyprctl activewindow | grep -oP "title: \K.*" | head -1)
if [[ $current_window != $TERMINAL ]]; then
    hyprctl dispatch focuswindow "title:$TERMINAL"
fi
