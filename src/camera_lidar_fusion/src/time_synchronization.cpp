#include <ros/ros.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/PointCloud2.h>
#include <message_filters/subscriber.h>
#include <message_filters/sync_policies/approximate_time.h>
#include <message_filters/synchronizer.h>

ros::Publisher camera_pub;
ros::Publisher lidar_pub;

// 回調函數，用於處理同步的相機和 LiDAR 資料
void callback(const sensor_msgs::ImageConstPtr& camera_msg, 
              const sensor_msgs::PointCloud2ConstPtr& lidar_msg) {
    ROS_INFO("Simultaneous release of camera and LiDAR data");
    
    // 發布同步的資料
    camera_pub.publish(camera_msg);
    lidar_pub.publish(lidar_msg);
}

int main(int argc, char** argv) {
    // 初始化 ROS 節點
    ros::init(argc, argv, "split_sync_and_publish");
    ros::NodeHandle nh;

    // 設置 Publisher
    camera_pub = nh.advertise<sensor_msgs::Image>("/synced_camera", 10);
    lidar_pub = nh.advertise<sensor_msgs::PointCloud2>("/synced_lidar", 10);

    // 訂閱原始感測器資料
    message_filters::Subscriber<sensor_msgs::Image> camera_sub(nh, "/usb_cam/image_raw", 10);
    message_filters::Subscriber<sensor_msgs::PointCloud2> lidar_sub(nh, "/rslidar_points", 10);

    // 配置時間同步器
    typedef message_filters::sync_policies::ApproximateTime<sensor_msgs::Image, sensor_msgs::PointCloud2> MySyncPolicy;
    message_filters::Synchronizer<MySyncPolicy> sync(MySyncPolicy(10), camera_sub, lidar_sub);

    // 註冊回調函數
    sync.registerCallback(boost::bind(&callback, _1, _2));

    // 開始 ROS 事件循環
    ros::spin();

    return 0;
}
