#!/bin/bash

# Ensure the script is executable: chmod +x run-yt-dlp-wrapper.sh

# Run the Python script with all passed arguments
python /opt/sinusbot/yt-dlp-files/yt-dlp-wrapper.py "$@" 2>&1
