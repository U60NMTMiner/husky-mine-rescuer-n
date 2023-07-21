#!/bin/bash

_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${_dir}/builder.sh
pi_addr=$(${_dir}/getip imupi) || true
export PI_ADDRESS=$pi_addr

export HUSKY_LOGITECH=1
export HUSKY_LASER_3D_ENABLED=1
export HUSKY_LASER_3D_PREFIX=ouster

port=$(get_usb "Prolific")
if [[ $? -eq 0 ]]; then
    export HUSKY_PORT=$port
else
    unset HUSKY_PORT
fi

exec "$@"

