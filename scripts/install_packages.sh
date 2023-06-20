#!/bin/bash

set -euo pipefail
export DEBIAN_FRONTEND='noninteractive'

# Update
apt-get update -y
apt-get upgrade -y

apt-get install -y libpcl-dev
# Standard tools
apt-get install -y \
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
  libeigen3-dev
  
# Install visual and debugging tools
apt-get install -y \
  ros-melodic-rosbag \
  ros-melodic-plotjuggler \
  ros-melodic-rqt-tf-tree \
  ros-melodic-rqt-plot \
  ros-melodic-rqt-image-view  \
  ros-melodic-dynamic-reconfigure \
  ros-melodic-rqt-reconfigure

# 2. Install ROS packages.
apt-get install -y \
  ros-melodic-roscpp \
  ros-melodic-xacro

# Install Husky Dependencies
apt-get install -y \
  ros-melodic-ros-control \
  ros-melodic-diagnostics \
  ros-melodic-roslint \
  ros-melodic-robot-upstart \
  ros-melodic-robot-state-publisher \
  ros-melodic-velodyne-description \
  ros-melodic-robot-localization \
  ros-melodic-interactive-marker-twist-server \
  ros-melodic-twist-mux \
  ros-melodic-teleop-twist-joy \
  ros-melodic-joy \
  ros-melodic-joint-state-controller \
  ros-melodic-diff-drive-controller \
  ros-melodic-joy-teleop

apt-get install -y ros-melodic-velodyne

# Install rosdeps manually
apt-get install -y libyaml-cpp-dev
apt-get install -y libeigen3-dev
apt-get install -y ros-melodic-cpr-onav-description
apt-get install -y ros-melodic-realsense2-description
apt-get install -y ros-melodic-joint-state-publisher
apt-get install -y ros-melodic-joint-state-publisher-gui
apt-get install -y ros-melodic-rviz
apt-get install -y ros-melodic-rviz-imu-plugin
apt-get install -y ros-melodic-rqt-robot-monitor
apt-get install -y libpcap0.8-dev
apt-get install -y ros-melodic-pcl-ros
apt-get install -y ros-melodic-joint-trajectory-controller
apt-get install -y ros-melodic-teleop-twist-keyboard
apt-get install -y ros-melodic-imu-filter-madgwick
apt-get install -y ros-melodic-imu-transformer
apt-get install -y ros-melodic-microstrain-3dmgx2-imu
apt-get install -y ros-melodic-microstrain-inertial-driver
apt-get install -y ros-melodic-nmea-comms
apt-get install -y ros-melodic-nmea-navsat-driver
apt-get install -y python3-scipy
apt-get install -y ros-melodic-realsense2-camera
apt-get install -y ros-melodic-spinnaker-camera-driver
apt-get install -y ros-melodic-um6
apt-get install -y ros-melodic-um7
apt-get install -y ros-melodic-urg-node
apt-get install -y ros-melodic-gazebo-plugins
apt-get install -y ros-melodic-gazebo-ros
apt-get install -y ros-melodic-gazebo-ros-control
apt-get install -y ros-melodic-hector-gazebo-plugins
apt-get install -y ros-melodic-pointcloud-to-laserscan
apt-get install -y ros-melodic-velodyne-gazebo-plugins
apt-get install -y ros-melodic-amcl
apt-get install -y ros-melodic-gmapping
apt-get install -y ros-melodic-map-server
apt-get install -y ros-melodic-move-base
apt-get install -y ros-melodic-navfn
apt-get install -y ros-melodic-base-local-planner
apt-get install -y ros-melodic-dwa-local-planner

# Delete cached files we don't need anymore
apt-get clean

# Delete index files we don't need anymore:
rm -rf /var/lib/apt/lists/*
