#include <ros/ros.h>
#include <sensor_msgs/PointCloud2.h>
#include <geometry_msgs/Point.h>
#include "camera_lidar_fusion/LabeledPointArray.h"
#include <iostream>
#include <cmath>
#include <vector>
#include <array>
#include <utility>

const int BATCH_SIZE = 20;
const int MAX_MATCHES = 1000;
double radius = 0.5;

//type: 1:blue 2:yellow

struct camp
{
    double x,y;
    int label;
};


std::vector<std::tuple<double, double>> lidar_points;
std::vector<camp> cam_points;

// 儲存匹配的 Lidar 與 Camera 的 ID
std::array<std::pair<int, int>, MAX_MATCHES> matched_ids;
int match_count = 0;

int lidar_index = 0;
int cam_index = 0;

void calculate_dis(const std::vector<std::tuple<double, double>>& lidar,
                   const std::vector<camp>& cam,
                   int lidar_start_index, int cam_start_index,
                   int batch_size, double radius) {
    for (int i = lidar_start_index; i < std::min(lidar_start_index + batch_size, (int)lidar.size()); ++i) {
        auto [lidar_x, lidar_y] = lidar[i];

        double min_dis = 100.0; 
        int best_cam_index = -1;
        for (int j = cam_start_index; j < std::min(cam_start_index + batch_size, (int)cam.size()); ++j) {
            // auto [cam_x, cam_y] = cam[j];
            double cam_x = cam[j].x,cam_y=cam[j].y;

            double dis = std::sqrt(std::pow(lidar_x - cam_x, 2) + std::pow(lidar_y - cam_y, 2));
            if (dis <= radius && dis < min_dis) {
                min_dis = dis;
                best_cam_index = j;
            }
        }

        if (best_cam_index != -1) {
            matched_ids[match_count++] = {i, best_cam_index};
            ROS_INFO("Lidar Point ID: %d matched with Cam Point ID: %d, Distance: %.2f",
                     i, best_cam_index, min_dis);
        }
    }
}


void lidarCallback(const camera_lidar_fusion::LabeledPointArray msg) {
    lidar_points.clear();

    for (size_t i = 0; i < msg.x.size(); ++i) {
        // float x = *(reinterpret_cast<const float*>(&msg->data[i * msg->point_step]));
        // float y = *(reinterpret_cast<const float*>(&msg->data[i * msg->point_step + sizeof(float)]));

        lidar_points.emplace_back(msg.x[i], msg.y[i]);
    }
    ROS_INFO("Lidar points size: %zu, Camera points size: %zu", lidar_points.size(), cam_points.size());
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
    ROS_INFO("Lidar points size: %zu, Camera points size: %zu", lidar_points.size(), cam_points.size());
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "lidar_camera_match");
    ros::NodeHandle nh;
    
    // Subscriber
    ros::Subscriber lidar_sub = nh.subscribe("/cone_detection", 1, lidarCallback);
    ros::Subscriber cam_sub = nh.subscribe("/yolo/objects/relative_coordinates", 1, cameraCallback);

    ros::Rate loop_rate(10);

    while (ros::ok()) {
        if (!lidar_points.empty() && !cam_points.empty()) {
            calculate_dis(lidar_points, cam_points, lidar_index, cam_index, BATCH_SIZE, radius);
        }

        ros::spinOnce();
        loop_rate.sleep();
    }

    ROS_INFO("Total Matches: %d", match_count);
    for (int i = 0; i < match_count; ++i) {
        ROS_INFO("Match %d: Lidar ID = %d, Camera ID = %d", i, matched_ids[i].first, matched_ids[i].second);
    }

    return 0;
}
