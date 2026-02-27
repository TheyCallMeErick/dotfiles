#!/usr/bin/env bash
set -e

# =========================
# YAY
# =========================

if ! command -v yay &> /dev/null
then
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
fi

# =========================
# UPDATE
# =========================

yay -Syu --noconfirm

# =========================
# BASE DEV
# =========================

yay -S --noconfirm \
  stow \
  rust \
  go \
  git \
  curl

# =========================
# DOCKER
# =========================

if ! command -v docker &> /dev/null
then
  yay -S --noconfirm docker docker-compose
  sudo systemctl enable --now docker
fi

if ! groups $USER | grep -q docker; then
  sudo usermod -aG docker $USER
fi

# =========================
# ZSH & OH MY ZSH
# =========================

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  yay -S --noconfirm zsh
  chsh -s $(which zsh)

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# =========================
# FONTS
# =========================

yay -S --noconfirm \
  ttf-fira-code \
  ttf-nerd-fonts-symbols

# =========================
# SOFTWARES
# =========================

yay -S --noconfirm \
  obs-studio \
  qbittorrent \
  code \
  brave-browser \
  clipse \
  1password \
  flatpak

# =========================
# FLATPAK APPS
# =========================

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.valvesoftware.Steam
flatpak install -y flathub app.ytmdesktop.ytmdesktop

# =========================
# CLIPVAULT
# =========================

if ! command -v clipvault &> /dev/null; then
  cargo install clipvault --locked
fi

# =========================
# GO TOOL
# =========================

if ! command -v lazysql &> /dev/null; then
  go install github.com/jorgerojas26/lazysql@latest
fi

# =========================
# GIT CONFIG
# =========================

git config --global user.name "TheyCallMeErick"
git config --global user.email "azeve.erick@gmail.com"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"

# =========================
# HYDE INSTALL
# =========================

if [ ! -d "$HOME/HyDE" ]; then
  echo "Instalando HyDE..."
  git clone https://github.com/HyDE-Project/HyDE.git
  cd HyDE
  chmod +x install.sh
  ./install.sh
  cd ..
else
  echo "HyDE já está instalado."
fi

echo "Setup completo"
