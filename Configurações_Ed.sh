#!/bin/bash

function print_message() {
    echo -e "\n\033[1;32m$1\033[0m\n"
}

print_message "Atualizando o sistema..."
sudo zypper refresh && sudo zypper update -y

print_message "Adicionando repositórios..."
sudo zypper ar https://repo.vivaldi.com/archive/vivaldi-suse.repo
sudo zypper ar https://packages.microsoft.com/yumrepos/vscode Microsoft-VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper ref

print_message "Instalando pacotes via zypper..."
sudo zypper install -y vivaldi-stable telegram-desktop git flatpak wine gcc gcc-c++ discord alacritty zed code steam starship libreoffice \
                        gstreamer-plugins-bad gstreamer-plugins-ugly ffmpeg

print_message "Instalando VLC."
sudo zypper ar https://download.videolan.org/SuSE/Tumbleweed VLC
sudo zypper mr -r VLC
sudo zypper in vlc

print_message "Instalando Flatpaks..."
flatpak install flathub com.spotify.Client
flatpak install flathub it.mijorus.gearlever
flatpak install flathub org.qbittorrent.qBittorrent
flatpak install flathub org.bunkus.mkvtoolnix-gui
flatpak install flathub io.mrarm.mcpelauncher

print_message "Instalando Tela Icon Theme..."
git clone https://github.com/vinceliuice/Tela-icon-theme
cd Tela-icon-theme
chmod +x install.sh
./install.sh
cd ..
rm -rf Tela-icon-theme

print_message "Configurando o Alacritty..."
mkdir -p ~/.config/alacritty
cat <<EOF > ~/.config/alacritty/alacritty.toml
[font]
size = 12

[font.bold]
family = "FiraCode Nerd Font"
style = "Bold"

[font.italic]
family = "FiraCode Nerd Font"
style = "Light"

[font.normal]
family = "FiraCode Nerd Font"
style = "Regular"

EOF

print_message "Configurando o Starship no .bashrc..."
if ! grep -Fxq 'eval "$(starship init bash)"' ~/.bashrc; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
    print_message "Starship adicionado ao .bashrc."
else
    print_message "Starship já está configurado no .bashrc."
fi

print_message "Configuração concluída!"
