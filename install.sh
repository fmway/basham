#!/usr/bin/env bash

set -e

INSTALL_PATH="/usr/local/bin"
SCRIPT_NAME="basham.sh"
SCRIPT_URL="https://raw.githubusercontent.com/lordpaijo/basham/refs/heads/master/src/basham.sh"

echo "[basham] Starting install..."

# Check for shared flag
if [[ "$1" == "--shared" ]]; then
    INSTALL_PATH="/usr/bin"
    echo "[basham] Shared install selected: $INSTALL_PATH"
fi

# dependencies
install_deps() {
    echo "[basham] Installing dependencies..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew not found. Please install it from https://brew.sh"
            exit 1
        fi
        brew tap ArmMbed/homebrew-formulae
        brew install curl nasm git gcc@13 arm-none-eabi-gcc aarch64-elf-gcc arm-none-eabi-binutils aarch64-linux-gnu-binutils

    elif [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y curl nasm git gcc-arm-none-eabi binutils-arm-none-eabi binutils-aarch64-linux-gnu

    elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
        sudo dnf install -y curl nasm git arm-none-eabi-gcc-cs arm-none-eabi-binutils binutils-aarch64-linux-gnu

    elif [ -f /etc/arch-release ]; then
        sudo pacman -Sy --noconfirm curl nasm git arm-none-eabi-gcc arm-none-eabi-binutils aarch64-linux-gnu-binutils

    else
        echo "[basham] Unsupported OS. Please install dependencies manually."
        exit 1
    fi
}

# basham.sh
download_script() {
    echo "[basham] Downloading script to $INSTALL_PATH/$SCRIPT_NAME..."
    sudo curl -fsSL -o "$INSTALL_PATH/$SCRIPT_NAME" "$SCRIPT_URL"
    sudo chmod +x "$INSTALL_PATH/$SCRIPT_NAME"
    echo "[basham] Installed successfully at $INSTALL_PATH/$SCRIPT_NAME"
}

install_deps
download_script

echo "[basham] Done! You can now run: basham.sh"
