#!/usr/bin/env bash

[ -f $XDG_DATA_HOME/rofi/rofi-websearch-history ] || touch "$XDG_DATA_HOME/rofi/rofi-websearch-history"
HISTORY_FILE="$XDG_DATA_HOME/rofi/rofi-websearch-history"

default_custom_format="{{name_enum}}:{{value}}"
custom_format="${format:-$default_custom_format}"

toLinesJson(){
	echo "$1" | sed -e 's/\\/\\\\/g' -e 's/\"/\\"/g' -e 's/.*/"&"/' | paste -sd ',' -
}

urlEncode() {
    echo -n "$1" | xxd -p | sed 's/../%&/g'
}

TEXT=$(cat <<EOF | tr -d '\n' | tr -d '\t'
{
	"input action":"send",
	"event format":"${custom_format}"
}
EOF
)
printf '%s\n' "$TEXT"

fill_menu(){
	JSON_LINES="$(toLinesJson "$menu")"
	echo "{\"lines\":[${JSON_LINES}]}"
}

while IFS= read -r line; do
    case "$line" in
        "SELECT"*)
            selected=$(echo "$line" | cut -d':' -f2-) && break
            ;;
        "INPUT_CHANGE"*)
            input=$(echo "$line" | cut -d':' -f2-)

            if [[ -z "$input" ]]; then
	            echo "{\"lines\":[]}"
            else
                # urlencode() {
                #     echo ${1// /"%20"}
                # }
                # lang="en"
                # url="http://suggestqueries.google.com/complete/search?client=chrome&hl=$lang&gl=us&q=$(urlencode "$input")"
                # res=$(jq -r '.[1] | .[]' <<< "$(curl -s "$url" &)" | tr -d '"')
                # fzf_history=$(echo "$res" | fzf --filter "$input")

                fzf_history=$(cat "$HISTORY_FILE" | fzf --filter "$input")

                if [[ -z $fzf_history ]]; then
                    menu="$input"
                else
                    menu="$input"$'\n'"$fzf_history"
                fi
                fill_menu
            fi

            ;;
        *)
            break
            ;;
    esac
done

if [[ -n "$selected" ]]; then
    rg -Fxv "$selected" "$HISTORY_FILE" > temp
    mv temp "$HISTORY_FILE"
    printf '%s\n' "$selected" | cat - "$HISTORY_FILE" | head -100 > temp
    mv temp "$HISTORY_FILE"

    $BROWSER "https://www.google.com/search?q=$(urlEncode "$selected")" >> /dev/null &
    hyprctl dispatch focuswindow "class:${BROWSER}" >> /dev/null
    notify-send "Web Search" "$selected" >> /dev/null
else
    notify-send "Web Search" "nothing" >> /dev/null
fi
