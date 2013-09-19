(in-package #:clifford)

(defun %nullary-multiplication (info)
  `(defmethod nullary-* ((x ,(name info)))
     (coerce 1 ',(scalar-type info))))

(defun %unary-multiplication (info)
  `(defmethod unary-* ((x ,(name info)))
     x))

(defun %binary-multiplication (info)
  (let ((table (basis-multiplication-table info))
        (accessors (accessors info)))
    (labels ((collect-terms (index)
               (iter (for a from 0 below (array-dimension table 0))
                     (appending
                      (iter (for b from 0 below (array-dimension table 1))
                            (for coeff = (nth index (aref table a b)))
                            (collect (list coeff
                                           (nth a accessors)
                                           (nth b accessors)))))))

             (make-term (term-info)
               (destructuring-bind (coeff a b) term-info
                 (cond
                   ((zerop coeff) nil)
                   ((= coeff  1) `(* (,a x) (,b y)))
                   ((= coeff -1) `(- (* (,a x) (,b y))))
                   (t `(* ,coeff (,a x) (,b y))))))

             (get-term (index)
               (awhen (remove nil (mapcar #'make-term (collect-terms index)))
                 `(+ ,@it))))

      `(defmethod binary-* ((x ,(name info)) (y ,(name info)))
         (,(constructor info)
           ,@(iter (for k in (keywords info))
                   (for v in (full-basis info))
                   (for s = (get-term (basis-vector-bits v)))
                   (when s
                     (collect k)
                     (collect s))))))))

(defun %scalar-multiplication (info)
  `((defmethod binary-* ((x ,(name info)) (y ,(scalar-type info)))
      (,(constructor info)
        ,@(iter (for a in-accessors-of info)
                (collecting `(* (,a x) y)))))
    (defmethod binary-* ((x ,(scalar-type info)) (y ,(name info)))
      (,(constructor info)
        ,@(iter (for a in-accessors-of info)
                (collecting `(* x (,a y))))))))

(defun create-multiplication-functions (info)
  `(,(%nullary-multiplication info)
    ,(%unary-multiplication info)
    ,(%binary-multiplication info)
    ,@(%scalar-multiplication info)))
