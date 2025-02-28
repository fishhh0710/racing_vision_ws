#include "ros/ros.h"
#include "geometry_msgs/Point.h"
#include "geometry_msgs/PointStamped.h"
#include "visualization_msgs/Marker.h"
#include "visualization_msgs/MarkerArray.h"
#include "yolo/LabeledPointArray.h"
#include <cmath>
#include <chrono>
#include <vector>
#include <std_msgs/Int8MultiArray.h>

class CameraPointListener {
public:
    CameraPointListener() {
        sub = nh.subscribe("/yolo/objects/world_point_array", 10, &CameraPointListener::pointCallback, this);
        pub = nh.advertise<visualization_msgs::MarkerArray>("/yolo/objects/cone_marker", 10);
    }

    void pointCallback(const yolo::LabeledPointArray::ConstPtr& msg) {
        markerArray.markers.clear();

        std::vector<std::string> labels = msg->labels;
        std::vector<double> x_values = msg->x;
        std::vector<double> y_values = msg->y;
        std::vector<double> z_values = msg->z;

        // Publish markers for visualization
        for (size_t i = 0; i < labels.size(); ++i) {
            visualization_msgs::Marker marker;
            marker.header.frame_id = "rslidar";
            marker.header.stamp = ros::Time::now();
            marker.ns = "world_points";
            marker.id = i;
            marker.type = visualization_msgs::Marker::MESH_RESOURCE;
            marker.mesh_resource = "package://yolo/meshes/cone.stl";
            marker.action = visualization_msgs::Marker::ADD;
            marker.pose.position.x = y_values[i];
            marker.pose.position.y = -x_values[i];
            marker.pose.position.z = z_values[i];
            marker.pose.orientation.x = 0.0;
            marker.pose.orientation.y = 0.0;
            marker.pose.orientation.z = 0.0;
            marker.pose.orientation.w = 1.0;
            marker.scale.x = 0.001;
            marker.scale.y = 0.001;
            marker.scale.z = 0.001;
            marker.color.a = 1.0;
            marker.lifetime = ros::Duration(0.1);
            
            if (labels[i] == "yellow_cone") {
                marker.color.r = 1.0;
                marker.color.g = 1.0;
                marker.color.b = 0.0;  // Yellow
            } else if (labels[i] == "blue_cone") {
                marker.color.r = 0.0;
                marker.color.g = 0.0;
                marker.color.b = 1.0;  // Blue
            } else {
                marker.color.r = 1.0;
                marker.color.g = 0.0;
                marker.color.b = 0.0;  // Red
            }
            
            markerArray.markers.push_back(marker);
        }

        pub.publish(markerArray);
    }

private:
    ros::NodeHandle nh;
    ros::Subscriber sub;
    ros::Publisher pub;
    visualization_msgs::MarkerArray markerArray;
};

int main(int argc, char** argv) {
    ros::init(argc, argv, "cone_marker");
    CameraPointListener listener;
    ros::spin();

    return 0;
}
