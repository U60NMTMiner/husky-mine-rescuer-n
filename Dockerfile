FROM ros:noetic-ros-core

COPY docker/install_packages.sh /install_packages.sh
RUN /install_packages.sh

# Add /catkin_ws to the ROS environment.
COPY ros/ros_entrypoint.sh /ros_entrypoint.sh

COPY ros /ros
RUN rosdep init
RUN rosdep fix-permissions
RUN rosdep update
RUN cd /ros/catkin_ws && /ros/ros_entrypoint.sh rosdep install --from-paths src --ignore-src --rosdistro noetic -y
#RUN rm -rf /ros/catkin_ws/devel /ros/catkin_ws/build
CMD cd /ros/catkin_ws && /ros/ros_entrypoint.sh catkin build

