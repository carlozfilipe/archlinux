import os
import re
from bs4 import BeautifulSoup
import fitz  # PyMuPDF

def decode_file_content(file_path):
    """Tenta ler o arquivo com diferentes codificações"""
    encodings = ['utf-8', 'iso-8859-1', 'windows-1252', 'cp1252']
    
    for encoding in encodings:
        try:
            with open(file_path, 'r', encoding=encoding) as f:
                return f.read()
        except UnicodeDecodeError:
            continue
    
    with open(file_path, 'rb') as f:
        return f.read().decode('utf-8', errors='ignore')

def extract_text_from_pdf(file_path):
    """Extrai texto de um arquivo PDF usando PyMuPDF"""
    text = ""
    try:
        with fitz.open(file_path) as doc:
            for page in doc:
                text += page.get_text()
    except Exception as e:
        print(f"Erro ao ler PDF {file_path}: {str(e)}")
    return text

def search_in_files(directory, search_terms, case_sensitive=False):
    flags = 0 if case_sensitive else re.IGNORECASE
    pattern = re.compile('|'.join(search_terms), flags)
    
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            text = ""
            is_valid = False

            if file.lower().endswith(('.htm', '.html')):
                try:
                    content = decode_file_content(file_path)
                    soup = BeautifulSoup(content, 'html.parser')
                    text = soup.get_text()
                    is_valid = True
                except Exception as e:
                    print(f"Erro ao processar HTML {file_path}: {str(e)}")

            elif file.lower().endswith('.pdf'):
                text = extract_text_from_pdf(file_path)
                is_valid = True

            if is_valid and text:
                matches = pattern.findall(text)
                if matches:
                    unique_matches = set(matches)
                    print(f"\nArquivo: {file_path}")
                    print(f"Termos encontrados: {', '.join(unique_matches)}")

                    lines = text.split('\n')
                    for i, line in enumerate(lines):
                        if pattern.search(line):
                            print(f"Linha {i+1}: {line.strip()}")

if __name__ == "__main__":
    directory = "/home/carlos/Documents/PM_ARARI/decretos"
    search_terms = ["Apae", "apae", "APAE"]
    
    print(f"Pesquisando por {search_terms} em {directory}...")
    search_in_files(directory, search_terms)
