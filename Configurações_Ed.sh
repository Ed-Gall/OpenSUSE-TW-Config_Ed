#!/bin/bash

function print_message() {
    echo -e "\n\033[1;32m$1\033[0m\n"
}

print_message "Atualizando o sistema..."
sudo zypper refresh && sudo zypper update -y

print_message "Adicionando repositórios..."
sudo zypper ar https://repo.vivaldi.com/archive/vivaldi-suse.repo
sudo zypper ar https://download.videolan.org/SuSE/Tumbleweed VLC
sudo zypper ar https://packages.microsoft.com/yumrepos/vscode Microsoft-VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

print_message "Instalando pacotes via zypper..."
sudo zypper install -y vivaldi Telegram alacritty zed code vlc starship arc-theme

print_message "Instalando Flatpaks..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub org.qbittorrent.qBittorrent
flatpak install -y flathub org.bunkus.mkvtoolnix-gui
flatpak install -y flathub io.mrarm.mcpelauncher

print_message "Aplicando temas e ícones..."
mkdir -p ~/.icons ~/.themes
wget -O Tela-Dark.tar.xz https://github.com/vinceliuice/Tela-icon-theme/releases/download/2021.12.24/Tela-Dark.tar.xz
tar -xf Tela-Dark.tar.xz -C ~/.icons
gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Tela-Dark"

print_message "Configurando o Alacritty..."
mkdir -p ~/.config/alacritty
cat <<EOF > ~/.config/alacritty/alacritty.toml
font:
  normal:
    family: "FiraCode Nerd Font"
    style: "Regular"
  bold:
    family: "FiraCode Nerd Font"
    style: "Bold"
  italic:
    family: "FiraCode Nerd Font"
    style: "Light"
  size: 12
EOF

print_message "Configurando o Starship no .bashrc..."
if ! grep -Fxq 'eval "$(starship init bash)"' ~/.bashrc; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
    print_message "Starship adicionado ao .bashrc."
else
    print_message "Starship já está configurado no .bashrc."
fi

print_message "Configuração concluída! Certifique-se de reiniciar ou relogar para aplicar todas as mudanças."
