(in-package #:clifford/test)

(nst:def-test-group accessor-tests ()
  (nst:def-test can-realpart (:equal 1)
    (realpart (make-r2 :one 1 :x 2 :y 3 :xy 4)))

  (nst:def-test can-imagpart (:equalp (make-r2 :x 2 :y 3 :xy 4))
    (imagpart (make-r2 :one 1 :x 2 :y 3 :xy 4)))

  (nst:def-test can-grade (:values (:equalp (make-r2 :one 1))
                                   (:equalp (make-r2 :x 2 :y 3))
                                   (:equalp (make-r2 :xy 4)))
    (let ((v (make-r2 :one 1 :x 2 :y 3 :xy 4)))
      (values (grade v 0)
              (grade v 1)
              (grade v 2))))

  (nst:def-test can-evenpart (:equalp (make-r2 :one 1 :xy 4))
    (evenpart (make-r2 :one 1 :x 2 :y 3 :xy 4))))
