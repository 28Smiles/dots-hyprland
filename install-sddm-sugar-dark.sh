#!/usr/bin/env bash
INSTALL_PATH=/usr/share/sddm/themes/sugar-dark
sudo git clone https://github.com/28Smiles/sddm-sugar-dark.git $INSTALL_PATH
sudo chmod 775 $INSTALL_PATH/Background.jpg
sudo chmod 775 $INSTALL_PATH/theme.conf
sudo mkdir /etc/sddm.conf.d
sudo bash -c "echo '[Theme]\nCurrent=sugar-dark' > /etc/sddm.conf.d/00.conf"
