(defpackage #:clifford-tests
  (:use #:common-lisp/generic-arithmetic #:clifford)
  (:export #:run-tests))

(in-package #:clifford-tests)

(defun run-tests ()
  (let ((*print-pretty* t))
    (nst:nst-cmd :run-package #.*package*)))
