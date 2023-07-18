// imu_filter.cpp
#include <ros/ros.h>
#include <sensor_msgs/Imu.h>

class KalmanFilter {
public:
    KalmanFilter() : Q(0.01), R(0.1), P(1.0), X(0.0) {}
    KalmanFilter(double q, double r, double p, double x) : Q(q), R(r), P(p), X(x) {}

    double update(double measurement) {
        // Prediction
        double X_pred = X;
        double P_pred = P + Q;

        // Update
        double K = P_pred / (P_pred + R);
        X = X_pred + K * (measurement - X_pred);
        P = (1 - K) * P_pred;

        return X;
    }

private:
    double Q; // Process noise covariance
    double R; // Measurement noise covariance
    double P; // Estimate error covariance
    double X; // Estimated state
};

class IMUFilterNode {
public:
    IMUFilterNode() : nh("~"), count(0) {
        nh.param<int>("calibration_samples", calibration_samples, 100);
        nh.param<std::string>("imu_data_topic", imu_data_topic, "/vectornav/IMU");
        nh.param<std::string>("imu_correct_topic", imu_correct_topic, "/imu/data");
        sub_imu = nh.subscribe(imu_data_topic, 10, &IMUFilterNode::imuCallback, this);
        pub_calibrated_imu = nh.advertise<sensor_msgs::Imu>(imu_correct_topic, 10);
    }

    void imuCallback(const sensor_msgs::Imu::ConstPtr& msg) {
        if (count < calibration_samples) {
            int percent = count * 100 / calibration_samples;
            ROS_INFO_STREAM("IMU Calibrating " << percent << "%");
            calibrateIMU(msg);
        }
        publishCalibratedIMU(msg);
    }

    void calibrateIMU(const sensor_msgs::Imu::ConstPtr& msg) {
        // Get average of first few values and create avg offset
        count++;
        sums.orientation.x += msg->orientation.x;
        sums.orientation.y += msg->orientation.y;
        sums.orientation.z += msg->orientation.z;
        sums.orientation.w += msg->orientation.w;
        sums.angular_velocity.x += msg->angular_velocity.x;
        sums.angular_velocity.y += msg->angular_velocity.y;
        sums.angular_velocity.z += msg->angular_velocity.z;
        sums.linear_acceleration.x += msg->linear_acceleration.x;
        sums.linear_acceleration.y += msg->linear_acceleration.y;
        sums.linear_acceleration.z += msg->linear_acceleration.z;
        
        ofsts.orientation.x = -sums.orientation.x / count;
        ofsts.orientation.y = -sums.orientation.y / count;
        ofsts.orientation.z = -sums.orientation.z / count;
        ofsts.orientation.w = -sums.orientation.w / count;
        ofsts.angular_velocity.x = -sums.angular_velocity.x / count;
        ofsts.angular_velocity.y = -sums.angular_velocity.y / count;
        ofsts.angular_velocity.z = -sums.angular_velocity.z / count;
        ofsts.linear_acceleration.x = -sums.linear_acceleration.x / count;
        ofsts.linear_acceleration.y = -sums.linear_acceleration.y / count;
        ofsts.linear_acceleration.z = -sums.linear_acceleration.z / count;
    }

    void publishCalibratedIMU(const sensor_msgs::Imu::ConstPtr& msg) {
        sensor_msgs::Imu calib = *msg;

        calib.orientation.x += ofsts.orientation.x;
        calib.orientation.y += ofsts.orientation.y;
        calib.orientation.z += ofsts.orientation.z;
        calib.orientation.w += ofsts.orientation.w;
        calib.angular_velocity.x += ofsts.angular_velocity.x;
        calib.angular_velocity.y += ofsts.angular_velocity.y;
        calib.angular_velocity.z += ofsts.angular_velocity.z;
        calib.linear_acceleration.x += ofsts.linear_acceleration.x;
        calib.linear_acceleration.y += ofsts.linear_acceleration.y;
        calib.linear_acceleration.z += ofsts.linear_acceleration.z;
        
        calib.orientation.x = ox.update(calib.orientation.x);
        calib.orientation.y = oy.update(calib.orientation.y);
        calib.orientation.z = oz.update(calib.orientation.z);
        calib.orientation.w = ow.update(calib.orientation.w);
        calib.angular_velocity.x = ax.update(calib.angular_velocity.x);
        calib.angular_velocity.y = ay.update(calib.angular_velocity.y);
        calib.angular_velocity.z = az.update(calib.angular_velocity.z);
        calib.linear_acceleration.x = lx.update(calib.linear_acceleration.x);
        calib.linear_acceleration.y = ly.update(calib.linear_acceleration.y);
        calib.linear_acceleration.z = lz.update(calib.linear_acceleration.z);
        
        pub_calibrated_imu.publish(calib);
    }

private:
    ros::NodeHandle nh;
    ros::Subscriber sub_imu;
    ros::Publisher pub_calibrated_imu;
    
    std::string imu_data_topic;
    std::string imu_correct_topic;
    int calibration_samples;
    int count;

    // These messages hold the calibrated sums and offsets
    sensor_msgs::Imu sums;
    sensor_msgs::Imu ofsts;

    KalmanFilter ox;
    KalmanFilter oy;
    KalmanFilter oz;
    KalmanFilter ow;
    KalmanFilter ax;
    KalmanFilter ay;
    KalmanFilter az;
    KalmanFilter lx;
    KalmanFilter ly;
    KalmanFilter lz;
};

int main(int argc, char** argv) {
    ros::init(argc, argv, "imu_filter_node");
    IMUFilterNode imu_filter;
    ros::spin();
    return 0;
}

