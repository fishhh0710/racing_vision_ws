# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "camera_lidar_fusion: 8 messages, 0 services")

set(MSG_I_FLAGS "-Icamera_lidar_fusion:/home/dl/vision_ws/src/camera_lidar_fusion/msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(camera_lidar_fusion_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg" NAME_WE)
add_custom_target(_camera_lidar_fusion_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "camera_lidar_fusion" "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg" ""
)

get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg" NAME_WE)
add_custom_target(_camera_lidar_fusion_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "camera_lidar_fusion" "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg" "geometry_msgs/Point:std_msgs/String"
)

get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg" NAME_WE)
add_custom_target(_camera_lidar_fusion_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "camera_lidar_fusion" "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg" "std_msgs/Header:std_msgs/String:geometry_msgs/Point:camera_lidar_fusion/Cone"
)

get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg" NAME_WE)
add_custom_target(_camera_lidar_fusion_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "camera_lidar_fusion" "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg" "std_msgs/Header:std_msgs/String:geometry_msgs/Point:camera_lidar_fusion/Cone"
)

get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg" NAME_WE)
add_custom_target(_camera_lidar_fusion_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "camera_lidar_fusion" "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg" "std_msgs/Header:std_msgs/Float32"
)

get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg" NAME_WE)
add_custom_target(_camera_lidar_fusion_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "camera_lidar_fusion" "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg" "std_msgs/Header:camera_lidar_fusion/CarStateDt:geometry_msgs/Pose2D"
)

get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg" NAME_WE)
add_custom_target(_camera_lidar_fusion_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "camera_lidar_fusion" "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg" "std_msgs/Header:geometry_msgs/Pose2D"
)

get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg" NAME_WE)
add_custom_target(_camera_lidar_fusion_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "camera_lidar_fusion" "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg" "std_msgs/Header"
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_cpp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_cpp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_cpp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_cpp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Float32.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_cpp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_cpp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_cpp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
)

### Generating Services

### Generating Module File
_generate_module_cpp(camera_lidar_fusion
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(camera_lidar_fusion_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(camera_lidar_fusion_generate_messages camera_lidar_fusion_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_cpp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_cpp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_cpp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_cpp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_cpp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_cpp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_cpp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_cpp _camera_lidar_fusion_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(camera_lidar_fusion_gencpp)
add_dependencies(camera_lidar_fusion_gencpp camera_lidar_fusion_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS camera_lidar_fusion_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_eus(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_eus(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_eus(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_eus(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Float32.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_eus(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_eus(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_eus(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
)

### Generating Services

### Generating Module File
_generate_module_eus(camera_lidar_fusion
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(camera_lidar_fusion_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(camera_lidar_fusion_generate_messages camera_lidar_fusion_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_eus _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_eus _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_eus _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_eus _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_eus _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_eus _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_eus _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_eus _camera_lidar_fusion_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(camera_lidar_fusion_geneus)
add_dependencies(camera_lidar_fusion_geneus camera_lidar_fusion_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS camera_lidar_fusion_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_lisp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_lisp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_lisp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_lisp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Float32.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_lisp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_lisp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_lisp(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
)

### Generating Services

### Generating Module File
_generate_module_lisp(camera_lidar_fusion
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(camera_lidar_fusion_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(camera_lidar_fusion_generate_messages camera_lidar_fusion_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_lisp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_lisp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_lisp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_lisp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_lisp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_lisp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_lisp _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_lisp _camera_lidar_fusion_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(camera_lidar_fusion_genlisp)
add_dependencies(camera_lidar_fusion_genlisp camera_lidar_fusion_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS camera_lidar_fusion_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_nodejs(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_nodejs(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_nodejs(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_nodejs(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Float32.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_nodejs(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_nodejs(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_nodejs(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
)

### Generating Services

### Generating Module File
_generate_module_nodejs(camera_lidar_fusion
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(camera_lidar_fusion_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(camera_lidar_fusion_generate_messages camera_lidar_fusion_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_nodejs _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_nodejs _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_nodejs _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_nodejs _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_nodejs _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_nodejs _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_nodejs _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_nodejs _camera_lidar_fusion_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(camera_lidar_fusion_gennodejs)
add_dependencies(camera_lidar_fusion_gennodejs camera_lidar_fusion_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS camera_lidar_fusion_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_py(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_py(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_py(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/String.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_py(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Float32.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_py(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_py(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose2D.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
)
_generate_msg_py(camera_lidar_fusion
  "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
)

### Generating Services

### Generating Module File
_generate_module_py(camera_lidar_fusion
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(camera_lidar_fusion_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(camera_lidar_fusion_generate_messages camera_lidar_fusion_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/LabeledPointArray.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_py _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Cone.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_py _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ConeDetections.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_py _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Map.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_py _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/ControlCommand.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_py _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarState.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_py _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/CarStateDt.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_py _camera_lidar_fusion_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/dl/vision_ws/src/camera_lidar_fusion/msg/Mission.msg" NAME_WE)
add_dependencies(camera_lidar_fusion_generate_messages_py _camera_lidar_fusion_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(camera_lidar_fusion_genpy)
add_dependencies(camera_lidar_fusion_genpy camera_lidar_fusion_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS camera_lidar_fusion_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/camera_lidar_fusion
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(camera_lidar_fusion_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(camera_lidar_fusion_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/camera_lidar_fusion
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(camera_lidar_fusion_generate_messages_eus std_msgs_generate_messages_eus)
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(camera_lidar_fusion_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/camera_lidar_fusion
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(camera_lidar_fusion_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(camera_lidar_fusion_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/camera_lidar_fusion
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(camera_lidar_fusion_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(camera_lidar_fusion_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/camera_lidar_fusion
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(camera_lidar_fusion_generate_messages_py std_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(camera_lidar_fusion_generate_messages_py geometry_msgs_generate_messages_py)
endif()
