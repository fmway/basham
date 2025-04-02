#!/bin/bash

parent_dir=$(pwd)
a1=$1
a2=$2
a3=$3

if [[ $a1 == "new" ]]; then
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
        echo "Finshed preparing your project in: $parent_dir/$2. Job done!"
        exit 0
    fi
fi

if [[ $a1 == "delete" ]]; then
    dir_path=$2
    if [[ $a2 == "" ]]; then
        echo "I can't delete something that doesn't exist... unless if nothing exists and if existing mean it's true that it exists, that I can delete it yet it would stay exists even if I delete its existence." >&2
        exit 1
    elif [[ $a2 == " " ]]; then
        echo "I can't delete a goddamn space, I'm not Okuyasu Nijimura damn it! " >&2
        exit 1
    elif [[ -d "$dir_path" && -f "$dir_path/main.asm" ]]; then
        echo "Deleting project: $dir_path"
        rm -r "$dir_path"
    else
        echo "Is this really a legit assembly project?" >&2
        exit 1
    fi
fi

if [[ $a1 == "build" ]]; then
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


if [[ $a1 == "test" || $a1 == "run" ]]; then
    if [[ $a1 == "run" ]]; then
        set -e
        nasm -f elf32 -o build/main.o main.asm
        ld -m elf_i386 -o build/main build/main.o
        exec ./build/test
        exit 0
    elif [[ -n "$a2" && $a2 != " " ]]; then
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

echo -e "You put nothing... What do you want me to do? Pray to God? Well, thank you becasue I always do.\n\nRTFM! https://github.com/lordpaijo/basham.git" >&2
exit 1