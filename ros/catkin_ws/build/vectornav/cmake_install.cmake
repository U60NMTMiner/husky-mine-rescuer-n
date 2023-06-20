# Install script for directory: /home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/vectornav

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/vectornav/msg" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/vectornav/msg/Ins.msg")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/vectornav/cmake" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/vectornav/catkin_generated/installspace/vectornav-msg-paths.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/include/vectornav")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/share/roseus/ros/vectornav")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/share/common-lisp/ros/vectornav")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/share/gennodejs/ros/vectornav")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/nix/store/6qk2ybm2yx2dxmx9h4dikr1shjhhbpfr-python3-3.10.11/bin/python3" -m compileall "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/python3/dist-packages/vectornav")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages" TYPE DIRECTORY FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/python3/dist-packages/vectornav")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/vectornav/catkin_generated/installspace/vectornav.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/vectornav/cmake" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/vectornav/catkin_generated/installspace/vectornav-msg-extras.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/vectornav/cmake" TYPE FILE FILES
    "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/vectornav/catkin_generated/installspace/vectornavConfig.cmake"
    "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/vectornav/catkin_generated/installspace/vectornavConfig-version.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/vectornav" TYPE FILE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/vectornav/package.xml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/vectornav/vnpub" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/vectornav/vnpub")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/vectornav/vnpub"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/vectornav" TYPE EXECUTABLE FILES "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib/vectornav/vnpub")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/vectornav/vnpub" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/vectornav/vnpub")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/vectornav/vnpub"
         OLD_RPATH "/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/nix/store/frxg2hvacachpkv3ywdpmfl5pl2yg5y6-gcc-wrapper-12.3.0/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/vectornav/vnpub")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/build/vectornav/vnproglib-1.2.0.0/cpp/cmake_install.cmake")

endif()

