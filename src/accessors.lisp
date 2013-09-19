(in-package #:clifford)

(defgeneric grade (x grade))
(defgeneric evenpart (x))

(defun %realpart (info)
  `(defmethod realpart ((x ,(name info)))
     (,(first (accessors info)) x)))

(defun %imagpart (info)
  `(defmethod imagpart ((x ,(name info)))
     (,(constructor info)
       ,@(iter (for a in-non-scalar-accessors-of info)
               (collecting `(,a x))))))

(defun %grade (info)
  `(defmethod grade ((x ,(name info)) g)
     (ecase g
       ,@(iter (for g :from 0 :to (length (vector-basis info)))
               (collect `(,g
                          (,(constructor info)
                            ,@(iter (for v in (full-basis info))
                                    (for k in (keywords info))
                                    (for a in (accessors info))
                                    (when (= (basis-vector-grade v) g)
                                      (collect k)
                                      (collect `(,a x)))))))))))

(defun %evenpart (info)
  `(defmethod evenpart ((x ,(name info)))
     (,(constructor info)
       ,@(iter (for v in (full-basis info))
               (for k in (keywords info))
               (for a in (accessors info))
               (when (evenp (basis-vector-grade v))
                 (collect k)
                 (collect `(,a x)))))))

(defun create-accessors-functions (info)
  `(,(%realpart info)
    ,(%imagpart info)
    ,(%grade info)
    ,(%evenpart info)))
