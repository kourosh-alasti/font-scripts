# Font Installer Script
A Bash Script for installing fonts on Linux and MacOS. The script supports downloading fonts from predefined URLs and installing fonts directly from a local directory.

### Features
- Install fonts from a list of predefined URLs.
- Install `.ttf` and `.otf` files from a specified local directory.
- Automatically determines the appropriate font directory based on the operating system:
-- `~/Library/Fonts` for MacOS
-- `~/.fonts` for Linux
- Automatically refreshes the font cache on Linux after installation. 

### Prerequisites
- **Curl**: Used for downloading fonts from URLs.
- **Unzip**: Required if the fonts URLs include ZIP archives.

### Usage
#### Clone the Repository
```bash
git clone https://github.com/kourosh-alasti/font-scripts.git
cd font-scripts
```
#### Make the Script Executable
```bash
chmod +x install_fonts.sh
```
#### Install Fonts
1. Install Fonts from a directory
To Install all `.ttf` and `.otf` files from a local directory:
```bash
./install_fonts.sh </path/to/fonts_directory>
```
2. Install Fonts from URLs
If no directory is specified, the script downloads and installs fonts from predefined URLs:
```bash
./install_fonts.sh
```

### Example Output
```bash
Installing fonts to ~/Library/Fonts...
Downloading font1.ttf...
Installing font1.ttf...
Downloading font2.otf...
Installing font2.otf...
Refreshing font cache...
Fonts installed successfully!
```

## Customization
### Predefined Font URLs
You can customize the list of font URLs in the script by editing the `FONTS` array:
```bash
FONTS=(
    "https://example.com/path/to/font1.ttf"
    "https://example.com/path/to/font2.otf"
    "https://example.com/path/to/font3.zip"
)
```

## Notes
- On MacOS, fonts are installed to `~/Library/Fonts`.
- On Linux, fonts are installed to `~/.fonts`. If the directory does not exist, it will be created.
- The script skips invalid or non-existent files in the specified directory.

## License
This project is licensed under the MIT License. See the [LICENSE](https://github.com/kourosh-alasti/font-scripts/LICENSE) file for details.
