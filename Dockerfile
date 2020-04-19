FROM alpine:3.11

WORKDIR /home/discord/musicbot

# Install packages
RUN apk update \
&& apk add --no-cache \
  ca-certificates ffmpeg opus python3 libsodium-dev \
# Install build dependencies
&& apk add --no-cache --virtual .build-deps \
  gcc git libffi-dev make musl-dev python3-dev

# Install pip dependencies
ADD requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt \
  # Clean up build dependencies
  && apk del .build-deps

# Add the rest of the source code
COPY . ./

# Create volume for mapping the config
VOLUME /home/discord/musicbot/config

ENV APP_ENV=docker

ENTRYPOINT ["python3", "dockerentry.py"]
