# Montagem de HD externo no Linux

Inicialmente deve-se montar o HD com o seguinte comando:
```
sudo mkdir -p /run/media/carlos/Dados  
```

Após a montagem deve-se criar a montagem com o seguinte comando:
```
sudo mount -t ntfs3 -o force,uid=carlos,gid=carlos /dev/sda1 /run/media/carlos/Dados
```

