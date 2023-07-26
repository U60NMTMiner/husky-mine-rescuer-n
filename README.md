# Husky Mine Rescuer

## Overview

A Husky robot (Clearpath Robotics, Inc.) eqquiped with LiDARs and depth cameras to be deployed in underground mine rescue operations. His name is Carl.

## Installation and Usage

This installation is for Linux systems. It is possible to run on windows but not supported.
Clone the Github Repo to your local machine and the husky

### Installation

Clone the git repo  
```git clone https://github.com/vandroulakis/husky-mine-rescuer.git```  
Cd into the folder  
```cd husky-mine-rescuer```  
Run the install script  
```./scripts/install_packages.sh```  
Add to bashrc. Execute the following from inside the git repo folder  
```echo "/opt/ros/noetic/setup.bash" >> ~/.bashrc```  
```echo "$PWD/ros/catkin_ws/devel/setup.bash" >> ~/.bashrc```  
On carl: ```echo "$PWD/scripts/env_husky.sh" >> ~/.bashrc```  
On raspi: ```echo "$PWD/scripts/env_pi.sh" >> ~/.bashrc```  
On host: ```echo "$PWD/scripts/env_ctrl.sh" >> ~/.bashrc```  
Source bashrc  
```source ~/.bashrc```  
Build (cake has been aliased to catkin build with cmake options)  
```cd ros/catkin_ws && cake```  

### Usage

#### On Carl

Start the base  
```roslaunch husky_base base.launch```  

This can be started with options. Append these to the end. ```base.launch arg:=value arg:=value```  
Arguments  
- **port**: Physical usb port of the husky. Defaults to environmental variable HUSKY_PORT or /dev/prolific
- **pi_addr**: IP adcress of the connected raspberry pi. Defaults to environmental variable PI_ADDRESS or 10.0.0.5
- **ouster**: Whether to launch ouster nodes. Defaults to false
- **velodyne**: Whether to launch velodyne nodes. Defaults to false
- **imu**: Whether to launch imu nodes on the raspberry pi. Defaults to false
- **map**: Wheter to launch google cartographer nodes. Defaults to false

#### On host machine

To start joystick control `start_joy` has been aliased. Rviz can also be run. eg. `rviz -d demo_3d.rviz`
