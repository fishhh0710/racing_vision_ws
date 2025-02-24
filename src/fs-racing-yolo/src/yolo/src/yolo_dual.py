#!/usr/bin/env python3
from ultralytics import YOLO

## ROS
import tf2_ros as tf
import tf2_geometry_msgs
import rospy
from sensor_msgs.msg import Image
from geometry_msgs.msg import PointStamped
from yolo.msg import LabeledPointArray
import std_msgs

## Other tools
import cv2
import numpy as np
from cv_bridge import CvBridge, CvBridgeError
from threading import Thread
import sys
import time
import threading
import os

# Define variables
WEIGHT_PATH = "/home/dl/vision_ws/src/fs-racing-yolo/src/yolo/src/weight/10ep.pt"
VERBOSE = False  # YOLO verbose (showing detection output)

# Camera intrinsic parameters
FOCAL_LENGTH = 4  # mm
SENSOR_HEIGHT = 3.45e-3  # mm
# Cone length
CONE_LEN = 0.3  # m

# Image resolution for resizing
RESIZED_WIDTH = 640
RESIZED_HEIGHT = 480

model = YOLO(WEIGHT_PATH)
bridge = CvBridge()
yolo_result_pub_l = rospy.Publisher("/yolo/objects/yolo_result_left", Image, queue_size=10)
world_point_array_pub_l = rospy.Publisher("/yolo/objects/world_point_array_left", LabeledPointArray, queue_size=10)
yolo_result_pub_r = rospy.Publisher("/yolo/objects/yolo_result_right", Image, queue_size=10)
world_point_array_pub_r = rospy.Publisher("/yolo/objects/world_point_array_right", LabeledPointArray, queue_size=10)

def call_back_left(cb_data):
    # left_img = cb_data
    yolo_proc(cb_data,1)

def call_back_right(cb_data):
    # right_img = cb_data
    yolo_proc(cb_data,0)

def yolo_proc(proimg,lr):
    high_res_image = bridge.imgmsg_to_cv2(proimg, "bgr8")
    low_res_image = cv2.resize(high_res_image, (RESIZED_WIDTH, RESIZED_HEIGHT))
    
    low_res_image = cv2.flip(low_res_image,0)
    result = model.predict(low_res_image,verbose = VERBOSE)
    res_img = result[0].plot()
    if(lr==1):
        yolo_result_pub_l.publish(bridge.cv2_to_imgmsg(res_img, encoding="bgr8"))
    else:
        yolo_result_pub_r.publish(bridge.cv2_to_imgmsg(res_img, encoding="bgr8"))

def process():
    rospy.init_node("dual_yolo_node")
    rospy.Subscriber('/camera/image_raw_left',Image,call_back_left)
    rospy.Subscriber('/camera/image_raw_right',Image,call_back_right)
    rospy.spin()



if __name__ == '__main__':
    try:
        process()
    except rospy.ROSInterruptException:
        pass
