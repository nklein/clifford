(in-package #:clifford-tests)

(nst:def-test-group accessor-tests ()
  (nst:def-test can-realpart (:equal 1)
    (realpart (make-r2 :one 1 :x 2 :y 3 :xy 4)))

  (nst:def-test can-imagpart (:equalp (make-r2 :x 2 :y 3 :xy 4))
    (imagpart (make-r2 :one 1 :x 2 :y 3 :xy 4))))
