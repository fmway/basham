#!/bin/bash

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
  $script_name run --git https://github.com/lordpaijo/testbasham.git 'free skibidi'
EOF
}

# Parse arguments and detect --arch and --help
while [[ $# -gt 0 ]]; do
    case "$1" in
        --testbin)
            echo "passed"
            exit
            ;;
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
a4=$4
a5=$5

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
        i386)
            nasm -f elf32 -o "${output}.o" "$input"
            ld -m elf_i386 -o "$output" "${output}.o"
            ;;
        x86_64)
            nasm -f elf64 -o "${output}.o" "$input"
            ld -m elf_x86_64 -o "$output" "${output}.o"
            ;;
        armv7l)
            arm-none-eabi-as -o "${output}.o" "$input"
            arm-none-eabi-ld -o "$output" "${output}.o"
            ;;
        aarch64)
            aarch64-linux-gnu-as -o "${output}.o" "$input"
            aarch64-linux-gnu-ld -o "$output" "${output}.o"
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
            echo "❌ A new project needs a valid name!" >&2
            exit 1
        fi

        echo "🛠️  Preparing your project..."
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
                touch README.md
                gitignore_echo "build/"
                gitignore_echo "test/"
            )
            echo "✅ Initialized Git repository in $a2/"
        fi

        echo "✅ Finished preparing your project in: $parent_dir/$a2"
        ;;

    "upgrade")
        case $a2 in
            "--local")
                echo "🛠️  Upgrading script in /usr/local/bin/basham.sh..."
                sudo curl -fsSL -o /usr/local/bin/basham.sh "https://raw.githubusercontent.com/lordpaijo/basham/refs/heads/master/src/basham.sh"
                sudo chmod +x /usr/local/bin/basham.sh
                echo "✅ Basham script updated at /usr/local/bin/basham.sh !"
                ;;
            "--shared")
                echo "🛠️  Upgrading script in /usr/bin/basham.sh..."
                sudo curl -fsSL -o /usr/bin/basham.sh "https://raw.githubusercontent.com/lordpaijo/basham/refs/heads/master/src/basham.sh"
                sudo chmod +x /usr/bin/basham.sh
                echo "✅ Basham script updated at /usr/bin/basham.sh !"
                ;;
            *)
                sudo curl -fsSL -o /usr/local/bin/basham.sh "https://raw.githubusercontent.com/lordpaijo/basham/refs/heads/master/src/basham.sh"
                sudo chmod +x /usr/local/bin/basham.sh
                echo "✅ Basham script updated!"
                ;;
        esac
        ;;

    "delete")
        if ! validate_name "$a2"; then
            echo "❌ Can't delete an invalid name..." >&2
            exit 1
        elif [[ -d "$a2" && -f "$a2/main.asm" ]]; then
            echo "🛠️  Deleting project: $a2"
            rm -rf "$a2"
            echo "✅ Poof! It's gone."
        else
            echo "❌ Is this really a legit assembly project?" >&2
            exit 1
        fi
        ;;

    "update")
        if ! validate_name "$a2"; then
            echo "❌ Invalid path. Can't update." >&2
            exit 1
        elif [[ -d "$a2" && -f "$a2/main.asm" ]]; then
            echo "🛠️  Updating project: $a2"
            cp "$0" "$a2/"
            echo "✅ '$a2' is successfully updated!"
        else
            echo "❌ What am I supposed to update here?" >&2
            exit 1
        fi
        ;;

    "search")
        echo "🛠️  Searching for *.asm files..."
        find . -type f -name "*.asm"
        ;;

    "build")
        if [[ "$a2" == "--git" && -n "$a3" && -n "$a4" ]]; then
            repo_url="$a3"
            temp_dir="$a4"
            src="main.asm"
            output_dir="${a5:-$temp_dir/build}"

            if [[ "$repo_url" == https://github.com/* ]]; then
                echo "🌐 Cloning via HTTPS..."
                # leave it as-is to allow public repo access without SSH
            elif [[ "$repo_url" == git@github.com:* ]]; then
                echo "🔐 Cloning via SSH..."
            else
                echo "❌ Unrecognized repo URL: $repo_url"
                exit 1
            fi

            git clone --quiet "$repo_url" "$temp_dir"
            if [[ ! -f "$temp_dir/$src" ]]; then
                echo "❌ Required file '$src' not found in '$temp_dir'"
                rm -rf "$temp_dir"
                exit 1
            fi

            mkdir -p "$output_dir"

            echo "🛠️  Building $src from $temp_dir..."
            build_asm "$temp_dir/$src" "$output_dir/main"
            file "$output_dir/main"
            echo "✅ '$src' successfully built to $output_dir/main"
        else
            src="${a2:-main.asm}"
            echo "🛠️  Building $src for $arch..."
            build_asm "$src" "build/main"
            file build/main
            echo "✅ '$src' is successfully built."
        fi
        ;;

    "test")
        src=${a2:-main.asm}
        echo "🚀 Testing $src for $arch..."
        build_asm "$src" "test/test"

        if [[ ! -f test/test ]]; then
            echo "❌ Build failed: 'test/test' not found."
            exit 1
        fi

        exec test/test >/dev/null 2>&1
        exit_code=$?

        if [[ $exit_code -eq 0 ]]; then
            echo "✅ Test passed: '$src' exited with code 0."
        else
            echo "❌ Test failed: '$src' exited with code $exit_code."
        fi
        ;;

    "run")
        if [[ "$a2" == "--git" && -n "$a3" && -n "$a4" ]]; then
            repo_url="$a3"
            temp_dir="$a4"

            if [[ "$repo_url" == https://github.com/* ]]; then
                echo "🌐 Cloning via HTTPS..."
                # leave it as-is to allow public repo access without SSH
            elif [[ "$repo_url" == git@github.com:* ]]; then
                echo "🔐 Cloning via SSH..."
            else
                echo "❌ Unrecognized repo URL: $repo_url"
                exit 1
            fi

            git clone "$repo_url" "$temp_dir" --quiet
            echo "🛠️  Cloning into '$temp_dir'..."
            (
                echo "🛠️  Verifying '$temp_dir' structure..."
                if [[ ! -f "$temp_dir/main.asm" ]]; then
                    echo "❌ main.asm not found in '$temp_dir'. Are you sure it's a valid assembly project?"
                    rm -rf "$temp_dir"
                    exit 1
                fi

                cd "$temp_dir"
                echo "✅ Repo structure verified. Building..."
                mkdir -p build
                build_asm "main.asm" "build/main"

                echo "🚀 Running project from '$temp_dir'"
                chmod +x build/main
                ./build/main || {
                    echo "❌ Failed to execute binary. You may got a wrong format or you're intentionally returning with an error code."
                    file build/main
                    exit 1
                }
            )
        else
            echo "🚀 Running local project..."
            build_asm "main.asm" "build/main"
            file build/main
            exec ./build/main
        fi
        ;;

    "clean" )
        echo "🧹 Cleaning up..."
        rm build/*
        rm test/*
        echo "✅ Cleaned up."
        ;;

    "install")
        as_what=${a2:-main}

        if [[ "$a3" == "--git" && -n "$a4" ]]; then
            repo_url="$a4"
            temp_dir="$a5"
            install_mode="$a6"

            src="main.asm"
            output_dir="${a7:-$temp_dir/build}"

            if [[ "$repo_url" == https://github.com/* ]]; then
                echo "🌐 Cloning via HTTPS..."
            elif [[ "$repo_url" == git@github.com:* ]]; then
                echo "🔐 Cloning via SSH..."
            else
                echo "❌ Unrecognized repo URL: $repo_url"
                exit 1
            fi

            git clone --quiet "$repo_url" "$temp_dir"
            if [[ ! -f "$temp_dir/$src" ]]; then
                echo "❌ Required file '$src' not found in '$temp_dir'"
                rm -rf "$temp_dir"
                exit 1
            fi

            mkdir -p "$output_dir"
            echo "🛠️  Building $src from $temp_dir..."
            build_asm "$temp_dir/$src" "$output_dir/main"

            binary_path="$output_dir/main"

        else
            echo "🛠️  Installing from local project..."
            $0 build
            binary_path="build/main"
            install_mode="$a3"
        fi

        case $install_mode in
            "--local")
                echo "📦 Installing to /usr/local/bin/$as_what..."
                sudo mv "$binary_path" /usr/local/bin/$as_what
                sudo chmod +x /usr/local/bin/$as_what
                ;;
            "--shared")
                echo "📦 Installing to /usr/bin/$as_what..."
                sudo mv "$binary_path" /usr/bin/$as_what
                sudo chmod +x /usr/bin/$as_what
                ;;
            *)
                echo "📦 Installing to /usr/local/bin/$as_what..."
                sudo mv "$binary_path" /usr/local/bin/$as_what
                sudo chmod +x /usr/local/bin/$as_what
                ;;
        esac

        echo "✅ Installed as '$as_what'"
        ;;

    *)
        echo -e "❌ Unknown command: '$a1'\n"
        show_help
        exit 1
        ;;
esac
