#!/bin/bash

# Get the current directory of the script
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$script_dir"
if ! git pull; then
    echo "Cannot update $dir, please run it manually."
fi

# Define the extensions directory
extensions_dir="$script_dir/extensions"

# Check if the extensions directory exists
if [ -d "$extensions_dir" ]; then
  # Loop through all subdirectories
  for dir in "$extensions_dir"/*; do
    if [ -d "$dir/.git" ]; then
      # Change to the directory and run the Git commands
      cd "$dir" || exit
      echo "Entering directory: $dir"
      git reset --hard
      if ! git pull; then
        echo "Cannot update $dir, please run it manually."
      fi
      echo "Finished directory: $dir"
      cd - || exit
    fi
  done
else
  echo "Extensions directory not found: $extensions_dir"
fi
./setup-modeli.sh
cd "$script_dir"
