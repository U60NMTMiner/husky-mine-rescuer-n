#!/bin/bash

set -eou pipefail
export DEBIAN_FRONTEND='noninteractive'

add-apt-repository -y ppa:borglab/gtsam-release-4.0
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-get install curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

apt-get update -y
apt-get upgrade -y

apt-get install -y ros-noetic-ros-base
apt-get install -y ros-noetic-rosconsole
apt-get install -y ros-noetic-roscpp

apt-get install -y ros-noetic-urdf
apt-get install -y ros-noetic-xacro
apt-get install -y ros-noetic-joy
apt-get install -y ros-noetic-controller-manager
apt-get install -y ros-noetic-teleop-twist-joy
apt-get install -y ros-noetic-teleop-twist-keyboard
apt-get install -y ros-noetic-twist-mux
apt-get install -y ros-noetic-roslint
apt-get install -y ros-noetic-rviz
apt-get install -y ros-noetic-pcl-ros
apt-get install -y ros-noetic-navigation
apt-get install -y ros-noetic-robot-localization
apt-get install -y ros-noetic-robot-state-publisher
apt-get install -y ros-noetic-cv-bridge
apt-get install -y ros-noetic-tf2-tools
apt-get install -y ros-noetic-imu-transformer
apt-get install -y ros-noetic-imu-filter-madgwick

apt-get install -y python3-scipy
apt-get install -y libcurl4-openssl-dev
apt-get install -y libspdlog-dev
apt-get install -y libjsoncpp-dev
apt-get install -y libpcl-dev
apt-get install -y libpcap0.8-dev
apt-get install -y libgtsam-dev 
apt-get install -y libgtsam-unstable-dev
apt-get install -y libcv-bridge-dev
apt-get install -y python3-wstool
apt-get install -y python3-rosdep
apt-get install -y ninja-build
apt-get install -y stow

rosdep init
rosdep update
rosdep install --from-paths ../ros/catkin_ws/src --ignore-src --rosdistro=noetic -y

apt-get remove ros-noetic-abseil-cpp
/bin/bash ../ros/catkin_ws/src/cartographer/scripts/install_abseil.sh
