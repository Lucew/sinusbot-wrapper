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
    logging.error(error_msg)
    raise FileNotFoundError(error_msg)


"""
-t mp3                          -f 'ba[acodec^=mp3]/ba/b' -x --audio-format
                                mp3

-t aac                          -f
                                'ba[acodec^=aac]/ba[acodec^=mp4a.40.]/ba/b'
                                -x --audio-format aac

-t mp4                          --merge-output-format mp4 --remux-video mp4
                                -S vcodec:h264,lang,quality,res,fps,hdr:12,a
                                codec:aac

-t mkv                          --merge-output-format mkv --remux-video mkv

-t sleep                        --sleep-subtitles 5 --sleep-requests 0.75
                                --sleep-interval 10 --max-sleep-interval 20
"""

# get the arguments the file is run with
args = sys.argv
args = [ele for ele in args if not ele.startswith('--no-call-home') or ele != '-x']
print(args)
# command = [r"/opt/sinusbot/yt-dlp", "--cookies", cookie_path, "-t", "aac", "-4", *args[1:]]
command = [r"/opt/sinusbot/yt-dlp", "--cookies", cookie_path, "-f", '"wv+ba/b"', "-x", "--audio-format", "aac", "--audio-quality", "high", "-4", *args[1:]]

# run the yt-dlp command but add the cookies
try:
    result = subprocess.run(command, capture_output=True, text=True, check=True)

    # Log the command and its output
    msg = f"Command ran successfully: {' '.join(command)}\nOutput:\n{result.stdout}"
    logging.info(msg)

    # print the result to console so the sinusbot can discover it
    print(result.stdout)

except subprocess.CalledProcessError as e:
    # Log the error output
    msg = f"Command failed: {' '.join(command)}\nReturn code: {e.returncode}\nError Output:\n{e.stderr}"
    logging.error(msg)
