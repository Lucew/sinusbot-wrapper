#!/usr/bin/python3
import sys
import os
import subprocess
import logging

# Configure the logging
log_file = "yt-dlp.log"
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

# check whether there are cookies
cookie_path = "/opt/sinusbot/cookies.txt"
if not os.path.isfile(cookie_path):
    with open(cookie_path, 'w'): pass
    error_msg = f"There is no cookies file in '{cookie_path}'. But I created it."
    logging.error(error_msg)
    raise FileNotFoundError(error_msg)

# get the arguments the file is run with
args = sys.argv
command = [r"/opt/sinusbot/yt-dlp", "--cookies", cookie_path, *args[1:]]

# run the yt-dlp command but add the cookies
try:
    result = subprocess.run(command, capture_output=True, text=True, check=True)

    # Log the command and its output
    logging.info(f"Command ran successfully: {' '.join(command)}\nOutput:\n{result.stdout}")

except subprocess.CalledProcessError as e:
    # Log the error output
    logging.error(f"Command failed: {' '.join(command)}\nReturn code: {e.returncode}\nError Output:\n{e.stderr}")
