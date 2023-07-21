#!/bin/bash

path=$(dirname "$0")
cd $path
source builder.sh
alias start_joy="roslaunch husky_control teleop.launch"
