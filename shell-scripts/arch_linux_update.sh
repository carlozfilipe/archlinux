#!/bin/bash

# Atualiza os repositórios
sudo pacman -Sy

# Atualiza todos os pacotes do sistema
sudo pacman -Su --noconfirm

#Atualiza os pacotes do AUR
yay -Syu --noconfirm

# Remove pacotes órfãos (não necessários)
sudo pacman -Rns --noconfirm $(pacman -Qdtq)

# Limpa o cache do pacman para liberar espaço em disco
sudo pacman -Sc --noconfirm

# Limpa o cache de pacotes que não estão instalados
sudo paccache -ruk0

# Lima o cache
rm -rf ~/.cache

# Atualiza a base de dados do Pacman
sudo updatedb

echo "Atualização concluída."

