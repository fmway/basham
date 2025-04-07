#!/bin/bash

set -e

parent_dir=$(pwd)
script_name=$(basename "$0")
POSITIONAL=()
jobs=("new" "upgrade" "delete" "update" "search" "build" "test" "run")

# >> Detect devices architecture
arch=$(uname -m)

# Git initialize
git=1

show_help() {
    cat <<EOF
Usage: $script_name [command] [options]

Commands:
  new <project_name>        Create a new assembly project
  upgrade                   Upgrade basham script to latest version
  delete <project_name>     Delete an existing project
  update <project_name>     Update script inside an existing project
  search                    Search for .asm files in current directory
  build [file.asm]          Assemble source (default: main.asm) to build/
  test [file.asm]           Assemble and execute in test/ (default: main.asm)
  run                       Build and execute main.asm in build/
  --help                    Show this help message
  --arch <arch>             Set target architecture (x86_64, armv7l, aarch64)
  --git                     Initialize git when making a new project

Examples:
  $script_name new myproj --git
  $script_name build --arch x86_64
  $script_name test myfile.asm --arch x86_64
EOF
}

# Parse arguments and detect --arch and --help
while [[ $# -gt 0 ]]; do
    case "$1" in
        --arch)
            shift
            arch="$1"
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
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
        x86_64)
            nasm -f elf32 -o "$output.o" "$input"
            ld -m elf_i386 -o "$output" "$output.o"
            ;;
        armv7l)
            arm-none-eabi-as -o "$output.o" "$input"
            arm-none-eabi-ld -o "$output" "$output.o"
            ;;
        aarch64)
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

        gitignore_echo() {
            local entry="$1"
            touch .gitignore
            grep -qxF "$entry" .gitignore || echo "$entry" >> .gitignore
        }

        if [[ " $@ " =~ " --git " ]]; then
            (
                cd "$a2" || exit 1
                git init --initial-branch=main > /dev/null 2>&1
                gitignore_echo "build/"
                gitignore_echo "test/"
            )
            echo "Initialized Git repository in $a2/"
        fi

        echo "Finished preparing your project in: $parent_dir/$a2"
        ;;

    "upgrade")
        sudo curl -fsSL -o /usr/local/bin/basham.sh "https://raw.githubusercontent.com/lordpaijo/basham/refs/heads/master/src/basham.sh"
        sudo chmod +x /usr/local/bin/basham.sh
        echo "Basham script updated!"
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
        echo -e "Unknown command: '$a1'\n"
        show_help
        exit 1
        ;;
esac
