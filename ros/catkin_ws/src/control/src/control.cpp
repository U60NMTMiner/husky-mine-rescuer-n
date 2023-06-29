#include "ros/ros.h"
#include "std_msgs/String.h"
#include "control/serial.h"
#include <ros/console.h>
#include <geometry_msgs/Twist.h>


// ROS Parameters
double max_accel, max_speed;
double polling_timeout;

// Serial parameters
int handle;
std::string port;
enum PayloadOffsets
{
    LEFT_SPEED = 0,
    RIGHT_SPEED = 2,
    LEFT_ACCEL = 4,
    RIGHT_ACCEL = 6,
    PAYLOAD_LEN = 8
};

double clip(double val, double min, double max);
void callback(const geometry_msgs::Twist::ConstPtr& msg);

int main(int argc, char **argv)
{
    // Setup ROS
    ros::init(argc, argv, "control");
    ros::NodeHandle nh, private_nh("~");

    private_nh.param<double>("max_accel", max_accel, 5.0);
    private_nh.param<double>("max_speed", max_speed, 1.0);
    private_nh.param<std::string>("port", port, "/dev/prolific");
    
    // Setup serial
    handle = serial::start(port, 3);
    if (handle < 0) {
        ROS_FATAL_STREAM("Failed to connect to " << port);
        return -1;
    }

    ros::Subscriber sub = nh.subscribe("/joy_teleop/cmd_vel", 1000, callback);
    ros::spin();
    close(handle);
    return 0;
}


double clip(double val, double min, double max)
{
    double c_val = (val > max) ? max : val;
    return (c_val < min) ? min : c_val;
}

void callback(const geometry_msgs::Twist::ConstPtr& msg)
{
    // Getting speed
    double left = msg->linear.x - msg->angular.z; 
    double right = msg->linear.x + msg->angular.z;
    left = clip(left, max_speed, -max_speed);
    right = clip(right, max_speed, -max_speed);
    ROS_INFO_STREAM("Control: Sending Speed (L: "
            << left << ", R: " << right << ")");

    // Sending
    uint8_t payload[PayloadOffsets::PAYLOAD_LEN];
    int ofst = serial::DataOffsets::PAYLOAD_OFST;
    serial::ftob(payload + ofst + PayloadOffsets::LEFT_SPEED, 2, left, 100);
    serial::ftob(payload + ofst + PayloadOffsets::RIGHT_SPEED, 2, right, 100);
    serial::ftob(payload + ofst + PayloadOffsets::LEFT_ACCEL, 2, max_accel, 100);
    serial::ftob(payload + ofst + PayloadOffsets::RIGHT_ACCEL, 2, max_accel, 100);
    serial::utob(payload + serial::DataOffsets::TYPE_OFST, 2, 
        (uint16_t) serial::MessageTypes::SET_DIFF_WHEEL_SPEEDS);
    int written = write(handle, (char *) payload, PayloadOffsets::PAYLOAD_LEN);
    if (written < 0) {
        ROS_ERROR("Failed to write speed");
    }
}
