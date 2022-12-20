#!/usr/bin/env bash

exec $XDG_CONFIG_HOME/obsidian/Obsidian-1.0.0.AppImage &

alacritty --working-directory /home/local/ -e tmux &

chromium --restore-last-session & # all running instances of chromium MUST be down (pkill chromium)

code-oss &

