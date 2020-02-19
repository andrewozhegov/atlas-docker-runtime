#!/bin/bash

HOST_IP="`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | tail -1`"
sed -i "s/^ip=.*$/${HOST_IP}/" ~HwHiAiUser/tools/scripts/env.conf

[ "$#" -ne 0 ] && exec "$@" || {
    cd $HIAI_HOME/tools/bin && bash start.sh
}
