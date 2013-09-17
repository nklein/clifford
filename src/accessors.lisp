(in-package #:clifford)

(defun %realpart (info)
  `(defmethod realpart ((x ,(name info)))
     (,(first (accessors info)) x)))

(defun %imagpart (info)
  `(defmethod imagpart ((x ,(name info)))
     (,(constructor info)
       ,@(iter (for a in-non-scalar-accessors-of info)
               (collecting `(,a x))))))

(defun create-accessors-functions (info)
  `(,(%realpart info)
    ,(%imagpart info)))
