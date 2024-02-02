#!/bin/bash

set -eou pipefail
export DEBIAN_FRONTEND='noninteractive'

_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-get install curl -y
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

sudo apt-get update -y
sudo apt-get upgrade -y

packages=(
    ros-noetic-ros-base

    ros-noetic-urdf
    ros-noetic-xacro
    ros-noetic-joy
    ros-noetic-teleop-twist-joy
    ros-noetic-teleop-twist-keyboard
    ros-noetic-twist-mux
    ros-noetic-pcl-ros
    ros-noetic-navigation
    ros-noetic-robot-localization
    ros-noetic-robot-state-publisher
    ros-noetic-cv-bridge
    ros-noetic-tf2-tools
    ros-noetic-imu-transformer
    ros-noetic-imu-filter-madgwick
    ros-noetic-image-common
    ros-noetic-librealsense2
    ros-noetic-realsense2-camera

    python3-rosdep
    python3-catkin-tools

    libcurl4-openssl-dev
    libjsoncpp-dev
    libpcl-dev
    libcv-bridge-dev

    librealsense2-dev
)


sudo apt-get install -y ${packages[@]}


# sudo rosdep init || true
# rosdep update
# rosdep install --from-paths $_dir/../ros/catkin_ws/src --ignore-src --rosdistro=noetic -y
