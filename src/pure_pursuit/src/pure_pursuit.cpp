#include <ros/ros.h>
#include <sensor_msgs/PointCloud2.h>
#include <geometry_msgs/Point.h>
#include "bits/stdc++.h"
#include <visualization_msgs/Marker.h>
#include <visualization_msgs/MarkerArray.h>
#include <nav_msgs/Path.h>
#include <geometry_msgs/PoseStamped.h>
#include "camera_lidar_fusion/CarState.h"
#include "camera_lidar_fusion/ControlCommand.h"
#include "camera_lidar_fusion/CarStateDt.h"

#define ob 30
const double dis_vis = 20.5;
const double eps = 1e-7;
const double weelbase = 1.535;
// const double turning_ratio = ;
#define pb push_back
#define pdd pair<double,double>
#define F first
#define S second

// from nav_msgs.msg import Path
// from geometry_msgs.msg import PoseStamped

using namespace std;

ros::Subscriber sub;
ros::Publisher pub,test_marker,test_marker_2;



visualization_msgs::Marker createMarker(int id, double x, double y, int color_label) {
    visualization_msgs::Marker marker;
    marker.header.frame_id = "rslidar";
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

vector<pdd> pts;
void cal();
void Callback(nav_msgs::Path data){
    pts.clear();
    for (auto i:data.poses){
        pdd temp;
        temp.F = i.pose.position.x;
        temp.S = i.pose.position.y;
        pts.pb(temp);
    }
    cout<<"[pure pursuit] sz : "<<pts.size()<<"\n";
    cal();
}

double dis(pdd a,pdd b){
    return (a.F-b.F)*(a.F-b.F)+(a.S-b.S)*(a.S-b.S);
}

double ds(pdd a){
    return a.F*a.F+a.S*a.S;
}

void cal(){
    visualization_msgs::MarkerArray temp;
    // int ii = 0;
    // for(auto i:pts){
    //     temp.markers.pb(createMarker(ii++,i.x,i.y,1));
    // }
    // test_marker.publish(temp);

    pdd last={0,0};
    for(pdd i:pts){
        if(ds(i)>dis_vis){
            last = i;
            break;
        }
    }
    if(ds(last)<eps){
        last = pts.back();
    }

    double tar_dis = ds(last);
    double dy = abs(last.S);
    double r = tar_dis*tar_dis/(2*dy);
    double k = 2*dy/(tar_dis);
    double steer = atan(weelbase*k);
    cout<<"steer:"<<steer<<"\n";

    visualization_msgs::Marker marker;
    marker.header.frame_id = "rslidar";
    marker.header.stamp = ros::Time::now();
    marker.ns = "lidar_camera";
    marker.id = 2;
    marker.type = visualization_msgs::Marker::ARROW; // 使用球體表示
    marker.action = visualization_msgs::Marker::ADD;
    marker.color.r = 0.0;
    marker.color.g = 0.0;
    marker.color.b = 1.0;
    marker.color.a = 1.0;
    marker.scale.x = 0.2;
    marker.scale.y = 0.2;
    marker.scale.z = 0.2;
    geometry_msgs::Point tt;
    tt.x = tt.y = tt.z = 0.0;
    marker.points.pb(tt);
    tt.x = cos(steer)*10.0;
    tt.y = sin(steer)*10.0;
    marker.points.pb(tt);

    temp.markers.push_back(marker);
    temp.markers.push_back(createMarker(1,last.F,last.S,1));
    test_marker_2.publish(temp);
    return ;
}

int main(int argc,char **argv){
    ros::init(argc,argv,"pure_pursuit");
    ros::NodeHandle nh;

    pub = nh.advertise<camera_lidar_fusion::CarState>("/pure_pursuit/acc_car_state", 1);
    test_marker = nh.advertise<visualization_msgs::MarkerArray>("/pure_pursuit/test_marker",1);
    test_marker_2 = nh.advertise<visualization_msgs::MarkerArray>("/pure_pursuit/direction",1);
    sub = nh.subscribe<nav_msgs::Path>("/calculated_path",1,Callback);
    ros::spin();
}