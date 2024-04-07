#!/usr/bin/env bash
INSTALL_PATH=/usr/share/sddm/themes/sugar-dark
sudo pacman -Suy weston
sudo git clone https://github.com/28Smiles/sddm-sugar-dark.git $INSTALL_PATH
[ getent group sddm-themes ] || sudo groupadd sddm-themes
v sudo usermod -aG sddm-themes "$(whoami)"
sudo chown :sddm-themes $INSTALL_PATH/Background.jpg
sudo chmod 775 $INSTALL_PATH/Background.jpg
sudo chown :sddm-themes $INSTALL_PATH/theme.conf
sudo chmod 664 $INSTALL_PATH/theme.conf

sudo mkdir /etc/sddm.conf.d
sudo bash -c "echo '[General]
DisplayServer=wayland

[Theme]
Current=sugar-dark' > /etc/sddm.conf.d/sugar-dark.conf"
