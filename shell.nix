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
    glibcLocales
    pcl
    libyaml
    scipy
    rviz
    spdlog
    (buildEnv { paths = [
      ros-core
      genmsg
      twist-mux
      diagnostic-aggregator
      dwa-local-planner
      urg-node
      realsense2-description
      velodyne-gazebo-plugins
      rqt-robot-monitor
      tf2
      joint-trajectory-controller
      map-server
      pointcloud-to-laserscan
      geographic-msgs
      rosbash
      roscpp
      xacro
      rosbag
      rqt-reconfigure
      gmapping
      amcl
      um7
      robot-state-publisher
      interactive-marker-twist-server
      velodyne-description
      teleop-twist-joy
      joy
      joint-state-controller
      diff-drive-controller
      velodyne
      joint-state-publisher
      pcl-ros
      teleop-twist-keyboard
      move-base
      base-local-planner
      controller-manager
      roslint
      eigen-conversions
    ]; })
  ];
  name = "ros-term";
  version = "0.2";
  shellHook = "source scripts/builder.sh";
}
