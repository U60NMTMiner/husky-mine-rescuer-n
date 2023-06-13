FROM ros:noetic-ros-core

RUN apt-get update -y

RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y libpcl-dev
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
libeigen3-dev

# 2. Install ROS packages from apt.
RUN apt-get install -y \
ros-noetic-roscpp \

# Install visual and debugging tools
RUN apt-get install -y \
ros-noetic-rosbag \
ros-noetic-plotjuggler \
ros-noetic-rqt-tf-tree \
ros-noetic-rqt-plot \
ros-noetic-rqt-image-view  \
ros-noetic-dynamic-reconfigure \
ros-noetic-rqt-reconfigure

# Add /catkin_ws to the ROS environment.
COPY ros/ros_entrypoint.sh /ros_entrypoint.sh

COPY ros /ros
RUN cd /ros/catkin_ws && /ros/entrypoint.sh catkin build

