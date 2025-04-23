#!/bin/bash

echo "Starting environment setup..."

# Install essential packages
echo "Installing zsh and ranger..."
sudo apt update && sudo apt install -y zsh ranger tilix
echo "zsh and ranger installed."

# Copy .zshrc to the home directory
echo "Copying .zshrc to the home directory..."
cp ./terminal/.zshrc ~/
echo ".zshrc copied to $HOME"

# Create .zsh/scripts directory if it doesn't exist
ZSH_SCRIPTS_DIR="$HOME/.zsh/scripts"
if [ ! -d "$ZSH_SCRIPTS_DIR" ]; then
  echo "Creating $ZSH_SCRIPTS_DIR directory..."
  mkdir -p "$ZSH_SCRIPTS_DIR"
else
  echo "$ZSH_SCRIPTS_DIR directory already exists."
fi

# Copy all .zsh scripts to ~/.zsh/scripts
echo "Copying .zsh scripts to $ZSH_SCRIPTS_DIR..."
find ./terminal/scripts -name "*.zsh" -print0 | while IFS= read -r -d $'\0' script; do
  cp "$script" "$ZSH_SCRIPTS_DIR/"
  echo "Copied $script to $ZSH_SCRIPTS_DIR"
done

# Create .fonts directory in $HOME if it doesn't exist
FONTS_DIR="$HOME/.fonts"
if [ ! -d "$FONTS_DIR" ]; then
  echo "Creating $FONTS_DIR directory..."
  mkdir -p "$FONTS_DIR"
else
  echo "$FONTS_DIR directory already exists."
fi

# Unzip all font.zip files from terminal/config-files/fonts into $HOME/.fonts
echo "Unzipping font files into $FONTS_DIR..."
find ./terminal/config-files/fonts -name "font.zip" -print0 | while IFS= read -r -d $'\0' zipfile; do
  echo "Unzipping $zipfile..."
  sudo apt install unzip
  unzip "$zipfile" -d "$FONTS_DIR"
  echo "Unzipped $zipfile to $FONTS_DIR"
done

echo "Environment setup complete!"