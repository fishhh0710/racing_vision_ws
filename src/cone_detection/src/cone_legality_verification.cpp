#include <ros/ros.h>
#include <sensor_msgs/PointCloud2.h>
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/point_cloud.h>
#include <pcl/point_types.h>
#include <pcl/kdtree/kdtree.h>
#include <pcl/segmentation/extract_clusters.h>
#include <pcl/filters/voxel_grid.h>
#include <pcl/common/common.h>
#include <pcl/common/impl/common.hpp>
#include <pcl/common/centroid.h>
#include <visualization_msgs/Marker.h>
#include <visualization_msgs/MarkerArray.h>
#include "yolo/LabeledPointArray.h"
#include "std_msgs/Header.h"


ros::Publisher pub;
ros::Publisher marker_pub, test_marker_pub;

bool isConeLegal(const pcl::PointCloud<pcl::PointXYZ>::Ptr& cone_cloud)
{
    double minHeight = 0.2;
    double maxHeight = 0.35;
    double minDensity = 5;

    pcl::PointXYZ minPt, maxPt;
    pcl::getMinMax3D(*cone_cloud, minPt, maxPt);

    double coneHeight = maxPt.z - minPt.z;
    double density = cone_cloud->size() / (coneHeight * coneHeight * coneHeight);

    return (coneHeight >= minHeight) && (coneHeight <= maxHeight) && (density >= minDensity);
}
int maxid = 0;
void coneReconstruction(const sensor_msgs::PointCloud2ConstPtr& cloud_msg)
{
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
    pcl::fromROSMsg(*cloud_msg, *cloud);

    pcl::search::KdTree<pcl::PointXYZ>::Ptr tree(new pcl::search::KdTree<pcl::PointXYZ>);
    tree->setInputCloud(cloud);
    
    std::cout<<"cloud size="<<cloud->size()<<"\n";
    pcl::EuclideanClusterExtraction<pcl::PointXYZ> ec;
    ec.setClusterTolerance(0.2);
    ec.setMinClusterSize(5);
    ec.setMaxClusterSize(50);
    ec.setSearchMethod(tree);
    ec.setInputCloud(cloud);

    std::vector<pcl::PointIndices> cluster_indices;
    ec.extract(cluster_indices);

    visualization_msgs::MarkerArray marker_array;
    sensor_msgs::PointCloud2 cluster_msg;

    yolo::LabeledPointArray ret;


    for (const auto& indices : cluster_indices){
        pcl::PointCloud<pcl::PointXYZ>::Ptr cone_cloud(new pcl::PointCloud<pcl::PointXYZ>);
        for (const auto& index : indices.indices){
            cone_cloud->push_back((*cloud)[index]);
        }

        if (isConeLegal(cone_cloud)){
            visualization_msgs::Marker marker;
            marker.header = cluster_msg.header;
            marker.header.frame_id = "rslidar";
            marker.ns = "cone_marker";
            marker.id = marker_array.markers.size();
            marker.type = visualization_msgs::Marker::SPHERE;
            marker.action = visualization_msgs::Marker::ADD;

            pcl::PointXYZ center;
            pcl::computeCentroid(*cone_cloud, center);
            marker.pose.position.x = center.x;
            marker.pose.position.y = center.y;
            marker.pose.position.z = center.z;
            ret.x.push_back(center.x);
            ret.y.push_back(center.y);
            ret.z.push_back(center.z);

            marker.pose.orientation.x = 0.0;
            marker.pose.orientation.y = 0.0;
            marker.pose.orientation.z = 0.0;
            marker.pose.orientation.w = 1.0;
            marker.scale.x = 0.2;
            marker.scale.y = 0.2;
            marker.scale.z = 0.2;
            marker.color.r = 1.0;
            marker.color.g = 0.0;
            marker.color.b = 0.0;
            marker.color.a = 1.0;
            marker.lifetime = ros::Duration();

            marker_array.markers.push_back(marker);
            test_marker_pub.publish(marker);
        }
    }
    maxid = std::max(maxid,(int)marker_array.markers.size());
    for(int i = marker_array.markers.size(); i < maxid; i++){
        visualization_msgs::Marker marker;
        marker.header = cluster_msg.header;
        marker.header.frame_id = "rslidar";
        marker.ns = "cone_marker";
        marker.id = i;
        marker.action = visualization_msgs::Marker::DELETE;
        marker_array.markers.push_back(marker);
    }
    maxid = marker_array.markers.size();
    pub.publish(ret);
    marker_pub.publish(marker_array);
    std::cout<<"cone detected:"<<ret.x.size()<<"\n";
}


int main(int argc, char** argv){
    ros::init(argc, argv, "cone_detection");
    ros::NodeHandle nh;
    std::cout<<"start cone detection...\n";
    ros::Subscriber sub = nh.subscribe<sensor_msgs::PointCloud2>("/ground_segmentation/obstacle_cloud", 1, coneReconstruction);

    pub = nh.advertise<yolo::LabeledPointArray>("/cone_detection", 1);
    marker_pub = nh.advertise<visualization_msgs::MarkerArray>("/cone_marker_array", 1);
    test_marker_pub = nh.advertise<visualization_msgs::Marker>("/test_cone_marker_array", 1);


    ros::spin();

    return 0;
}