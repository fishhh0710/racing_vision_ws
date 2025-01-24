#include <sensor_msgs/PointCloud2.h>
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/point_cloud.h>
#include <pcl/point_types.h>
#include <pcl/filters/crop_box.h>

ros::Publisher pub;

// 將 PCLVisualizer 的初始化移除
// pcl::visualization::PCLVisualizer viewer("PCL Viewer");


void cloudCallback(const sensor_msgs::PointCloud2ConstPtr& cloud_msg)
{
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
    pcl::fromROSMsg(*cloud_msg, *cloud);

    pcl::CropBox<pcl::PointXYZ> crop;
    crop.setInputCloud(cloud);
    crop.setMin(Eigen::Vector4f(0, -12, -0.5, 1.0));
    crop.setMax(Eigen::Vector4f(300, 12, 0.5, 1.0));
    pcl::PointCloud<pcl::PointXYZ> cropped_cloud;
    crop.filter(cropped_cloud);

    sensor_msgs::PointCloud2 output_cloud;
    pcl::toROSMsg(cropped_cloud, output_cloud);
    output_cloud.header = cloud_msg->header;
    pub.publish(output_cloud);
    // std::cout<<"size:"<<output_cloud.size()<<"\n";
}

int main(int argc, char** argv)
{
    std::cout<<"Conditional removal running...\n";
    ros::init(argc, argv, "conditional_removal");
    ros::NodeHandle nh;

    ros::Subscriber sub = nh.subscribe<sensor_msgs::PointCloud2>("/rslidar_points", 1, cloudCallback);

    pub = nh.advertise<sensor_msgs::PointCloud2>("/field_of_view_trimming", 1);

    ros::spin();

    return 0;
}
