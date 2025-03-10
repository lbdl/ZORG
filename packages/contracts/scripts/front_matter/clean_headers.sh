#!/bin/bash

# Check if a directory is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Check if the provided path is a directory
if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a directory"
    exit 1
fi

# Function to process a single file
process_file() {
    local file="$1"
    local temp_file=$(mktemp)
    
    while IFS= read -r line; do
        # Skip lines containing "Copyright"
        if [[ ! $line =~ Copyright ]]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$file"
    
    # Replace original file with modified content
    mv "$temp_file" "$file"
    echo "Processed: $file"
}

# Find all .cairo files in the directory and its subdirectories
find "$1" -type f -name "*.cairo" | while read -r file; do
    process_file "$file"
done
