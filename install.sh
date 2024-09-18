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

# Get the API key from the user
read -s -p "Enter your GROQ API key: " GROQ_API_KEY

# Set the system-wide environment variable
sudo echo "$GROQ_API_KEY" >> /etc/environment

# Reload the environment
source /etc/environment

# Check if the variable was set successfully
echo "GROQ_API_KEY is now set to $GROQ_API_KEY"

# Check if the copy was successful
if [ $? -eq 0 ]; then
  echo "Successfully installed wtf script to /usr/bin/wtf."
else
  echo "Error: Failed to copy wtf script to /usr/bin/wtf."
fi
