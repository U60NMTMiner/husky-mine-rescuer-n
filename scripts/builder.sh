#!/bin/bash

# Always run in catkin_ws
# parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
# cd "$parent_path/../ros/catkin_ws"

# Get active IP address
ip_addr=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
export ROS_IP=$ip_addr

export HUSKY_LOGITECH=1
export HUSKY_LASER_3D_ENABLED=1
export HUSKY_LASER_3D_PREFIX=ouster


if [ "$(hostname)" = "husky" ]; then
  export ROS_MASTER_URI=http://$ip_addr:11311
  # Figure out which usb is which
  HUSKY_PORT=$(basename "$(readlink "/dev/serial/by-id/$(ls /dev/serial/by-id | grep Prolific)")")
  IMU_PORT=$(basename "$(readlink "/dev/serial/by-id/$(ls /dev/serial/by-id | grep FTDI)")")
  export HUSKY_PORT=/dev/$HUSKY_PORT
  export IMU_PORT=/dev/$IMU_PORT
else
  export ROS_MASTER_URI=http://husky:11311
  alias start_joy="roslaunch husky_teleop teleop.launch"
fi

cmake_args=(
  -DCMAKE_BUILD_TYPE=Release
  -DCMAKE_WARN_DEPRECATED=OFF
)

alias cake="catkin_make --cmake-args ${cmake_args[@]}"
