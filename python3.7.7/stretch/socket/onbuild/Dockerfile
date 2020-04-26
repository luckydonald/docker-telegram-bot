#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM luckydonald/telegram-bot:3.7.7-stretch-socket
ARG IMAGE_NAME
ENV IMAGE_NAME $IMAGE_NAME

LABEL docker.image.base="luckydonald/telegram-bot:3.7.7-stretch-socket-onbuild"
LABEL docker.image.name=$IMAGE_NAME

# automatically install requirements.txt and copy the code folder
ONBUILD COPY $FOLDER/requirements.txt   /config/
ONBUILD RUN pip install --no-cache-dir -r /config/requirements.txt

ONBUILD COPY $FOLDER/code /app
