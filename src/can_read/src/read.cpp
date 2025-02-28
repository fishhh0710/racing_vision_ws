#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <libgen.h>
#include <time.h>    // time()
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/uio.h>
#include <linux/can.h>
#include <net/if.h>
#include <linux/can/raw.h>
#include <fcntl.h>
#include <termios.h>
#include <ros/ros.h>
#include "can_read/CanFrame.h"
#include "std_msgs/Float32.h"


#define PF_CAN 29

#define LOOP 100

#define CAN_ID_DEFAULT	(2)

ros::Publisher can_frame_pub,imu_pub;

int init_can(char *name) 
{
	int skt;
	struct ifreq ifr;
	struct sockaddr_can addr;
	
	if ((skt = socket(PF_CAN, SOCK_RAW, CAN_RAW)) < 0) 
	{
		perror("socket");
		return -1;
	}

	addr.can_family = PF_CAN;
	strcpy(ifr.ifr_name, name);
	ioctl(skt, SIOCGIFINDEX, &ifr);
	addr.can_ifindex = ifr.ifr_ifindex;
	
	if (bind(skt, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
		perror("bind");
		return -1;
	}
	return skt;
}

int can_send(int s1, struct can_frame frame)
{
    int ret;
    
    ret = write(s1, &frame, sizeof(frame));
    if(ret < 0 ) {
        perror("can write");
        return -1;
    }
    return 0;
}
float orig = 300.0;
int can_readd(int s2, struct can_frame frame)
{	
	can_read::CanFrame temp;
    struct can_frame frame2;
    int ret, i, nbytes;
    
    memset(frame2.data , 0 , sizeof(frame2.data));
    if ((nbytes = read(s2, &frame2, sizeof(frame2))) < 0) {
		perror("can read");
        return -1;
    }
	
	temp.id = frame2.can_id;
	for(int i=0;i<7;i++){
		temp.data[i] = frame2.data[i];
	}
	can_frame_pub.publish(temp);
	if(frame2.can_id==0x14){
		printf("Received!!\n");
		int16_t tmp = frame2.data[4]<<8|frame2.data[5];
		float c = 0.0078125; 
		float theta = 0;
		if(orig>200){
			orig = tmp*c;
		}
		if(tmp*c-orig>180){
			theta = ((tmp*c-orig-360)*3.1415926535)/180.0f;
		}
		else if(tmp*c-orig<-180){
			theta = ((tmp*c-orig+360)*3.1415926535)/180.0f;
		}
		else{
			theta = ((tmp*c-orig)*3.1415926535)/180.0f;
		}
		printf("deg = %f\n",theta);
		std_msgs::Float32 msg;
		msg.data = theta;
		imu_pub.publish(msg);
	}
	else if(frame2.can_id==0xE5){
		printf("Received_break!!\n");
		u_int8_t tmp = frame2.data[4];
		printf("value = %d\n",tmp);
	}
	return 1;
    // printf("Recv: [%03x] %s\n", frame2.can_id, frame2.data);
}

int main(int argc, char **argv)
{
	ros::init(argc, argv, "can_read_node");
    ros::NodeHandle nh;
    // argv[1] = 0;

	can_frame_pub = nh.advertise<can_read::CanFrame>("/can_frame",1);
	imu_pub = nh.advertise<std_msgs::Float32>("/imu_angle",1);

	static int skt = -1 , skt2 = -1, extended = 0;
	int err = 0, j, id, loop;
	unsigned int maxid;
	char ifc[20];
    
	struct can_frame frame = {
		.can_dlc = 1,
	};
    
	struct can_filter filter[] = {
		{
			.can_id = 2,
		},
	};
	// if(argc < 2){return 0;}
	
	//init canbus sokcet
	sprintf(ifc,"can%d",atoi("0"));
	printf("%s\n",ifc);
	skt = init_can(ifc);
	if(skt < 0) {
		printf("Error %d Init can\n",atoi("0"));
		return 0;
	}
    
    //read message
    while(ros::ok)
    {
		usleep(1000);
		can_readd(skt, frame);
     
     }
    
	close(skt);
	//close(skt2);

	return 0;
}
