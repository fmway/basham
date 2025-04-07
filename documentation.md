# How the hell you gon' use it twin?

Simple, `basham.sh <args> <specifiers (optional)>`

## Usage
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

List of specifiers:
| Specifiers | Functions |
|------------|-----------|
| `--help`   | Show help message with usage instructions. |
| `--arch`   | Specify the build architecture. |
| `--git`    | Integrate git with the passed arguments. |

And here's a break down!

### Break Down

| Arguments | Specifiers | Functions |
|-----------|------------|-----------|
| `build` | `--arch` | Build the main with architecture specified executable of the project and putting it into `build` directory. |
| `build` | `--git` | Build an assembly project that is available in github (Yes, github). |
| `run` | `--arch` | Run the main executable with architecture specified. |
| `run` | `--git` | Run an assembly project that is available in github (Yes, github). |

---
