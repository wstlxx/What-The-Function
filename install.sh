#!/bin/bash

# Function to check for a command
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Dependency Checks ---
echo "Checking for dependencies..."

# 1. Check for Python
if ! command_exists python3; then
    echo "Warning: Python 3 is not installed or not in your PATH."
    echo "Please install Python 3 to use this tool: https://www.python.org/downloads/"
    # Ask user if they want to continue
    read -p "Do you want to continue the installation anyway? (y/n): " choice
    case "$choice" in
      y|Y ) echo "Continuing installation...";;
      n|N ) echo "Installation aborted."; exit 1;;
      * ) echo "Invalid input. Installation aborted."; exit 1;;
    esac
else
    echo "Python 3 found."
fi

# 2. Check for pip
if ! command_exists pip3; then
    echo "Warning: pip3 is not installed or not in your PATH."
    echo "pip3 is required to install Python packages."
    echo "Please make sure you have pip3 installed for your Python 3 distribution."
    read -p "Do you want to continue the installation anyway? (y/n): " choice
    case "$choice" in
      y|Y ) echo "Continuing installation...";;
      n|N ) echo "Installation aborted."; exit 1;;
      * ) echo "Invalid input. Installation aborted."; exit 1;;
    esac
else
    echo "pip3 found."
fi

# --- Installation ---

# Check if the script exists in the current directory
if [ ! -f "./wtf_new.py" ]; then
  echo "Error: ./wtf_new.py not found in the current directory."
  exit 1
fi

# Make the script executable
chmod +x ./wtf_new.py

# Determine the OS and set install path
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

echo "This script will perform the following actions:"
echo "1. Install the 'requests' Python package using pip3."
echo "2. Copy the 'wtf_new.py' script to '$INSTALL_PATH'."
echo "This requires sudo privileges."

# Ask for sudo password at the beginning
sudo -v

# 1. Install 'requests' package
echo "Installing 'requests' package..."
if sudo pip3 install requests; then
    echo "'requests' package installed successfully."
else
    echo "Warning: Failed to install 'requests' package."
    echo "Please try installing it manually: 'sudo pip3 install requests'"
fi

# 2. Copy the script to the install path
echo "Attempting to install wtf to $INSTALL_PATH"
if sudo cp ./wtf_new.py "$INSTALL_PATH"; then
  echo "Successfully installed wtf script to $INSTALL_PATH."
  echo "Please run 'wtf --init' to configure the API endpoint and key."
else
  echo "Error: Failed to copy wtf script to $INSTALL_PATH."
  echo "Please ensure you have the necessary permissions."
fi
