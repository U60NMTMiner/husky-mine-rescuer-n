#!/bin/bash

source builder.sh

IMU_PORT=$(ls /dev/serial/by-id | grep FTDI)
IMU_PORT=$(readlink /dev/serial/by-id/$IMU_PORT)
IMU_PORT="/dev$(basename $IMU_PORT)"
export IMU_PORT=$IMU_PORT

source /opt/ros/noetic/setup.bash
source /home/pi/husky/ros/catkin_ws/devel/setup.bash

exec "$@"
