FROM ros:noetic-ros-core
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y

RUN apt-get install -y libpcl-dev
# Standard tools
RUN apt-get install -y \
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
RUN apt-get install -y \
  ros-noetic-rosbag \
  ros-noetic-plotjuggler \
  ros-noetic-rqt-tf-tree \
  ros-noetic-rqt-plot \
  ros-noetic-rqt-image-view  \
  ros-noetic-dynamic-reconfigure \
  ros-noetic-rqt-reconfigure

# 2. Install ROS packages.
RUN apt-get install -y \
  ros-noetic-roscpp \
  ros-noetic-xacro

# Install Husky Dependencies
RUN apt-get install -y \
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
  ros-noetic-joy-teleop

RUN apt-get install -y \
  ros-noetic-velodyne

# Install rosdeps manually
RUN apt-get install -y libyaml-cpp-dev
RUN apt-get install -y libeigen3-dev
RUN apt-get install -y ros-noetic-cpr-onav-description
RUN apt-get install -y ros-noetic-realsense2-description
RUN apt-get install -y ros-noetic-joint-state-publisher
RUN apt-get install -y ros-noetic-joint-state-publisher-gui
RUN apt-get install -y ros-noetic-rviz
RUN apt-get install -y ros-noetic-rviz-imu-plugin
RUN apt-get install -y ros-noetic-rqt-robot-monitor
RUN apt-get install -y libpcap0.8-dev
RUN apt-get install -y ros-noetic-pcl-ros
RUN apt-get install -y ros-noetic-joint-trajectory-controller
RUN apt-get install -y ros-noetic-teleop-twist-keyboard
RUN apt-get install -y ros-noetic-imu-filter-madgwick
RUN apt-get install -y ros-noetic-imu-transformer
RUN apt-get install -y ros-noetic-microstrain-3dmgx2-imu
RUN apt-get install -y ros-noetic-microstrain-inertial-driver
RUN apt-get install -y ros-noetic-nmea-comms
RUN apt-get install -y ros-noetic-nmea-navsat-driver
RUN apt-get install -y python3-scipy
RUN apt-get install -y ros-noetic-realsense2-camera
RUN apt-get install -y ros-noetic-spinnaker-camera-driver
RUN apt-get install -y ros-noetic-um6
RUN apt-get install -y ros-noetic-um7
RUN apt-get install -y ros-noetic-urg-node
RUN apt-get install -y ros-noetic-gazebo-plugins
RUN apt-get install -y ros-noetic-gazebo-ros
RUN apt-get install -y ros-noetic-gazebo-ros-control
RUN apt-get install -y ros-noetic-hector-gazebo-plugins
RUN apt-get install -y ros-noetic-pointcloud-to-laserscan
RUN apt-get install -y ros-noetic-velodyne-gazebo-plugins
RUN apt-get install -y ros-noetic-amcl
RUN apt-get install -y ros-noetic-gmapping
RUN apt-get install -y ros-noetic-map-server
RUN apt-get install -y ros-noetic-move-base
RUN apt-get install -y ros-noetic-navfn
RUN apt-get install -y ros-noetic-base-local-planner
RUN apt-get install -y ros-noetic-dwa-local-planner

# Add /catkin_ws to the ROS environment.
COPY ros/ros_entrypoint.sh /ros_entrypoint.sh

COPY ros /ros
# RUN rosdep init
# RUN rosdep fix-permissions
# RUN rosdep update
# RUN cd /ros/catkin_ws && /ros/ros_entrypoint.sh rosdep install --from-paths src --ignore-src --rosdistro noetic -y
RUN rm -rf /ros/catkin_ws/devel /ros/catkin_ws/build
RUN cd /ros/catkin_ws && /ros/ros_entrypoint.sh catkin build

