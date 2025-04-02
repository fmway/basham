# BASHAM!

A simple bash script to manage your assembly project.

## Dependencies
- nasm

## Install
Clone and `cd` to the repo.
```sh
$ git clone https://github.com/lordpaijo/basham.git
$ cd basham
```

Add the script to your path and make it executable.
```
$ mv src/basham.sh /usr/local/bin
$ chmod +x /usr/local/bin/basham.sh
```

And you're good to go.

## Usage

It's as simple as calling `basham.sh` followed by an argument.

List of available arguments:
| Arguments | Functions |
|-----------|-----------|
| `new` | Initiate a new project. |
| `delete` | Delete an existing project. |
| `build` | Build a main executable the project and put the executable into `build` directory. |
| `test` | Build a test executable and run it. |
| `run` | Run the main executable. |

---

Have fun.