#!/bin/bash

# Atualiza os pacotes oficiais
sudo pacman -Syu --noconfirm

# Atualiza os pacotes do AUR
yay -Syu --noconfirm

# Verifica se há pacotes órfãos e remove-os, se existirem
orphans=$(pacman -Qdtq)
if [ -n "$orphans" ]; then
  sudo pacman -Rns $orphans --noconfirm
else
  echo "Nenhum pacote órfão encontrado."
fi

# Limpa o cache do pacman para liberar espaço em disco
sudo pacman -Sc --noconfirm

# Limpa o cache de pacotes que não estão instalados
sudo paccache -ruk0

# Limpa o cache
rm -rf ~/.cache

# Atualiza a base de dados do Pacman
sudo updatedb

echo "Atualização concluída."
