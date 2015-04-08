(in-package #:clifford)

(defgeneric dot (x y))
(defgeneric wedge (x y))

(defun %dot (info)
  `(defmethod dot ((x ,(name info)) (y ,(name info)))
     (* ,(coerce 1/2 (scalar-type info)) (+ (* x y) (* y x)))))

(defun %wedge (info)
  `(defmethod wedge ((x ,(name info)) (y ,(name info)))
     (* ,(coerce 1/2 (scalar-type info)) (- (* x y) (* y x)))))

(defun create-product-functions (info)
  `(,(%dot info)
    ,(%wedge info)))
