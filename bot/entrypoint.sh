#!/bin/bash
set -e;

SOCKET_PATH="/sockets/bots/${URL_PATH}.sock";
CMD="/usr/local/bin/uwsgi";
ARGS="--ini /config/uwsgi.ini --need-app --die-on-term --socket=${SOCKET_PATH} --mount /${URL_PATH}=main.py $@ ${MORE_UWSGI_ARGS}";

function cleanup {
    # remove socket
    echo 'Cleaning up!';
    set -x;
    if [ -f "${SOCKET_PATH}" ]; then
        rm "${SOCKET_PATH}" || echo "removing failed"
        echo "removed socket"
    else
        echo "socket gone"
    fi
}

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "${1:0:1}" = '-' ]; then
    set -- /usr/local/bin/uwsgi "$@"
elif [ -n "${1}" ]; then
    # empty argument call
    set -- /usr/local/bin/uwsgi
elif [ "${1}" = 'uwsgi' ]; then
    # just uwsgi
    set -- /usr/local/bin/uwsgi
fi
if [ "$1" == '/usr/local/bin/uwsgi' ]; then
    # the expected command
    trap cleanup EXIT;

    chown -R $USER_UID:$GROUP_UID /sockets/bots/;
    echo "exec gosu $USER_UID:$GROUP_UID $CMD $ARGS";
    set -ex;
    exec gosu $USER_UID:$GROUP_UID $CMD $ARGS;
else
    # else default to run whatever the user wanted like "bash"
    exec "$@"
fi