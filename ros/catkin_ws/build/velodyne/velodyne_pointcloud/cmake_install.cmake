# Install script for directory: /home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_pointcloud

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/nix/store/frxg2hvacachpkv3ywdpmfl5pl2yg5y6-gcc-wrapper-12.3.0/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/velodyne_pointcloud" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/include/velodyne_pointcloud/TransformNodeConfig.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages/velodyne_pointcloud" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/python3/dist-packages/velodyne_pointcloud/__init__.py")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/nix/store/6qk2ybm2yx2dxmx9h4dikr1shjhhbpfr-python3-3.10.11/bin/python3" -m compileall "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/python3/dist-packages/velodyne_pointcloud/cfg")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages/velodyne_pointcloud" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/python3/dist-packages/velodyne_pointcloud/cfg")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_pointcloud/catkin_generated/installspace/velodyne_pointcloud.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/velodyne_pointcloud/cmake" TYPE FILE FILES
    "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_pointcloud/catkin_generated/installspace/velodyne_pointcloudConfig.cmake"
    "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_pointcloud/catkin_generated/installspace/velodyne_pointcloudConfig-version.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/velodyne_pointcloud" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_pointcloud/package.xml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/velodyne_pointcloud" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_pointcloud/include/velodyne_pointcloud/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/velodyne_pointcloud" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_pointcloud/nodelets.xml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/velodyne_pointcloud/launch" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_pointcloud/launch/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/velodyne_pointcloud/params" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_pointcloud/params/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/velodyne_pointcloud" TYPE PROGRAM FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_pointcloud/scripts/gen_calibration.py")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_pointcloud/src/lib/cmake_install.cmake")
  include("/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_pointcloud/src/conversions/cmake_install.cmake")
  include("/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_pointcloud/tests/cmake_install.cmake")

endif()

