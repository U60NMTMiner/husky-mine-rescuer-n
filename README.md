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
Add the husky to your /etc/hosts, where {husky-ip} is the ip address of the husky. This is currently sent as a discord message on wifi startup.
The ip address will change occasionally. Instead of running the following command, simply edit the /etc/hosts file to include the new ip. 
```sudo bash -c "echo \"xxx.xxx.xxx.xxx    husky\" >> /etc/hosts"```  
Add to bashrc. Execute the following from inside the git repo folder  
```echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc```  
```echo "source $PWD/ros/catkin_ws/devel/setup.bash" >> ~/.bashrc```  
On carl: ```echo "source $PWD/scripts/env_husky.sh" >> ~/.bashrc```  
On raspi: ```echo "source $PWD/scripts/env_pi.sh" >> ~/.bashrc```  
On host: ```echo "source $PWD/scripts/env_ctrl.sh" >> ~/.bashrc```  
Source bashrc  
```source ~/.bashrc```  
Build (cake has been aliased to catkin build with cmake options)  
```cd ros/catkin_ws && cake```  

### Usage

#### On Carl

Start the base  
```roslaunch husky_base base.launch```  

This can be started with options. Append these to the end, eg.  
```roslaunch husky_base base.launch arg:=value arg:=value```  
Arguments  
- **port**: Physical usb port of the husky. Defaults to environmental variable HUSKY_PORT or /dev/prolific
- **pi_addr**: IP adcress of the connected raspberry pi. Defaults to environmental variable PI_ADDRESS or 10.0.0.5
- **ouster**: true/false. Whether to launch ouster nodes. Defaults to false
- **velodyne**: true/false. Whether to launch velodyne nodes. Defaults to false
- **imu**: true/false. Whether to launch imu nodes on the raspberry pi. Defaults to false
- **map**: true/false. Whether to launch google cartographer nodes. Defaults to false

#### On host machine

To start joystick control `start_joy` has been aliased. Rviz can also be run. `rviz` will run a basic unconfigured rviz. The rviz folder contains configurations
for rviz, which can be run with `rviz -d path_to_config`

### After First-Time Setup

After you've run Carl for the first time, this Google Doc [Using the Husky Rover](https://docs.google.com/document/d/1mPvYiojK2ZEdXlYF6LimjaO2kbSO9qbYCGDZx3Ve6g0/edit?usp=sharing)
contains step-by-step instructions for subsequent runs.
