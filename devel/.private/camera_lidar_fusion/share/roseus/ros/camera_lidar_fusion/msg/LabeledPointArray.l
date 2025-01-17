;; Auto-generated. Do not edit!


(when (boundp 'camera_lidar_fusion::LabeledPointArray)
  (if (not (find-package "CAMERA_LIDAR_FUSION"))
    (make-package "CAMERA_LIDAR_FUSION"))
  (shadow 'LabeledPointArray (find-package "CAMERA_LIDAR_FUSION")))
(unless (find-package "CAMERA_LIDAR_FUSION::LABELEDPOINTARRAY")
  (make-package "CAMERA_LIDAR_FUSION::LABELEDPOINTARRAY"))

(in-package "ROS")
;;//! \htmlinclude LabeledPointArray.msg.html


(defclass camera_lidar_fusion::LabeledPointArray
  :super ros::object
  :slots (_labels _x _y _z ))

(defmethod camera_lidar_fusion::LabeledPointArray
  (:init
   (&key
    ((:labels __labels) (let (r) (dotimes (i 0) (push "" r)) r))
    ((:x __x) (make-array 0 :initial-element 0.0 :element-type :float))
    ((:y __y) (make-array 0 :initial-element 0.0 :element-type :float))
    ((:z __z) (make-array 0 :initial-element 0.0 :element-type :float))
    )
   (send-super :init)
   (setq _labels __labels)
   (setq _x __x)
   (setq _y __y)
   (setq _z __z)
   self)
  (:labels
   (&optional __labels)
   (if __labels (setq _labels __labels)) _labels)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:z
   (&optional __z)
   (if __z (setq _z __z)) _z)
  (:serialization-length
   ()
   (+
    ;; string[] _labels
    (apply #'+ (mapcar #'(lambda (x) (+ 4 (length x))) _labels)) 4
    ;; float64[] _x
    (* 8    (length _x)) 4
    ;; float64[] _y
    (* 8    (length _y)) 4
    ;; float64[] _z
    (* 8    (length _z)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string[] _labels
     (write-long (length _labels) s)
     (dolist (elem _labels)
       (write-long (length elem) s) (princ elem s)
       )
     ;; float64[] _x
     (write-long (length _x) s)
     (dotimes (i (length _x))
       (sys::poke (elt _x i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;; float64[] _y
     (write-long (length _y) s)
     (dotimes (i (length _y))
       (sys::poke (elt _y i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;; float64[] _z
     (write-long (length _z) s)
     (dotimes (i (length _z))
       (sys::poke (elt _z i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string[] _labels
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _labels (make-list n))
     (dotimes (i n)
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setf (elt _labels i) (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
     ))
   ;; float64[] _x
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _x (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _x i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     ))
   ;; float64[] _y
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _y (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _y i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     ))
   ;; float64[] _z
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _z (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _z i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     ))
   ;;
   self)
  )

(setf (get camera_lidar_fusion::LabeledPointArray :md5sum-) "c125202a3740730672f3937d330b8f0b")
(setf (get camera_lidar_fusion::LabeledPointArray :datatype-) "camera_lidar_fusion/LabeledPointArray")
(setf (get camera_lidar_fusion::LabeledPointArray :definition-)
      "string[] labels
float64[] x
float64[] y
float64[] z
")



(provide :camera_lidar_fusion/LabeledPointArray "c125202a3740730672f3937d330b8f0b")


