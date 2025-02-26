#!/usr/bin/env python3
from ultralytics import YOLO

## ROS
import tf2_ros as tf
import tf2_geometry_msgs
import rospy
from sensor_msgs.msg import Image
from geometry_msgs.msg import PointStamped
from geometry_msgs.msg import PointStamped, Quaternion
from yolo.msg import LabeledPointArray
import std_msgs
from visualization_msgs.msg import Marker, MarkerArray

## Other tools
import cv2
import numpy as np
from cv_bridge import CvBridge, CvBridgeError
from threading import Thread

# Define variables
WEIGHT_PATH = "/home/dl/vision_ws/src/fs-racing-yolo/src/yolo/src/weight/10ep.pt"
VERBOSE = False  # YOLO verbose (showing detection output)

# Camera intrinsic parameters
FOCAL_LENGTH = 0.003  # mm
SENSOR_HEIGHT = 0.000144  # mm ? unknow 0.0001
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
marker_array_pub_r = rospy.Publisher("/yolo/objects/marker_array_right", MarkerArray, queue_size=10)


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

def distortBackPoints(x, y):

    fx = 1524.639574
    fy = 1514.123479
    cx = 963.594215
    cy = 514.740181
    k1 = -0.569882 * -1
    k2 = 0.230664 * -1
    k3 = 0.000000 * -1
    p1 = 0.010624 * -1
    p2 = 0.005089 * -1
    x = (x - cx) / fx
    y = (y - cy) / fy

    r2 = x*x + y*y

    xDistort = x * (1 + k1 * r2 + k2 * r2 * r2 + k3 * r2 * r2 * r2)
    yDistort = y * (1 + k1 * r2 + k2 * r2 * r2 + k3 * r2 * r2 * r2)

    xDistort = xDistort + (2 * p1 * x * y + p2 * (r2 + 2 * x * x))
    yDistort = yDistort + (p1 * (r2 + 2 * y * y) + 2 * p2 * x * y)

    xDistort = xDistort * fx + cx;
    yDistort = yDistort * fy + cy;

    return xDistort, yDistort

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
def create_identity_quaternion():
        q = Quaternion()
        q.x = 0.0
        q.y = 0.0
        q.z = 0.0
        q.w = 1.0
        return q

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
    
    # 正確初始化 MarkerArray 並使用 DELETEALL
    delete_marker_array = MarkerArray()
    delete_marker = Marker()
    delete_marker.action = Marker.DELETEALL
    delete_marker.header.frame_id = "rslidar"
    delete_marker_array.markers.append(delete_marker)

    # 發佈 MarkerArray 來刪除 Marker
    marker_array_pub_r.publish(delete_marker_array)

    marker_array = MarkerArray()
    i = 0
    for box in result[0].boxes:
        i+=1
        x1, y1, x2, y2 = map(int, box.xyxy[0])
        x1,y1 = distortBackPoints(x1,y1)
        x2,y2 = distortBackPoints(x2,y2)
        pixel_x, pixel_y = round((x1 + x2) / 2), round((y1 + y2) / 2)
        depth = CONE_LEN * FOCAL_LENGTH / ((y2 - y1) * SENSOR_HEIGHT)

        pixel_x = (depth * (pixel_x - 321.72616) / 11.7047874)
        pixel_y = (depth * (pixel_y - 242.67215) / 11.7085504)

        class_id = int(box.cls)
        label = str(model_l.names[class_id])

        # Transform coordinates
        # world_x, world_y, world_z = transform_coordinates(pixel_x, pixel_y, depth)
        import numpy as np
        points = np.array([pixel_x, pixel_y, depth]) 
        # rotation_angles = (-2.65, 0, -60)
        rotation_angles = (0, 0, -60)
        translation = np.array([0, 0, 0])
        np = transform_3d(points,rotation_angles,translation)
        # print(np)

        labeled_point_array_msg.labels.append(label)
        labeled_point_array_msg.x.append(np[0])
        labeled_point_array_msg.y.append(np[1])
        labeled_point_array_msg.z.append(np[2])

        marker = Marker()
        marker.header.frame_id = "rslidar"
        marker.header.stamp = rospy.Time.now()
        marker.ns = "projected_points"
        marker.id = i
        marker.type = Marker.SPHERE
        marker.action = Marker.ADD
        marker.pose.position.x = np[0]
        marker.pose.position.y = np[1]
        marker.pose.position.z = np[2]
        marker.scale.x = 0.5 
        marker.scale.y = 0.5
        marker.scale.z = 0.5
        marker.color.a = 1.0

        if label == "yellow_cone":
                marker.color.r = 1.0
                marker.color.g = 1.0
                marker.color.b = 0.0  # 黃色
        elif label == "blue_cone":
            marker.color.r = 0.0
            marker.color.g = 0.0
            marker.color.b = 1.0  # 藍色
        elif label == "orange_cone":
            marker.color.r = 1.0
            marker.color.g = 0.0
            marker.color.b = 0.0  # 紅色
        else:
            marker.color.r = 1.0
            marker.color.g = 1.0
            marker.color.b = 1.0  # 預設為黑色
        marker.pose.orientation = create_identity_quaternion()

        marker_array.markers.append(marker)
    marker_array_pub_r.publish(marker_array)
    

    res_img = result[0].plot()
    if(lr == 1):
        world_point_array_pub_l.publish(labeled_point_array_msg)
    #     yolo_result_pub_l.publish(bridge.cv2_to_imgmsg(res_img, encoding="bgr8"))
    else:
        world_point_array_pub_r.publish(labeled_point_array_msg)
        yolo_result_pub_r.publish(bridge.cv2_to_imgmsg(res_img, encoding="bgr8"))

