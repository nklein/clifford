(in-package #:clifford)

(defstruct basis-vector
  grade
  name
  bits)

(defun %subset (k list)
  (iter (for i from 0)
        (for v in list)
        (when (logbitp i k)
          (collect v))))

(defun %sym-from-subset (subset package)
  (if subset
      (intern (apply #'concatenate 'string
                     (mapcar #'symbol-name subset)) package)
      (intern (symbol-name 'one) package)))

(defun %full-basis-info (vector-basis package)
  (stable-sort (iter (for k from 0 below (expt 2 (length vector-basis)))
                     (for grade = (logcount k))
                     (for subset = (%subset k vector-basis))
                     (collect (make-basis-vector :grade grade
                                                 :name (%sym-from-subset
                                                        subset package)
                                                 :bits k)))
               #'< :key #'basis-vector-grade))


(defun calculate-full-basis (info)
  (let* ((full-basis (%full-basis-info (vector-basis info) (package info))))

    (unless (equalp full-basis (remove-duplicates full-basis
                                                  :key #'basis-vector-name))
      (error 'clifford-bad-basis-specification
             :algebra-name (name info)
             :basis-spec (vector-basis info)
             :reason
             "Basis elements cannot be concatenation of other elements"))

    (setf (full-basis info) full-basis)))

(defun %vec (len index &optional (value 1))
  (iter (for x from 0 below len)
        (collect (if (= index x) value 0))))

(defun %vs (alpha vec)
  (mapcar (lambda (x) (* alpha x)) vec))

(defun %v+ (a b)
  (mapcar #'+ a b))

(defun %v- (a b)
  (mapcar #'- a b))

(defmacro %with-quadratic-form ((quadratic-form) &body body)
  `(macrolet ((q (x)
                `(funcall ,',quadratic-form ,x))
              (b (x y)
                (let ((gx (gensym "X"))
                      (gy (gensym "Y")))
                  `(let ((,gx ,x)
                         (,gy ,y))
                     (* 1/2 (- (q (%v+ ,gx ,gy)) (q ,gx) (q ,gy)))))))
     ,@body))

(defun %calculate-basis-dot-products (quadratic-form length)
  (%with-quadratic-form (quadratic-form)
    (let ((dots (make-array (list length length))))
      (dotimes (j length dots)
        (let ((jvec (%vec length j)))
          (dotimes (i length)
            (setf (aref dots j i)
                  (setf (aref dots i j) (b jvec (%vec length i))))))))))

(defun %bits-set (x)
  (iter (for i from 0)
        (for b initially 1 then (ash b 1))
        (while (<= b x))
        (when (logbitp i x)
          (collect (1+ i)))))

(defun %from-bits (xs)
  (iter (for x in xs)
        (sum (ash 1 (1- x)))))

;;; Concept here should be that I have an arbitrarily long list of
;;; ordered tuples.
;;; At any step, combine all the ones that can be readily combined.
;;; At any step, remove any nils.
;;; If there is only one, (vec len (from-bits x)).
;;; Otherwise, find one to swap and do that.

(defun %combine-adjacent (xs)
  (labels ((combine (xs accum)
             (cond
               ((null xs)
                (nreverse accum))

               ((null (rest xs))
                (combine nil (list* (first xs) accum)))

               (t
                (destructuring-bind (x y . xs) xs
                  (cond
                   ((< (first (last x)) (first y))
                    (combine (list* (append x y) xs) accum))

                   (t
                    (combine (list* y xs) (list* x accum)))))))))
    (combine xs nil)))

(defun %basis-multiply (dot-fn len dim &rest xs)
  (labels ((mul (xs)
             (let ((xs (%combine-adjacent (remove nil xs))))
               (cond
                 ((null xs)
                  (%vec len 0))

                 ((null (rest xs))
                  (%vec len (%from-bits (first xs))))

                 (t
                  (destructuring-bind (x y . xs) xs
                    (let ((a (first (last x)))
                          (b (first y))
                          (x (butlast x))
                          (y (rest y)))
                      (if (= a b)
                          (combine-like x a y xs)
                          (swap-ab x a b y xs))))))))

           (dot (a b)
             (funcall dot-fn (%vec dim (1- a)) (%vec dim (1- b))))

           (combine-like (x a y xs)
             ;; X e1 e1 Y ... = (e1.e1) X Y ...
             (%vs (dot a a) (mul (list* x y xs))))

           (swap-ab (x a b y xs)
             ;; X e2 e1 Y ... = 2(e1.e2) X Y ... - X e1 e2 Y ...
             (%v- (%vs (* 2 (dot a b)) (mul (list* x xs)))
                  (mul (list* x (list b a) y xs)))))
    (mul xs)))

(defun %cl*-from-inner-product (inner-product vector-basis)
  (let* ((dim (length vector-basis))
         (len (expt 2 dim))
         (mul (make-array (list len len) :initial-element nil))
         (rev (make-array (list len) :initial-element nil)))
    (dotimes (a len (values mul rev))
      (dotimes (b len)
        (setf (aref mul a b) (%basis-multiply inner-product len dim
                                              (%bits-set a) (%bits-set b))))
      (setf (aref rev a) (apply #'%basis-multiply
                                inner-product len dim
                                (mapcar #'list (nreverse (%bits-set a))))))))

(defun %cl*-from-quadratic-form (quadratic-form vector-basis)
  (flet ((dot (a b)
           (* 1/2 (- (funcall quadratic-form (%v+ a b))
                     (funcall quadratic-form a)
                     (funcall quadratic-form b)))))
    (%cl*-from-inner-product #'dot vector-basis)))

(defun %calculate-basis-multiplication-table (info)
  (let* ((vector-basis (vector-basis info))
         (options (options info))
         (quadratic-form (option options :quadratic-form))
         (inner-product (option options :inner-product)))
    (acond
      ((and quadratic-form inner-product)
       (error 'clifford-overspecified
              :algebra-name (name info)
              :quadratic-form quadratic-form
              :inner-product inner-product))

      (quadratic-form
       (%cl*-from-quadratic-form (compile nil it) vector-basis))

      (inner-product
       (%cl*-from-inner-product (compile nil it) vector-basis))

      (t
       (flet ((l2 (v) (reduce #'+ (mapcar #'* v v))))
         (%cl*-from-quadratic-form #'l2 vector-basis))))))

(defun calculate-basis-multiplication-table (info)
  (multiple-value-bind (mul-table reversion-table)
      (%calculate-basis-multiplication-table info)
    (setf (basis-multiplication-table info) mul-table
          (basis-reversion-table info) reversion-table)))
