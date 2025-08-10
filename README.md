# What-The-Function
Simple prompt, simple command. Stay simple, stay naive.

# Get started

## Clone the repo
```
git clone https://github.com/wstlxx/What-The-Function.git && cd What-The-Function
```
## Run the installer
```
chmod +x ./install.sh && ./install.sh
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

---
# Remember Preferences
You can save preferences to be used in the prompt with the `-r` or `--remember` flag.
```
wtf -r "always use sudo for docker commands"
```
This will save the preference to your configuration file.

---
# Upgrade
To upgrade `wtf` to the latest version, run:
```
wtf --upgrade
```
