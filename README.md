
# How to run remote firefox
Firefox downloads
https://askubuntu.com/questions/1117381/how-can-i-get-firefox-snap-to-use-the-downloads-folder-in-my-home

X11 Windows
https://unix.stackexchange.com/a/742448

Start XLaunch (with default and without the OpenGl option)

Then set the display variable
```bash
set DISPLAY=127.0.0.1:0.0
```

Then connect through SSH using the -Y option
```bash
ssh -Y netcup
```

Then set the correct authentication
```bash
export XAUTHORITY=$HOME/.Xauthority 
```

# How to work on the folders
```bash
chmod -R a+rw ./data

```bash
chmod -R a+rw ./scripts
```


# How to run sinusbot docker
Run without logs
```bash
docker run -d -p 8087:8087 -v ./scripts:/opt/sinusbot/scripts -v ./data:/opt/sinusbot/data -v ./yt-dlp-files:/opt/sinusbot/yt-dlp-files:ro --name sinusbot sinusbot
```

Create the persistent log folder
```bash
mkdir logs
```

```bash
chown 1000:1000 logs
```

Run with the logs repository
```bash
docker run -d -p 8087:8087 -v ./logs:/opt/sinusbot/logs -v ./scripts:/opt/sinusbot/scripts -v ./data:/opt/sinusbot/data -v ./yt-dlp-files:/opt/sinusbot/yt-dlp-files:ro --name sinusbot sinusbot
```

# How to access shell into the sinusbot docker
```bash
docker exec -it sinusbot sh
```

# How to build the container
```bash
docker build -t sinusbot .
```

https://forum.sinusbot.com/threads/the-bot-does-not-listen-to-my-commands.8239/

Sometimes, when developing on windows you have to call dos2unix on the files you create on windows. Otherwise linux
and especially linux in docker will not find or correctly run the files.!

You can mititgate this:
https://docs.github.com/en/get-started/git-basics/configuring-git-to-handle-line-endings
https://stackoverflow.com/a/71674232

The data/ folder and scripts/ folder have to be owned by user id 1000
```bash
chown -R 1000:1000 /data
```

```bash
find . -type f -print0 | xargs -0 dos2unix
```
Will recursively find all files inside current directory and call for these files dos2unix command

# How to make the volume for the logs

```bash
docker volume create logs
```