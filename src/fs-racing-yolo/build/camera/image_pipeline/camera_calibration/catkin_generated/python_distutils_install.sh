#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/home/dl/Desktop/FS-Racing-YOLO/src/camera/image_pipeline/camera_calibration"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/home/dl/Desktop/FS-Racing-YOLO/install/lib/python3/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/home/dl/Desktop/FS-Racing-YOLO/install/lib/python3/dist-packages:/home/dl/Desktop/FS-Racing-YOLO/build/lib/python3/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/dl/Desktop/FS-Racing-YOLO/build" \
    "/usr/bin/python3" \
    "/home/dl/Desktop/FS-Racing-YOLO/src/camera/image_pipeline/camera_calibration/setup.py" \
    egg_info --egg-base /home/dl/Desktop/FS-Racing-YOLO/build/camera/image_pipeline/camera_calibration \
    build --build-base "/home/dl/Desktop/FS-Racing-YOLO/build/camera/image_pipeline/camera_calibration" \
    install \
    --root="${DESTDIR-/}" \
    --install-layout=deb --prefix="/home/dl/Desktop/FS-Racing-YOLO/install" --install-scripts="/home/dl/Desktop/FS-Racing-YOLO/install/bin"
