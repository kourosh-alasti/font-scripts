#!/bin/bash
shopt -s globstar

# Enable colors
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
BOLD="\033[1m"
RESET="\033[0m"

# Get Script directory
SCRIPT_DIR=$(dirname "$(realpath "$0")")
TMP_DIR="$SCRIPT_DIR/.tmp"

# Create temp folder
mkdir -p "$TMP_DIR"

# Display Usage
usage() {
  printf "${BOLD}${BLUE}Usage:${RESET} $0 [fonts_directory]\n"
  printf "${YELLOW}fonts_directory:${RESET} (Optional) Directory containing .ttf and .otf files to install.\n"
  exit 1
}

printf "${BOLD}${BLUE}=== Font Installer Script ===${RESET}\n"
printf "${YELLOW}Temp Directory:${RESET} $TMP_DIR\n"

# Check OS
OS=$(uname)
if [ "$OS" == "Darwin" ]; then
  FONT_DIR=~/Library/Fonts
elif [ "$OS" == "Linux" ]; then
  FONT_DIR=~/.fonts
  mkdir -p "$FONT_DIR"
else
  printf "${RED}Unsupported Operating System: $OS${RESET}\n"
  exit 1
fi

# Check for Directory Argument
if [ $# -gt 0 ]; then
  if [ ! -d "$1" ]; then
    printf "${RED}Error:${RESET} Directory '$1' does not exist.\n"
    usage
  fi

  # Install fonts from Directory Argument
  printf "${YELLOW}Installing fonts from directory: ${RESET}$1...\n"
  for FONT_FILE in "$1"/*.{ttf,otf}; do
    if [ -f "$FONT_FILE" ]; then
      printf "${YELLOW}Installing ${RESET}${BOLD}$(basename "$FONT_FILE")${RESET}...\n"
      cp "$FONT_FILE" "$FONT_DIR" && printf "${GREEN}Successfully installed $(basename "$FONT_FILE")${RESET}\n"
    else
      printf "${RED}No font files found in the directory: $1${RESET}\n"
      exit 1
    fi
  done
else
  # Proceed with default URL fonts
  printf "${YELLOW}No directory provided. Installing default fonts from predefined URLs...${RESET}\n"

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

  # Download and install fonts
  printf "${YELLOW}Installing fonts to $FONT_DIR...${RESET}\n"
  for URL in "${FONTS[@]}"; do 
    FILENAME=$(basename "$URL")
    printf "${YELLOW}Downloading ${RESET}${BOLD}$FILENAME${RESET}...\n"
    curl -L --progress-bar "$URL" -o "$TMP_DIR/$FILENAME" || { printf "${RED}Failed to download $URL${RESET}\n"; exit 1; }

    # Check if file is zip
    if [[ "$FILENAME" == *.zip ]]; then
      printf "${YELLOW}Extracting ${RESET}${BOLD}$FILENAME${RESET}...\n"
      EXTRACT_DIR="$TMP_DIR/extracted_$(basename "$FILENAME" .zip)"
      mkdir -p "$EXTRACT_DIR"
      unzip -q "$TMP_DIR/$FILENAME" -d "$EXTRACT_DIR" || { printf "${RED}Failed to extract $FILENAME${RESET}\n"; exit 1; }
    fi
  done 

  # Find font files recursively
  printf "${BOLD}${BLUE}Installing Fonts...${RESET}\n"
  for FONT_FILE in "$TMP_DIR"/**/*.{ttf,otf}; do
    if [ -f "$FONT_FILE" ]; then
      printf "${YELLOW}Installing ${RESET}${BOLD}$(basename "$FONT_FILE")${RESET}...\n"
      cp "$FONT_FILE" "$FONT_DIR" && printf "${GREEN}Successfully installed $(basename "$FONT_FILE")${RESET}\n"
    fi
  done
fi

# Refresh Font cache (Linux)
if [ "$OS" == "Linux" ]; then
  printf "${YELLOW}Refreshing Font Cache...${RESET}\n"
  fc-cache -f -v
fi

# Clean up
rm -rf "$TMP_DIR"

printf "${GREEN}${BOLD}Fonts Installed Successfully!${RESET}\n"
r