#!/usr/bin/env bash
set -e

# =========================
# UPDATE
# =========================
sudo dnf upgrade -y

# =========================
# RPM Fusion (necessário)
# =========================
sudo dnf install -y \
 https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
 https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf update -y

# =========================
# BASE DEV
# =========================
sudo dnf install -y \
  git curl stow \
  rust cargo go \
  gcc gcc-c++ make \
  python3 python3-pip \
  imagemagick \
  brightnessctl

# =========================
# HYPRLAND + WAYLAND CORE
# =========================
sudo dnf install -y \
  hyprland \
  waybar \
  wofi \
  foot \
  wl-clipboard \
  grim \
  slurp \
  swappy \
  pipewire \
  wireplumber \
  xdg-desktop-portal-hyprland \
  xdg-desktop-portal \
  polkit \
  polkit-gnome \
  network-manager-applet

# =========================
# DOCKER
# =========================
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# =========================
# ZSH & OH MY ZSH
# =========================
sudo dnf install -y zsh
chsh -s $(which zsh)

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# =========================
# NOCTALIA (Repo Terra)
# =========================
sudo dnf install --nogpgcheck \
  --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

sudo dnf install -y noctalia-shell

# =========================
# DEPENDÊNCIAS OPCIONAIS NOCTALIA
# =========================
sudo dnf install -y \
  cliphist \
  cava \
  wlsunset \
  evolution-data-server

# =========================
# FLATPAK
# =========================
sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Setup Fedora + Hyprland + Noctalia completo"
