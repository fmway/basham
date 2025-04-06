#!/bin/bash

set -e

parent_dir=$(pwd)
script_name=$(basename "$0")
POSITIONAL=()
jobs=("new" "upgrade" "delete" "update" "search" "build" "test" "run")

# Default architecture
arch="x86"

# Parse arguments and detect --arch
while [[ $# -gt 0 ]]; do
    case "$1" in
        --arch)
            shift
            arch="$1"
            ;;
        *)
            # Save positional args (command + others)
            POSITIONAL+=("$1")
            ;;
    esac
    shift
done

# Restore positional arguments
set -- "${POSITIONAL[@]}"
a1=$1
a2=$2
a3=$3

validate_name() {
    if [[ -z "$1" || "$1" =~ ^[[:space:]]*$ ]]; then
        echo "Invalid name: '$1'" >&2
        return 1
    fi
    return 0
}

build_asm() {
    local input=$1
    local output=$2

    case "$arch" in
        x86)
            nasm -f elf32 -o "$output.o" "$input"
            ld -m elf_i386 -o "$output" "$output.o"
            ;;
        arm32)
            arm-none-eabi-as -o "$output.o" "$input"
            arm-none-eabi-ld -o "$output" "$output.o"
            ;;
        arm64)
            aarch64-linux-gnu-as -o "$output.o" "$input"
            aarch64-linux-gnu-ld -o "$output" "$output.o"
            ;;
        *)
            echo "Unsupported architecture: $arch" >&2
            exit 1
            ;;
    esac
}

case "$a1" in
    "new")
        if ! validate_name "$a2"; then
            echo "A new project needs a valid name!" >&2
            exit 1
        fi
        echo "Preparing your project..."
        mkdir -p "$a2/build" "$a2/test"
        touch "$a2/main.asm"
        cp "$0" "$a2/"
        echo "Finished preparing your project in: $parent_dir/$a2"
        ;;

    "upgrade")
        echo "Upgrading script..."
        sudo curl -fsSL -o /usr/local/bin/basham.sh "https://raw.githubusercontent.com/lordpaijo/basham/refs/heads/master/src/basham.sh"
        sudo chmod +x /usr/local/bin/basham.sh
        echo "Upgrade complete!"
        ;;

    "delete")
        if ! validate_name "$a2"; then
            echo "Can't delete an invalid name..." >&2
            exit 1
        elif [[ -d "$a2" && -f "$a2/main.asm" ]]; then
            echo "Deleting project: $a2"
            rm -rf "$a2"
            echo "Poof! It's gone."
        else
            echo "Is this really a legit assembly project?" >&2
            exit 1
        fi
        ;;

    "update")
        if ! validate_name "$a2"; then
            echo "Invalid path. Can't update." >&2
            exit 1
        elif [[ -d "$a2" && -f "$a2/main.asm" ]]; then
            echo "Updating project: $a2"
            cp "$0" "$a2/"
        else
            echo "What am I supposed to update here?" >&2
            exit 1
        fi
        ;;

    "search")
        echo "Searching for *.asm files..."
        find . -type f -name "*.asm"
        ;;

    "build")
        src=${a2:-main.asm}
        echo "Building $src for $arch..."
        build_asm "$src" "build/main"
        ;;

    "test")
        src=${a2:-main.asm}
        echo "Testing $src for $arch..."
        build_asm "$src" "test/test"
        exec ./test/test
        ;;

    "run")
        echo "Running for $arch..."
        build_asm "main.asm" "build/main"
        exec ./build/main
        ;;

    *)
        echo -e "Unknown command: '$a1'\n\nRTFM! https://github.com/lordpaijo/basham.git" >&2
        exit 1
        ;;
esac
