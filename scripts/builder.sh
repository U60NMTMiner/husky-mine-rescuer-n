#!/bin/bash

path=$(dirname "$0")
cd $path

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
