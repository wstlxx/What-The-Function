#!/bin/bash

# Check if the script exists in the current directory
if [ ! -f "./wtf_new.py" ]; then
  echo "Error: ./wtf_new.py not found in the current directory."
  exit 1
fi

# Make the script executable
chmod +x ./wtf_new.py

# Determine the OS
OS="$(uname)"
INSTALL_PATH=""

if [ "$OS" == "Linux" ]; then
  INSTALL_PATH="/usr/bin/wtf"
elif [ "$OS" == "Darwin" ]; then
  INSTALL_PATH="/usr/local/bin/wtf"
else
  echo "Unsupported OS: $OS"
  exit 1
fi

echo "Attempting to install wtf to $INSTALL_PATH"

# Copy the script to the install path (requires sudo)
sudo cp ./wtf_new.py "$INSTALL_PATH"

# Check if the copy was successful
if [ $? -eq 0 ]; then
  echo "Successfully installed wtf script to $INSTALL_PATH."
  echo "Please run 'wtf --init' to configure the API endpoint and key."
else
  echo "Error: Failed to copy wtf script to $INSTALL_PATH."
  echo "Please ensure you have the necessary permissions (e.g., run with sudo if needed)."
fi
