#!/bin/bash

# Find the first file in ~/Downloads that ends with cookies.txt
SOURCE_FILE=$(find ~/Downloads -maxdepth 1 -type f -name '*cookies.txt' | head -n 1)

# Check if a matching file was found
if [[ -n "$SOURCE_FILE" ]]; then
    # Copy it to the target directory and rename it
    cp "$SOURCE_FILE" ~/sinusbot-wrapper/data/cookies.txt

    # Change ownership to UID 1000 and GID 1000
    chown 1000:1000 ~/sinusbot-wrapper/data/cookies.txt

    echo "File copied and ownership changed successfully."
else
    echo "No file ending with 'cookies.txt' found in ~/Downloads."
fi