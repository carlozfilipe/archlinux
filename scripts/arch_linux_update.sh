#!/bin/bash

set -euo pipefail

echo "======================================"
echo " Início da atualização: $(date)"
echo "======================================"

# Atualiza pacotes oficiais
echo ">> Atualizando pacotes oficiais..."
sudo pacman -Syu --noconfirm

# Atualiza pacotes do AUR
if command -v yay &>/dev/null; then
    echo ">> Atualizando pacotes do AUR..."
    yay -Syu --noconfirm
else
    echo ">> yay não encontrado, pulando AUR."
fi

# Remove pacotes órfãos
echo ">> Verificando pacotes órfãos..."
orphans=$(pacman -Qdtq || true)
if [ -n "$orphans" ]; then
    sudo pacman -Rns $orphans --noconfirm
else
    echo "Nenhum pacote órfão encontrado."
fi

# Limpa cache do pacman (mantém 1 versão antiga)
echo ">> Limpando cache do pacman..."
sudo paccache -rk1

# Atualiza base de dados do locate
if command -v updatedb &>/dev/null; then
    echo ">> Atualizando base do locate..."
    sudo updatedb
fi

echo "======================================"
echo " Atualização concluída com sucesso!"
echo "======================================"

