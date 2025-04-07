# BASHAM!

A simple bash script to manage your assembly project.

## Dependencies
- `binutils`
- `curl`
- `git`
- `nasm` (x86_64)
- `arm-none-eabi-as` (armv7l)
- `arm-none-eabi-ld` (armv7l)
- `aarch64-linux-gnu-as` (aarch64)
- `aarch64-linux-gnu-ld` (aarch64)

### Here's how you can install them:
- MacOS (Homebrew)
```sh
$ brew tap ArmMbed/homebrew-formulae
$ brew install curl nasm git gcc@13 arm-none-eabi-gcc aarch64-elf-gcc arm-none-eabi-binutils aarch64-linux-gnu-binutils
```

- Ubuntu/Debian
```sh
$ sudo apt install curl nasm git gcc-arm-none-eabi binutils-arm-none-eabi binutils-aarch64-linux-gnu
```

- Fedora/CentOS
```sh
$ sudo dnf install curl nasm git arm-none-eabi-gcc-cs arm-none-eabi-binutils binutils-aarch64-linux-gnu
```

- Arch
```sh
$ sudo pacman -S curl nasm git arm-none-eabi-gcc arm-none-eabi-binutils aarch64-linux-gnu-binutils
```

## Install
Clone and `cd` to the repo.
```sh
$ git clone https://github.com/lordpaijo/basham.git
$ cd basham
```

Add the script to your path and make it executable.
```
$ mv src/basham.sh /usr/local/bin/basham.sh
$ chmod +x /usr/local/bin/basham.sh
```

And you're good to go.

## Usage

It's as simple as calling `basham.sh` followed by an argument.

```sh
$ basham.sh new blablablablablabla
$ basham.sh build --arch x86_64
$ basham.sh run --arch x86_64
```

## Nix Usage
If you don't want to install it, you can execute via `nix run`
```sh
$ nix run github:lordpaijo/basham -- new blablablablablabla
```
Or you can install it via `nix profile`
```sh
$ nix profile install github:lordpaijo/basham
$ basham.sh new blablablablablabla
```

### Arguments

List of available arguments:
| Arguments | Functions |
|-----------|-----------|
| `new` | Initiate a new project. |
| `upgrade` | Upgrade the script system wide. |
| `delete` | Delete an existing project. |
| `update` | Update an existing project. |
| `search` | Search for assembly files. |
| `build` | Build the main executable of the project and putting it into `build` directory. |
| `test` | Build the test executable and putting it into `test` directory before running it. |
| `run` | Rebuild and run the main executable . |

### Specifiers

Fortunately, there are more than one specifier (which is unfortunate for me to maintain).
| Specifiers | Functions |
|------------|-----------|
| `--help`   | Show help message with usage instructions. |
| `--arch`   | Specify the build architecture. |
| `--git`    | Integrate git with the passed arguments. |


Have a full documentation here -> [click me please daddy~](https://github.com/lordpaijo/basham/blob/master/documentation.md)
---

Have fun.
