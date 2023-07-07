/**
*
*  \author     Paul Bovbel <pbovbel@clearpathrobotics.com>
*  \copyright  Copyright (c) 2014-2015, Clearpath Robotics, Inc.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of Clearpath Robotics, Inc. nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL CLEARPATH ROBOTICS, INC. BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* Please send comments, questions, or patches to code@clearpathrobotics.com
*
*/

#include "ros/ros.h"
#include "geometry_msgs/Twist.h"
#include "husky_base/horizon_legacy_wrapper.h"
#include "husky_base/husky_diagnostics.h"
#include "diagnostic_updater/diagnostic_updater.h"
#include "husky_msgs/HuskyStatus.h"

double max_accel;
double max_speed;
double control_frequency;

ros::Rate *rate;

void callback(const geometry_msgs::Twist::ConstPtr& msg)
{
  double left = msg->linear.x - msg->angular.z;
  double right = msg->linear.x + msg->angular.z;
  double large = (left > right) ? left : right;
  if ( large > max_speed )
  {
    left *= max_speed / large;
    right *= max_speed / large;
  }

  horizon_legacy::controlSpeed(left, right, max_accel, max_accel);
  rate->sleep();
}

int main(int argc, char *argv[])
{
  ros::init(argc, argv, "husky_base");
  ros::NodeHandle nh, private_nh("~");

  private_nh.param<double>("control_frequency", control_frequency, 10.0);
  private_nh.param<double>("max_accel", max_accel, 5.0);
  private_nh.param<double>("max_speed", max_speed, 1.0);

  rate = new ros::Rate(control_frequency);
  
  std::string port;
  private_nh.param<std::string>("port", port, "/dev/ttyUSB0");
  if (!horizon_legacy::isConnected(port))
  {
    horizon_legacy::connect(port);
  } else { std::cout << "Already Connected\n"; }
  horizon_legacy::configureLimits(max_speed, max_accel);

  ros::Subscriber sub = nh.subscribe("joy_teleop/cmd_vel", 5, callback);

  ros::spin();
  delete rate;

  return 0;
}
