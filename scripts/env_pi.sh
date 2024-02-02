#!/bin/sh

_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${_dir}/builder.sh

export ROS_MASTER_URI="http://$ip_addr:11311"

source /opt/ros/noetic/setup.bash
source /home/ubuntu/goliath/catkin_ws/devel/setup.bash

exec "$@"
