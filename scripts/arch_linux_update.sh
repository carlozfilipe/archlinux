#!/bin/bash

# Atualiza pacotes oficiais
sudo pacman -Syu --noconfirm

# Atualiza pacotes do AUR
yay -Syu --noconfirm

# Remove pacotes órfãos
orphans=$(pacman -Qdtq)
if [ -n "$orphans" ]; then
    sudo pacman -Rns $orphans --noconfirm
else
    echo "Nenhum pacote órfão encontrado."
fi

# Limpa cache do pacman (mantém 1 versão antiga)
sudo paccache -rk1

# Atualiza base de dados do locate
sudo updatedb

echo "Atualização concluída."
