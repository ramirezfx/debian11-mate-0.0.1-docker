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

# Mate desktop
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      mate-desktop-environment-core && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      fortunes \
      mate-applets \
      mate-notification-daemon \
      mate-system-monitor \
      mate-utils curl sudo firefox-esr firefox-esr-l10n-de gimp breeze wget pluma meld filezilla mate-calc atril pulseaudio vim

RUN wget -O /tmp/nomachine.deb "https://www.nomachine.com/free/arm/v8/deb" && apt-get install -y /tmp/nomachine.deb
# RUN wget -O nomachine.deb https://download.nomachine.com/download/8.2/Arm/nomachine_8.2.3_3_arm64.deb && dpkg -i nomachine.deb

# ADD nxserver.sh /
RUN wget -O /nxserver.sh "https://github.com/ramirezfx/debian11-mate-0.0.1-docker/raw/arm64-0.0.1/nxserver.sh"
RUN chmod +x /nxserver.sh
ENTRYPOINT ["/nxserver.sh"]
