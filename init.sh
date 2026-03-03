#!/usr/bin/env bash
set -e

echo "🚀 Iniciando setup completo..."

# =========================
# YAY
# =========================

if ! command -v yay &> /dev/null; then
  echo "📦 Instalando yay..."
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
fi

# =========================
# UPDATE SYSTEM
# =========================

echo "🔄 Atualizando sistema..."
yay -Syu --noconfirm

# =========================
# BASE DEV + TERMINAL TOOLS
# =========================

echo "🛠 Instalando ferramentas base e terminal..."
yay -S --needed --noconfirm \
  stow \
  rust \
  go \
  git \
  curl \
  nodejs \
  npm \
  dotnet-sdk \
  postgresql \
  redis \
  neovim \
  tmux \
  fzf \
  ripgrep \
  btop \
  starship \
  zoxide \
  bat \
  eza \
  jq \
  httpie \
  direnv \
  pre-commit

# =========================
# DOCKER + TUI
# =========================

if ! command -v docker &> /dev/null; then
  echo "🐳 Instalando Docker..."
  yay -S --needed --noconfirm docker docker-compose lazydocker
  sudo systemctl enable --now docker
fi

if ! groups $USER | grep -q docker; then
  sudo usermod -aG docker $USER
fi

# =========================
# DATABASE TOOLS
# =========================

yay -S --needed --noconfirm pgcli

# =========================
# ZSH + OH MY ZSH
# =========================

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💻 Instalando ZSH..."
  yay -S --needed --noconfirm zsh
  chsh -s $(which zsh)

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Starship + Zoxide config
if ! grep -q "starship init" ~/.zshrc; then
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

if ! grep -q "zoxide init" ~/.zshrc; then
  echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
fi

# Aliases
if ! grep -q "alias ls=" ~/.zshrc; then
  echo 'alias ls="eza --icons"' >> ~/.zshrc
fi

# =========================
# HYPRLAND CORE (NOCTALIA)
# =========================

echo "🪟 Instalando Hyprland base..."
yay -S --needed --noconfirm \
  hyprland \
  hyprpaper \
  hyprlock \
  hypridle \
  waybar \
  rofi-wayland \
  kitty \
  swww \
  grim \
  slurp \
  wl-clipboard \
  wl-clipboard-history \
  pipewire \
  wireplumber \
  xdg-desktop-portal-hyprland \
  udiskie \
  power-profiles-daemon

sudo systemctl enable --now power-profiles-daemon

# =========================
# FONTS
# =========================

yay -S --needed --noconfirm \
  ttf-fira-code \
  ttf-nerd-fonts-symbols

# =========================
# DESKTOP SOFTWARE
# =========================

yay -S --needed --noconfirm \
  obs-studio \
  qbittorrent \
  code \
  brave-browser \
  1password \
  flatpak \
  mangohud \
  gamemode

# =========================
# FLATPAK APPS
# =========================

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.valvesoftware.Steam
flatpak install -y flathub app.ytmdesktop.ytmdesktop

# =========================
# RUST TOOL
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
# NOCTALIA INSTALL
# =========================

if [ ! -d "$HOME/noctalia" ]; then
  echo "🌙 Instalando Noctalia..."
  git clone https://github.com/noctalia-dev/noctalia.git
  cd noctalia
  chmod +x install.sh
  ./install.sh
  cd ..
else
  echo "Noctalia já instalado."
fi

echo ""
echo "✅ SETUP COMPLETO FINALIZADO"
echo "⚠️ Reinicie e selecione a sessão Hyprland/Noctalia."
echo "⚠️ Faça logout/login para aplicar grupo docker."
