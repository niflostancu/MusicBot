FROM alpine:3.11

ENV BOT_UID=999

# Install packages
RUN apk update && apk add --no-cache \
  bash coreutils shadow ca-certificates ffmpeg opus python3 libsodium-dev
# Install build dependencies \
RUN apk add --no-cache --virtual .build-deps \
    gcc git libffi-dev make musl-dev python3-dev

# Create user and work from home from now on ;) 
RUN useradd -u $BOT_UID -s /bin/bash -m discord
USER discord
WORKDIR /home/discord

# Install pip dependencies
ADD requirements.txt ./
RUN pip3 install --user --no-cache-dir -r requirements.txt

# Add the rest of the source code
COPY . ./
RUN mv ./config ./config.initial

ENV APP_ENV=docker

ENTRYPOINT ["/home/discord/dockerentry.sh"]
CMD ["./run.py"]

