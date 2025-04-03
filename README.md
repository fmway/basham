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
$ mv src/basham.sh /usr/local/bin/basham.sh
$ chmod +x /usr/local/bin/basham.sh
```

And you're good to go.

## Usage

It's as simple as calling `basham.sh` followed by an argument.

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

---

Have fun.