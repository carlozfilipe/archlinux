# Desabilitar o gnome-keyring

#### Google Chrome

 Crie o arquivo:

```jsx
vim ~/.config/chrome-flags.conf  
```

Adicione o seguinte no arquivo:

```jsx
--password-store=basic
```

VSCode

Edite ou crie o arquivo: 

```jsx
vim ~/.vscode/argv.json
```

Adicione dentro do json o seguinte:

```jsx
// Remove gnome-keyring password store support, as it is not working properly on some systems
  "password-store": "basic"
```
