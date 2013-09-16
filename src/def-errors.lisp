(in-package #:clifford)

(define-condition clifford-bad-basis-specification (error)
  ((algebra-name :initarg :algebra-name
                 :reader clifford-bad-basis-specification-algebra-name)
   (basis-spec :initarg :basis-spec
               :reader clifford-bad-basis-specification-basis-spec)
   (reason :initarg :reason
           :reader clifford-bad-basis-specification-reason))
  (:report
   (lambda (condition stream)
     (format stream "Bad basis specification for algebra ~A: ~A (~A)~%"
             (clifford-bad-basis-specification-algebra-name condition)
             (clifford-bad-basis-specification-basis-spec condition)
             (clifford-bad-basis-specification-reason condition)))))

(define-condition clifford-no-keyword-constructor (error)
  ((algebra-name :initarg :algebra-name
                 :reader clifford-no-keyword-constructor-algebra-name)
   (struct-options :initarg :struct-options
                   :reader clifford-no-keyword-constructor-struct-options))
  (:report
   (lambda (condition stream)
     (format stream "Must have a keyword-constructor for ~A (~A)"
             (clifford-no-keyword-constructor-algebra-name condition)
             (clifford-no-keyword-constructor-struct-options condition)))))

(define-condition clifford-overspecified (error)
  ((algebra-name :initarg :algebra-name
                 :reader clifford-overspecified-algebra-name)
   (quadratic-form :initarg :quadratic-form
                   :reader clifford-overspecified-quadratic-form)
   (inner-product :initarg :inner-product
                  :reader clifford-overspecified-inner-product))
  (:report
   (lambda (condition stream)
     (format stream "Can only specify quadratic-form or inner-product for ~A"
             (clifford-overspecified-algebra-name condition)))))
