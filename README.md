[# Husky Mine Rescuer

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
```cd scripts && ./install_packages_host.sh```  
Add this line to /etc/hosts
```10.0.1.1  husky```

The only package that needs to be compiled on the host machine is the husky_control package.
```cd ros/catkin_ws && catkin build husky_control```

### Usage

#### On Carl

Start the base  
```roslaunch husky_base base.launch```
This should run as a systemd service on startup. If the comm light does not turn green within 5 minutes, startup has failed
For debugging, ssh into carl
```ssh jetson@husky```
kill the systemd service
```sudo systemctl stop ros.service```
And run the above command manually to see it's output. If it is successful, try restarting the systemd service
```sudo systemctl start ros.service```

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

#### On host machine

The rviz folder contains configurations
for rviz, which can be run with `rviz -d path_to_config` eg.
```rviz -d rviz/demo_3d.rviz```
](url)

To move the robot, run the teleop.launch file in the husky_control package. Ensure the logitech controller is plugged into the host machine
```roslaunch husky_control teleop.launch```
