# Husky Mine Rescuer

## Overview

A Husky robot (Clearpath Robotics, Inc.) eqquiped with LiDARs and depth cameras to be deployed in underground mine rescue operations. His name is Carl.

## Installation and Usage

The docker folder contains bash scripts that setup docker containers with ros for the robot and host computer

### ros_term

Run `ros_term` on the host computer to open a ROS connected terminal. This does not require ROS to be installed on the machine running it.
Flags:
**-r**: Remote. Connect to ROS on the robot. Running without this flag start roscore locally. To use this flag, add "<ip> carl" to your /etc/hosts file. Use after robot has been run on Carl
**-d**: Disable rebuild. Uses cached docker container when internet access is limited
**-j**: Joystick. Use this option to allow access to a USB joystick inside the docker container

### robot

Run `robot` on Carl to start ROS and all other operations
Flags:
**-d**: Disable rebuild. Uses cached docker container when internet access is limited

