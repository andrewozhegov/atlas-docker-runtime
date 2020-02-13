#!/bin/bash

[ "$#" -ne 0 ] && exec "$@" || {
    sed -i 's/^ip=.*$/ip=10.0.40.106/' ~HwHiAiUser/tools/scripts/env.conf
    cd $HIAI_HOME/tools/bin && bash start.sh &
    read
}
