FROM ubuntu:22.04
LABEL authors="lucas"


# install several required packages (these were found by trial and error)
RUN apt-get update
RUN apt-get install -y x11vnc xvfb libxcursor1 ca-certificates curl bzip2 libnss3 libegl1-mesa x11-xkb-utils libasound2 libpci3 libxslt1.1 libxkbcommon0 libxss1 libxcomposite1 libevent-dev liblcms2-dev libatomic1
RUN apt-get install -y qtbase5-dev qt5-qmake
RUN update-ca-certificates
RUN apt-get install -y libglib2.0-0

# make the sinusbot user
RUN adduser --disabled-login sinusbot

# install python so we can run the wrapper around yt-dlp
RUN apt-get install python3 python3-pip -y
RUN apt-get install python-is-python3

# install dos2unix which we will use to make sure the files have the right EOF (end of file) if we copy them
RUN apt-get install -y dos2unix

# get wget to download teamspeak and sinusbot
RUN apt-get install -y wget

# create folder for the sinusbot to be located in
RUN mkdir -p /opt/sinusbot

# grant sinusbot user permissions on specified folder
RUN chown -R sinusbot:sinusbot /opt/sinusbot

# change the user and switch to our working directory for the rest
USER sinusbot
WORKDIR /opt/sinusbot

# donwload packaged sinusbot
RUN wget https://www.sinusbot.com/dl/sinusbot.current.tar.bz2

# extract sinusbot, clean up, and make it runnable
RUN tar -xjf sinusbot.current.tar.bz2
RUN cp config.ini.dist config.ini
RUN rm sinusbot.current.tar.bz2
RUN chmod 755 sinusbot

# install yt-dlp
RUN curl -s -L -o yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
RUN chmod 755 yt-dlp

# update youtoube downloader
RUN ./yt-dlp -U

# set the command line path so sinusbot knows which file to use
RUN echo 'YoutubeDLPath = "/opt/sinusbot/shell-yt-dlp-wrapper.sh"' >> config.ini

# set the current/supported TS3 version here
ARG VERSION="3.5.2"

# download teamspeak, install it and clean up
RUN wget https://files.teamspeak-services.com/releases/client/$VERSION/TeamSpeak3-Client-linux_amd64-$VERSION.run
RUN chmod 0755 TeamSpeak3-Client-linux_amd64-$VERSION.run
RUN yes | ./TeamSpeak3-Client-linux_amd64-$VERSION.run
RUN rm TeamSpeak3-Client-linux_amd64-$VERSION.run
RUN rm TeamSpeak3-Client-linux_amd64/xcbglintegrations/libqxcb-glx-integration.so
RUN mkdir TeamSpeak3-Client-linux_amd64/plugins
RUN cp plugin/libsoundbot_plugin.so TeamSpeak3-Client-linux_amd64/plugins/

# copy the shell script into the container and make it executable
COPY yt-dlp-files/shell-yt-dlp-wrapper.sh /opt/sinusbot/
RUN sudo chown $(whoami):$(whoami) shell-yt-dlp-wrapper.sh
RUN chmod 0755 /opt/sinusbot/shell-yt-dlp-wrapper.sh

CMD ["./sinusbot", "--override-password=newpassword"]