# Docker image for managing audio and video files for podcasting
#
# Includes AWS Cli tools and updated apt-get repo with PPA for ffmpeg
# as well as installs of SoX and ffmpeg
#
# Currently installs: awscli 1.7.23

FROM ubuntu:14.10

MAINTAINER Patrick McClory <pmcclory@gmail.com>

RUN \
  sudo apt-get update -y -qq && \
  sudo apt-get install software-properties-common wget python-pip git-core -y -qq && \
  sudo pip install awscli==1.7.23

RUN \
  sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next && \
  sudo apt-get update -y -qq && \
  sudo apt-get install -y sox libsox-fmt-mp3 lame -qq && \
  sudo apt-get install -y ffmpeg -qq

COPY normalize.sh /bin/normalize

COPY processaudio.sh /bin/processaudio

RUN \
  sudo chmod +x /bin/normalize && \
  sudo chmod +x /bin/processaudio

VOLUME /media

ENV HOME /root

WORKDIR /media

ENV MEDIA_SOURCE="BDMV.mov"
ENV NOISE_PROFILE_FILE="TWFC-NoiseProfile.mp3"
ENV AUDIO_RIP_BITRATE="256"
ENV PODCAST_BITRATE="128"

CMD ["/bin/processaudio $MEDIA_SOURCE $NOISE_PROFILE_FILE"]
