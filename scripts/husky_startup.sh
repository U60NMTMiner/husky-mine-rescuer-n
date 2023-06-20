#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
set -x

# Always run as root.
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# Get active IP address
ip_addr=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')

# Figure out which usb is which
HUSKY_PORT=$(basename "$(readlink "/dev/serial/by-id/$(ls /dev/serial/by-id | grep Prolific)")")
IMU_PORT=$(basename "$(readlink "/dev/serial/by-id/$(ls /dev/serial/by-id | grep FTDI)")")

export ROS_MASTER_URI http://$ip_addr:11311
export ROS_IP $ip_addr
export HUSKY_LOGITECH 1
export HUSKY_PORT /dev/$HUSKY_PORT
export IMU_PORT /dev/$IMU_PORT
export HUSKY_LASER_3D_ENABLED 1

cd ../ros/catkin_ws/
catkin build
roscore
rosrun --wait husky_bringup install
roslaunch --wait husky_base base.launch 
roslaunch --wait velodyne_pointcloud VLP16_points.launch
roslaunch --wait vectornav vectornav.launch
