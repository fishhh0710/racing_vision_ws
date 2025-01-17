# cd /home/ws/vision_ws
source devel/setup.bash

roslaunch yolo tf_camera.launch &
sleep 3
rosrun yolo LTS_v2.py