def process():
    rospy.init_node("dual_yolo_node_right")
    # rospy.Subscriber('/camera/image_raw_left',Image,call_back_left)
    rospy.Subscriber('/camera/image_raw_right',Image,call_back_right)
    rospy.spin()


if __name__ == '__main__':
    global cll,clr
    cll = 0
    clr = 0
    try:
        process()
    except rospy.ROSInterruptException:
        pass


# Camera 1(120 deg)
# [narrow_stereo]

# camera matrix
# 1605.262159 0.000000 959.553002
# 0.000000 1607.616295 527.920353
# 0.000000 0.000000 1.000000

# distortion
# -0.691536 0.414902 0.007394 -0.000337 0.000000

# rectification
# 1.000000 0.000000 0.000000
# 0.000000 1.000000 0.000000
# 0.000000 0.000000 1.000000

# projection
# 1157.513374 0.000000 958.206193 0.000000
# 0.000000 1470.375499 531.322520 0.000000
# 0.000000 0.000000 1.000000 0.000000

# --------

# camera 0(180 deg)
# [narrow_stereo]

# camera matrix
# 1257.707515 0.000000 909.390490
# 0.000000 1281.972428 553.271695
# 0.000000 0.000000 1.000000

# distortion
# -0.615255 0.231877 0.003040 0.011792 0.000000

# rectification
# 1.000000 0.000000 0.000000
# 0.000000 1.000000 0.000000
# 0.000000 0.000000 1.000000

# projection
# 886.296188 0.000000 898.908643 0.000000
# 0.000000 1111.865048 562.198380 0.000000
# 0.000000 0.000000 1.000000 0.000000

# ----------------

# camera 0 (120 deg)
# [narrow_stereo]

# camera matrix
# 1524.639574 0.000000 963.594215
# 0.000000 1514.123479 514.740181
# 0.000000 0.000000 1.000000

# distortion
# -0.569882 0.230664 0.010624 0.005089 0.000000

# rectification
# 1.000000 0.000000 0.000000
# 0.000000 1.000000 0.000000
# 0.000000 0.000000 1.000000

# projection
# 1046.346222 0.000000 999.923059 0.000000
# 0.000000 1393.574077 518.548481 0.000000
# 0.000000 0.000000 1.000000 0.000000