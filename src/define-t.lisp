(in-package #:clifford-tests)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defcliff r2 (x y)))

(nst:def-test-group definition-tests ()
  (nst:def-test can-instantiate-r2 (:true)
    (make-r2 :one 1 :x 2 :y 3 :xy 4))

  (nst:def-test slots-correct (:equal '(1 2 3 4))
    (let ((vec (make-r2 :one 1 :x 2 :y 3 :xy 4)))
      (list (r2-one vec)
            (r2-x vec)
            (r2-y vec)
            (r2-xy vec)))))
