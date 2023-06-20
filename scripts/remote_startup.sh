#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
set -x

# Always run as root.
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

while getopts 'r' OPTION; do
    case "$OPTION" in
        r)
            CARL_ADDRESS=$(cat /etc/hosts | grep -w carl | awk '{print $1;}')
            if [ -z "$CARL_ADDRESS" ]; then
                echo "Please add \"carls-ip  carl\" to /etc/hosts"
                exit 1
            fi
            # Some of us have more than one wireless card
            MY_ADDRESS=$(ip route get $CARL_ADDRESS | sed 's/.* src //;s/ .*//;2,$d')

            export ROS_IP $MY_ADDRESS
            export ROS_MASTER_URI http://jetson:11311
            ;;
    esac
done

cd ../ros/catkin_ws/
catkin build
