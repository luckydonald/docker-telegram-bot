#!/bin/bash
set -e;

SOCKET_PATH="/sockets/bots/${URL_PATH}.sock";
CMD="/usr/local/bin/uwsgi";
ARGS="--ini /config/uwsgi.ini --need-app --die-on-term --socket=${SOCKET_PATH} --mount /${URL_PATH}=main.py $@ ${MORE_UWSGI_ARGS}";

function cleanup {
    # remove socket
    echo 'Cleaning up!';
    set -x;
    rm "${SOCKET_PATH}";
}
trap cleanup EXIT;

chown -R $USER_UID:$GROUP_UID /sockets/bots/;
echo "exec gosu $USER_UID:$GROUP_UID $CMD $ARGS";
set -ex;
exec gosu $USER_UID:$GROUP_UID $CMD $ARGS;
