#!/bin/bash

set -e  # Encerra o script se algum comando falhar

# Instala pacotes base para o yay
sudo pacman -S --needed git base-devel --noconfirm

# Instala yay se ainda não estiver instalado
if ! command -v yay &> /dev/null; then
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# Instala Brave
yay -S brave-bin --noconfirm

# Instala ZSH e complementos
yay -S zsh zsh-completions --noconfirm

# Define o ZSH como shell padrão
chsh -s /bin/zsh

# Instala Oh My Zsh, se ainda não estiver instalado
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Instalando Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Instala o tema Spaceship
THEME_DIR="$HOME/.oh-my-zsh/custom/themes/spaceship-prompt"
if [ ! -d "$THEME_DIR" ]; then
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$THEME_DIR" --depth=1
  ln -sf "$THEME_DIR/spaceship.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
fi

# Instala plugins: syntax-highlighting
PLUGIN_SYNTAX="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [ ! -d "$PLUGIN_SYNTAX" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_SYNTAX"
fi

# Instala plugins: autosuggestions
PLUGIN_AUTOSUGGEST="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$PLUGIN_AUTOSUGGEST" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_AUTOSUGGEST"
fi

# Cria .zshrc se não existir
if [ ! -f "$HOME/.zshrc" ]; then
  cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
fi

# Define o tema spaceship no .zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="spaceship"/' "$HOME/.zshrc"

# Adiciona plugins ao .zshrc
sed -i 's/^plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' "$HOME/.zshrc"

# Adiciona manualmente o source do syntax-highlighting ao final (obrigatório)
grep -qxF 'source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' "$HOME/.zshrc" || echo 'source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$HOME/.zshrc"

echo -e "\n✅ ZSH, Oh My Zsh, tema Spaceship e plugins instalados e configurados!"
echo "🔁 Reinicie o terminal ou digite 'zsh' para começar a usar."
