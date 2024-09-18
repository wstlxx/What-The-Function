#!/usr/bin/env python3

import os
import sys
import requests
import subprocess
import os

API_KEY = os.getenv("GROQ_API_KEY")

# Replace with your OpenAI-compatible API endpoint
API_ENDPOINT = "https://api.groq.com/openai/v1/chat/completions"

def get_command(prompt):
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    data = {
        "model": "llama3-8b-8192",  # or whatever model your API supports
        "messages": [
            {"role": "system", "content": "You are a helpful assistant that provides Linux commands. You give command directly without explain or anything else since yyour response should be used directly as command to send. no brackets or quotation marks"},
            {"role": "user", "content": f"What's the Linux command for: {prompt}"}
        ]
    }

    response = requests.post(API_ENDPOINT, headers=headers, json=data)

    if response.status_code == 200:
        return response.json()['choices'][0]['message']['content'].strip()
    else:
        return f"Error: {response.status_code} - {response.text}"

def main():
    if len(sys.argv) < 2:
        print("Usage: wtf <your question about a Linux command>")
        sys.exit(1)

    prompt = " ".join(sys.argv[1:])
    command = get_command(prompt)

    print(f"Suggested command: {command}")

    user_input = input("Do you want to run this command? (Y/N): ").lower()

    if user_input == 'y':
        try:
            subprocess.run(command, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Command failed with error: {e}")
    else:
        print("Command not executed.")

if __name__ == "__main__":
    main()

