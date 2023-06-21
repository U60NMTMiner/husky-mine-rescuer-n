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
      rqt-reconfigure
      robot-state-publisher
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
  shellHook = ''
    # Get active IP address
    ip_addr=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
    export ROS_IP=$ip_addr
    export HUSKY_LOGITECH=1
    export HUSKY_LASER_3D_ENABLED=1
    if [ "$(hostname)" = "husky" ]; then
      export ROS_MASTER_URI=http://$ip_addr:11311
      # Figure out which usb is which
      HUSKY_PORT=$(basename "$(readlink "/dev/serial/by-id/$(ls /dev/serial/by-id | grep Prolific)")")
      IMU_PORT=$(basename "$(readlink "/dev/serial/by-id/$(ls /dev/serial/by-id | grep FTDI)")")
      export HUSKY_PORT=/dev/$HUSKY_PORT
      export IMU_PORT=/dev/$IMU_PORT
    else
      export ROS_MASTER_URI=http://jetson:11311
      alias start_joy="roslaunch husky_teleop teleop.launch"
    fi
    cd ros/catkin_ws
  '';
}
