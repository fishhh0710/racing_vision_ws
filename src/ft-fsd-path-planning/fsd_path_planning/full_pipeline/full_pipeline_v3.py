#!/usr/bin/env python3
# -*- coding:utf-8 -*-
"""
Description: A class that runs the whole path planning pipeline.

- Cone sorting
- Cone Matching
- Path Calculation

Project: fsd_path_planning
"""
from __future__ import annotations

from typing import Any, List, Optional, Union

import numpy as np

from fsd_path_planning.calculate_path.core_calculate_path import PathCalculationInput
from fsd_path_planning.cone_matching.core_cone_matching import ConeMatchingInput
from fsd_path_planning.config import (
    create_default_cone_matching_with_non_monotonic_matches,
    create_default_pathing,
    create_default_sorting,
)
from fsd_path_planning.relocalization.acceleration.acceleration_relocalization import (
    AccelerationRelocalizer,
)
from fsd_path_planning.relocalization.relocalization_base_class import Relocalizer
from fsd_path_planning.relocalization.relocalization_information import (
    RelocalizationInformation,
)
from fsd_path_planning.relocalization.skidpad.skidpad_path_data import BASE_SKIDPAD_PATH
from fsd_path_planning.relocalization.skidpad.skidpad_relocalizer import (
    SkidpadRelocalizer,
)
from fsd_path_planning.sorting_cones.core_cone_sorting import ConeSortingInput
from fsd_path_planning.types import FloatArray, IntArray
from fsd_path_planning.utils.cone_types import ConeTypes
from fsd_path_planning.utils.math_utils import (
    angle_from_2d_vector,
    unit_2d_vector_from_angle,
)
from fsd_path_planning.utils.mission_types import MissionTypes
from fsd_path_planning.utils.utils import Timer

from yolo.msg import LabeledPointArray 
import rospy
import matplotlib.pyplot as plt
import geometry_msgs.msg
import std_msgs.msg
from visualization_msgs.msg import Marker, MarkerArray
from nav_msgs.msg import Path
from geometry_msgs.msg import PoseStamped

import time  # 新增時間模組


MissionToRelocalizer: dict[MissionTypes, Relocalizer] = {
    MissionTypes.acceleration: AccelerationRelocalizer,
    MissionTypes.ebs_test: AccelerationRelocalizer,
    MissionTypes.skidpad: SkidpadRelocalizer,
}


