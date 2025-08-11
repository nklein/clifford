(in-package #:clifford)

(defun %load-object (info)
  (let ((env (gensym "ENVIRONMENT-")))
    `(defmethod make-load-form ((x ,(name info)) &optional ,env)
       (declare (ignore ,env))
       (list ',(constructor info)
             ,@(iter (for a in-accessors-of info)
                 (collecting `(,a x)))))))

(defun %print-object (info)
  (let ((first (gensym "FIRST-"))
        (v (gensym "V-"))
        (a (gensym "A-"))
        (n (gensym "N-")))
    `(defmethod print-object ((x ,(name info)) stream)
       (cond
         (*print-readably*
          (call-next-method))
         (*print-pretty*
          (let ((,first t))
            (map 'nil
                 (lambda (,v ,a)
                   (let ((,n (funcall ,a x)))
                     (cond
                       ((zerop ,n))
                       (,first
                        (format stream "~A~A" ,n ,v)
                        (setf ,first nil))
                       (t
                        (if (plusp ,n)
                            (format stream " + ~A~A" ,n ,v)
                            (format stream " - ~A~A" (- ,n) ,v))))))
                 (list ,@(mapcar (lambda (k)
                                   (if (eq k :one)
                                       ""
                                       (format nil "·~A" (string-downcase (string k)))))
                                 (keywords info)))
                 (list ,@(mapcar (lambda (a) `(function ,a)) (accessors info))))
            (when ,first
              (format stream "~A" ,(scalar-zero info)))))
         (t
          (call-next-method))))))

(defun create-printer-functions (info)
  `(,(%load-object info)
    ,(%print-object info)))
