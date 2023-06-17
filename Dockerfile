FROM ros:noetic-ros-core

RUN apt-get update -y

RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y libpcl-dev
# Standard tools
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
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
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ros-noetic-rosbag \
  ros-noetic-plotjuggler \
  ros-noetic-rqt-tf-tree \
  ros-noetic-rqt-plot \
  ros-noetic-rqt-image-view  \
  ros-noetic-dynamic-reconfigure \
  ros-noetic-rqt-reconfigure

# 2. Install ROS packages.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ros-noetic-roscpp \
  ros-noetic-xacro

# Install Husky Dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
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

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ros-noetic-velodyne

# Add /catkin_ws to the ROS environment.
COPY ros/ros_entrypoint.sh /ros_entrypoint.sh

COPY ros /ros
RUN rosdep init
RUN rosdep fix-permissions
RUN rosdep update
RUN cd /ros/catkin_ws && /ros/ros_entrypoint.sh rosdep install --from-paths src --ignore-src --rosdistro noetic -y
RUN rm -rf /ros/catkin_ws/devel /ros/catkin_ws/build
RUN cd /ros/catkin_ws && /ros/ros_entrypoint.sh catkin build

