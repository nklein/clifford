(in-package #:clifford/test)

(nst:def-test-group involution-tests ()
  (nst:def-test can-grade-inversion
      (:equalp (make-r2 :one 1 :x -2 :y -3 :xy 4))
    (grade-inversion (make-r2 :one 1 :x 2 :y 3 :xy 4)))

  (nst:def-test can-reversion
      (:equalp (make-r2 :one 1 :x 2 :y 3 :xy -4))
    (reversion (make-r2 :one 1 :x 2 :y 3 :xy 4)))

  (nst:def-test can-conjugate
      (:equalp (make-r2 :one 1 :x 2 :y 3 :xy -4))
    (conjugate (make-r2 :one 1 :x -2 :y -3 :xy 4))))
