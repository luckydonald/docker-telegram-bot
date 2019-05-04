#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM luckydonald/telegram-bot:3.7-stretch

LABEL docker.image.base="luckydonald/telegram-bot:3.7-stretch-onbuild"
LABEL docker.image.base.author="luckydonald"
LABEL docker.image.base.url.github="https://github.com/luckydonald/docker-telegram-bot"
LABEL docker.image.base.url.docker="https://hub.docker.com/r/luckydonald/telegram-bot/"

ONBUILD COPY $FOLDER/requirements.txt   /config/
ONBUILD RUN pip install --no-cache-dir -r /config/requirements.txt

ONBUILD COPY $FOLDER/code /app
