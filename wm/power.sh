#!/usr/bin/env bash
 
# add the following binaries to your sudoer's NOPASSWD section -- https://darknesscode.xyz/notes/shutdown-void-linux/?fbclid=IwAR0IWmTLqpQC8Yw8x14J1WiXOGdXRuCothJW9faM1PbS15S17afNXXBiY6U

# assumes screen lock is performed through suspend hook in /etc/zzz.d/suspend/99-user-script
run_dmenu() {
    dmenu -i -fn 'JetBrainsMono Nerd Font:style:regular:size=11' -nb '#232634' -nf '#edeff1' -sb '#edeff1' -sf '#232634' -p "$1"
}

options="lock\nsuspend\nhibernate\nreboot\nshutdown\nexit"
chosen="$(echo -e "$options" | run_dmenu "$1")"

# https://github.com/muennich/physlock/issues/40#issuecomment-247121051
case "$chosen" in
    "") echo "No option chosen";;
    lock) pamixer --mute && /usr/local/bin/physlock -dms;; 
    # suspend) /usr/local/bin/physlock -dms; sudo /usr/bin/zzz;;
    suspend) sudo /usr/bin/zzz;; 
    hibernate) sudo /usr/bin/ZZZ;;
    reboot) sudo /usr/bin/reboot;;
    shutdown) sudo /usr/bin/shutdown -P now;;
esac
