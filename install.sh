#!/bin/bash

# Check if the script exists in the current directory
if [ ! -f "./wtf.py" ]; then
  echo "Error: ./wtf.py not found in the current directory."
  exit 1
fi

# Make the script executable
chmod +x ./wtf.py

# Copy the script to /usr/bin/wtf (requires sudo)
sudo cp ./wtf.py /usr/bin/wtf

# Prompt the user for input
echo "Please enter your Sambanova API key:"
read api_key

# Determine which shell configuration file to use
if [ -n "$BASH_VERSION" ]; then
    config_file="$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    config_file="$HOME/.zshrc"
else
    echo "Unsupported shell. Please manually add the export command to your shell's configuration file."
    exit 1
fi

# Add the export command to the shell configuration file
echo "export SAMBANOVA_API_KEY=\"$api_key\"" >> "$config_file"

# Set the variable for the current session
export SAMBANOVA_API_KEY="$api_key"

# Confirm the variable has been set
echo "SAMBANOVA_API_KEY has been set to: $SAMBANOVA_API_KEY"
echo "The export command has been added to $config_file"
echo "Please restart your terminal or run 'source $config_file' for the change to take effect in new sessions."

# Check if the copy was successful
if [ $? -eq 0 ]; then
  echo "Successfully installed wtf script to /usr/bin/wtf."
else
  echo "Error: Failed to copy wtf script to /usr/bin/wtf."
fi
