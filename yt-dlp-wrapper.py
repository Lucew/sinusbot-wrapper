#!/usr/bin/python3
import sys
import subprocess

# get the arguments the file is run with
args = sys.argv

# run the yt-dlp command but add the cookies
subprocess.run([r"/opt/sinusbot/yt-dlp", "--cookies", "/opt/sinusbot/cookies.txt", *args[1:]])