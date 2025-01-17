
(cl:in-package :asdf)

(defsystem "yolo-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "LabeledPointArray" :depends-on ("_package_LabeledPointArray"))
    (:file "_package_LabeledPointArray" :depends-on ("_package"))
  ))