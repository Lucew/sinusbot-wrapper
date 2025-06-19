
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

```bash
chmod -R a+rw ./data

```bash
chmod -R a+rw ./scripts
```

```bash
docker run -d -p 8087:8087 -v ./scripts:/opt/sinusbot/scripts -v ./data:/opt/sinusbot/data --name sinusbot sinusbot
```

```bash
docker exec -it sinusbot sh
```

```bash
docker build -t sinusbot .
```

https://forum.sinusbot.com/threads/the-bot-does-not-listen-to-my-commands.8239/


find . -type f -print0 | xargs -0 dos2unix
Will recursively find all files inside current directory and call for these files dos2unix command