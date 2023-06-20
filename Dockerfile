FROM ros:noetic-ros-core
ARG DEBIAN_FRONTEND=noninteractive

COPY docker/install_packages.sh /install_packages.sh
RUN /install_packages.sh

# Add /catkin_ws to the ROS environment.
COPY ros/ros_entrypoint.sh /ros_entrypoint.sh

COPY ros /ros
RUN rm -rf /ros/catkin_ws/devel /ros/catkin_ws/build
RUN cd /ros/catkin_ws && /ros/ros_entrypoint.sh catkin build

