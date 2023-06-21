#!/bin/bash

set -euo pipefail
export DEBIAN_FRONTEND='noninteractive'

# Update
apt-get update -y
apt-get upgrade -y

# Standard tools
apt-get install -y \
  apt-utils \
  libpcl-dev \
  clang \
  make \
  gcc \
  g++ \
  inetutils-ping \
  net-tools \
  git \
  tmux \
  python3-catkin-tools \
  python3-rosdep \
  apt-utils \
  libeigen3-dev \

# Visual and debugging tools
apt-get install -y \
  ros-noetic-rosbag \
  ros-noetic-plotjuggler \
  ros-noetic-rqt-tf-tree \
  ros-noetic-rqt-plot \
  ros-noetic-rqt-image-view  \
  ros-noetic-dynamic-reconfigure \
  ros-noetic-rqt-reconfigure

# Ros packages
apt-get install -y \
  ros-noetic-roscpp \
  ros-noetic-xacro \
  ros-noetic-ros-control \
  ros-noetic-diagnostics \
  ros-noetic-roslint \
  ros-noetic-robot-upstart \
  ros-noetic-robot-state-publisher \
  ros-noetic-velodyne-description \
  ros-noetic-robot-localization \
  ros-noetic-interactive-marker-twist-server \
  ros-noetic-twist-mux \
  ros-noetic-teleop-twist-joy \
  ros-noetic-joy \
  ros-noetic-joint-state-controller \
  ros-noetic-diff-drive-controller \
  ros-noetic-joy-teleop \
  ros-noetic-velodyne \
  ros-noetic-pcl-ros

# Delete cached files we don't need anymore
apt-get clean

# Delete index files we don't need anymore:
rm -rf /var/lib/apt/lists/*
