# Install script for directory: /home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/velodyne/velodyne_driver/src/driver

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

if(CMAKE_INSTALL_COMPONENT STREQUAL "main" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_driver/velodyne_node" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_driver/velodyne_node")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_driver/velodyne_node"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/velodyne_driver" TYPE EXECUTABLE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/velodyne_driver/velodyne_node")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_driver/velodyne_node" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_driver/velodyne_node")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_driver/velodyne_node"
         OLD_RPATH "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib:/nix/store/kn06j0x4z5bcbpzy6y50xkpkxngd73dn-ros-noetic-diagnostic-updater-1.11.0-r1/lib:/nix/store/2wyx9fbrnh8rwl7k6si795hmv2kwk28j-ros-noetic-dynamic-reconfigure-1.7.3-r1/lib:/nix/store/mibjq8d5wq8ndrc3a6fkzsjrbs6583zc-ros-noetic-nodelet-1.10.2-r1/lib:/nix/store/jpa0d901zdmc9r23bxvqiz7d1bkf730m-ros-noetic-bondcpp-1.8.6-r1/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/nix/store/frxg2hvacachpkv3ywdpmfl5pl2yg5y6-gcc-wrapper-12.3.0/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/velodyne_driver/velodyne_node")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libdriver_nodelet.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libdriver_nodelet.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libdriver_nodelet.so"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/libdriver_nodelet.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libdriver_nodelet.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libdriver_nodelet.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libdriver_nodelet.so"
         OLD_RPATH "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib:/nix/store/kn06j0x4z5bcbpzy6y50xkpkxngd73dn-ros-noetic-diagnostic-updater-1.11.0-r1/lib:/nix/store/2wyx9fbrnh8rwl7k6si795hmv2kwk28j-ros-noetic-dynamic-reconfigure-1.7.3-r1/lib:/nix/store/mibjq8d5wq8ndrc3a6fkzsjrbs6583zc-ros-noetic-nodelet-1.10.2-r1/lib:/nix/store/jpa0d901zdmc9r23bxvqiz7d1bkf730m-ros-noetic-bondcpp-1.8.6-r1/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/nix/store/frxg2hvacachpkv3ywdpmfl5pl2yg5y6-gcc-wrapper-12.3.0/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libdriver_nodelet.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

