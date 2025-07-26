#!/usr/bin/python3
import sys
import os
import subprocess
import logging

# check whether we can access the file
folder = "/opt/sinusbot/logs"
if os.path.isdir(folder):
    log_file = f"{folder}/yt-dlp.log"
else:
    print('!Logging in Container!')
    log_file = f"yt-dlp.log"

# Configure the logging
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

# check whether there are cookies
cookie_path = "/opt/sinusbot/data/cookies.txt"
if not os.path.isfile(cookie_path):
    with open(cookie_path, 'w'): pass
    error_msg = f"There is no cookies file in '{cookie_path}'. But I created it."
    print(error_msg)
    logging.error(error_msg)
    raise FileNotFoundError(error_msg)

# get the arguments the file is run with
args = sys.argv
command = [r"/opt/sinusbot/yt-dlp", "--cookies", cookie_path, *args[1:]]

# run the yt-dlp command but add the cookies
try:
    result = subprocess.run(command, capture_output=True, text=True, check=True)

    # Log the command and its output
    msg = f"Command ran successfully: {' '.join(command)}\nOutput:\n{result.stdout}"
    print(msg)
    logging.info(msg)

except subprocess.CalledProcessError as e:
    # Log the error output
    msg = f"Command failed: {' '.join(command)}\nReturn code: {e.returncode}\nError Output:\n{e.stderr}"
    print(msg)
    logging.error(msg)
