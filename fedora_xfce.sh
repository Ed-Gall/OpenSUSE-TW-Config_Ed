#!/bin/bash

function print_message() {
    echo -e "\n\033[1;32m$1\033[0m\n"
}

print_message "Atualizando o sistema..."
sudo dnf upgrade --refresh -y

print_message "Adicionando repositórios..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode

print_message "Instalando pacotes via dnf..."
sudo dnf install -y telegram-desktop git flatpak wine gcc gcc-c++ discord alacritty zed code texlive-scheme-basic steam starship libreoffice \
    gstreamer1 gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugin-openh264 ffmpeg

print_message "Habilitando suporte a Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

print_message "Instalando Flatpaks..."
flatpak install -y flathub com.spotify.Client org.videolan.VLC it.mijorus.gearlever \
    org.qbittorrent.qBittorrent org.bunkus.mkvtoolnix-gui io.mrarm.mcpelauncher

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
