#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM python:3.7.7-stretch

ARG FOLDER=.
ARG GROUP_UID=1020
ARG USER_UID=1020
ARG GOSU_VERSION=1.10
ARG GOSU_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4
ARG UWSGICURL_VERSION=master
# latest GOSU_VERSION: https://github.com/tianon/gosu/releases
ARG BASE_IMAGE_GIT_COMMIT
ARG BASE_IMAGE_GIT_MESSAGE
ARG IMAGE_NAME

# copy that into the container
ENV GROUP_UID $GROUP_UID
ENV USER_UID $USER_UID
ENV BASE_IMAGE_GIT_COMMIT $BASE_IMAGE_GIT_COMMIT
ENV BASE_IMAGE_GIT_MESSAGE $BASE_IMAGE_GIT_MESSAGE
ENV IMAGE_NAME $IMAGE_NAME
# Sane defaults for pip
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on

MAINTAINER luckydonald
LABEL docker.image.base="luckydonald/telegram-bot:3.7.7-stretch-socket"
LABEL docker.image.base.author="luckydonald"
LABEL docker.image.base.url.github="https://github.com/luckydonald/docker-telegram-bot"
LABEL docker.image.base.url.docker="https://hub.docker.com/r/luckydonald/telegram-bot/"
LABEL docker.image.base.git.commit=$BASE_IMAGE_GIT_COMMIT
LABEL docker.image.base.git.message=$BASE_IMAGE_GIT_MESSAGE
LABEL docker.image.name=$IMAGE_NAME

RUN set -x \
    && mkdir -p /app \
    # install stuff we need
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
    # https
        ca-certificates \
    # utilities
        nano \
    # install latest pip and latest uwsgi curl
    && pip install --upgrade pip -e "git://github.com/luckydonald-forks/uwsgi-tools.git@$UWSGICURL_VERSION#egg=uwsgi-tools" \
    && rm -rfv /var/lib/apt/lists/* \
    # install gosu (root stepdown)
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && echo '# gnupg ipv6 workaround from https://github.com/f-secure-foundry/usbarmory-debian-base_image/issues/9#issuecomment-451635505' \
    && echo "disable-ipv6" >> ${GNUPGHOME}/dirmngr.conf \
    && echo '# gnupng name resolution failure workaround from https://github.com/f-secure-foundry/usbarmory-debian-base_image/issues/9#issuecomment-502449504' \
    && ping -c 10 ha.pool.sks-keyservers.net \
    && echo "# let's try grabbing those keys..." \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $GOSU_KEY \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -rfv "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && groupadd -r uwsgi --gid ${GROUP_UID} && useradd -r -g uwsgi uwsgi --uid ${USER_UID} \
    # test gosu
    && gosu uwsgi true

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK CMD ["/healthcheck.sh", "--timeout", "5"]
HEALTHCHECK --start-period=30s --interval=15s --timeout=5s CMD ["/healthcheck.sh", "--timeout", "5"]


COPY $FOLDER/socket/entrypoint.sh      /
COPY $FOLDER/socket/healthcheck.sh     /
COPY $FOLDER/socket/uwsgi.ini          /config/
COPY $FOLDER/requirements.txt          /config/
RUN chmod +x /entrypoint.sh /healthcheck.sh && pip install -r /config/requirements.txt

COPY $FOLDER/code /app
