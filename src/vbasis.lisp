(in-package #:clifford)

(defun %symbolify (list package)
  (flet ((symbolify (item)
           (typecase item
             (string (intern item package))
             (t item))))
    (mapcar #'symbolify list)))

(defun %symbol-but-not-keyword-p (sym)
  (and (symbolp sym)
       (not (keywordp sym))))

(defun validate-vector-basis (info)
  (let* ((package (package info))
         (vector-basis (%symbolify (vector-basis info) package)))
    (flet ((err (reason)
             (error 'clifford-bad-basis-specification
                    :algebra-name (name info)
                    :basis-spec vector-basis
                    :reason reason)))

      (unless vector-basis
        (err "Must specify at least one basis vector"))

      (unless (equalp vector-basis (remove-duplicates vector-basis))
        (err "Basis cannot have repeated elements"))

      (unless (every #'%symbol-but-not-keyword-p vector-basis)
        (err "Basis elements must be non-keyword symbols or strings"))

      (when (find :one vector-basis :test #'string= :key #'symbol-name)
        (err "Vector basis cannot contain element \"ONE\""))

      (setf (vector-basis info) vector-basis))))
