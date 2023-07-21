#!/bin/bash

source builder.sh

export HUSKY_LOGITECH=1
export HUSKY_LASER_3D_ENABLED=1
export HUSKY_LASER_3D_PREFIX=ouster

HUSKY_PORT=$(ls /dev/serial/by-id | grep Prolific)
HUSKY_PORT=$(readlink /dev/serial/by-id/$HUSKY_PORT)
HUSKY_PORT="/dev$(basename $HUSKY_PORT)"
export HUSKY_PORT=$HUSKY_PORT

exec "$@"

