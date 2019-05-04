#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM python:3.6-stretch

ARG FOLDER=.
ARG GROUP_UID=1020
ARG USER_UID=1020
ARG GOSU_VERSION=1.10
ARG GOSU_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4
ARG UWSGICURL_VERSION=master
# latest GOSU_VERSION: https://github.com/tianon/gosu/releases
ARG BASE_IMAGE_GIT_COMMIT
ARG BASE_IMAGE_GIT_MESSAGE

# copy that into the container
ENV GROUP_UID $GROUP_UID
ENV USER_UID $USER_UID
ENV BASE_IMAGE_GIT_COMMIT $BASE_IMAGE_GIT_COMMIT
ENV BASE_IMAGE_GIT_MESSAGE $BASE_IMAGE_GIT_MESSAGE
# Sane defaults for pip
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on

MAINTAINER luckydonald
LABEL docker.image.base="luckydonald/telegram-bot:3.6-stretch"
LABEL docker.image.base.author="luckydonald"
LABEL docker.image.base.url.github="https://github.com/luckydonald/docker-telegram-bot"
LABEL docker.image.base.url.docker="https://hub.docker.com/r/luckydonald/telegram-bot/"
LABEL docker.image.base.git.commit=$BASE_IMAGE_GIT_COMMIT
LABEL docker.image.base.git.message=$BASE_IMAGE_GIT_MESSAGE

# deploy script additions
ONBUILD ARG DEPLOY_GIT_COMMIT=unknown
ONBUILD ARG DEPLOY_GIT_BRANCH=unknown
ONBUILD ARG DEPLOY_GIT_MESSAGE=unknown
ONBUILD ARG DEPLOY_GIT_BRANCHES=unknown
ONBUILD ARG DEPLOY_GIT_DIRTY_ROOT=unknown
ONBUILD ARG DEPLOY_GIT_DIRTY_PROJECT=unknown
ONBUILD ARG DEPLOY_GIT_TAGS=unknown
ONBUILD ARG DEPLOY_GIT_DATE=unknown
ONBUILD ARG DEPLOY_RUN_ARGS=unknown
ONBUILD ARG DEPLOY_RUN_DATE=unknown
# copy that into the container
ONBUILD ENV DEPLOY_GIT_COMMIT $DEPLOY_GIT_COMMIT
ONBUILD ENV DEPLOY_GIT_BRANCH $DEPLOY_GIT_BRANCH
ONBUILD ENV DEPLOY_GIT_MESSAGE $DEPLOY_GIT_MESSAGE
ONBUILD ENV DEPLOY_GIT_BRANCHES $DEPLOY_GIT_BRANCHES
ONBUILD ENV DEPLOY_GIT_DIRTY_ROOT $DEPLOY_GIT_DIRTY_ROOT
ONBUILD ENV DEPLOY_GIT_DIRTY_PROJECT $DEPLOY_GIT_DIRTY_PROJECT
ONBUILD ENV DEPLOY_GIT_TAGS $DEPLOY_GIT_TAGS
ONBUILD ENV DEPLOY_GIT_DATE $DEPLOY_GIT_DATE
ONBUILD ENV DEPLOY_RUN_ARGS $DEPLOY_RUN_ARGS
ONBUILD ENV DEPLOY_RUN_DATE $DEPLOY_RUN_DATE
# add as label for easy access
ONBUILD LABEL deploy.git.commit=$DEPLOY_GIT_COMMIT
ONBUILD LABEL deploy.git.branch=$DEPLOY_GIT_BRANCH
ONBUILD LABEL deploy.git.message=$DEPLOY_GIT_MESSAGE
ONBUILD LABEL deploy.git.branches=$DEPLOY_GIT_BRANCHES
ONBUILD LABEL deploy.git.dirty.root=$DEPLOY_GIT_DIRTY_ROOT
ONBUILD LABEL deploy.git.dirty.project=$DEPLOY_GIT_DIRTY_PROJECT
ONBUILD LABEL deploy.git.tags=$DEPLOY_GIT_TAGS
ONBUILD LABEL deploy.git.date=$DEPLOY_GIT_DATE
ONBUILD LABEL deploy.run.args=$DEPLOY_RUN_ARGS
ONBUILD LABEL deploy.run.date=$DEPLOY_RUN_DATE

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
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $GOSU_KEY \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -rfv "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && groupadd -r uwsgi --gid ${GROUP_UID} && useradd -r -g uwsgi uwsgi --uid ${USER_UID} \
    # test gosu
    && gosu uwsgi true

WORKDIR /app
HEALTHCHECK --start-period=30s --interval=15s --timeout=5s CMD ["/healthcheck.sh", "--timeout", "5"]
HEALTHCHECK CMD ["/healthcheck.sh", "--timeout", "5"]


COPY $FOLDER/entrypoint.sh      /
COPY $FOLDER/healthcheck.sh     /
COPY $FOLDER/uwsgi.ini          /config/
COPY $FOLDER/requirements.txt   /config/
RUN chmod +x /entrypoint.sh /healthcheck.sh && pip install -r /config/requirements.txt

COPY $FOLDER/code /app
