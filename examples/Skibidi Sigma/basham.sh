#!/bin/bash

set -e  # exit on error

parent_dir=$(pwd)
script_name=$(basename "$0")
jobs=("new" "upgrade" "delete" "update" "search" "build" "test" "run")
a1=$1
a2=$2
a3=$3

# Validation
validate_name() {
    if [[ -z "$1" || "$1" =~ ^[[:space:]]*$ ]]; then
        echo "Invalid project name: '$1'" >&2
        return 1
    fi
    return 0
}

# Main
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
        echo "Finished preparing your project in: $parent_dir/$a2. Job done!"
        ;;

    "upgrade")
        echo "Upgrading script..."
        if ! sudo -v; then
            echo "Failed to gain sudo privileges!" >&2
            exit 1
        fi
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
        echo "Building $src..."
        nasm -f elf32 -o build/main.o "$src"
        ld -m elf_i386 -o build/main build/main.o
        ;;

    "test")
        src=${a2:-main.asm}
        echo "Testing $src..."
        nasm -f elf32 -o test/test.o "$src"
        ld -m elf_i386 -o test/test test/test.o
        exec ./test/test
        ;;

    "run")
        echo "Running..."
        nasm -f elf32 -o build/main.o main.asm
        ld -m elf_i386 -o build/main build/main.o
        exec ./build/main
        ;;

    *)
        if [[ -n "$a1" ]]; then
            echo -e "What the hell are you trying to cast here? What are you, some kind of wizard from Hogwarts?\n\nRTFM! https://github.com/lordpaijo/basham.git" >&2
        else
            echo -e "You put nothing... What do you want me to do? Pray to God? Well, thank you because I always do.\n\nRTFM! https://github.com/lordpaijo/basham.git" >&2
        fi
        exit 1
        ;;
esac
