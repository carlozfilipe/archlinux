#!/bin/bash

# =============================================================================
# SCRIPT DE MIGRAÇÃO DIRETA DE MONGODB (via Pipe)
#
# Compatível com versões antigas do 'mongodump' (sem --excludeDatabase).
#
# Este script:
# 1. Testa a conexão com a origem e o destino usando 'mongodump'.
# 2. Lista todos os bancos de dados na origem.
# 3. Itera (loop) por cada banco, ignorando 'admin', 'config' e 'local'.
# 4. Migra cada banco de aplicação (um por um) diretamente via pipe
#    (mongodump | mongorestore) sem criar arquivos temporários.
# =============================================================================

# --- CONFIGURAÇÃO ---
# ⚠️ IMPORTANTE: Verifique suas URIs ⚠️

# [CORREÇÃO] Adicione o '?authSource=admin' no final da URI de origem.
# Se 'admin' não funcionar, tente '?authSource=test' (ou o banco onde
# o usuário 'work_mongo_database' foi criado).
SOURCE_URI="mongodb://work_mongo_database:WNQJdX1hdE0T4C_8q7NNf@191.252.113.4:27047/?authSource=admin"

# A URI de destino (root) geralmente usa 'authSource=admin' também.
DEST_URI="mongodb://root_mongoWork:H7sJAJykk9xIBla@181.191.209.174:27017/?authSource=admin"
# --------------------

# Aborta o script imediatamente se qualquer comando falhar
set -e
# Garante que o script aborte se um comando em um pipe falhar
set -o pipefail

# --- FUNÇÃO DE TESTE DE CONEXÃO ---
# Tenta fazer um dump leve para validar a URI e a conexão.
test_connection() {
    local uri_to_test=$1
    # Tenta fazer dump da coleção 'system.version' do banco 'admin'.
    if mongodump --uri="$uri_to_test" --db=admin --collection=system.version --quiet --archive > /dev/null; then
        return 0 # Sucesso
    else
        return 1 # Falha
    fi
}

# --- INÍCIO ---
echo "==============================================="
echo "🚀 Iniciando migração DIRETA de Bancos de Dados (Pipe)"
echo "Data: $(date)"
# Oculta as senhas do log
echo "Origem: ${SOURCE_URI//:*/:****@}"
echo "Destino: ${DEST_URI//:*/:****@}"
echo "==============================================="

# --- 1. TESTE DE CONEXÃO ---
echo "🔍 Testando conexão com servidor antigo..."
if test_connection "$SOURCE_URI"; then
    echo "✅ Conectado ao servidor antigo"
else
    echo "❌ Falha ao conectar ao servidor antigo. Verifique a URI, usuário/senha, ?authSource e regras de firewall."
    exit 1
fi

echo "🔍 Testando conexão com servidor novo..."
if test_connection "$DEST_URI"; then
    echo "✅ Conectado ao servidor novo"
else
    echo "❌ Falha ao conectar ao servidor novo. Verifique a URI, usuário/senha, ?authSource e regras de firewall."
    exit 1
fi

# --- 2. MIGRAÇÃO (BANCO POR BANCO) ---
echo "📦 Obtendo lista de bancos de dados da origem..."

# Detecta qual shell (moderno 'mongosh' ou legado 'mongo') está disponível
shell_cmd=""
if command -v mongosh &> /dev/null; then
    shell_cmd="mongosh"
elif command -v mongo &> /dev/null; then
    shell_cmd="mongo"
else
    echo "❌ Erro: Nem 'mongosh' nem 'mongo' (shell) encontrados no PATH."
    echo "    O script precisa de um deles para listar os bancos de dados."
    exit 1
fi

# Obter a lista de todos os bancos de dados
DB_LIST=$($shell_cmd "$SOURCE_URI" --quiet --eval "print(db.getMongo().getDBNames().join('\n'))")

if [ -z "$DB_LIST" ]; then
    echo "⚠️ Nenhum banco de dados encontrado na origem (ou falha ao listar)."
fi

echo "📦 Iniciando migração direta (banco por banco)..."

# Itera pela lista de bancos de dados
for db_name in $DB_LIST; do
    
    # Remove espaços em branco
    db_name=$(echo "$db_name" | tr -d '[:space:]')

    # Filtrar bancos de sistema
    if [[ "$db_name" == "admin" || "$db_name" == "config" || "$db_name" == "local" ]]; then
        echo "  -> Ignorando banco de sistema: $db_name"
        continue
    fi

    # Se não for um banco de sistema, migra
    echo "  -> Migrando banco: $db_name ..."
    
    # Migra um banco de dados de cada vez via pipe.
    mongodump --uri="$SOURCE_URI" --db="$db_name" --gzip --archive | \
    mongorestore --uri="$DEST_URI" --gzip --archive --drop
    
    echo "     ... $db_name concluído."
done

echo "✅ Migração (dump/restore) concluída com sucesso."
echo "==============================================="
echo "🎉 Migração concluída!"
echo "==============================================="

exit 0