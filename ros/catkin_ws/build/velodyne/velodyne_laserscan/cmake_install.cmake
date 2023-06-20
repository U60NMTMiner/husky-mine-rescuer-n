# Install script for directory: /home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_laserscan

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/velodyne_laserscan" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/include/velodyne_laserscan/VelodyneLaserScanConfig.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages/velodyne_laserscan" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/python3/dist-packages/velodyne_laserscan/__init__.py")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/nix/store/6qk2ybm2yx2dxmx9h4dikr1shjhhbpfr-python3-3.10.11/bin/python3" -m compileall "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/python3/dist-packages/velodyne_laserscan/cfg")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages/velodyne_laserscan" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/python3/dist-packages/velodyne_laserscan/cfg")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_laserscan/catkin_generated/installspace/velodyne_laserscan.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/velodyne_laserscan/cmake" TYPE FILE FILES
    "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_laserscan/catkin_generated/installspace/velodyne_laserscanConfig.cmake"
    "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_laserscan/catkin_generated/installspace/velodyne_laserscanConfig-version.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/velodyne_laserscan" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_laserscan/package.xml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libvelodyne_laserscan.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libvelodyne_laserscan.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libvelodyne_laserscan.so"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/libvelodyne_laserscan.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libvelodyne_laserscan.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libvelodyne_laserscan.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libvelodyne_laserscan.so"
         OLD_RPATH "/nix/store/mibjq8d5wq8ndrc3a6fkzsjrbs6583zc-ros-noetic-nodelet-1.10.2-r1/lib:/nix/store/jpa0d901zdmc9r23bxvqiz7d1bkf730m-ros-noetic-bondcpp-1.8.6-r1/lib:/nix/store/2wyx9fbrnh8rwl7k6si795hmv2kwk28j-ros-noetic-dynamic-reconfigure-1.7.3-r1/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/nix/store/frxg2hvacachpkv3ywdpmfl5pl2yg5y6-gcc-wrapper-12.3.0/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libvelodyne_laserscan.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_laserscan/velodyne_laserscan_node" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_laserscan/velodyne_laserscan_node")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_laserscan/velodyne_laserscan_node"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/velodyne_laserscan" TYPE EXECUTABLE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/velodyne_laserscan/velodyne_laserscan_node")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_laserscan/velodyne_laserscan_node" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_laserscan/velodyne_laserscan_node")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_laserscan/velodyne_laserscan_node"
         OLD_RPATH "/nix/store/mibjq8d5wq8ndrc3a6fkzsjrbs6583zc-ros-noetic-nodelet-1.10.2-r1/lib:/nix/store/jpa0d901zdmc9r23bxvqiz7d1bkf730m-ros-noetic-bondcpp-1.8.6-r1/lib:/nix/store/2wyx9fbrnh8rwl7k6si795hmv2kwk28j-ros-noetic-dynamic-reconfigure-1.7.3-r1/lib:/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/nix/store/frxg2hvacachpkv3ywdpmfl5pl2yg5y6-gcc-wrapper-12.3.0/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_laserscan/velodyne_laserscan_node")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/velodyne_laserscan" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_laserscan/nodelets.xml")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/velodyne/velodyne_laserscan/tests/cmake_install.cmake")

endif()

