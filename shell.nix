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
    (buildEnv { paths = [
      rosbash
      roscpp
      xacro
      rosbag
      rqt-reconfigure
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
    ]; })
  ];
  name = "ros-term";
  version = "0.2";
  shellHook = "source scripts/builder.sh";
}
