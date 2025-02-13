#include <ros/ros.h>
#include <sensor_msgs/PointCloud2.h>
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/point_cloud.h>
#include <pcl/point_types.h>
#include <pcl/segmentation/extract_clusters.h>
#include <pcl/filters/voxel_grid.h>
#include <pcl/common/common.h>
#include <pcl/common/impl/common.hpp>
#include <pcl/common/centroid.h>
#include <visualization_msgs/Marker.h>
#include <visualization_msgs/MarkerArray.h>
#include "cone_detection/LabeledPointArray.h"
#include "std_msgs/Header.h"
#include "pcl/kdtree/kdtree_flann.h"
#include "random"
#include "set"
#include "queue"

const double eeps = 1e-8;
double eps = 0.0005;
int k = 50;

#define max(a, b) (a > b ? a : b)
#define min(a, b) (a < b ? a : b)
#define cmax(a, b) a = (a > b ? a : b)
#define cmin(a, b) a = (a < b ? a : b)
#define F first
#define S second
#define pb push_back

ros::Publisher pub;
ros::Publisher marker_pub,pos_pub;
int maxid = 0;
using namespace std;
int group[6000];
int par[6000];
int sz[6000];
int find_p(int now){
    if(par[now]!=now){
        return par[now] = find_p(par[now]);
    }
    return now;
}

double rr[100],gg[100],bb[100],aa,r,g,b;
visualization_msgs::Marker createMarker(int id,double x,double y,double z){
    visualization_msgs::Marker marker;
    marker.header.frame_id = "rslidar";
    marker.header.stamp = ros::Time::now();
    marker.ns = "cone_detection/dbscan";
    marker.id = id;
    marker.action = visualization_msgs::Marker::ADD;
    marker.type = visualization_msgs::Marker::SPHERE;

    marker.pose.position.x = x;
    marker.pose.position.y = y;
    marker.pose.position.z = z;
    marker.pose.orientation.x = 0.0;
    marker.pose.orientation.y = 0.0;
    marker.pose.orientation.z = 0.0;
    marker.pose.orientation.w = 1.0;

    marker.scale.x = 0.08;
    marker.scale.y = 0.08;
    marker.scale.z = 0.08;

    marker.color.r = r;
    marker.color.g = g;
    marker.color.b = b;
    marker.color.a = aa;

    return marker;
}
vector<double> gps[20000];

double getmed(int tar){
    double mx = -99,mn=99;
    for(double i:gps[tar]){
        cmax(mx,i);
        cmin(mn,i);
    }
    double pv = (mx+mn)/2.0;
    // for(int i=0;i<gps[tar].size();i++){
    //     if(gps[tar][i]-pv<1e-3){
    //         return ;
    //     }
    // }
    return pv;
}

// 透過x,y,z med vs avg to vaildate the cone

void dbscan(const sensor_msgs::PointCloud2ConstPtr& cloud_msg){
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
    pcl::fromROSMsg(*cloud_msg, *cloud);
    cout << "[dbscan]cloud size = " << cloud->points.size() << "\n";

    int temp = min(6000,cloud->points.size());
    for(int i = 0; i < temp; i++){
        group[i] = 0;
        sz[i+1] = 1;
        par[i+1] = i+1;
    }
    pcl::KdTreeFLANN<pcl::PointXYZ> kdtree;
    kdtree.setInputCloud(cloud);
    // about 20~50 points
    vector<int> pointidx(k);
    vector<float> dist(k);
    int ng = 1;

    for(int i = 0; i < cloud->points.size(); i++){
        // if(group[i])continue;
        if(!group[i]){
            gps[3*ng].clear();
            gps[3*ng+1].clear();
            gps[3*ng+2].clear();
            group[i]=ng++;
        }
        if(kdtree.nearestKSearch(cloud->points[i], k, pointidx, dist)){
            for(int j = 0; j < k; j++){
                if(dist[j] < eps){
                    if(group[pointidx[j]]){
                        int ppa = find_p(par[group[i]]), ppb = find_p(par[group[pointidx[j]]]);
                        if(ppa-ppb){
                            sz[ppb]+=sz[ppa];
                            par[ppa] = ppb;
                        }
                    }
                    else{
                        group[pointidx[j]] = group[i];
                        sz[find_p(group[i])]++;
                    }
                }
            }
        }
    }
    
    cout << "[dbscan]total distrbute group = " << ng << "\n";
    srand(123);
    visualization_msgs::MarkerArray mk;
    aa = 1.0;
    pcl::PointCloud<pcl::PointXYZRGB>::Ptr colored_cluster(new pcl::PointCloud<pcl::PointXYZRGB>);
    pcl::PointXYZRGB point;
    set<int> sett;
    for(int j = 0;j < cloud->points.size(); j++){
        int tt = find_p(group[j]);
        if(sz[tt]<5||sz[tt]>80)continue;
        auto temp = cloud->points[j];
        r = rr[tt];
        g = gg[tt];
        b = bb[tt];
        mk.markers.pb(createMarker(mk.markers.size(),temp.x,temp.y,temp.z));
        point.x = temp.x, point.y = temp.y, point.z = temp.z;
        point.r = rr[tt];
        point.g = gg[tt];
        point.b = bb[tt];
        colored_cluster->points.push_back(point);
        gps[3*tt].pb(temp.x);
        gps[3*tt+1].pb(temp.y);
        gps[3*tt+2].pb(temp.z);
        sett.insert(tt);
    }
    sensor_msgs::PointCloud2 cluster_msg;
    pcl::toROSMsg(*colored_cluster,cluster_msg);
    cluster_msg.header = cloud_msg->header;
    pub.publish(cluster_msg);
    marker_pub.publish(mk);
    cone_detection::LabeledPointArray ret;
    for(int i = 0;i < cloud->points.size();i++){
        int tt = find_p(group[i]);
        auto temp = sett.find(tt);
        if(temp == sett.end())continue;
        sett.erase(temp);

        double xm,ym,zm;
        xm = getmed(tt*3);
        ym = getmed(tt*3+1);
        zm = getmed(tt*3+2);
        ret.x.pb(xm);
        ret.y.pb(ym);
        ret.z.pb(zm);
    }
    cout<<"[dbscan] point size = "<<ret.x.size()<<"\n";
    pos_pub.publish(ret);
    return ;
}


int main(int argc, char** argv){
    ros::init(argc, argv, "cone_detection_dbscan\n");
    ros::NodeHandle nh;
    bool res = 1;
    string sub_source;
    
    res&=nh.getParam("dbscan_eps",eps);
    res&=nh.getParam("dbscan_k",k);
    res&=nh.getParam("dbscan_source",sub_source);


    std::cout<<"[dbscan] Start cone detection by dbscan...\n";
    cout<<"[dbscan] Param get "<<(res?"successfully":"faild")<<"\n";

    ros::Subscriber sub = nh.subscribe<sensor_msgs::PointCloud2>(sub_source, 1, dbscan);

    pub = nh.advertise<sensor_msgs::PointCloud2>("/dbscan_cloud", 1);
    marker_pub = nh.advertise<visualization_msgs::MarkerArray>("/cone_marker_array_dbscan", 1);
    pos_pub = nh.advertise<cone_detection::LabeledPointArray>("/dbscan_position",1);

    for(int i = 1; i < 100; i++){
        int ra = rand()%100;
        rr[i] = ((double)ra/100.0);
        ra = rand()%100;
        gg[i] = ((double)ra/100.0);
        ra = rand()%100;
        bb[i] = ((double)ra/100.0);
    }

    ros::spin();

    return 0;
}