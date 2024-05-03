#!/bin/bash

# Atualiza os pacotes oficiais
sudo pacman -Syu --noconfirm

# Atualiza os pacotes do AUR
yay -Syu --noconfirm

# Remove pacotes órfãos (não necessários)
sudo pacman -Rns $(pacman -Qdtq) --noconfirm

# Limpa o cache do pacman para liberar espaço em disco
sudo pacman -Sc --noconfirm

# Limpa o cache de pacotes que não estão instalados
sudo paccache -ruk0

# Lima o cache
rm -rf ~/.cache

# Atualiza a base de dados do Pacman
sudo updatedb

echo "Atualização concluída."

