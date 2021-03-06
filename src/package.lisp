(org.tfeb.conduit-packages:defpackage #:clifford
  (:use #:iterate #:anaphora)
  (:extends #:common-lisp/generic-arithmetic)
  (:export #:one)
  (:export #:clifford-bad-basis-specification
           #:clifford-bad-basis-specification-algebra-name
           #:clifford-bad-basis-specification-basis-spec
           #:clifford-bad-basis-specification-reason)
  (:export #:clifford-no-keyword-constructor
           #:clifford-no-keyword-constructor-algebra-name
           #:clifford-no-keyword-constructor-struct-options)
  (:export #:clifford-overspecified
           #:clifford-overspecified-algebra-name
           #:clifford-overspecified-quadratic-form
           #:clifford-overspecified-inner-product)
  (:export #:defcliff)
  (:export #:grade
           #:evenpart
           #:oddpart)
  (:export #:grade-inversion
           #:reversion)
  (:export #:dot
           #:wedge))

(defpackage #:clifford-user
  (:use #:clifford))
