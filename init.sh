#!/bin/bash
sudo su
# waybar hyprland asdf (nodejs, java, csharp, golang) superfile zsh ohmyzsh spaceship kitty https://github.com/th-ch/youtube-music flameshot code flatpak discord  localsend docker docker-compose 

dnf install hyprland waybar zsh kitty flameshot -y

#####DOCKER####
dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

dnf -y install dnf-plugins-core
dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

groupadd docker
usermod -aG docker $USER
newgrp docker

