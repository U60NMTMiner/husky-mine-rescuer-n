# Husky Mine Rescuer

## Overview

A Husky robot (Clearpath Robotics, Inc.) eqquiped with LiDAR to be deployed in underground mine rescue operations. His name is Carl.

## Installation and Usage

This installation is for Linux systems. It is possible to run on windows but not supported.
Clone the Github Repo to your local machine. It should already be on the husky. Make sure to
commit changes regularly and keep the husky up to date with git repo. Basic linux knowledge
is assumed.

### Installation

ROS noetic must be installed
Clone the git repo  
```git clone https://github.com/vandroulakis/husky-mine-rescuer.git```  

Alternatively:
'''git clone git@github.com:vandroulakis/husky-mine-rescuer.git'''

Cd into the folder  
```cd husky-mine-rescuer```  
Install required packages
```sudo apt update
sudo apt install ros-noetic-joy ros-noetic-teleop-twist-joy ros-noetic-teleop-twist-keyboard ros-noetic-rviz ros-noetic-twist-mux ros-noetic-xacro ros-noetic-tf2-tools ros-noetic-urdf python3-rosdep python3-catkin-tools```
Add ```10.0.1.1  husky``` to /etc/hosts
```sudo nano /etc/hosts```

The only package that needs to be compiled on the host machine is the husky_control package.
```cd ros/catkin_ws && catkin build husky_control```

### Usage

#### On host machine

Connect to carl's network
SSID: carl
Password: 123456789

Source ros (more details on ros installation wiki). This can be added to your .bashrc to save time
```source path_to_catkin_ws/devel/setup.bash```

Source provided script. Use . ./file instead of source. They are similar but do different things.
```cd husky_mine_rescuer/scripts && . ./env_ctrl.sh```

To move the robot, run the teleop.launch file in the husky_control package. Ensure the logitech controller is plugged into the host machine
```roslaunch husky_control teleop.launch```

The rviz folder contains configurations for rviz, which can be run with `rviz -d path_to_config` eg.
```rviz -d rviz/demo_3d.rviz```

#### On Carl

Systemd services will run husky_base on startup. These services are found under /etc/systemd/system.
husky_base will move the robot based on commands sent to topic /cmd_vel or /joy_teleop/cmd_vel/
These commands are sent over the network from the host computer running the teleop node. Carl
hosts his own network 'carl' password 123456789. Host computer must be connected to this network
in order to communicate with the husky.

Turn on the platform by pressing the power button. Ensure battery level is acceptable.
If the comm light does not turn green within 5 minutes, startup has failed.
Restart the platform.

The following instructions detail how to manually turn on the base node and mapping

SSH into Carl
```ssh jetson@husky```
Password is 123456789

If the base node is already running, kill it. Try ```systemctl --help``` for more options
```sudo systemctl stop rosMaster.service```
Service will restart on reboot.

Start the base
```roslaunch husky_base base.launch```
This normally will run as a systemd service on startup. 

This can be started with options. Append these to the end, eg.  
```roslaunch husky_base base.launch arg:=value arg:=value```  
Arguments  
- **ouster**: true/false. Whether to launch ouster nodes. Defaults to false
- **velodyne**: true/false. Whether to launch velodyne nodes. Defaults to false. DEPRACATED
- **imu**: true/false. Whether to launch imu nodes on the raspberry pi. Defaults to false. DEPRACATED
- **map**: true/false. Whether to launch google cartographer nodes. Defaults to false
To run mapping:
```roslaunch husky_base base.launch map:=true ouster:=true```
Mapping does not run automatically on startup.
