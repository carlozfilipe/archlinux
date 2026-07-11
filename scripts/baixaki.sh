#!/bin/bash

DESTINO="/home/carlos/Downloads/"

echo "=================================================="
echo "   Baixar do YouTube usando yt-dlp"
echo "=================================================="
echo "1) Baixar VÍDEO (MP4 até 1080p)"
echo "2) Baixar ÁUDIO (MP3)"
echo -n "Escolha uma opção (1 ou 2): "
read OPCAO

echo -n "Digite a URL do vídeo: "
read URL

# Criar diretório se não existir
mkdir -p "$DESTINO"

case "$OPCAO" in
    1)
        echo "Baixando VÍDEO em MP4..."
        yt-dlp -f "bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]" \
            --merge-output-format mp4 \
            -o "$DESTINO/%(title)s.%(ext)s" \
            "$URL"
        ;;
    2)
        echo "Baixando ÁUDIO em MP3..."
        yt-dlp -x --audio-format mp3 \
            -o "$DESTINO/%(title)s.%(ext)s" \
            "$URL"
        ;;
    *)
        echo "Opção inválida! Saindo."
        exit 1
        ;;
esac

echo "Download concluído! Arquivo salvo em: $DESTINO"
