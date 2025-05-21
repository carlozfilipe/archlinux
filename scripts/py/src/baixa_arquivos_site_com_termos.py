import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# Domínio base
base_url = "https://administracaopublica.com.br"

# Token de acesso
token = "3684ef3ebb550579561c57466d8c73a7b8025fd1"

# Rotas que você quer visitar
rotas = [
    "/licitacoes-e-contratos/todos-os-acordos",
    "/admpublica/divisao/declaracoes-realizadas",
    "/admpublica/lei-ordinaria", 
    "/admpublica/divisao/declaracoes-realizadas",
    "/admpublica/divisao/declaracoes-recebidas",
    "/admpublica/patrimonio",
    "/admpublica/lei-ordinaria",
    "/admpublica/resolucoes",
    "/admpublica/decreto"
    "/admpublica/diarias-e-legislacao",
    "/admpublica/relacao-das-diarias-dentro-e-fora-estado-e-fora-do-pais",
    "/admpublica/indicacao-do-fiscal-do-contrato"
    "/prestacao-de-contas",
    "/admpublica/relatorio-circunstanciado",
    "/admpublica/parecer-previo"
    "/admpublica/gestao-fiscal",
    "/admpublica/planejamento-estategico",
    "/admpublica/instrumentos-da-gestao-fiscal-e-de-planejamento",
    "/admpublica/relatorio-de-gestao-atividades",
    "/",
    "/",
    "/",
    "/",
    "/",
    "/",
    "/",
    "/",
    "/",
    "/",
    "/",
    "/",

]

# Diretório de downloads
download_dir = os.path.expanduser("~/Downloads")

# Cria o diretório se não existir
if not os.path.exists(download_dir):
    os.makedirs(download_dir)

for rota in rotas:
    # Monta a URL completa com token
    url = f"{base_url}{rota}?token={token}"
    print(f"\nAcessando: {url}")

    try:
        response = requests.get(url)
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"Erro ao acessar {url}: {e}")
        continue

    soup = BeautifulSoup(response.content, 'html.parser')

    # Encontra todos os links
    for link in soup.find_all('a', href=True):
        file_url = urljoin(url, link['href'])

        if file_url.endswith(('.pdf', '.doc', '.docx', '.xls', '.xlsx', '.zip', '.rar')):
            file_name = os.path.basename(file_url)

            if "Declaração" in file_name:
                print(f"Ignorando {file_name} (contém 'Declaração')")
                continue

            file_path = os.path.join(download_dir, file_name)

            print(f"Baixando {file_name}...")
            try:
                with requests.get(file_url, stream=True) as r:
                    r.raise_for_status()
                    with open(file_path, 'wb') as f:
                        for chunk in r.iter_content(chunk_size=8192):
                            f.write(chunk)
                print(f"{file_name} baixado com sucesso!")
            except Exception as e:
                print(f"Erro ao baixar {file_name}: {e}")

print("\nTodos os arquivos foram processados.")
