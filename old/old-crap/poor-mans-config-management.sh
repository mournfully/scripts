#!/bin/bash

timer_start=`date +%s.%N`
configs_dir="config"
scripts_dir="bin"
ssh_dir=".ssh"

### SHORTCUTS ###
find /home/$USER/ -maxdepth 1 -xtype l -delete 
ln -snf /data/dotfiles/ /home/$USER/
ln -snf /data/precursor/wiki/ /home/$USER/


### CONFIGS ###
ln -snf /data/dotfiles/$configs_dir/.xinitrc /home/$USER/
ln -snf /data/dotfiles/$configs_dir/.bashrc /home/$USER/


# vim (editor)
ln -snf /data/dotfiles/$configs_dir/.vimrc /home/$USER/.vimrc


# fonts (must be manually configured on void linux) 
# global_fonts=+( 10-sub-pixel-rgb.conf 70-no-bitmaps.conf ) 
# for i in ${global_fonts[@]}; do
#     sudo ln -s /usr/share/fontconfig/conf.avail/$i /etc/fonts/conf.d/
# done

# user_fonts=+( 10-hinting-slight.conf 10-sub-pixel-rgb.conf 50-user.conf 60-latin.conf 70-no-bitmaps.conf )
# for i in ${user_fonts[@]}; do
#    sudo ln -s /usr/share/fontconfig/conf.avail/$i /home/$USER/.config/fontconfig/conf.d/
# done

# sudo ln -snf /data/dotfiles/config/.Xresources /home/$USER/
# sudo ln -snf /data/dotfiles/config/freetype2.sh /etc/profile.d/


# dunst (notification manager)
# mkdir -p /home/$USER/.config/dunst/
# ln -snf /data/dotfiles/$configs_dir/dunstrc/ /home/$USER/.config/dunst/


# alacritty (terminal emulator)
mkdir -p /home/$USER/.config/alacritty/
ln -snf /data/dotfiles/$configs_dir/alacritty.yml /home/$USER/.config/alacritty/


# tmux (terminal multiplexer)
# mkdir -p /home/$USER/.config/tmux
ln -snf /data/dotfiles/$configs_dir/.tmux.conf /home/$USER/


# bin (custom scripts)
# https://opensource.com/article/18/5/you-dont-know-bash-intro-bash-arrays
# sudo chown local:local /usr/local/bin
cd /data/dotfiles/$scripts_dir/
scripts_name=() && mapfile -t scripts_name < <( ls --ignore="." --ignore=".." | awk -F '.' '{print $2}' ) && scripts_name_counter=$(echo ${!scripts_name[@]} | awk '{print $NF}')
base_scripts_name=() && mapfile -t base_scripts_name < <( ls --ignore="." --ignore=".." ) && base_scripts_name_counter=$(echo ${!base_scripts_name[@]} | awk '{print $NF}')
if [ $scripts_name_counter == $base_scripts_name_counter ]; then
    find /usr/local/bin/ -maxdepth 1 -xtype l -delete
    for i in ${!scripts_name[@]}; do
        ln -snf /data/dotfiles/$scripts_dir/${base_scripts_name[$i]} /usr/local/bin/${scripts_name[$i]}
    done
else
    echo "invalid script name found in /data/dotfiles/$script_dir"
fi


### BACKUPS ###
# ssh (config & public/private keys) 
# mkdir -p /home/$USER/.ssh/
# cd /data/dotfiles/$ssh_dir/
# cp `ls | grep -v 'config'` /home/$USER/.ssh/
cd /home/$USER/.ssh/
cp $(ls | grep -v 'config\|known_hosts\|known_hosts.old') /data/dotfiles/$ssh_dir/
ln -snf /data/dotfiles/$ssh_dir/config /home/$USER/.ssh/


# vscode (code editor)
# cat /data/dotfiles/vscode/extensions.txt | xargs -n 1 code --install-extension
# mkdir -p /home/$USER/.config/Code/User/
# https://superuser.com/questions/1080682/how-do-i-back-up-my-vs-code-settings-and-list-of-installed-extensions
# code --list-extensions >> /home/local/dotfiles/vscode/extensions.txt
# ln -snf /home/local/dotfiles/vscode/keybindings.json /home/$USER/.config/Code/User/
# ln -snf /home/local/dotfiles/vscode/settings.json /home/$USER/.config/Code/User/


# backing up misc configs
# sudo cp /etc/sudoers /data/dotfiles/$configs_dir/
# - sudo usermod -aG wheel local
# - "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
# cp /etc/default/grub /data/dotfiles/$configs_dir/


timer_end=`date +%s.%N`
echo "finished in $(echo "$timer_end - $timer_start" | bc -l) seconds"
