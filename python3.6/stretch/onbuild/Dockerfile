#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM luckydonald/telegram-bot:3.6-stretch

LABEL docker.image.base="luckydonald/telegram-bot:3.6-stretch-onbuild"

ONBUILD COPY $FOLDER/requirements.txt   /config/
ONBUILD RUN pip install --no-cache-dir -r /config/requirements.txt

ONBUILD COPY $FOLDER/code /app
