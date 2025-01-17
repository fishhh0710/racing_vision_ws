cmake_minimum_required(VERSION 3.0.2)
project(cone_detection)

## Compile as C++11, supported in ROS Kinetic and newer
# add_compile_options(-std=c++11)

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  pcl_conversions
  pcl_msgs
  pcl_ros
  roscpp
  sensor_msgs
  std_msgs
  message_generation
  visualization_msgs
)
find_package(PCL REQUIRED)

## Generate messages in the 'msg' folder
add_message_files(
  FILES
  LabeledPointArray.msg
)

## Generate added messages and services with any dependencies listed here
generate_messages(
  DEPENDENCIES
  std_msgs  # Or other packages containing msgs
)

################################################
## Declare ROS dynamic reconfigure parameters ##
################################################

## To declare and build dynamic reconfigure parameters within this
## package, follow these steps:
## * In the file package.xml:
##   * add a build_depend and a exec_depend tag for "dynamic_reconfigure"
## * In this file (CMakeLists.txt):
##   * add "dynamic_reconfigure" to
##     find_package(catkin REQUIRED COMPONENTS ...)
##   * uncomment the "generate_dynamic_reconfigure_options" section below
##     and list every .cfg file to be processed

## Generate dynamic reconfigure parameters in the 'cfg' folder
# generate_dynamic_reconfigure_options(
#   cfg/DynReconf1.cfg
#   cfg/DynReconf2.cfg
# )

###################################
## catkin specific configuration ##
###################################
## The catkin_package macro generates cmake config files for your package
## Declare things to be passed to dependent projects
## INCLUDE_DIRS: uncomment this if your package contains header files
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need
catkin_package(
  INCLUDE_DIRS src
  LIBRARIES cone_detection
  CATKIN_DEPENDS pcl_conversions pcl_msgs pcl_ros roscpp sensor_msgs
  DEPENDS system_lib
)

include_directories(
  src
  ${catkin_INCLUDE_DIRS}
  ${PCL_INCLUDE_DIRS}
)

link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})


add_executable(conditional_removel src/conditional_removel.cpp)
target_link_libraries(conditional_removel ${catkin_LIBRARIES} ${PCL_LIBRARIES})

add_executable(euclidean_clustering src/euclidean_clustering.cpp)
target_link_libraries(euclidean_clustering ${catkin_LIBRARIES} ${PCL_LIBRARIES})

add_executable(reconstructed_cone src/reconstructed_cone.cpp)
target_link_libraries(reconstructed_cone ${catkin_LIBRARIES} ${PCL_LIBRARIES})

add_executable(cone_legality_verification src/cone_legality_verification.cpp)
target_link_libraries(cone_legality_verification ${catkin_LIBRARIES} ${PCL_LIBRARIES})

add_executable(downsampling src/downsampling.cpp)
target_link_libraries(downsampling ${catkin_LIBRARIES} ${PCL_LIBRARIES})
