# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/dl/Desktop/FS-Racing-YOLO/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/dl/Desktop/FS-Racing-YOLO/build

# Utility rule file for clean_test_results_image_proc.

# Include the progress variables for this target.
include camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/progress.make

camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc:
	cd /home/dl/Desktop/FS-Racing-YOLO/build/camera/image_pipeline/image_proc/test && /usr/bin/python3 /opt/ros/noetic/share/catkin/cmake/test/remove_test_results.py /home/dl/Desktop/FS-Racing-YOLO/build/test_results/image_proc

clean_test_results_image_proc: camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc
clean_test_results_image_proc: camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/build.make

.PHONY : clean_test_results_image_proc

# Rule to build all files generated by this target.
camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/build: clean_test_results_image_proc

.PHONY : camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/build

camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/clean:
	cd /home/dl/Desktop/FS-Racing-YOLO/build/camera/image_pipeline/image_proc/test && $(CMAKE_COMMAND) -P CMakeFiles/clean_test_results_image_proc.dir/cmake_clean.cmake
.PHONY : camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/clean

camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/depend:
	cd /home/dl/Desktop/FS-Racing-YOLO/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/dl/Desktop/FS-Racing-YOLO/src /home/dl/Desktop/FS-Racing-YOLO/src/camera/image_pipeline/image_proc/test /home/dl/Desktop/FS-Racing-YOLO/build /home/dl/Desktop/FS-Racing-YOLO/build/camera/image_pipeline/image_proc/test /home/dl/Desktop/FS-Racing-YOLO/build/camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : camera/image_pipeline/image_proc/test/CMakeFiles/clean_test_results_image_proc.dir/depend

