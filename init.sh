#!/usr/bin/env bash
set -e

echo "🚀 Iniciando setup Fedora + Hyprland..."

# =========================
# SYSTEM UPDATE
# =========================

sudo dnf upgrade -y

# =========================
# RPM FUSION
# =========================

sudo dnf install -y \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf update -y

# =========================
# BASE DEV
# =========================

sudo dnf install -y \
git curl wget stow \
neovim tmux fzf ripgrep fd \
btop jq unzip \
gcc gcc-c++ make cmake ninja-build \
nodejs npm \
rust cargo \
golang \
dotnet-sdk-8.0 \
postgresql-server postgresql \
redis \
zsh \
starship \
zoxide \
bat \
eza \
direnv \
pre-commit

# =========================
# DOCKER
# =========================

sudo dnf install -y \
docker \
docker-compose-plugin

sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# =========================
# DATABASE TOOLS
# =========================

sudo dnf install -y pgcli

# =========================
# TERMINAL
# =========================

sudo dnf install -y kitty

# =========================
# WAYLAND / HYPRLAND
# =========================

sudo dnf install -y \
hyprland \
waybar \
rofi-wayland \
hyprpaper \
hyprlock \
hypridle \
grim \
slurp \
wl-clipboard \
pipewire \
wireplumber \
xdg-desktop-portal-hyprland \
brightnessctl \
playerctl \
network-manager-applet \
blueman \
udiskie

# =========================
# DISPLAY MANAGEMENT
# =========================

sudo dnf install -y \
kanshi \
wdisplays \
wlr-randr

# =========================
# FONTS
# =========================

sudo dnf install -y \
fira-code-fonts \
google-noto-fonts \
google-noto-emoji-fonts

# =========================
# BROWSERS
# =========================

sudo dnf install -y \
brave-browser

# =========================
# FLATPAK
# =========================

sudo dnf install -y flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub \
com.discordapp.Discord \
app.ytmdesktop.ytmdesktop \
com.valvesoftware.Steam \
com.usebottles.bottles

# =========================
# GAMING
# =========================

sudo dnf install -y \
steam \
wine \
winetricks \
gamemode \
mangohud

# =========================
# LAZYVIM
# =========================

if [ ! -d "$HOME/.config/nvim" ]; then
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
fi

# =========================
# ZSH + OH MY ZSH
# =========================

if [ ! -d "$HOME/.oh-my-zsh" ]; then

RUNZSH=no \
CHSH=no \
KEEP_ZSHRC=yes \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

fi

git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true

# =========================
# SHELL CONFIG
# =========================

grep -qxF 'eval "$(starship init zsh)"' ~/.zshrc || echo 'eval "$(starship init zsh)"' >> ~/.zshrc
grep -qxF 'eval "$(zoxide init zsh)"' ~/.zshrc || echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
grep -qxF 'alias ls="eza --icons"' ~/.zshrc || echo 'alias ls="eza --icons"' >> ~/.zshrc

# =========================
# ASDF
# =========================

if [ ! -d "$HOME/.asdf" ]; then

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc

fi

source "$HOME/.asdf/asdf.sh"

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
asdf plugin add java https://github.com/halcyon/asdf-java.git || true
asdf plugin add dotnet https://github.com/hensou/asdf-dotnet.git || true
asdf plugin add php https://github.com/asdf-community/asdf-php.git || true

asdf install nodejs latest
asdf global nodejs latest

asdf install java latest
asdf global java latest

asdf install dotnet latest
asdf global dotnet latest

asdf install php latest
asdf global php latest

# =========================
# FLUTTER
# =========================

if [ ! -d "$HOME/flutter" ]; then

git clone https://github.com/flutter/flutter.git -b stable ~/flutter

echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc

fi

# =========================
# ANDROID SDK
# =========================

sudo dnf install -y \
android-tools

mkdir -p $HOME/Android/Sdk

echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc

# =========================
# DOTFILES STRUCTURE
# =========================

mkdir -p ~/dotfiles

cd ~/dotfiles

mkdir -p \
hypr \
waybar \
rofi \
kitty \
zsh

echo "📁 Estrutura de dotfiles criada em ~/dotfiles"

# =========================
# WAYBAR CONFIG BASE
# =========================

mkdir -p ~/.config/waybar

cat <<EOF > ~/.config/waybar/config
{
 "layer": "top",
 "position": "top",
 "modules-left": ["hyprland/workspaces"],
 "modules-center": ["clock"],
 "modules-right": ["pulseaudio","network","cpu","memory","tray"]
}
EOF

# =========================
# ROFI STYLE (HYDE LIKE)
# =========================

mkdir -p ~/.config/rofi

cat <<EOF > ~/.config/rofi/config.rasi
configuration {
    show-icons: true;
    display-drun: "Apps";
}

@theme "gruvbox-dark"
EOF

# =========================
# HYPRLAND BASE CONFIG
# =========================

mkdir -p ~/.config/hypr

cat <<EOF > ~/.config/hypr/hyprland.conf
exec-once = waybar
exec-once = hyprpaper
exec-once = kanshi
exec-once = nm-applet
exec-once = blueman-applet

bind = SUPER, RETURN, exec, kitty
bind = SUPER, SPACE, exec, rofi -show drun
bind = SUPER, Q, killactive
bind = SUPER, E, exec, thunar
EOF

echo ""
echo "✅ SETUP FINALIZADO"
echo ""
echo "⚠️ Reinicie o sistema"
echo "⚠️ Depois execute:"
echo "flutter doctor"
