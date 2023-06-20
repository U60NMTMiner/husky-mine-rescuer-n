{ pkgs ? import (fetchTarball "https://github.com/lopsided98/nix-ros-overlay/archive/master.tar.gz") {} }:
with pkgs;
with rosPackages.noetic;
with pythonPackages;

mkShell {
  buildInputs = [
    clang
    gnumake
    gcc
    git
    tmux
    catkin-tools
    rosdep
    eigen
    glibcLocales
    pcl
    libyaml
    scipy
    rviz
    (buildEnv { paths = [
      rosbash
      roscpp
      xacro
	    rosbag
      rqt-image-view 
      rqt-reconfigure
      ros-control
      diagnostics
      roslint
      robot-upstart
      robot-state-publisher
      velodyne-description
      robot-localization
      interactive-marker-twist-server
      twist-mux
      teleop-twist-joy
      joy
      joint-state-controller
      diff-drive-controller
      velodyne
      realsense2-description
      joint-state-publisher
      joint-state-publisher-gui
      pcl-ros
      joint-trajectory-controller
      teleop-twist-keyboard
      imu-filter-madgwick
      imu-transformer
      nmea-comms
      nmea-navsat-driver
      realsense2-camera
      pointcloud-to-laserscan
      move-base
      base-local-planner
    ]; })
  ];
}
