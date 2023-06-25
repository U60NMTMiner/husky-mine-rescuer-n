#!/bin/bash

set -eou pipefail
export DEBIAN_FRONTEND='noninteractive'

apt-get update -y
apt-get upgrade -y

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
apt-get install -y python3-scipy
apt-get install -y libcurl4-openssl-dev
apt-get install -y libspdlog-dev
apt-get install -y libjsoncpp-dev
apt-get install -y libpcl-dev
apt-get install -y libpcap0.8-dev