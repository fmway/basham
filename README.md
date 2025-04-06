# BASHAM!

A simple bash script to manage your assembly project.

## Dependencies
- binutils
- curl
- nasm (x86)
- arm-none-eabi-as (ARM32)
- arm-none-eabi-ld (ARM32)
- aarch64-linux-gnu-as (ARM64)
- aarch64-linux-gnu-ld (ARM64)

### Here's how you can install them:
- MacOS (Homebrew)
```sh
$ brew tap ArmMbed/homebrew-formulae
$ brew install curl nasm gcc@13 arm-none-eabi-gcc aarch64-elf-gcc arm-none-eabi-binutils aarch64-linux-gnu-binutils
```

- Ubuntu/Debian
```sh
$ sudo apt install curl gcc-arm-none-eabi binutils-arm-none-eabi binutils-aarch64-linux-gnu
```

- Fedora
```sh
$ sudo dnf install curl arm-none-eabi-gcc-cs arm-none-eabi-binutils binutils-aarch64-linux-gnu
```

- Arch
```sh
$ sudo pacman -S arm-none-eabi-gcc arm-none-eabi-binutils aarch64-linux-gnu-binutils
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
$ basham.sh build --arch x86
$ basham.sh run --arch x86
```

## Nix Usage
If you don't want install it, you can execute via `nix run`
```sh
$ nix run github:lordpaijo/basham -- blablablablablabla
```
Or you can install it via `nix profile`
```sh
$ nix profile install github:lordpaijo/basham
$ basham.sh blablablablablabla
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

Fortunately, there's only one specifier.
| Specifiers | Functions |
|------------|-----------|
| `--arch`   | Specify the build architecture (Default: x86) |
| `--help`   | Show help message with usage instructions |

---

Have fun.
