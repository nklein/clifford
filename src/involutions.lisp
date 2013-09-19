(in-package #:clifford)

(defgeneric grade-inversion (x))
(defgeneric reversion (x))

(defun %grade-inversion (info)
  `(defmethod grade-inversion ((x ,(name info)))
     (,(constructor info)
       ,@(iter (for v in (full-basis info))
               (for k in (keywords info))
               (for a in (accessors info))
               (collect k)
               (if (evenp (basis-vector-grade v))
                   (collect `(,a x))
                   (collect `(- (,a x))))))))

(defun %reversion-and-conjugate (info)
  (let ((table (basis-reversion-table info))
        (accessors (accessors info)))
    (labels ((collect-terms (index)
               (iter (for a from 0 below (array-dimension table 0))
                     (for coeff = (nth index (aref table a)))
                     (collect (list coeff
                                    (nth a accessors)))))

             (make-term (term-info)
               (destructuring-bind (coeff a) term-info
                 (cond
                   ((zerop coeff) nil)
                   (t `(* ,coeff (,a x))))))

             (get-term (index)
               (awhen (remove nil (mapcar #'make-term (collect-terms index)))
                 `(+ ,@it))))

      `((defmethod reversion ((x ,(name info)))
          (,(constructor info)
            ,@(iter (for k in (keywords info))
                    (for v in (full-basis info))
                    (for s = (get-term (basis-vector-bits v)))
                    (when s
                      (collect k)
                      (collect s)))))

        (defmethod conjugate ((x ,(name info)))
          (,(constructor info)
            ,@(iter (for k in (keywords info))
                    (for v in (full-basis info))
                    (for s = (get-term (basis-vector-bits v)))
                    (when s
                      (collect k)
                      (if (evenp (basis-vector-grade v))
                          (collect s)
                          (collect `(- ,s)))))))))))

(defun create-involution-functions (info)
  `(,(%grade-inversion info)
    ,@(%reversion-and-conjugate info)))
