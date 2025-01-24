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

const double eeps = 1e-8;
const float eps = 0.5;
const int k = 50;

#define max(a, b) (a > b ? a : b)
#define min(a, b) (a < b ? a : b)
#define cmax(a, b) a = (a > b ? a : b)
#define cmin(a, b) a = (a < b ? a : b)
#define F first
#define S second
#define pb push_back

ros::Publisher pub;
ros::Publisher marker_pub;
int maxid = 0;
using namespace std;
int group[6000];
int par[6000];
int find_p(int now){
    if(par[now]!=now){
        return par[now] = find_p(par[now]);
    }
    return now;
}
void dbscan(const sensor_msgs::PointCloud2ConstPtr& cloud_msg)
{
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
    pcl::fromROSMsg(*cloud_msg, *cloud);
    cout<<"cloud size="<<cloud->points.size()<<"\n";

    int temp = min(6000,cloud->points.size());
    for(int i=0;i<temp;i++){
        group[i] = 0;
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
            group[i]=ng++;
        }
        if(kdtree.nearestKSearch(cloud->points[i],k,pointidx,dist)){
            for(int j=0;j<k;j++){
                if(dist[j]<eps){
                    if(group[pointidx[j]]){
                        int ppa = find_p(group[i]), ppb = find_p(group[pointidx[j]]);
                        par[ppa] = ppb;
                    }
                    else{
                        group[pointidx[j]] = group[i];
                    }
                }
            }
        }
    }
    
    cout<<"total distrbute group = "<<ng<<"\n";

    cout<<"\n";
}


int main(int argc, char** argv){
    ros::init(argc, argv, "cone_detection_dbscan");
    ros::NodeHandle nh;
    std::cout<<"start cone detection by dbscan...\n";
    ros::Subscriber sub = nh.subscribe<sensor_msgs::PointCloud2>("/ground_segmentation/obstacle_cloud", 1, dbscan);

    pub = nh.advertise<cone_detection::LabeledPointArray>("/cone_detection_dbscan", 1);
    marker_pub = nh.advertise<visualization_msgs::MarkerArray>("/cone_marker_array_dbscan", 1);


    ros::spin();

    return 0;
}