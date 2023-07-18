#include <ros/ros.h>
#include <sensor_msgs/Imu.h>
#include <tf2_ros/transform_broadcaster.h>
#include <geometry_msgs/TransformStamped.h>

struct Point {
    double x;
    double y;
    double z;

    Point() : x(0.0), y(0.0), z(0.0) {}
    Point(double x_val, double y_val, double z_val) : x(x_val), y(y_val), z(z_val) {}

    // Overload addition operator
    Point operator+(const Point& other) const {
        return Point(x + other.x, y + other.y, z + other.z);
    }

    // Overload += operator
    Point& operator+=(const Point& other) {
        x += other.x;
        y += other.y;
        z += other.z;
        return *this;
    }

    // Overload subtraction operator
    Point operator-(const Point& other) const {
        return Point(x - other.x, y - other.y, z - other.z);
    }
    
    // Overload multiplication operator
    Point operator*(const Point& other) const {
        return Point(x * other.x, y * other.y, z * other.z);
    }

    // Overload multiplication operator
    Point operator*(const double& other) const {
        return Point(x * other, y * other, z * other);
    }

    // Overload division operator
    Point operator/(const Point& other) const {
        return Point(x / other.x, y / other.y, z / other.z);
    }

    // Overload division operator
    Point operator/(const double& other) const {
        return Point(x / other, y / other, z / other);
    }

};

// Overload << operator for Point
std::ostream& operator<<(std::ostream& os, const Point& p) {
    os << "(" << p.x << ", " << p.y << ", " << p.z << ")";
    return os;
}

class ImuToTFNode {
public:
    ImuToTFNode() : nh("~"), count(0), grace_loops(5) {
        nh.param<std::string>("imu_frame_id", imu_frame_id, "imu_link");
        nh.param<std::string>("world_frame_id", base_link_frame_id, "odom");
        nh.param<std::string>("imu_data_topic", imu_data_topic, "/imu/data");

        sub_imu = nh.subscribe(imu_data_topic, 10, &ImuToTFNode::imuCallback, this);
    }

    void imuCallback(const sensor_msgs::Imu::ConstPtr& msg) {
        // Calculate position from acceleration
        unsigned long curr_time = msg->header.stamp.nsec;
        double time_delta = (curr_time - last_time) / 1000000000;
        unsigned long last_time = curr_time;
        Point accel(msg->linear_acceleration.x,
                    msg->linear_acceleration.y,
                    msg->linear_acceleration.z);

        pos += accel * time_delta * time_delta;
        
        ROS_INFO_STREAM("Current Position: " << pos);
        
        // Create the transform message
        geometry_msgs::TransformStamped transformStamped;
        transformStamped.header = msg->header;
        transformStamped.child_frame_id = base_link_frame_id;
        transformStamped.transform.translation.x = pos.x;
        transformStamped.transform.translation.y = pos.y;
        transformStamped.transform.translation.z = pos.z;
        transformStamped.transform.rotation = msg->orientation;

        // Publish the transform
        if (count < grace_loops) {
            count++;
        } else {
            tf_broadcaster.sendTransform(transformStamped);
        }
    }

private:
    ros::NodeHandle nh;
    ros::Subscriber sub_imu;
    tf2_ros::TransformBroadcaster tf_broadcaster;
    std::string imu_frame_id;
    std::string base_link_frame_id;
    std::string imu_data_topic;

    unsigned long last_time;
    Point pos;

    // Give it a few loops to calculate values
    int count;
    int grace_loops;
};

int main(int argc, char** argv) {
    ros::init(argc, argv, "imu_to_tf_node");
    ros::console::set_logger_level(ROSCONSOLE_DEFAULT_NAME, ros::console::levels::Info);
    ImuToTFNode node;
    ros::spin();
    return 0;
}

