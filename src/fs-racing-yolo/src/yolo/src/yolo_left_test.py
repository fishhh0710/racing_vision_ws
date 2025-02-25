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

# Define variables
WEIGHT_PATH = "/home/dl/vision_ws/src/fs-racing-yolo/src/yolo/src/weight/10ep.pt"
VERBOSE = False  # YOLO verbose (showing detection output)

# Camera intrinsic parameters
FOCAL_LENGTH = 3  # mm
SENSOR_HEIGHT = 3.45e-3  # mm
# Cone length
CONE_LEN = 0.3  # m

# Image resolution for resizing
RESIZED_WIDTH = 640
RESIZED_HEIGHT = 480

model_l = YOLO(WEIGHT_PATH)
model_r = YOLO(WEIGHT_PATH)
bridge = CvBridge()
tf_buffer = tf.Buffer()
yolo_result_pub_l = rospy.Publisher("/yolo/objects/yolo_result_left", Image, queue_size=10)
world_point_array_pub_l = rospy.Publisher("/yolo/objects/world_point_array_left", LabeledPointArray, queue_size=10)
yolo_result_pub_r = rospy.Publisher("/yolo/objects/yolo_result_right", Image, queue_size=10)
world_point_array_pub_r = rospy.Publisher("/yolo/objects/world_point_array_right", LabeledPointArray, queue_size=10)

def distortBackPoints(x, y):

    fx = 1605.262159
    fy = 1607.616295
    cx = 959.553002
    cy = 527.920353
    k1 = -0.691536 * -1
    k2 = 0.414902 * -1
    k3 = 0.0 * -1
    p1 = 0.007394 * -1
    p2 = -0.000337 * -1

    x = (x - cx) / fx
    y = (y - cy) / fy

    r2 = x*x + y*y

    xDistort = x * (1 + k1 * r2 + k2 * r2 * r2 + k3 * r2 * r2 * r2)
    yDistort = y * (1 + k1 * r2 + k2 * r2 * r2 + k3 * r2 * r2 * r2)

    xDistort = xDistort + (2 * p1 * x * y + p2 * (r2 + 2 * x * x))
    yDistort = yDistort + (p1 * (r2 + 2 * y * y) + 2 * p2 * x * y)

    xDistort = xDistort * fx + cx
    yDistort = yDistort * fy + cy

    return xDistort, yDistort

def call_back_left(cb_data):
    # left_img = cb_data
    # global ltl,cll
    # if cll!=0 and type(ltl)==Thread:
    #     ltl.join()
    # tl = Thread(target=yolo_proc,args=(cb_data,1))
    # tl.start()
    # ltl = tl
    # cll += 1
    yolo_proc(cb_data,1)

def call_back_right(cb_data):
    # right_img = cb_data
    # global ltr,clr
    # if clr!=0 and type(ltr) == Thread:
    #     ltr.join()
    # tr = Thread(target=yolo_proc,args=(cb_data,0))
    # tr.start()
    # ltr = tr
    # clr += 1
    yolo_proc(cb_data,0)

def rotation_matrix_3d(axis, angle):
    theta = np.radians(angle)
    c, s = np.cos(theta), np.sin(theta)

    if axis == 'x':
        return np.array([[1, 0,  0],
                         [0, c, -s],
                         [0, s,  c]])
    elif axis == 'y':
        return np.array([[ c, 0, s],
                         [ 0, 1, 0],
                         [-s, 0, c]])
    elif axis == 'z':
        return np.array([[c, -s, 0],
                         [s,  c, 0],
                         [0,  0, 1]])
    else:
        raise ValueError("Invalid axis. Choose from 'x', 'y', or 'z'.")
    
def transform_3d(points, rotation_angles, translation):
    Rx = rotation_matrix_3d('x', rotation_angles[0])
    Ry = rotation_matrix_3d('y', rotation_angles[1])
    Rz = rotation_matrix_3d('z', rotation_angles[2])

    R = Rz @ Ry @ Rx  

    rotated_points = points @ R.T

    transformed_points = rotated_points + translation
    
    return transformed_points

def yolo_proc(proimg, lr):
    high_res_image = bridge.imgmsg_to_cv2(proimg, "bgr8")
    low_res_image = cv2.resize(high_res_image, (RESIZED_WIDTH, RESIZED_HEIGHT))
    
    low_res_image = cv2.flip(low_res_image,0)
    
    if lr==1:
        result = model_l.predict(low_res_image,verbose = VERBOSE)
    else :
        result = model_r.predict(low_res_image,verbose = VERBOSE)

    labeled_point_array_msg = LabeledPointArray()
    labeled_point_array_msg.labels = []
    labeled_point_array_msg.x = []
    labeled_point_array_msg.y = []
    labeled_point_array_msg.z = []

    for box in result[0].boxes:
        x1, y1, x2, y2 = map(int, box.xyxy[0])
        x1,y1 = distortBackPoints(x1,y1)
        x2,y2 = distortBackPoints(x2,y2)
        pixel_x, pixel_y = round((x1 + x2) / 2), round((y1 + y2) / 2)
        depth = CONE_LEN / ((y2 - y1) * SENSOR_HEIGHT) * FOCAL_LENGTH

        class_id = int(box.cls)
        label = str(model_l.names[class_id])

        # Transform coordinates
        # world_x, world_y, world_z = transform_coordinates(pixel_x, pixel_y, depth)
        import numpy as np
        points = np.array([pixel_x, pixel_y, depth]) 
        rotation_angles = (-0.65, 0, -60)
        translation = np.array([0, 0, 0])
        np = transform_3d(points,rotation_angles,translation)
        # print(np)

        labeled_point_array_msg.labels.append(label)
        labeled_point_array_msg.x.append(np[0])
        labeled_point_array_msg.y.append(np[1])
        labeled_point_array_msg.z.append(np[2])

    # res_img = result[0].plot()
    if(lr == 1):
        world_point_array_pub_l.publish(labeled_point_array_msg)
    #     yolo_result_pub_l.publish(bridge.cv2_to_imgmsg(res_img, encoding="bgr8"))
    else:
        world_point_array_pub_r.publish(labeled_point_array_msg)
    #     yolo_result_pub_r.publish(bridge.cv2_to_imgmsg(res_img, encoding="bgr8"))

def process():
    rospy.init_node("dual_yolo_node_left_test")
    rospy.Subscriber('/camera/image_raw_left',Image,call_back_left)
    # rospy.Subscriber('/camera/image_raw_right',Image,call_back_right)
    rospy.spin()


if __name__ == '__main__':
    global cll,clr
    cll = 0
    clr = 0
    try:
        process()
    except rospy.ROSInterruptException:
        pass