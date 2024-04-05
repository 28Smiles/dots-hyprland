#!/usr/bin/env bash
sudo pacman -Suy firefox code docker docker-compose
sudo systemctl enable docker.socket
sudo systemctl start docker.socket
yay -Suy thorium-browser intellij-idea-ultimate-edition spotifyd spotify-qt lazydocker discord_arch_electron
