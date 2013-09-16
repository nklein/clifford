(in-package #:clifford-tests)

(nst:def-test-group addition-tests ()
  (nst:def-test can-add-r2 (:equalp (make-r2 :one 1 :x 2 :y 3 :xy 4))
    (+ (make-r2 :one 1 :x 1 :y 1 :xy 1)
       (make-r2 :one 0 :x 1 :y 1 :xy 1)
       (make-r2 :one 0 :x 0 :y 1 :xy 1)
       (make-r2 :one 0 :x 0 :y 0 :xy 1)))

  (nst:def-test can-pre-add-scalar (:equalp (make-r2 :one 2 :x 1))
    (+ 1 (make-r2 :one 1 :x 1)))

  (nst:def-test can-post-add-scalar (:equalp (make-r2 :one 2 :x 1))
    (+ (make-r2 :one 1 :x 1) 1))

  (nst:def-test can-1+ (:equalp (make-r2 :one 2 :x 1))
    (1+ (make-r2 :one 1 :x 1)))

  (nst:def-test can-unary-add (:equalp (make-r2 :one 1 :x 1))
    (+ (make-r2 :one 1 :x 1))))
