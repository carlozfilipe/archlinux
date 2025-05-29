#!/bin/bash

# Executa o build do projeto
echo "----------------------------------"
echo "🚀 Iniciando o build do projeto..."
echo "----------------------------------"
npm run build

# Adiciona todos os arquivos modificados ao stage
echo "-----------------------------------"
echo "➕ Adicionando arquivos ao stage..."
echo "-----------------------------------"
git add .

# Faz o commit das alterações
echo "-------------------------------------"
echo "💾 Fazendo o commit das alterações..."
echo "-------------------------------------"
git commit -m "Add INFO DADOS PUBLICOS"

# Envia as alterações para o repositório remoto na branch atual
echo "---------------------------------------------------"
echo "📤 Enviando alterações para o repositório remoto..."
echo "---------------------------------------------------"
git push origin $(git branch --show-current)

echo "----------------------"
echo "✅ Processo concluído!"
echo "----------------------"
