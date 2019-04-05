FROM node:8-stretch-slim as builder
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/wycliffeassociates/translationExchange /translationExchange && \
    git clone https://github.com/wycliffeassociates/tE-backend /tE-backend && \
    rm -r /tE-backend/tRecorderApi/static/chunks
WORKDIR /translationExchange
RUN npm link cross-env && npm install --production && npm run build

FROM python:3.6-slim-stretch 
RUN echo "deb http://deb.debian.org/debian stretch main non-free\n" >> /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian stretch main non-free\n" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*
COPY . /
COPY --from=builder /tE-backend /var/www/html/tE-backend
COPY --from=builder /translationExchange /var/www/html/tE-backend/tRecorderApi/frontend
WORKDIR /var/www/html/tE-backend/scripts
RUN python3 ./download_chunks.py && \
    mv /var/www/html/tE-backend/scripts/chunks/ /var/www/html/tE-backend/tRecorderApi/static/ && \
    pip install -r /requirements.txt
VOLUME [ "/var/www/html/tE-backend/tRecorderApi/media" ]
WORKDIR /var/www/html/tE-backend/tRecorderApi
