from fsd_path_planning import PathPlanner, MissionTypes, ConeTypes
import numpy as np
from fsd_path_planning.utils.math_utils import unit_2d_vector_from_angle, rotate
from fsd_path_planning.utils.cone_types import ConeTypes
from fsd_path_planning.sorting_cones.core_cone_sorting import ConeSortingInput


from yolo.msg import LabeledPointArray 
import rospy
import matplotlib.pyplot as plt
import geometry_msgs.msg
import std_msgs.msg
from visualization_msgs.msg import Marker, MarkerArray
from nav_msgs.msg import Path
from geometry_msgs.msg import PoseStamped

import time  # 新增時間模組

global cone_sorting_input

planner = PathPlanner(MissionTypes.trackdrive)

path_pub = rospy.Publisher("/calculated_path", Path, queue_size=10)
marker_pub = rospy.Publisher("/visualization_marker_array", MarkerArray, queue_size=10)

def classify_cone(label: str) -> ConeTypes:
    
    # 根據 YOLO 標籤將圓錐分類為 ConeTypes 並返回對應顏色。
    if label == "yellow_cone":
        return ConeTypes.YELLOW, (1.0, 1.0, 0.0)  # 黃色
    elif label == "blue_cone":
        return ConeTypes.BLUE, (0.0, 0.0, 1.0)  # 藍色
    elif label == "orange_cone":
        return ConeTypes.ORANGE, (1.0, 0.27, 0.0)  # orange
    else:
        return ConeTypes.UNKNOWN, (0.5, 0.5, 0.5)  # 灰色，未知顏色

def Callback(data):
    current_ids = [marker_id for marker_id in range(len(data.labels))]
    cones_world = np.array(list(zip(data.x, data.y)))
    cones_by_type = {ConeTypes.UNKNOWN: [], ConeTypes.RIGHT: [], ConeTypes.LEFT: []}
    
    for i, label in enumerate(data.labels):
            cone_type, color = classify_cone(label)
            cones_by_type[cone_type].append(cones_world[i])
    
    cones_by_type_array = [
        np.array(cones_by_type[ConeTypes.UNKNOWN]) if cones_by_type[ConeTypes.UNKNOWN] else np.zeros((0, 2)),
        np.array(cones_by_type[ConeTypes.RIGHT]) if cones_by_type[ConeTypes.RIGHT] else np.zeros((0, 2)),
        np.array(cones_by_type[ConeTypes.LEFT]) if cones_by_type[ConeTypes.LEFT] else np.zeros((0, 2))
    ]
    cal(cones_by_type_array)


def create_path_marker(path_points):
    # 打印起點座標
    if len(path_points) > 0:
        start_point = path_points[0]
        rospy.loginfo(f"Path start point: x={start_point[0]}, y={start_point[1]}")

    marker = Marker()
    marker.header.frame_id = "rslidar"
    marker.type = Marker.LINE_STRIP
    marker.action = Marker.ADD
    marker.id = 1000  # 假設ID 1000留給路徑
    marker.scale.x = 0.1  # 線的寬度
    marker.color.r = 0.0
    marker.color.g = 0.0
    marker.color.b = 1.0
    marker.color.a = 1.0  # 不透明度
    
    for point in path_points:
        p = geometry_msgs.msg.Point()
        p.x = point[0]

        p.y = point[1]
        p.z = 0.0
        marker.points.append(p)
    
    return marker


def publish_path(final_path):
    rospy.loginfo("Publishing path...")  # 添加這行來確認是否執行到這裡
    path_msg = Path()
    path_msg.header.stamp = rospy.Time.now()
    path_msg.header.frame_id = "rslidar"

    for point in final_path:
        pose = PoseStamped()
        pose.header.stamp = rospy.Time.now()
        pose.header.frame_id = "rslidar"
        pose.pose.position.x = point[1]  # X 座標
        pose.pose.position.y = point[2]  # Y 座標
        pose.pose.position.z = 0.0  # Z 座標為0，因為是2D路徑
        path_msg.poses.append(pose)
    
    path_pub.publish(path_msg)

def cal(cones_by_type_array):

    global cone_sorting_input
    for i, c in enumerate(ConeTypes):
        print(c, f"= {i}")

    vehicle_position = np.array([0, 0], dtype=np.float64)  # 初始車輛位置設置為 float64
    vehicle_direction = np.array([0, 1], dtype=np.float64)

    cones_by_type = [np.zeros((0, 2)) for _ in range(5)]
    cones_by_type[ConeTypes.LEFT] = cones_by_type_array[ConeTypes.LEFT]
    cones_by_type[ConeTypes.RIGHT] = cones_by_type_array[ConeTypes.RIGHT]
    cones_by_type[ConeTypes.UNKNOWN] = cones_by_type_array[ConeTypes.UNKNOWN]

    out = planner.calculate_path_in_global_frame(
        cones_by_type, vehicle_position, vehicle_direction, return_intermediate_results=True
    )

    (
        path,
        sorted_left,
        sorted_right,
        left_cones_with_virtual,
        right_cones_with_virtual,
        left_to_right_match,
        right_to_left_match,
    ) = out
    marker_array = MarkerArray()
    path_marker = create_path_marker(out[:, 1:3])
    marker_array.markers.append(path_marker)

if __name__ == '__main__':
    rospy.init_node('path_planning_node')

    mission_type = MissionTypes.autocross 
    planner = PathPlanner(mission_type)

    vehicle_position = np.array([0, 0], dtype=np.float64)  # 初始車輛位置設置為 float64
    vehicle_direction = np.array([0, 1], dtype=np.float64)  # 初始車輛方向設置為 float64

    cone_sorting_input = ConeSortingInput(
        slam_cones=[],  
        slam_position=vehicle_position,
        slam_direction=vehicle_direction
    )

    # rospy.Subscriber("/camera_lidar_fusion/lidar_camera_pos", LabeledPointArray, yolo_callback)
    rospy.Subscriber("/yolo/objects/relative_coordinates", LabeledPointArray, Callback)

    rospy.spin()