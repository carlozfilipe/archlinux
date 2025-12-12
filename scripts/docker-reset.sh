#!/bin/bash

echo "🚨 Parando todos os containers..."
docker stop $(docker ps -aq) 2>/dev/null

echo "🗑️ Removendo todos os containers..."
docker rm $(docker ps -aq) 2>/dev/null

echo "🧹 Removendo todas as imagens..."
docker rmi $(docker images -q) 2>/dev/null

echo "🔄 Limpando volumes e redes não usados..."
docker system prune -a --volumes -f

echo "✅ Docker zerado!"
