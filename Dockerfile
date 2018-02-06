FROM python:3-slim-stretch
#FROM python:3-alpine
ENV PYTHONUNBUFFERED 1  
RUN mkdir /config  
ADD /config/requirements.txt /config/  
ADD /config/config.py /config/  

#FFMPEG
# The repository needs updating from the original
# Note that ffmpeg not standardly available for Ubuntu 14.04: http://www.faqforge.com/linux/how-to-install-ffmpeg-on-ubuntu-14-04/
RUN echo "deb http://httpredir.debian.org/debian jessie-backports main non-free\n" >> /etc/apt/sources.list
RUN echo "deb-src http://httpredir.debian.org/debian jessie-backports main non-free\n" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y ffmpeg

# ENV FFMPEG_VERSION=3.4.1
# WORKDIR /tmp/ffmpeg

# RUN apk add --update build-base curl nasm tar bzip2 \
#   zlib-dev openssl-dev yasm-dev lame-dev libogg-dev x264-dev libvpx-dev libvorbis-dev x265-dev freetype-dev libass-dev libwebp-dev rtmpdump-dev libtheora-dev opus-dev && \
#   DIR=$(mktemp -d) && cd ${DIR} && \
#   curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . && \
#   cd ffmpeg-${FFMPEG_VERSION} && \
#   ./configure \
#   --enable-version3 --enable-gpl --enable-nonfree --enable-small --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libvpx --enable-libtheora --enable-libvorbis --enable-libopus --enable-libass --enable-libwebp --enable-librtmp --enable-postproc --enable-avresample --enable-libfreetype --enable-openssl --disable-debug && \
#   make && \
#   make install && \
#   make distclean && \
#   rm -rf ${DIR} && \
#   apk del build-base curl tar bzip2 x264 openssl nasm && rm -rf /var/cache/apk/*


RUN pip install -r /config/requirements.txt && mkdir -p /var/www/html/tE-backend/tRecorderApi;  
WORKDIR /var/www/html/tE-backend/tRecorderApi