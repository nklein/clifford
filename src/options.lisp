(in-package #:clifford)

(defun option (options name &optional default)
  (acond
    ((assoc name options) (second it))
    (t default)))

(defun option* (options name &optional default)
  (acond
    ((assoc name options) (rest it))
    (t default)))
