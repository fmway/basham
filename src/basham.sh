#!/bin/bash

parent_dir=$(pwd)
jobs=("new" "upgrade" "delete" "update" "search" "build" "test" "run")
is_acceptable=false
a1=$1
a2=$2
a3=$3

if ! sudo -v; then
    echo "Failed to gain sudo privileges!"
    exit 1
fi

if [[ $a1 == "${jobs[0]}" ]]; then
    if [[ $a2 == "" ]]; then
        echo "A new project needs a name!" >&2
        exit 1
    elif [[ $a2 == " " ]]; then
        echo "Here's the thing, just a space is not enough for a project name. Nice try bud." >&2
        exit 1
    else
        echo "Preparing your project..."
        mkdir "$2/"
        mkdir "$2/build/"
        mkdir "$2/test/"
        touch "$2/main.asm"
        cp "$0 $2/"
        echo "Finshed preparing your project in: $parent_dir/$2. Job done!"
        exit 0
    fi
fi

if [[ $a1 == "${jobs[1]}" ]]; then
    echo "Upgrading script..."
    sudo curl -o /usr/local/bin/basham.sh "https://raw.githubusercontent.com/lordpaijo/basham/refs/heads/master/src/basham.sh"
    echo "Done!"
    is_acceptable=true
    exit 0
fi

if [[ $a1 == "${jobs[2]}" ]]; then
    dir_path=$2
    if [[ $a2 == "" ]]; then
        echo "I can't delete something that doesn't exist... unless if nothing exists and if existing mean it's true that it exists, that I can delete it yet it would stay exists even if I delete its existence." >&2
        exit 1
    elif [[ $a2 == " " ]]; then
        echo "I can't delete a goddamn space, I'm not Okuyasu Nijimura damn it! " >&2
        exit 1
    elif [[ -d "$dir_path" && -f "$dir_path/main.asm" ]]; then
        echo "Deleting project: $dir_path"
        cp "$0" "$2/"
    else
        echo "Is this really a legit assembly project?" >&2
        exit 1
    fi
fi

if [[ "$a1" == "${jobs[3]}" ]]; then
    dir_path="$2"

    if [[ -z "$a2" ]]; then
        echo "I see no one's here to wash." >&2
        exit 1
    elif [[ "$a2" =~ ^[[:space:]]+$ ]]; then
        echo "Uhm, hello? Is there anybody here?" >&2
        exit 1
    fi

    echo "Checking directory: $dir_path"
    ls -l "$dir_path"

    if [[ -d "$dir_path" && -f "$dir_path/main.asm" ]]; then
        echo "Updating project: $dir_path"
        cp "$0" "$2/"
        is_acceptable=true
    else
        echo "What am I supposed to update here?" >&2
        exit 1
    fi
fi


if [[ $a1 == "${jobs[4]}" ]]; then
    search_dir="."
    file_ext="*.asm"
    found_files=$(find "$search_dir" -type f -name "$file_ext")
    if [[ -n $found_files ]]; then
        echo -e "\t$found_files"
    fi
fi

if [[ $a1 == "${jobs[5]}" ]]; then
    if [[ -n "$a2" && $a2 != " " ]]; then
        set -e
        nasm -f elf32 -o build/main.o $a2
        ld -m elf_i386 -o build/main build/main.o
        exit 0
    else
        set -e
        nasm -f elf32 -o build/main.o main.asm
        ld -m elf_i386 -o build/main build/main.o
        exit 0
    fi
fi


if [[ $a1 == "${jobs[6]}" ]]; then
    if [[ -n "$a2" && $a2 != " " ]]; then
        set -e
        nasm -f elf32 -o test/test.o $a2
        ld -m elf_i386 -o test/test test/test.o
        exec ./test/test
        exit 0
    else
        set -e
        nasm -f elf32 -o test/test.o main.asm
        ld -m elf_i386 -o test/test test/test.o
        exec ./test/test
        exit 0
    fi
fi

if [[ $a1 == "${jobs[7]}" ]]; then
    set -e
    nasm -f elf32 -o build/main.o main.asm
    ld -m elf_i386 -o build/main build/main.o
    exec ./build/main
    exit 0
fi

for arg in "$@"; do
    found=false

    for job in "${jobs[@]}"; do
        if [[ "$arg" == "$job" ]]; then
            if [[ "$is_acceptable" == true ]]; then
                found=true
            fi
            break
        fi
    done

    if [[ $found == false && -n $arg && $is_acceptable == false ]]; then
        echo -e "What the hell are you trying to cast here? What are you, some kind of wizard from Hogwarts or something?\n\nRTFM! https://github.com/lordpaijo/basham.git" >&2
    fi
done

if [[ $a1 == "" && $a2 == "" && $a3 == "" ]]; then
    echo -e "You put nothing... What do you want me to do? Pray to God? Well, thank you becasue I always do.\n\nRTFM! https://github.com/lordpaijo/basham.git" >&2
    exit 1
fi