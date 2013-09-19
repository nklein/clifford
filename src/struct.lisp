(in-package #:clifford)

(defun %defstruct-name-and-options (name options)
  (list* name (option* options :struct-options)))

(defun create-struct (info)
  (let* ((name (name info))
         (options (options info))
         (name-and-options (%defstruct-name-and-options name options))
         (zero (scalar-zero info))
         (slot-type (scalar-type info)))

    (flet ((slot (v)
             (let ((name (basis-vector-name v)))
               `(,name ,zero :type ,slot-type :read-only t))))
      `(defstruct ,name-and-options
         ,@(mapcar #'slot (full-basis info))))))
