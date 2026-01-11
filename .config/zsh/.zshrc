#############
### THEME ###
#############

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme


#############
### INIT ###
#############

zmodload zsh/complist
autoload -U compinit
autoload -U colors && colors

if [[ -z "$TMUX" ]] && command -v tmux &> /dev/null && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]]; then
  exec tmux new-session -A -s main
fi

[ -f "$XDG_CONFIG_HOME/zsh/alias.zsh" ] && source "$XDG_CONFIG_HOME/zsh/alias.zsh"

eval "$(fzf --zsh)"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


###################
### KEYBINDINGS ###
###################

bindkey -e
export KEYTIMEOUT=1
bindkey "^[" vi-cmd-mode
bindkey -M menuselect "^p" vi-up-line-or-history
bindkey -M menuselect "^n" vi-down-line-or-history

###############
### HISTORY ###
###############

[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
HISTFILE="$XDG_STATE_HOME"/zsh/history


##################
### COMPLETION ###
##################

[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ow=01\;34 di=34 tw=34
zstyle ':completion:*' menu select
_comp_options+=(globdots)


###############
### PLUGINS ###
###############

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
