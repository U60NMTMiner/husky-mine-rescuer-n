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
    (buildEnv { paths = [
      rosbash
      roscpp
      xacro
	    rosbag
      plotjuggler
      rqt-tf-tree
      rqt-plot
      rqt-image-view 
      dynamic-reconfigure
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
      joy-teleop
      velodyne
      realsense2-description
      joint-state-publisher
      joint-state-publisher-gui
      rviz
      rviz-imu-plugin
      rqt-robot-monitor
      pcl-ros
      joint-trajectory-controller
      teleop-twist-keyboard
      imu-filter-madgwick
      imu-transformer
      microstrain-3dmgx2-imu
      microstrain-inertial-driver
      nmea-comms
      nmea-navsat-driver
      realsense2-camera
      spinnaker-camera-driver
      um6
      um7
      urg-node
      gazebo-plugins
      gazebo-ros
      gazebo-ros-control
      hector-gazebo-plugins
      pointcloud-to-laserscan
      velodyne-gazebo-plugins
      amcl
      gmapping
      map-server
      move-base
      navfn
      base-local-planner
      dwa-local-planner
    ]; })
  ];
}
