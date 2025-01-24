#include <ros/ros.h>
#include <sensor_msgs/PointCloud2.h>
#include <geometry_msgs/Point.h>
#include <camera_lidar_fusion/LabeledPointArray.h>
#include "bits/stdc++.h"
#include <visualization_msgs/Marker.h>
#include <visualization_msgs/MarkerArray.h>

#define F first
#define S second

const double eps = 1e-7;
//type: 1:blue 2:yellow

ros::Publisher pub,pub_label;


std::vector<std::pair<double, double>> lidar_points;
std::vector<std::pair<std::pair<double,double>,int>> cam_points;

// 儲存匹配的 Lidar 與 Camera 的 ID
std::vector<std::pair<std::pair<double,double>,int>> matched_pts;

int maxid = 0;

visualization_msgs::Marker createMarker(int id, double x, double y, int color_label) {
    visualization_msgs::Marker marker;
    marker.header.frame_id = "map";
    marker.header.stamp = ros::Time::now();
    marker.ns = "lidar_camera";
    marker.id = id; // Marker 的唯一 ID
    marker.action = marker.DELETEALL;
    marker.type = visualization_msgs::Marker::SPHERE; // 使用球體表示
    marker.action = visualization_msgs::Marker::ADD;

    // 設置 Marker 的位置
    marker.pose.position.x = x;
    marker.pose.position.y = y;
    marker.pose.position.z = 0.0;
    marker.pose.orientation.x = 0.0;
    marker.pose.orientation.y = 0.0;
    marker.pose.orientation.z = 0.0;
    marker.pose.orientation.w = 1.0;

    // 設置 Marker 的大小
    marker.scale.x = 0.2;
    marker.scale.y = 0.2;
    marker.scale.z = 0.2;

    if (color_label == 1) {
        marker.color.r = 0.0;
        marker.color.g = 0.0;
        marker.color.b = 1.0;
        marker.color.a = 1.0;
    } else if (color_label == 2) {
        marker.color.r = 1.0;
        marker.color.g = 1.0;
        marker.color.b = 0.0;
        marker.color.a = 1.0;
    } else if(color_label == 99) {
        marker.color.r = 0.0;
        marker.color.g = 0.0;
        marker.color.b = 0.0;
        marker.color.a = 0.0;
    }

    return marker;
}

double dis(std::pair<double,double> a,std::pair<double,double> b){
    return (a.F-b.F)*(a.F-b.F)+(a.S-b.S)*(a.S-b.S); 
}

void calculate_dis() {
    ROS_INFO("Lidar points size: %zu, Camera points size: %zu", lidar_points.size(), cam_points.size());
    visualization_msgs::MarkerArray marker_array;
    camera_lidar_fusion::LabeledPointArray temp;
    matched_pts.clear();
    int now = 0;
    for(auto i:cam_points){
        double min_dis = 1; //max error 0.5m
        std::pair<double,double> now_ds = {-1,-1};
        for(auto j:lidar_points){
            if(min_dis > dis(i.F, j)){
                min_dis = dis(i.F, j);
                now_ds = j;
            }
        }
        if(abs(min_dis - 5) > eps){
            matched_pts.push_back({now_ds, i.S});
            marker_array.markers.push_back(createMarker(matched_pts.size(), now_ds.F, now_ds.S, i.S));
            maxid = std::max(maxid,(int)matched_pts.size());
            temp.x.push_back(now_ds.F);
            temp.y.push_back(now_ds.S);
            if(i.S==1){
                temp.labels.push_back("blue_cone");
            }
            else{
                temp.labels.push_back("yellow_cone");
            }
        }
        for(int i = 0; i < maxid - matched_pts.size(); i++){
            marker_array.markers.push_back(createMarker(matched_pts.size() + 1 + i, 0, 0, 99));
        }
        now++;
    }
    pub.publish(marker_array);
    pub_label.publish(temp);
    std::cout<<"matched pt:"<<marker_array.markers.size()<<"\n";

}

void lidarCallback(const camera_lidar_fusion::LabeledPointArray msg) {
    lidar_points.clear();

    for (int i = 0; i < msg.x.size(); ++i) {
        lidar_points.emplace_back(msg.x[i], msg.y[i]);
    }
    // ROS_INFO("Received %zu Lidar points", lidar_points.size());
    ROS_INFO("Lidar points size: %zu, Camera points size: %zu", lidar_points.size(), cam_points.size());

}

void cameraCallback(const camera_lidar_fusion::LabeledPointArray msg) {
    cam_points.clear();
    
    for (int i = 0; i < msg.x.size(); i++){
        // std::tuple<double, double,int> temp;
        std::pair<std::pair<double,double>,int> temp;
        temp.F.F = msg.x[i];
        temp.F.S = msg.y[i];
        // temp[2] = 1;
        if(msg.labels[i]=="blue_cone"){
            temp.S = 1;
        }
        else if(msg.labels[i]=="yellow_cone"){
            temp.S = 2;
        }
        cam_points.push_back(temp);
    }

    // cam_points.emplace_back(msg->x, msg->y);
    // ROS_INFO("Received Camera Point: (%.2f, %.2f)", msg->x, msg->y);
    // ROS_INFO("Received Camera Point: (%d)", cam_points.size());
    ROS_INFO("Lidar points size: %zu, Camera points size: %zu", lidar_points.size(), cam_points.size());

}

int main(int argc, char** argv) {
    ros::init(argc, argv, "lidar_camera_match");
    ros::NodeHandle nh;
    pub = nh.advertise<visualization_msgs::MarkerArray>("/camera_lidar_fusion/lidar_camera_markers", 1);
    pub_label = nh.advertise<camera_lidar_fusion::LabeledPointArray>("/camera_lidar_fusion/lidar_camera_pos", 1);
    
    // Subscriber
    ros::Subscriber lidar_sub = nh.subscribe("/cone_detection", 1, lidarCallback);
    ros::Subscriber cam_sub = nh.subscribe("/yolo/objects/relative_coordinates", 1, cameraCallback);

    ros::Rate loop_rate(10);

    while (ros::ok()) {
        if (!lidar_points.empty() && !cam_points.empty()) {
            calculate_dis();
            // std::cout<<"matched pts:"<<matched_pts.size()<<"\n";
        }

        ros::spinOnce();
        loop_rate.sleep();
    }

    ROS_INFO("Total Matches: %d", matched_pts.size());

    return 0;
}