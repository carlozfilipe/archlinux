#!/bin/bash

set -e  # Encerra se algum comando falhar

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

# Instala Google Chrome
yay -S google-chrome --noconfirm

# Instala ZSH e complementos
yay -S zsh zsh-completions --noconfirm

# Define o ZSH como shell padrão
chsh -s /bin/zsh

# Instala Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Tema Spaceship
THEME_DIR="$HOME/.oh-my-zsh/custom/themes/spaceship-prompt"
if [ ! -d "$THEME_DIR" ]; then
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$THEME_DIR" --depth=1
  ln -sf "$THEME_DIR/spaceship.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
fi

# Plugins
PLUGIN_SYNTAX="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
[ ! -d "$PLUGIN_SYNTAX" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_SYNTAX"

PLUGIN_AUTOSUGGEST="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
[ ! -d "$PLUGIN_AUTOSUGGEST" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_AUTOSUGGEST"

# Cria .zshrc se não existir
[ ! -f "$HOME/.zshrc" ] && cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

# Aplica tema e plugins
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="spaceship"/' "$HOME/.zshrc"
sed -i 's/^plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' "$HOME/.zshrc"

# Source manual obrigatório para syntax-highlighting
grep -qxF 'source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' "$HOME/.zshrc" || echo 'source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$HOME/.zshrc"

echo -e "\n✅ Tudo instalado e configurado!"
echo "⚠️ Reinicie o terminal ou execute 'zsh' para começar a usar."
