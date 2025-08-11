(in-package #:clifford/test)

(nst:def-test-group product-tests ()
  (nst:def-test dot-product-a-a
      (:equalp (make-r2 :one -2 :x 4 :y 6 :xy 8))
    (let ((a (make-r2 :one 1 :x 2 :y 3 :xy 4)))
      (dot a a)))

  (nst:def-test dot-product-a-b
      (:equalp (make-r2 :one 2 :x 3 :y 4 :xy 5))
    (let ((a (make-r2 :one 1 :x 2 :y 3 :xy 4))
          (b (make-r2 :one 1 :x 1 :y 1 :xy 1)))
      (dot a b)))

  (nst:def-test wedge-product-a-a (:predicate zerop)
    (let ((a (make-r2 :one 1 :x 2 :y 3 :xy 4)))
      (wedge a a)))

  (nst:def-test wedge-product-a-b
      (:equalp (make-r2 :one 0 :x 1 :y -2 :xy -1))
    (let ((a (make-r2 :one 1 :x 2 :y 3 :xy 4))
          (b (make-r2 :one 1 :x 1 :y 1 :xy 1)))
      (wedge a b))))
