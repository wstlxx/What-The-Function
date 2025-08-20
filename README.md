# What-The-Function
Simple prompt, simple command. Stay simple, stay naive.

# Get started

## Clone the repo
```
git clone https://github.com/wstlxx/What-The-Function.git && cd What-The-Function
```
## Run the installer
The installer will check for Python and pip. If they are not found, it will warn you. It will also attempt to install the `requests` library.

### For Linux and macOS
```
chmod +x ./install.sh && ./install.sh
```
### For Windows
```
./install.bat
```
## Configure the tool
Run `wtf --init` to set up your API endpoint and key.
```
wtf --init
```
This will create a configuration file at `~/.config/wtf/config.json`.

---
# Usage
Try your command with natural language like:
```
wtf whatever command you desire
```
The tool will suggest a command. You can then:
- Press `Y` to execute the command.
- Press `N` to see the next suggestion.
- Press `P` to see the previous suggestion.
- Press `Q` to quit.
- Press `E` to edit the command before executing.

---
# All Commands

| Command | Alias | Description |
| --- | --- | --- |
| `wtf <prompt>` | | Get command suggestions for a prompt. |
| `wtf --init` | | Initialize the configuration. |
| `wtf --ask <question>` | | Ask a question and get a direct answer. |
| `wtf --remember <preference>` | `-r` | Remember a preference for future prompts. |
| `wtf --set-model <model_name>` | | Set the model to use for suggestions. |
| `wtf --upgrade` | | Upgrade wtf to the latest version. |
| `wtf --uninstall`| | Uninstall wtf and remove all configurations. |
| `wtf --help` | `-h` | Show the help message. |

---
# Upgrade
To upgrade `wtf` to the latest version, run:
```
wtf --upgrade
```
