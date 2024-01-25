#!/bin/bash

# Define the base directory
base_dir="/workspace/stable-diffusion-webui/outputs"

# Get the current date in "YYYY-MM-DD" format
current_date=$(date "+%Y-%m-%d")

# Iterate through subdirectories of the base directory
for sub_dir in "$base_dir"/*/; do
    # Iterate through sub-subdirectories of each subdirectory
    for sub_sub_dir in "$sub_dir"/*/; do
        sub_sub_dir_name=$(basename "$sub_sub_dir")

        # Check if sub_sub_dir_name is not equal to the current date
        if [ "$sub_sub_dir_name" != "$current_date" ]; then
            # Delete the sub_sub_dir and its contents
            rm -rf "$sub_sub_dir"
            echo "Deleted: $sub_sub_dir"
        fi
    done
done
