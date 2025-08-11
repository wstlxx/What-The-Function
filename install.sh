#!/bin/bash

# Check if the script exists in the current directory
if [ ! -f "./wtf_new.py" ]; then
  echo "Error: ./wtf_new.py not found in the current directory."
  exit 1
fi

# Make the script executable
chmod +x ./wtf_new.py

# Copy the script to /usr/bin/wtf (requires sudo)
sudo cp ./wtf_new.py /usr/bin/wtf

# Check if the copy was successful
if [ $? -eq 0 ]; then
  echo "Successfully installed wtf script to /usr/bin/wtf."
  echo "Please run 'wtf --init' to configure the API endpoint and key."
else
  echo "Error: Failed to copy wtf script to /usr/bin/wtf."
fi
