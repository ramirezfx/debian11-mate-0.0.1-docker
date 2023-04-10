# x11docker/mate
# 
# Run Mate desktop in docker container. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: x11docker --desktop x11docker/mate
#           x11docker x11docker/mate caja
#
# Options:
# Persistent home folder stored on host with   --home
# Shared host file or folder with              --share PATH
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# ALSA sound support with option               --alsa
# Pulseaudio sound support with option         --pulseaudio
# Language setting with                        --lang [=$LANG]
# Printing over CUPS with                      --printer
# Webcam support with                          --webcam
#
# See x11docker --help for further options.

FROM debian:bookworm

RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      dbus-x11 \
      procps \
      psmisc && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      xdg-utils \
      xdg-user-dirs \
      menu-xdg \
      mime-support \
      desktop-file-utils && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      mesa-utils \
      mesa-utils-extra \
      libxv1

# Language/locale settings
#   replace en_US by your desired locale setting, 
#   for example de_DE for german.
ENV LANG de_DE.ISO-8859-1
RUN echo $LANG UTF-8 > /etc/locale.gen && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      locales && \
    update-locale --reset LANG=$LANG

# Mate desktop
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      mate-desktop-environment-core && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      fortunes \
      mate-applets \
      mate-notification-daemon \
      mate-system-monitor \
      mate-utils curl sudo kmymoney firefox-esr firefox-esr-l10n-de gimp breeze wget pluma meld filezilla mate-calc atril pulseaudio vim
      
RUN wget -O /tmp/nomachine.deb "https://www.nomachine.com/free/linux/64/deb" && apt-get install -y /tmp/nomachine.deb
# && echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
RUN apt-get install -y /tmp/google-chrome-stable_current_amd64.deb
RUN sed -i 's/\/usr\/bin\/google-chrome-stable/\/usr\/bin\/google-chrome-stable --no-sandbox/g' /usr/share/applications/google-chrome.desktop
RUN sed -i 's/\/usr\/bin\/google-chrome-stable --incognito/\/usr\/bin\/google-chrome-stable --no-sandbox/g' /usr/share/applications/google-chrome.desktop
RUN sudo sed -i 's/\/usr\/bin\/google-chrome-stable %U/\/usr\/bin\/google-chrome-stable --no-sandbox/g' /usr/share/applications/google-chrome.desktop

RUN wget -O /nxserver.sh "https://github.com/ramirezfx/debian11-mate-0.0.1-docker/raw/main/nxserver.sh"
RUN chmod +x /nxserver.sh

ENTRYPOINT ["/nxserver.sh"]

