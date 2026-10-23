# Scripts Windows 11

Clique no menu Iniciar, digite CMD (ou PowerShell), clique com o botão direito nele e selecione "Executar como Administrador".

PASSO 1 (A Fábrica): Cole o comando do DISM abaixo para reparar a imagem base do Windows e pressione Enter. Aguarde o processo chegar em 100% (pode demorar alguns minutos): 

```powershell
DISM.exe /Online /Cleanup-image /Restorehealth
```

PASSO 2 (O Pedreiro): Logo após o término do DISM, cole o comando do SFC abaixo para corrigir os arquivos que estão rodando no sistema e pressione Enter: 

```powershell
sfc /scannow
```