#include <iostream>
#include <ros/ros.h>
#include <sensor_msgs/Joy.h>
#include <can/can.h>

// TODO fix the buttons
int drawer_btn = 0;
int node_btn = 1;

bool drawer = 0;
bool drawer_state = 0;
bool last_drawer_state = 0;
bool node = 0;

string interface = "can0"
static SocketCan socket(interface);

void joy_callback(const sensor_msgs::Joy::ConstPtr& joy);

int main(int argc, char** argv)
{
    ros::init(argc, argv, "joy_to_can");
    ros::NodeHandle nh;
    ros::Subscriber j_sub = nh.subscribe("joy_teleop/joy", 10, joy_callback);
    ros::Subscriber e_sub = nh.subscribe("estop", 10, estop_callback);
    ros::spin();   
}

void joy_callback(const sensor_msgs::Joy::ConstPtr& joy)
{
    if (joy->buttons[drawer_btn] && !drawer)
    {
        drawer_state = !drawer_state;
    }

    if (joy->buttons[node_btn] && !node)
    {
        CAN::drop_node(socket);
    }

    drawer = joy->buttons[drawer_btn]; 
    node = joy->buttons[node_btn]; 

    if (drawer_state && !last_drawer_state)
    {
        CAN::drawer_open(socket);
    } elif (!drawer_state && last_drawer_state)
    {
        CAN::drawer_closed(socket);
    }
    last_drawer_state = drawer_state;
}

