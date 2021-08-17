#!/bin/sh

set -u
( [ ! -z ${RENODE_DIR+x} ] && \
    $RENODE_DIR/renode --version | grep 'Renode, version' ) \
    || ( echo 'Renode not yet installed' && exit 1 )
