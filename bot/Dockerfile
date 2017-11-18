# FROM tiangolo/uwsgi-nginx-flask:flask-python3.5
FROM python:3.6-stretch

MAINTAINER luckydonald

ARG FOLDER
ARG GROUP_UID=1020
ARG USER_UID=1020
ARG GOSU_VERSION=1.10
# GOSU_VERSION: https://github.com/tianon/gosu/releases

# copy that into the container
ENV GROUP_UID $GROUP_UID
ENV USER_UID $USER_UID
# Sane defaults for pip
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on

# To force docker to build the RUN step again, change this value.
ARG DOCKER_CACHE_KILLER=2

RUN set -x \
    # make überstart executable
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
    # Install nginx, and stuff
        ca-certificates \
        gettext-base \
    # utilities
        nano \
    # install python wsgi
    && pip install --upgrade pip -e git://github.com/luckydonald-forks/uwsgi-tools.git@master#egg=uwsgi-tools \
    && rm -rfv /var/lib/apt/lists/* \
    # install gosu (root stepdown)
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -rfv "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && groupadd -r uwsgi --gid ${GROUP_UID} && useradd -r -g uwsgi uwsgi --uid ${USER_UID} \
    # test gosu
    && gosu uwsgi true

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --start-period=5s CMD ["/healthcheck.sh", "--timeout", "5"]


COPY $FOLDER/entrypoint.sh      /
COPY $FOLDER/healthcheck.sh     /
COPY $FOLDER/uwsgi.ini          /config/
RUN chmod +x /entrypoint.sh /healthcheck.sh

ONBUILD COPY $FOLDER/requirements.txt   /config/
ONBUILD RUN pip install -r /config/requirements.txt

ONBUILD COPY $FOLDER/code /app
