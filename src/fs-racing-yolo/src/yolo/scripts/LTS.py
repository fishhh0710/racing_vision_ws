#!/usr/bin/env python3
## Vision
from ultralytics import YOLO

## ROS
import tf2_ros as tf
import tf2_geometry_msgs
import rospy
from sensor_msgs.msg import Image
from geometry_msgs.msg import PointStamped
from yolo.msg import LabeledPointArray

## Other tools
import numpy as np
from cv_bridge import CvBridge
from threading import Thread, Event
import sys
import time
import threading

# Define variables
WEIGHT_PATH = "src/yolo/weight/10ep.pt"
VERBOSE = False  # YOLO verbose (showing detection output)

# Camera intrinsic parameters
FOCAL_LENGTH = 4 # mm
SENSOR_HEIGHT = 3.45e-3 # mm
# Cone length
CONE_LEN = 0.3 # m

def log_same_line():
    while not rospy.is_shutdown():
        sys.stdout.write("\033[2J\033[H")
        rospy.loginfo("Processing YOLO .  ")
        time.sleep(1)
        
        sys.stdout.write("\033[F\033[K")
        rospy.loginfo("Processing YOLO .. ")
        time.sleep(1)
        
        sys.stdout.write("\033[F\033[K")
        rospy.loginfo("Processing YOLO ...")
        time.sleep(1)

class Node:
    def __init__(self):
        rospy.init_node("CB_Server")

        ### YOLO model ###
        self.model = YOLO(WEIGHT_PATH)
        # self.model.fuse() # Fuse for speed
        self.results_img = None
        self.yolo_thread_started = False

        ### Publisher ###
        # GUI Publisher
        self.yolo_result_pub = rospy.Publisher("/yolo/objects/yolo_result", Image, queue_size=10)
        # Camera Point Publisher
        self.world_point_array_pub = rospy.Publisher("/yolo/objects/world_point_array", LabeledPointArray, queue_size=10)
        self.world_points = []

        self.camera_point = PointStamped()
        self.camera_point.header.frame_id = "tiscamera"
        self.camera_point.header.stamp = rospy.Time.now()

        ### Subscriber ###
        self.col1_msg = None
        self.sub_col1 = rospy.Subscriber("/usb_cam/image_raw", Image, self.col_callback1)

        ### Other tools ###
        # CvBridge
        self.bridge = CvBridge()
        # tf_listener
        self.tf_buffer = tf.Buffer()
        self.tf_listener = tf.TransformListener(self.tf_buffer)

    def col_callback1(self, msg):
        self.col1_msg = msg

    def preprocess(self, col1_msg: Image) -> np.ndarray:
        # Convert col_msg
        cv_col1_img = self.bridge.imgmsg_to_cv2(col1_msg, desired_encoding="bgr8")
        np_col1_img = np.asanyarray(cv_col1_img, dtype=np.uint8)
        return np_col1_img

    def yolo(self):
        while rospy.is_shutdown() is False:
            if self.col1_msg is not None:
                color_img = self.preprocess(self.col1_msg)

                # YOLO detection
                results = self.model.predict(source=color_img, verbose=VERBOSE)

                for obj in results:
                    self.results_img = obj.plot()
                    self.yolo_result_pub.publish(self.bridge.cv2_to_imgmsg(self.results_img, encoding="bgr8"))
                    boxes = obj.boxes
                    for box in boxes:
                        
                        x1, y1, x2, y2 = map(int, box.xyxy[0])
                        pixel_x, pixel_y = round((x1 + x2) / 2), round((y1 + y2) / 2)
                        depth = CONE_LEN/((y2 - y1) * SENSOR_HEIGHT) * FOCAL_LENGTH

                        class_id = int(box.cls)
                        label = str(self.model.names[class_id])
                        
                        # Transform coordinates
                        world_x, world_y, world_z = self.transform_coordinates(pixel_x, pixel_y, depth)

                        self.collect_world_points(label, world_x, world_y, world_z)

                self.publish_world_points()

                if not self.yolo_thread_started:
                    log_thread = threading.Thread(target=log_same_line)
                    log_thread.daemon = True
                    log_thread.start()
                    self.yolo_thread_started = True

    def transform_coordinates(self, x, y, depth):
        self.camera_point.point.x = (depth * (x - 321.72626) / 1170.47874)
        self.camera_point.point.y = (depth * (y - 242.67215) / 1170.85504)
        self.camera_point.point.z = depth
        self.camera_point.header.stamp = rospy.Time.now()

        try:
            self.tf_buffer.can_transform('map', 'tiscamera', rospy.Time(0), rospy.Duration(1.0))
            world_point = tf2_geometry_msgs.do_transform_point(self.camera_point,
                                                               self.tf_buffer.lookup_transform('map', 'tiscamera',
                                                                                                rospy.Time(0)))
            return world_point.point.x, world_point.point.y, world_point.point.z

        except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException) as ex:
            rospy.logerr("Transform error: %s", str(ex))
            return None
        
    def collect_world_points(self, label, world_x, world_y, world_z):
        world_point = PointStamped()
        world_point.header.frame_id = label
        world_point.point.x = world_x
        world_point.point.y = world_y
        world_point.point.z = world_z

        self.world_points.append(world_point)

    def publish_world_points(self):
        labeled_point_array_msg = LabeledPointArray()
        labeled_point_array_msg.labels = []
        labeled_point_array_msg.x = []
        labeled_point_array_msg.y = []
        labeled_point_array_msg.z = []

        for point in self.world_points:
            labeled_point_array_msg.labels.append(point.header.frame_id)
            labeled_point_array_msg.x.append(point.point.x)
            labeled_point_array_msg.y.append(point.point.y)
            labeled_point_array_msg.z.append(point.point.z)

        # Display object and depth    
        #labels_str = ', '.join(labeled_point_array_msg.labels)
        #depth_value = labeled_point_array_msg.z[0] if labeled_point_array_msg.z else 0.0
        #rospy.loginfo(f"Object: {labels_str}, Depth: {depth_value:.2f} m")

        self.world_point_array_pub.publish(labeled_point_array_msg)
        self.world_points.clear()

if __name__ == '__main__':
    try:
        vision_node = Node()
        rospy.loginfo("Starting YOLO detection...")
        vision_node.yolo()
        rospy.spin()

    except rospy.ROSInterruptException:
        pass