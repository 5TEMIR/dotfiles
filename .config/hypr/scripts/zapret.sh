#!/usr/bin/env bash

running=$(systemctl status zapret.service | rg "running")

if [[ -z $running ]]; then
    sudo systemctl start zapret.service
    notify-send "Zapret" "Service start"
else
    sudo systemctl stop zapret.service
    notify-send "Zapret" "Service stopped"
fi
