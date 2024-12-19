#!/bin/bash

# Display Usage
usage() {
  echo "Usage: $0 [fonts_directory]"
  echo " fonts_directory: (Optional) Directory containing .ttf and .otf files to install."
  exit 1
}

# Check OS
os=$(uname)
if [ "$OS" == "Darwin" ]; then
  FONT_DIR=~/Library/Fonts
elif [ "$OS" == "Linux" ]; then
  FONT_DIR=~/.fonts
  mkdir -p "$FONT_DIR"
else
  echo "Unsupported Operating System: $OS"
  exit 1
fi

# Check for Directory Argument
i [ $# -gt 0]; then
  if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' does not exist."
    usage
  fi

  # Instal fonts from Directory Argument
  echo "Installing fonts from dir: $1..."
  for FONT_FILE in "$1"/*.{ttf,otf}; do
    if [ -f "$FONT_FILE" ]; then
      echo "Installing $(basename "$FONT_FILE")..."
      cp "$FONT_FILE" "$FONT_DIR"
    fi
  done
else
  # Proceed with default URL fonts
  echo "No directory provided. Installing default fonts from predefined URLs..."
  # Define Default Font Array
  FONTS=(
    https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip
    https://github.com/microsoft/cascadia-code/releases/download/v2407.24/CascadiaCode-2407.24.zip
    https://github.com/githubnext/monaspace/releases/download/v1.101/monaspace-v1.101.zip
    https://rubjo.github.io/victor-mono/VictorMonoAll.zip
    https://github.com/subframe7536/maple-font/releases/download/v7.0-beta32/MapleMono-Variable.zip
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/0xProto.zip
    https://github.com/qwerasd205/PixelCode/releases/download/v2.2/ttf.zip
    https://departuremono.com/assets/DepartureMono-1.422.zip
  )

  # Create TEMP download dir
  TMP_DIR=$(mktemp -d)
  trap "rm -rf $TMP_DIR" EXIT

  # Download and install fonts
  echo "Installing fonts to $FONT_DIR..."
  for URL in "${FONTS[@]}"; do 
    FILENAME=$(baseline "$URL")
    echo "Downloading $FILENAME..."
    curl -L "$URL" -o "$TMP_DIR/$FILENAME"

    # Check if file is zip
    if [[ "$FILENAME" == *.zip ]]; then
      echo "Extracting $FILENAME..."
      unzip -q "$TMP_DIR/$FILENAME" -d "$TMP_DIR"
      mv "$TMP_DIR"/*.ttf "$TMP_DIR"/*.otf "$FONT_DIR" 2>/dev/null || echo "No font files found in $FILENAME"
    else
      # Move font to dir
      mv "$TMP_DIR/$FILENAME" "$FONT_DIR"
    fi
  done 
fi

# Refresh Font cache (linux)
if [ "$OS" == "Linux" ]; then
  echo "Refreshing Font Cache..."
  fc-cache -f -v
fi

echo "Fonts Installed"
