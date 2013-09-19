(in-package #:clifford)

(defun %nullary-addition (info)
  `(defmethod nullary-+ ((x ,(name info)))
     ,(scalar-zero info)))

(defun %unary-addition (info)
  `(defmethod unary-+ ((x ,(name info)))
     x))

(defun %binary-addition (info)
  `(defmethod binary-+ ((x ,(name info)) (y ,(name info)))
     (,(constructor info)
       ,@(iter (for a in-accessors-of info)
               (collecting `(+ (,a x) (,a y)))))))

(defun %scalar-addition (info)
  `((defmethod binary-+ ((x ,(name info)) (y ,(scalar-type info)))
      (,(constructor info)
        ,(first (keywords info)) (+ (,(first (accessors info)) x) y)
        ,@(iter (for a in-non-scalar-accessors-of info)
                (collecting `(,a x)))))
    (defmethod binary-+ ((x ,(scalar-type info)) (y ,(name info)))
      (,(constructor info)
        ,(first (keywords info)) (+ x (,(first (accessors info)) y))
        ,@(iter (for a in-non-scalar-accessors-of info)
                (collecting `(,a y)))))))

(defun %1+-addition (info)
  `(defmethod 1+ ((x ,(name info)))
     (,(constructor info)
       ,(first (keywords info)) (1+ (,(first (accessors info)) x))
       ,@(iter (for a in-non-scalar-accessors-of info)
               (collecting `(,a x))))))

(defun create-addition-functions (info)
  `(,(%nullary-addition info)
    ,(%unary-addition info)
    ,(%binary-addition info)
    ,@(%scalar-addition info)
    ,(%1+-addition info)))
