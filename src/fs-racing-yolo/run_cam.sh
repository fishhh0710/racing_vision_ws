roscore &
sleep 3
#cd /home/ws/camera_ws
source devel/setup.bash

roslaunch usb_cam usb_cam-test.launch
sleep 3

#rosrun camera_dynamic dynamic_reconfigure_node &
#sleep 3
#rosrun rqt_reconfigure rqt_reconfigure &