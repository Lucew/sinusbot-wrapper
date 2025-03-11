FROM ubuntu:22.04
LABEL authors="lucas"


# install necessary python libraries and try to use docker cache by only copying the requirements
RUN apt-get update
RUN apt-get install -y x11vnc xvfb libxcursor1 ca-certificates curl bzip2 libnss3 libegl1-mesa x11-xkb-utils libasound2 libpci3 libxslt1.1 libxkbcommon0 libxss1 libxcomposite1 libevent-dev liblcms2-dev libatomic1
RUN apt-get install -y qtbase5-dev qt5-qmake
RUN update-ca-certificates
RUN apt-get install -y libglib2.0-0
RUN adduser --disabled-login sinusbot

# get wget to download stuff
RUN apt-get install -y wget

# create folder
RUN mkdir -p /opt/sinusbot

# grant sinusbot user permissions on specified folder
RUN chown -R sinusbot:sinusbot /opt/sinusbot

USER sinusbot
WORKDIR /opt/sinusbot
RUN wget https://www.sinusbot.com/dl/sinusbot.current.tar.bz2

RUN tar -xjf sinusbot.current.tar.bz2
RUN cp config.ini.dist config.ini

# install youtube-dl
RUN curl -s -L -o yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
RUN chmod 755 yt-dlp
COPY ../auctionator-service/cookies.txt /opt/sinusbot/
RUN echo 'YoutubeDLPath = "/opt/sinusbot/yt-dlp"' >> config.ini
RUN /opt/sinusbot/yt-dlp --cookies cookies.txt https://www.youtube.com/watch?v=GI6CfKcMhjY&ab_channel=thelonelyisland

# set the current/supported TS3 version here
ARG VERSION="3.5.2"
RUN wget https://files.teamspeak-services.com/releases/client/$VERSION/TeamSpeak3-Client-linux_amd64-$VERSION.run
RUN chmod 0755 TeamSpeak3-Client-linux_amd64-$VERSION.run
RUN yes | ./TeamSpeak3-Client-linux_amd64-$VERSION.run

RUN rm TeamSpeak3-Client-linux_amd64/xcbglintegrations/libqxcb-glx-integration.so
RUN mkdir TeamSpeak3-Client-linux_amd64/plugins
RUN cp plugin/libsoundbot_plugin.so TeamSpeak3-Client-linux_amd64/plugins/
RUN chmod 755 sinusbot

CMD ["./sinusbot", "--override-password=newpassword"]