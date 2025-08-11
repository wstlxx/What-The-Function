#!/usr/bin/env python3

import os
import sys
import requests
import subprocess
import json
import tty
import termios
import readline

CONFIG_DIR = os.path.join(os.path.expanduser("~"), ".config", "wtf")
CONFIG_FILE = os.path.join(CONFIG_DIR, "config.json")

def load_config():
    """Loads the configuration from the config file."""
    if not os.path.exists(CONFIG_FILE):
        return {}
    with open(CONFIG_FILE, 'r') as f:
        return json.load(f)

def save_config(config):
    """Saves the configuration to the config file."""
    os.makedirs(CONFIG_DIR, exist_ok=True)
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=4)

def initialize_config():
    """Initializes the configuration for wtf."""
    print("Starting wtf configuration...")

    api_endpoint = input("Enter the API endpoint (e.g., https://openrouter.ai/api/v1/chat/completions): ")
    api_key = input("Enter the API key: ")
    model = input("Enter the model (default: z-ai/glm-4.5-air:free): ") or "z-ai/glm-4.5-air:free"

    config = {
        "api_endpoint": api_endpoint,
        "api_key": api_key,
        "model": model,
        "preferences": []
    }

    save_config(config)
    print(f"Configuration saved to {CONFIG_FILE}")

def remember_preference(preference):
    """Saves a user preference to the config file."""
    config = load_config()
    if not config:
        print("Please run 'wtf --init' first.")
        sys.exit(1)
    if "preferences" not in config:
        config["preferences"] = []
    config["preferences"].append(preference)
    save_config(config)
    print(f"Preference saved: {preference}")

def set_model(model):
    """Sets the model in the config file."""
    config = load_config()
    if not config:
        print("Please run 'wtf --init' first.")
        sys.exit(1)
    config["model"] = model
    save_config(config)
    print(f"Model set to: {model}")

def get_single_char():
    """
    Waits for a single keypress on stdin and returns the character.
    """
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setcbreak(sys.stdin.fileno())
        char = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return char

def get_command(prompt):
    config = load_config()
    api_key = config.get("api_key")
    api_endpoint = config.get("api_endpoint")
    model = config.get("model", "z-ai/glm-4.5-air:free")
    preferences = config.get("preferences", [])

    if not api_key or not api_endpoint:
        print("API key or endpoint not found. Please run 'wtf --init' to configure the tool.")
        sys.exit(1)

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/wstlxx/What-The-Function",
        "X-Title": "What The Function"
    }

    system_prompt = "You are a helpful assistant that provides 3 distinct Linux commands. You give command directly without explain or anything else since your response should be used directly as command to send. no brackets or quotation marks, your response should be in format 'command 1\\ncommand 2\\ncommand 3'"
    if preferences:
        system_prompt += "\n\nPlease also follow these user-provided instructions:\n- " + "\n- ".join(preferences)

    data = {
        "model": model,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": f"What's the Linux command for: {prompt}"}
        ]
    }

    try:
        response = requests.post(api_endpoint, headers=headers, json=data)
        response.raise_for_status()
        commands = response.json()['choices'][0]['message']['content'].strip().split('\n')
        return [cmd.strip() for cmd in commands if cmd.strip()]
    except requests.exceptions.RequestException as e:
        return [f"Error: API request failed - {e}"]
    except (KeyError, IndexError):
        return ["Error: Unexpected response format from API."]

def edit_and_execute_command(command):
    """Allows editing and executing a command."""
    def prefill_input():
        readline.insert_text(command)
    readline.set_startup_hook(prefill_input)
    try:
        edited_command = input("Edit command: ")
    finally:
        readline.set_startup_hook()
    if edited_command:
        print(f"Executing: {edited_command}")
        try:
            subprocess.run(edited_command, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Command failed with error: {e}")

def upgrade_script():
    print("Upgrading wtf...")
    try:
        # The file to upgrade to is the new script name
        url = "https://raw.githubusercontent.com/wstlxx/What-The-Function/main/wtf_new.py"
        response = requests.get(url)
        response.raise_for_status()

        # This will be /usr/bin/wtf, so we need to find the source file to update
        # A bit tricky, for now, we assume the user runs it from the repo.
        # A better solution would be to have the installer store the location.
        script_path = os.path.abspath(sys.argv[0])
        with open(script_path, 'w') as f:
            f.write(response.text)
        print(f"wtf has been upgraded successfully. The script at {script_path} was updated.")
    except Exception as e:
        print(f"An error occurred during the upgrade: {e}")

def main():
    if len(sys.argv) > 1:
        if sys.argv[1] == '--init':
            initialize_config()
            sys.exit(0)
        elif sys.argv[1] == '--upgrade':
            upgrade_script()
            sys.exit(0)
        elif sys.argv[1] in ['-r', '--remember'] and len(sys.argv) > 2:
            remember_preference(" ".join(sys.argv[2:]))
            sys.exit(0)
        elif sys.argv[1] == '--set-model' and len(sys.argv) > 2:
            set_model(sys.argv[2])
            sys.exit(0)

    if len(sys.argv) < 2:
        print("Usage: wtf <your question about a Linux command>")
        print("Or: wtf --init | --upgrade | --remember <preference> | --set-model <model_name>")
        sys.exit(1)

    prompt = " ".join(sys.argv[1:])
    commands = get_command(prompt)

    if not commands or "Error" in commands[0]:
        print(commands[0])
        sys.exit(1)

    current_index = 0
    while True:
        print(f"Suggested command ({current_index + 1}/{len(commands)}): {commands[current_index]}")
        print("Execute? [Y/n/p/q/e]: ", end='', flush=True)
        user_input = get_single_char().lower()
        print()

        if user_input in ('y', '\r', '\n'):
            try:
                subprocess.run(commands[current_index], shell=True, check=True)
            except subprocess.CalledProcessError as e:
                print(f"Command failed with error: {e}")
            break
        elif user_input == 'n':
            current_index = (current_index + 1) % len(commands)
        elif user_input == 'p':
            current_index = (current_index - 1 + len(commands)) % len(commands)
        elif user_input == 'q':
            print("Command not executed.")
            break
        elif user_input == 'e':
            edit_and_execute_command(commands[current_index])
            break
        else:
            print("Invalid input. Please use Y/n/p/q/e.")

if __name__ == "__main__":
    main()
