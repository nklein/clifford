(in-package #:clifford-tests)

(nst:def-test-group multiplication-tests ()
  (nst:def-test can-mul-r2 (:equalp (make-r2 :one -2 :x -2))
    (* (make-r2 :one 1 :x 1 :y 1 :xy 1)
       (make-r2 :one 0 :x 1 :y 1 :xy 1)
       (make-r2 :one 0 :x 0 :y 1 :xy 1)
       (make-r2 :one 0 :x 0 :y 0 :xy 1)))

  (nst:def-test can-unary-times (:equalp (make-r2 :one 1 :x 1))
    (* (make-r2 :one 1 :x 1)))

  (nst:def-test can-pre-mul-scalar (:equalp (make-r2 :one 2 :x 2))
    (* 2 (make-r2 :one 1 :x 1)))

  (nst:def-test can-post-mul-scalar (:equalp (make-r2 :one 2 :x 2))
    (* (make-r2 :one 1 :x 1) 2)))
