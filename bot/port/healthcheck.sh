#!/bin/bash
CMD="curl";
ARGS="curl --fail http://localhost/${HEALTHCHECK_URL:-/healthcheck} $@";
echo "exec gosu $USER_UID:$GROUP_UID $CMD ''$ARGS''";
exec gosu $USER_UID:$GROUP_UID  $CMD $ARGS || exit 1
