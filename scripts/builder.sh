#!/bin/bash

# Always run in catkin_ws
# parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
# cd "$parent_path/../ros/catkin_ws"

# Get active IP address
ip_addr=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
husky_addr=$(./getip husky)

export ROS_IP=$ip_addr
export ROS_MASTER_IP=$husky_addr

cmake_args=(
  -DCMAKE_BUILD_TYPE=Release
  -DCMAKE_WARN_DEPRECATED=OFF
)

alias cake="catkin build --cmake-args ${cmake_args[@]}"
