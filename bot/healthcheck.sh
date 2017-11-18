#!/bin/bash
CMD="uwsgi_curl";
ARGS="unix:///sockets/bots/${URL_PATH}.sock GET ${HEALTHCHECK_URL} $@";
echo "exec gosu $USER_UID:$GROUP_UID $CMD ''$ARGS''";
exec gosu $USER_UID:$GROUP_UID $CMD $ARGS