class PathPlanner:
    def __init__(
        self, mission: MissionTypes, experimental_performance_improvements: bool = False
    ) -> None:
        self.mission = mission

        self.relocalizer: Relocalizer | None = None
        relocalizer_class = MissionToRelocalizer.get(mission)

        if relocalizer_class is not None:
            self.relocalizer = relocalizer_class()

        self.cone_sorting = create_default_sorting(
            mission, experimental_performance_improvements
        )

        self.cone_matching = create_default_cone_matching_with_non_monotonic_matches(
            mission
        )
        self.pathing = create_default_pathing(mission)
        self.global_path: Optional[FloatArray] = None

        self.experimental_performance_improvements = (
            experimental_performance_improvements
        )

    def _convert_direction_to_array(self, direction: Any) -> FloatArray:
        direction = np.squeeze(np.array(direction))
        if direction.shape == (2,):
            return direction

        if direction.shape in [(1,), ()]:
            return unit_2d_vector_from_angle(direction)

        raise ValueError("direction must be a float or a 2 element array")

    def set_global_path(self, global_path):
        self.global_path = global_path

    def calculate_path_in_global_frame(
        self,
        cones: List[FloatArray],
        vehicle_position: FloatArray,
        vehicle_direction: Union[FloatArray, float],
        return_intermediate_results: bool = False,
    ) -> Union[
        FloatArray,
        tuple[
            FloatArray,
            FloatArray,
            FloatArray,
            FloatArray,
            FloatArray,
            IntArray,
            IntArray,
        ],
    ]:
        rospy.loginfo(f"Initial vehicle position: {vehicle_position}")

        vehicle_direction = self._convert_direction_to_array(vehicle_direction)

        noprint = True

        if self.relocalizer is not None:
            with Timer("Relocalization", noprint=noprint):
                self.relocalizer.attempt_relocalization_calculation(
                    cones.astype(np.float64), 
                    vehicle_position.astype(np.float64), 
                    vehicle_direction.astype(np.float64)
                )

            if self.relocalizer.is_relocalized:
                print("重定位\n")
                vehicle_yaw = angle_from_2d_vector(vehicle_direction)
                (
                    vehicle_position,
                    vehicle_yaw,
                ) = self.relocalizer.transform_to_known_map_frame(
                    vehicle_position, vehicle_yaw
                )
                vehicle_direction = unit_2d_vector_from_angle(vehicle_yaw)
                self.global_path = self.relocalizer.get_known_global_path()

            
            sorted_left, sorted_right = np.zeros((2, 0, 2))
            left_cones_with_virtual, right_cones_with_virtual = np.zeros((2, 0, 2))
            left_to_right_match, right_to_left_match = np.zeros((2, 0), dtype=int)

        else:
            with Timer("Cone sorting", noprint=noprint):
                '''
                cone_sorting_input = ConeSortingInput(
                    cones.astype(np.float64), 
                    vehicle_position.astype(np.float64), 
                    vehicle_direction.astype(np.float64)
                )
                '''
                self.cone_sorting.set_new_input(cone_sorting_input)
                sorted_left, sorted_right = self.cone_sorting.run_cone_sorting() # tuple<float_array,float_array>


                # 打印排序結果
                print(f"Sorted left cones!: {sorted_left}") 
                print(f"Sorted right cones: {sorted_right}")


            with Timer("Cone matching", noprint=noprint):
                matched_cones_input = [np.zeros((0, 2)) for _ in ConeTypes]
                matched_cones_input[ConeTypes.LEFT] = sorted_left
                matched_cones_input[ConeTypes.RIGHT] = sorted_right

                cone_matching_input = ConeMatchingInput(
                    matched_cones_input, vehicle_position, vehicle_direction
                )
                self.cone_matching.set_new_input(cone_matching_input)
                (
                    left_cones_with_virtual,
                    right_cones_with_virtual,
                    left_to_right_match,
                    right_to_left_match,
                ) = self.cone_matching.run_cone_matching()

        with Timer("Path calculation", noprint=noprint):
            path_calculation_input = PathCalculationInput(
                left_cones_with_virtual,
                right_cones_with_virtual,
                left_to_right_match,
                right_to_left_match,
                vehicle_position,
                vehicle_direction,
                self.global_path,
            )
            self.pathing.set_new_input(path_calculation_input)
            final_path, _ = self.pathing.run_path_calculation()

            # 在 path_calculation 結束後打印結果
            rospy.loginfo(f"Calculated path start point: {final_path[0]}")

            '''
            # 如果起點偏移，強制重設為 (0, 0)
            if not np.allclose(final_path[0][:2], [0.0, 0.0], atol=1e-3):
                rospy.logwarn("Path start point deviates from (0, 0). Resetting to origin.")
                final_path[0][:2] = [0.0, 0.0]
            '''
            

        if self.relocalization_info is not None and self.relocalizer.is_relocalized:
            final_path = final_path.copy()
            path_xy = final_path[:, 1:3]
            fake_yaw = np.zeros(len(path_xy))

            path_xy, _ = self.relocalizer.transform_to_original_frame(path_xy, fake_yaw)

            final_path = final_path.copy()

            final_path[:, 1:3] = path_xy

        if return_intermediate_results:
            return (
                final_path,
                sorted_left,
                sorted_right,
                left_cones_with_virtual,
                right_cones_with_virtual,
                left_to_right_match,
                right_to_left_match,
            )

        return final_path

    @property
    def relocalization_info(self) -> RelocalizationInformation | None:
        if self.relocalizer is None:
            return None

        if not self.relocalizer.is_relocalized:
            return None

        return RelocalizationInformation.from_transform_function(
            self.relocalizer.transform_to_known_map_frame
        )


#########
# 全局變數
global cone_sorting_input
global vehicle_position
global vehicle_direction  # 新增方向變數

def create_cone_marker(cone_position, cone_id, color):
    marker = Marker()
    marker.header.frame_id = "rslidar"
    marker.type = Marker.SPHERE
    marker.action = Marker.ADD
    marker.id = cone_id
    marker.pose.position.x = cone_position[0]
    marker.pose.position.y = cone_position[1]
    marker.pose.position.z = 0.2
    marker.scale.x = 0.5
    marker.scale.y = 0.5
    marker.scale.z = 0.5
    marker.color.a = 1.0  # 不透明度
    marker.color.r, marker.color.g, marker.color.b = color
    return marker

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

# 建立 path 和 marker 發佈器
path_pub = rospy.Publisher("/calculated_path", Path, queue_size=10)
marker_pub = rospy.Publisher("/visualization_marker_array", MarkerArray, queue_size=10)

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

# 建立全局變數來追蹤處理次數和開始時間
callback_count = 0
start_time = None

# 儲存先前的 Marker ID 列表
previous_cone_marker_ids = []

def delete_previous_cone_markers(current_ids):
    """刪除舊的圓錐 Marker, 僅刪除不再需要的 ID。"""
    global previous_cone_marker_ids
    marker_array = MarkerArray()

    # 找出需要刪除的 Marker ID
    for marker_id in previous_cone_marker_ids:
        if marker_id not in current_ids:
            delete_marker = Marker()
            delete_marker.header.frame_id = "rslidar"
            delete_marker.id = marker_id
            delete_marker.action = Marker.DELETE  # 設置為刪除動作
            marker_array.markers.append(delete_marker)

    # 發佈刪除指令
    marker_pub.publish(marker_array)

    # 更新已顯示的 Marker ID 列表
    previous_cone_marker_ids = current_ids


