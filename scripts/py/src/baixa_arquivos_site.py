import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# URL do site
# url = "https://administracaopublica.com.br/admpublica/lei-ordinaria?token=e0432f4f88f2e1705ee2ba5e50748896e0606790"
url = "https://www.codo.ma.gov.br/leis"

# Diretório de downloads no Linux
download_dir = os.path.expanduser("~/Downloads")

# Cria o diretório de downloads se não existir
if not os.path.exists(download_dir):
    os.makedirs(download_dir)

# Faz a requisição HTTP para obter o conteúdo da página
response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

# Encontra todos os links na página
for link in soup.find_all('a', href=True):
    file_url = urljoin(url, link['href'])
    
    # Verifica se o link é um arquivo (por exemplo, .pdf, .doc, .zip, etc.)
    if file_url.endswith(('.pdf', '.doc', '.docx', '.xls', '.xlsx', '.zip', '.rar')):
        # Obtém o nome do arquivo a partir da URL
        file_name = os.path.basename(file_url)
        
        # Caminho completo para salvar o arquivo
        file_path = os.path.join(download_dir, file_name)
        
        # Faz o download do arquivo
        print(f"Baixando {file_name}...")
        with requests.get(file_url, stream=True) as r:
            r.raise_for_status()
            with open(file_path, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
        print(f"{file_name} baixado com sucesso!")

print("Todos os arquivos foram baixados.")
