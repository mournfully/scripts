#!/usr/bin/env bash
# https://github.com/jdpedersen1/scripts/blob/main/dmenu/edit_configs.sh

options=("alacritty
chezmoi
dwm
nvim
statusbar
sxhkd
tmux
xresources
zshrc
zshenv
quit")

choice="$(echo -e "${options[@]}" | fzf --prompt="Select a File : " --border=rounded --margin=5% --color=dark --height 100% --reverse --header="           CONFIGS " --info=hidden --header-first)"

case "$choice" in
    quit) echo "Program terminated." && exit 1 ;;
    alacritty) choice="${XDG_CONFIG_HOME}/alacritty/alacritty.yml" ;;
		chezmoi) choice="~/.local/share/chezmoi/" ;;
    dwm) choice="${XDG_CONFIG_HOME}/dwm/config.h" ;;
		nvim) choice="${XDG_CONFIG_HOME}/nvim/init.vim" ;;
    statusbar) choice="$HOME/.local/bin/dwm/config" ;;
		sxhkd) choice="${XDG_CONFIG_HOME}/sxhkd/sxhkdrc" ;;
    tmux) choice="${XDG_CONFIG_HOME}/tmux/tmux.conf" ;;
    xresources) choice="${XDG_CONFIG_HOME}/X11/.Xresources" ;;
    zshrc) choice="${XDG_CONFIG_HOME}/zsh/.zshrc" ;;
    zshenv) choice="$HOME/.zshenv" ;;
    *) exit 1 ;;
esac

devour alacritty -e nvim -u "${XDG_CONFIG_HOME}/nvim/init.vim" "$choice"
