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
echo "Please enter your GROQ API key:"
read api_key

# Set the input as an environment variable
export GROQ_API_KEY="$api_key"

# Optionally, confirm the variable has been set
echo "GROQ_API_KEY has been set to: $GROQ_API_KEY"

# Check if the copy was successful
if [ $? -eq 0 ]; then
  echo "Successfully installed wtf script to /usr/bin/wtf."
else
  echo "Error: Failed to copy wtf script to /usr/bin/wtf."
fi
