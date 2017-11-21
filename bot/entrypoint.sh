#!/bin/bash
set -e;
set -o pipefail; # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully.
set -o nounset;  # Treat undefined variables as errors, not as null.

if [ "${1:0:1}" == '-' ]; then
    # this if will check if the first argument is a flag
    # but only works if all arguments require a hyphenated flag
    # -v; -SL; -f arg; etc will work, but not arg1 arg2
    echo "command is flag, using uwsgi"
    set -- /usr/local/bin/uwsgi "$@"
elif [ $# -eq 0 ]; then
    # empty argument call
    echo "command is empty, using uwsgi"
    set -- /usr/local/bin/uwsgi
elif [ "${1}" == 'uwsgi' ]; then
    # just uwsgi
    echo "command is just uwsgi"
    set -- /usr/local/bin/uwsgi
fi
if [ "$1" == '/usr/local/bin/uwsgi' ]; then
    # the expected command
    echo "command is uwsgi executable"

    SOCKET_PATH="/sockets/bots/${URL_PATH}.sock";
    CMD="/usr/local/bin/uwsgi";
    ARGS="--ini /config/uwsgi.ini --need-app --die-on-term --socket=${SOCKET_PATH} --mount /${URL_PATH}=main.py $@ ${MORE_UWSGI_ARGS:-}";

    function cleanup {
        # remove socket
        echo 'Cleaning up!';
        set -x;
        if [ -e "${SOCKET_PATH}" ]; then
            [ ! -S "${SOCKET_PATH}" ] || echo "is socket"
            rm "${SOCKET_PATH}" || echo "removing failed"
            echo "removed socket"
        else
            echo "socket gone"
        fi
    }

    [ ! -d "${SOCKET_PATH}" ] || chown -R $USER_UID:$GROUP_UID /sockets/bots/;
    echo "exec gosu $USER_UID:$GROUP_UID $CMD $ARGS";
    trap cleanup EXIT;
    exec gosu $USER_UID:$GROUP_UID $CMD $ARGS;
else
    # else default to run whatever the user wanted like "bash"
    exec "$@"
fi