# 全局變數來控制角錐輸出頻率
marker_publish_counter = 0  # 計數器
def yolo_callback(data):
    global callback_count, start_time,marker_publish_counter

    # 初始化計時器
    if start_time is None:
        start_time = time.time()

    try:
        global cone_sorting_input
        global planner
        global vehicle_position
        global vehicle_direction

        current_ids = [marker_id for marker_id in range(len(data.labels))]

        '''
         # **打印接收到的相對座標訊息**
        rospy.loginfo("Received relative coordinates:")
        for x, y, z, label in zip(data.x, data.y, data.z, data.labels):
            rospy.loginfo(f"x: {x}, y: {y}, z: {z}, label: {label}")
        '''

        # 刪除之前的圓錐 Marker
        delete_previous_cone_markers(current_ids)

        # 確保方向不為零向量
        if np.linalg.norm(vehicle_direction) == 0:
            vehicle_direction = np.array([1, 0], dtype=np.float64)  # 設置為默認方向

        # 處理 YOLO 偵測資料
        cones_world = np.array(list(zip(data.x, data.y)))

        print(f"receive :{len(cones_world)}")

        cones_2d_relative = cones_world - vehicle_position                               

        # 圓錐分類
        cones_by_type = {ConeTypes.UNKNOWN: [], ConeTypes.RIGHT: [], ConeTypes.LEFT: []}
        marker_array = MarkerArray()

        for i, label in enumerate(data.labels):
            cone_type, color = classify_cone(label)
            cones_by_type[cone_type].append(cones_2d_relative[i])

            if marker_publish_counter % 1 == 0:  # 每 5 次輸出一次角錐
                marker = create_cone_marker(cones_2d_relative[i], i, color)
                marker_array.markers.append(marker)
                previous_cone_marker_ids.append(i)  # 儲存 Marker ID


        # 更新 cone_sorting_input
        cones_by_type_array = [
            np.array(cones_by_type[ConeTypes.UNKNOWN]) if cones_by_type[ConeTypes.UNKNOWN] else np.zeros((0, 2)),
            np.array(cones_by_type[ConeTypes.RIGHT]) if cones_by_type[ConeTypes.RIGHT] else np.zeros((0, 2)),
            np.array(cones_by_type[ConeTypes.LEFT]) if cones_by_type[ConeTypes.LEFT] else np.zeros((0, 2))
        ]
        print(f"left = {len(cones_by_type_array[ConeTypes.LEFT])},r = {len(cones_by_type_array[ConeTypes.RIGHT])}, unk = {len(cones_by_type_array[ConeTypes.UNKNOWN])}",end="!!\n")

        cone_sorting_input.slam_position = vehicle_position
        cone_sorting_input.slam_direction = vehicle_direction
        cone_sorting_input.slam_cones = cones_by_type_array

        # 計算路徑
        rospy.loginfo(f"yolo_callback_Vehicle position: {vehicle_position}")
        final_path = planner.calculate_path_in_global_frame(
            cones=cones_by_type_array,
            vehicle_position=cone_sorting_input.slam_position,
            vehicle_direction=cone_sorting_input.slam_direction,
            return_intermediate_results=False
        )

         # 路徑可視化
        path_marker = create_path_marker(final_path[:, 1:3])
        marker_array.markers.append(path_marker)

        # 發布結果
        if marker_publish_counter % 1 == 0:  # 每 5 次輸出一次角錐
            marker_pub.publish(marker_array)
        publish_path(final_path)

        # 增加計數器並重置
        marker_publish_counter += 1
        if marker_publish_counter >= 1000:  # 避免計數器無限增長
            marker_publish_counter = 0

        # 增加 callback 計數
        callback_count += 1

        # 每次回呼時計算 Hz
        elapsed_time = time.time() - start_time
        if elapsed_time > 0:  # 避免除以 0
            hz = callback_count / elapsed_time
            rospy.loginfo(f"Current processing speed: {hz:.2f} Hz")

    except Exception as e:
        rospy.logerr(f"Error in yolo_callback: {e}")
        
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
    
if __name__ == '__main__':
    rospy.init_node('path_planning_with_yolo')

    mission_type = MissionTypes.autocross 
    planner = PathPlanner(mission_type)

    vehicle_position = np.array([0, 0], dtype=np.float64)  # 初始車輛位置設置為 float64
    vehicle_direction = np.array([1, 0], dtype=np.float64)  # 初始車輛方向設置為 float64

    cone_sorting_input = ConeSortingInput(
        slam_cones=[],  
        slam_position=vehicle_position,
        slam_direction=vehicle_direction
    )

    rospy.Subscriber("/camera_lidar_fusion/lidar_camera_pos", LabeledPointArray, yolo_callback)
    # rospy.Subscriber("/yolo/objects/relative_coordinates", LabeledPointArray, yolo_callback)

    rospy.spin()