#include "bits/stdc++.h"
#include "ros/ros.h"
#include "can_read/CanFrame.h"

using namespace std;

void canCallback(const can_read::CanFrame msg){
    if(msg.id == 0xE3){
        int res = (msg.data[1]<<8)|(msg.data[0]);
        double temp = (double)res/100.0;
    }
}

int main(int argc,char **argv){
    ros::init(argc,argv,"speed_comp");
    ros::NodeHandle nh;

    ros::Subscriber can_sub = nh.subscribe("/can_frame",1,canCallback);
}