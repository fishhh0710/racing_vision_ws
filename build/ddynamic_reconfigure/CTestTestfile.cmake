# CMake generated Testfile for 
# Source directory: /home/dl/vision_ws/src/fs-racing-yolo/src/camera/ddynamic_reconfigure
# Build directory: /home/dl/vision_ws/build/ddynamic_reconfigure
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(_ctest_ddynamic_reconfigure_rostest_test_ddynamic_reconfigure.test "/home/dl/vision_ws/build/ddynamic_reconfigure/catkin_generated/env_cached.sh" "/usr/bin/python3" "/opt/ros/noetic/share/catkin/cmake/test/run_tests.py" "/home/dl/vision_ws/build/ddynamic_reconfigure/test_results/ddynamic_reconfigure/rostest-test_ddynamic_reconfigure.xml" "--return-code" "/usr/bin/python3 /opt/ros/noetic/share/rostest/cmake/../../../bin/rostest --pkgdir=/home/dl/vision_ws/src/fs-racing-yolo/src/camera/ddynamic_reconfigure --package=ddynamic_reconfigure --results-filename test_ddynamic_reconfigure.xml --results-base-dir \"/home/dl/vision_ws/build/ddynamic_reconfigure/test_results\" /home/dl/vision_ws/src/fs-racing-yolo/src/camera/ddynamic_reconfigure/test/ddynamic_reconfigure.test ")
set_tests_properties(_ctest_ddynamic_reconfigure_rostest_test_ddynamic_reconfigure.test PROPERTIES  _BACKTRACE_TRIPLES "/opt/ros/noetic/share/catkin/cmake/test/tests.cmake;160;add_test;/opt/ros/noetic/share/rostest/cmake/rostest-extras.cmake;52;catkin_run_tests_target;/opt/ros/noetic/share/rostest/cmake/rostest-extras.cmake;80;add_rostest;/opt/ros/noetic/share/rostest/cmake/rostest-extras.cmake;119;_add_rostest_google_test;/home/dl/vision_ws/src/fs-racing-yolo/src/camera/ddynamic_reconfigure/CMakeLists.txt;58;add_rostest_gmock;/home/dl/vision_ws/src/fs-racing-yolo/src/camera/ddynamic_reconfigure/CMakeLists.txt;0;")
subdirs("gtest")
