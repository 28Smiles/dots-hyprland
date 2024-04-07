#!/usr/bin/env bash
INSTALL_PATH=/usr/share/sddm/themes/sugar-dark
sudo git clone https://github.com/28Smiles/sddm-sugar-dark.git $INSTALL_PATH
sudo chmod ugo+rw $INSTALL_PATH/Background.jpg
sudo chmod ugo+rw $INSTALL_PATH/theme.conf
sudo mkdir /etc/sddm.conf.d
sudo bash -c "echo '[Theme]
Current=sugar-dark' > /etc/sddm.conf.d/sugar-dark.conf"
