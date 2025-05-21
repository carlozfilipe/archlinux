import os
import pdfkit
from concurrent.futures import ThreadPoolExecutor
import time

def convert_html_to_pdf(html_file, output_folder, options=None):
    """Converte um único arquivo HTML para PDF"""
    try:
        # Configurações padrão
        default_options = {
            'encoding': 'UTF-8',
            'quiet': '',
            'enable-local-file-access': None,  # Permite acesso a arquivos locais
            'no-stop-slow-scripts': None,     # Evita parar scripts lentos
            'javascript-delay': 1000,         # Tempo para carregar JS
            'page-size': 'A4',
            'margin-top': '15mm',
            'margin-right': '15mm',
            'margin-bottom': '15mm',
            'margin-left': '15mm',
        }
        
        # Mescla com opções personalizadas se fornecidas
        if options:
            default_options.update(options)
        
        # Cria o nome do arquivo de saída
        pdf_file = os.path.join(
            output_folder,
            os.path.splitext(os.path.basename(html_file))[0] + '.pdf'
        )
        
        # Verifica se o PDF já existe
        if os.path.exists(pdf_file):
            print(f"PDF já existe: {pdf_file}")
            return
        
        print(f"Convertendo: {html_file} -> {pdf_file}")
        
        # Converte o arquivo
        pdfkit.from_file(
            input=html_file,
            output_path=pdf_file,
            options=default_options
        )
        
        return pdf_file
        
    except Exception as e:
        print(f"Erro ao converter {html_file}: {str(e)}")
        return None

def batch_convert_html_to_pdf(input_folder, output_folder, max_workers=4):
    """Converte todos os arquivos HTML/HTM em um diretório para PDF"""
    # Cria o diretório de saída se não existir
    os.makedirs(output_folder, exist_ok=True)
    
    # Coleta todos os arquivos HTML/HTM
    html_files = []
    for root, _, files in os.walk(input_folder):
        for file in files:
            if file.lower().endswith(('.htm', '.html')):
                html_files.append(os.path.join(root, file))
    
    if not html_files:
        print("Nenhum arquivo HTML/HTM encontrado.")
        return
    
    print(f"Encontrados {len(html_files)} arquivos para conversão.")
    
    # Usa ThreadPool para conversão paralela
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = []
        for html_file in html_files:
            futures.append(
                executor.submit(
                    convert_html_to_pdf,
                    html_file,
                    output_folder
                )
            )
        
        # Aguarda todas as conversões
        for future in futures:
            future.result()
    
    print("Conversão concluída!")

if __name__ == "__main__":
    # Configurações
    input_folder = "/home/carlos/Downloads/Arari/decretos/"
    output_folder = "/home/carlos/Downloads/Arari/decretos_pdf/"
    
    # Opções adicionais (personalize conforme necessário)
    custom_options = {
        'javascript-delay': 2000,  # Aumenta o tempo para páginas com muito JS
        'zoom': 1.2,               # Ajuste de zoom se necessário
    }
    
    print(f"Iniciando conversão de HTML para PDF...")
    start_time = time.time()
    
    batch_convert_html_to_pdf(input_folder, output_folder)
    
    end_time = time.time()
    print(f"Tempo total: {end_time - start_time:.2f} segundos")