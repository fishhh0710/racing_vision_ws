#include <ros/ros.h>
#include <sensor_msgs/PointCloud2.h>
#include <geometry_msgs/Point.h>
#include "camera_lidar_fusion/LabeledPointArray.h"
#include <iostream>
#include <cmath>
#include <vector>
#include <array>
#include <utility>
#include <visualization_msgs/Marker.h>
#include <visualization_msgs/MarkerArray.h>


ros::Publisher pub;

const int BATCH_SIZE = 20;
const int MAX_MATCHES = 1000;
double radius = 0.5;

//type: 1:blue 2:yellow

struct camp
{
    double x,y;
    int label;
};

struct MatchedData {
    double lidar_x, lidar_y;
    int color_label;
};


std::vector<std::tuple<double, double>> lidar_points;
std::vector<camp> cam_points;
std::vector<MatchedData> matched_data;

// 儲存匹配的 Lidar 與 Camera 的 ID
std::vector<std::pair<int,int>> matched_ids;

visualization_msgs::Marker createMarker(int id, double x, double y, int color_label) {
    visualization_msgs::Marker marker;
    marker.header.frame_id = "map"; // 根據你的固定框架設定
    marker.header.stamp = ros::Time::now();
    marker.ns = "lidar_camera";
    marker.id = id; // Marker 的唯一 ID
    marker.type = visualization_msgs::Marker::SPHERE; // 使用球體表示
    marker.action = visualization_msgs::Marker::ADD;

    // 設置 Marker 的位置
    marker.pose.position.x = x;
    marker.pose.position.y = y;
    marker.pose.position.z = 0.0; // 假設 Z 軸為 0
    marker.pose.orientation.x = 0.0;
    marker.pose.orientation.y = 0.0;
    marker.pose.orientation.z = 0.0;
    marker.pose.orientation.w = 1.0;

    // 設置 Marker 的大小
    marker.scale.x = 0.2;
    marker.scale.y = 0.2;
    marker.scale.z = 0.2;

    // 根據顏色標籤設置 Marker 顏色
    if (color_label == 1) { // 藍色
        marker.color.r = 0.0;
        marker.color.g = 0.0;
        marker.color.b = 1.0;
        marker.color.a = 1.0; // 不透明
    } else if (color_label == 2) { // 黃色
        marker.color.r = 1.0;
        marker.color.g = 1.0;
        marker.color.b = 0.0;
        marker.color.a = 1.0; // 不透明
    } else { // 預設為紅色
        marker.color.r = 1.0;
        marker.color.g = 0.0;
        marker.color.b = 0.0;
        marker.color.a = 1.0;
    }

    return marker;
}

void calculate_dis() {
    visualization_msgs::MarkerArray marker_array; // 用於存儲所有 Marker

    for (int i = lidar_start_index; i < std::min(lidar_start_index, (int)lidar.size()); ++i) {
        auto [lidar_x, lidar_y] = lidar[i];

        double min_dis = 100.0; 
        int best_cam_index = -1;
        for (int j = cam_start_index; j < std::min(cam_start_index + batch_size, (int)cam.size()); ++j) {
            double cam_x = cam[j].x, cam_y = cam[j].y;

            double dis = std::sqrt(std::pow(lidar_x - cam_x, 2) + std::pow(lidar_y - cam_y, 2));
            if (dis <= radius && dis < min_dis) {
                min_dis = dis;
                best_cam_index = j;
            }
        }

        if (best_cam_index != -1) {
            // 保存匹配結果
            matched_data.push_back({lidar_x, lidar_y, cam[best_cam_index].label});

            // 創建對應的 Marker 並加入陣列
            marker_array.markers.push_back(createMarker(marker_array.markers.size(), lidar_x, lidar_y, cam[best_cam_index].label));

            ROS_INFO("Lidar Point (%.2f, %.2f) matched with Cam Point (%.2f, %.2f), Color Label: %d, Distance: %.2f",
                     lidar_x, lidar_y, cam[best_cam_index].x, cam[best_cam_index].y, cam[best_cam_index].label, min_dis);
        }
    }

    pub.publish(marker_array);
}


void lidarCallback(const camera_lidar_fusion::LabeledPointArray msg) {
    lidar_points.clear();

    for (size_t i = 0; i < msg.x.size(); ++i) {
        // float x = *(reinterpret_cast<const float*>(&msg->data[i * msg->point_step]));
        // float y = *(reinterpret_cast<const float*>(&msg->data[i * msg->point_step + sizeof(float)]));

        lidar_points.emplace_back(msg.x[i], msg.y[i]);
    }
    // ROS_INFO("Lidar points size: %zu, Camera points size: %zu", lidar_points.size(), cam_points.size());
}

void cameraCallback(const camera_lidar_fusion::LabeledPointArray msg) {
    cam_points.clear();
    
    for (int i=0;i<msg.x.size();i++){
        camp temp;
        temp.x = msg.x[i];
        temp.y = msg.y[i];
        temp.label = 1;
        cam_points.push_back(temp);
    }
    // ROS_INFO("Lidar points size: %zu, Camera points size: %zu", lidar_points.size(), cam_points.size());
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "lidar_camera_match");
    ros::NodeHandle nh;
    
    pub = nh.advertise<visualization_msgs::MarkerArray>("/camera_lidar_fusion/lidar_camera_markers", 1);

    // Subscriber
    ros::Subscriber lidar_sub = nh.subscribe("/cone_detection", 1, lidarCallback);
    ros::Subscriber cam_sub = nh.subscribe("/yolo/objects/relative_coordinates", 1, cameraCallback);

    ros::Rate loop_rate(10);

    while (ros::ok()) {
    if (!lidar_points.empty() && !cam_points.empty()) {
        calculate_dis();

        for (const auto& data : matched_data) {
            ROS_INFO("Matched Lidar Point: (%.2f, %.2f), Color Label: %d",
                     data.lidar_x, data.lidar_y, data.color_label);
        }

        // 清空 matched_data，避免重複輸出
        matched_data.clear();
    }

    ros::spinOnce();
    loop_rate.sleep();
    }

    return 0;
}