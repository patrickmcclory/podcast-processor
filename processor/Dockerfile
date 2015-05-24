# Docker image for managing audio and video files for podcasting
#
# Includes AWS Cli tools and updated apt-get repo with PPA for ffmpeg
# as well as installs of SoX and ffmpeg
#
# Currently installs: awscli 1.7.23

FROM ubuntu:14.10

RUN \
  sudo apt-get update -y -qq && \
  sudo apt-get install wget python-pip git-core -y -qq && \
  sudo pip install awscli==1.7.23

RUN \
  sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next && \
  sudo apt-get update -y -qq && \
  sudo apt-get install sox ffmpeg -y -qq

COPY normalize.sh /bin/normalize

COPY processaudio.sh /bin/processaudio

RUN \
  sudo chmod +x /bin/normalize && \
  sudo chmod +x /bin/processaudio

ENV HOME /root

WORKDIR /root

CMD ["bash"]
