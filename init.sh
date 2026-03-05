#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive
export CI=true

echo "🚀 Iniciando setup automático..."

# =========================
# YAY
# =========================

if ! command -v yay &> /dev/null; then
  sudo pacman -S --needed --noconfirm base-devel git

  git clone --depth 1 https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
fi

# =========================
# UPDATE SYSTEM
# =========================

yay -Syu --noconfirm

# =========================
# BASE DEV
# =========================

yay -S --needed --noconfirm \
stow rust go git curl nodejs npm \
dotnet-sdk postgresql redis \
neovim tmux fzf ripgrep btop \
starship zoxide bat eza jq httpie \
direnv pre-commit unzip fd \
base-devel cmake ninja

# =========================
# DOCKER
# =========================

yay -S --needed --noconfirm \
docker docker-compose lazydocker

sudo systemctl enable --now docker || true
sudo usermod -aG docker $USER || true

# =========================
# DATABASE
# =========================

yay -S --needed --noconfirm pgcli

# =========================
# ZSH
# =========================

yay -S --needed --noconfirm zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then

RUNZSH=no \
CHSH=no \
KEEP_ZSHRC=yes \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

fi

git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true

git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true

# =========================
# SHELL CONFIG
# =========================

grep -qxF 'eval "$(starship init zsh)"' ~/.zshrc || echo 'eval "$(starship init zsh)"' >> ~/.zshrc
grep -qxF 'eval "$(zoxide init zsh)"' ~/.zshrc || echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
grep -qxF 'alias ls="eza --icons"' ~/.zshrc || echo 'alias ls="eza --icons"' >> ~/.zshrc

# =========================
# HYPRLAND
# =========================

yay -S --needed --noconfirm \
hyprland hyprpaper hyprlock hypridle \
waybar rofi-wayland kitty swww \
grim slurp wl-clipboard \
pipewire wireplumber \
xdg-desktop-portal-hyprland \
udiskie power-profiles-daemon

sudo systemctl enable --now power-profiles-daemon || true

# =========================
# FONTS
# =========================

yay -S --needed --noconfirm \
ttf-fira-code \
ttf-nerd-fonts-symbols \
noto-fonts \
noto-fonts-emoji

# =========================
# DESKTOP SOFTWARE
# =========================

yay -S --needed --noconfirm \
obs-studio \
qbittorrent \
visual-studio-code-bin \
brave-browser \
vivaldi \
1password \
flatpak \
mangohud \
gamemode

# =========================
# GAMING
# =========================

yay -S --needed --noconfirm \
steam \
wine \
wine-gecko \
wine-mono \
winetricks

# =========================
# FLATPAK
# =========================

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub app.ytmdesktop.ytmdesktop

# =========================
# LAZYVIM
# =========================

if [ ! -d "$HOME/.config/nvim" ]; then
git clone --depth 1 https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
fi

# =========================
# ASDF
# =========================

if [ ! -d "$HOME/.asdf" ]; then
git clone --depth 1 https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

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
git clone --depth 1 https://github.com/flutter/flutter.git -b stable ~/flutter

grep -qxF 'export PATH="$PATH:$HOME/flutter/bin"' ~/.zshrc || \
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
fi

# =========================
# ANDROID SDK
# =========================

yay -S --needed --noconfirm \
android-sdk \
android-sdk-platform-tools \
android-sdk-build-tools \
android-sdk-cmdline-tools-latest

grep -qxF 'export ANDROID_HOME=$HOME/Android/Sdk' ~/.zshrc || \
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.zshrc

grep -qxF 'export PATH=$PATH:$ANDROID_HOME/platform-tools' ~/.zshrc || \
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc

grep -qxF 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' ~/.zshrc || \
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.zshrc

export ANDROID_HOME=$HOME/Android/Sdk

yes | sdkmanager --licenses

sdkmanager \
"platform-tools" \
"platforms;android-34" \
"build-tools;34.0.0"

# =========================
# HYDE
# =========================

if [ ! -d "$HOME/HyDE" ]; then
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
cd ~/HyDE
chmod +x install.sh
yes | ./install.sh
cd ~
fi

echo ""
echo "✅ SETUP AUTOMÁTICO FINALIZADO"
echo ""
echo "⚠️ Reinicie o sistema."
echo "⚠️ Após login execute:"
echo "flutter doctor"
