#include <sensor_msgs/PointCloud2.h>
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/point_cloud.h>
#include <pcl/point_types.h>
#include <pcl/filters/crop_box.h>
#include "ros/ros.h"

ros::Publisher pub,time_pub;
using namespace std;

// 將 PCLVisualizer 的初始化移除
// pcl::visualization::PCLVisualizer viewer("PCL Viewer");
float min_x,min_y,min_z,max_x,max_y,max_z;

void cloudCallback(const sensor_msgs::PointCloud2ConstPtr& cloud_msg)
{
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
    pcl::fromROSMsg(*cloud_msg, *cloud);

    pcl::CropBox<pcl::PointXYZ> crop;
    crop.setInputCloud(cloud);
    crop.setMin(Eigen::Vector4f(min_x, min_y, min_z, 1.0));
    crop.setMax(Eigen::Vector4f(max_x, max_y, max_z, 1.0));
    pcl::PointCloud<pcl::PointXYZ> cropped_cloud;
    crop.filter(cropped_cloud);

    for (auto& point : cropped_cloud.points) {
        auto temp = point;
        point.x = 0.996*temp.x-0.091*temp.z;
        point.y = -temp.y;
        point.z = -0.091*temp.x - 0.996 * temp.z + 0.95;
    }
    sensor_msgs::PointCloud2 output_cloud;
    pcl::toROSMsg(cropped_cloud, output_cloud);
    output_cloud.header = cloud_msg->header;
    pub.publish(output_cloud);
    // std::cout<<"size:"<<output_cloud.size()<<"\n";
}

int main(int argc, char** argv)
{
    cout<<"[Conditional removal]Conditional removal running...\n";
    ros::init(argc, argv, "conditional_removal");
    ros::NodeHandle nh;

    bool res = 1;
    string sub_source;
    res&=nh.getParam("conditional_removel_min_x",min_x);
    res&=nh.getParam("conditional_removel_min_y",min_y);
    res&=nh.getParam("conditional_removel_min_z",min_z);
    res&=nh.getParam("conditional_removel_max_x",max_x);
    res&=nh.getParam("conditional_removel_max_y",max_y);
    res&=nh.getParam("conditional_removel_max_z",max_z);
    res&=nh.getParam("conditional_source",sub_source);

    cout<<"[Conditional removal] Param get "<<(res?"successfully":"faild")<<"\n";
    // cout<<"[Conditional removal]"<<min_x<<" "<<max_x<<"\n";
    
    // time_pub_ = nh.advertise<std_msgs::Header>("segmentation_header", 1, latch);
    ros::Subscriber sub = nh.subscribe<sensor_msgs::PointCloud2>(sub_source, 1, cloudCallback);

    pub = nh.advertise<sensor_msgs::PointCloud2>("/field_of_view_trimming", 1);

    ros::spin();

    return 0;
}
