cmake_minimum_required(VERSION 2.8.3)
project(imu_filter)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  sensor_msgs
  tf2
  tf2_ros
)

catkin_package(
  INCLUDE_DIRS include
  CATKIN_DEPENDS roscpp sensor_msgs tf2 tf2_ros
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

add_executable(imu_filter src/imu_filter.cpp)
target_link_libraries(imu_filter ${catkin_LIBRARIES})

add_executable(imu_to_tf src/imu_to_tf.cpp)
target_link_libraries(imu_to_tf ${catkin_LIBRARIES})
