#!/bin/bash

set -eou pipefail
export DEBIAN_FRONTEND='noninteractive'

sudo apt-get update -y
sudo apt-get upgrade -y

packages=(
    ros-noetic-ros-base
    ros-noetic-joy
    ros-noetic-teleop-twist-joy
    ros-noetic-teleop-twist-keyboard
    ros-noetic-rviz
    ros-noetic-twist-mux
    ros-noetic-xacro
    ros-noetic-tf2-tools
    ros-noetic-urdf
    python3-rosdep
    python3-catkin-tools
)

sudo apt-get install -y ${packages[@]}


# sudo rosdep init || true
# rosdep update
# rosdep install --from-paths $_dir/../ros/catkin_ws/src --ignore-src --rosdistro=noetic -y
