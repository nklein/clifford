(defpackage #:clifford/test
  (:use #:cl)
  (:shadowing-import-from :clifford
      :+ :- :* :/
      :negate :zerop
      :1+ :1-
      :incf :decf)
  (:shadowing-import-from :clifford
      :realpart :imagpart :conjugate)
  (:shadowing-import-from :clifford
      := :/= :equalp)
  (:import-from :clifford
                #:one)
  (:import-from :clifford
                #:clifford-bad-basis-specification
                #:clifford-bad-basis-specification-algebra-name
                #:clifford-bad-basis-specification-basis-spec
                #:clifford-bad-basis-specification-reason)
  (:import-from :clifford
                #:clifford-no-keyword-constructor
                #:clifford-no-keyword-constructor-algebra-name
                #:clifford-no-keyword-constructor-struct-options)
  (:import-from :clifford
                #:clifford-overspecified
                #:clifford-overspecified-algebra-name
                #:clifford-overspecified-quadratic-form
                #:clifford-overspecified-inner-product)
  (:import-from :clifford
                #:defcliff)
  (:import-from :clifford
                #:grade
                #:evenpart
                #:oddpart)
  (:import-from :clifford
                #:grade-inversion
                #:reversion)
  (:import-from :clifford
                #:dot
                #:wedge))

(in-package #:clifford/test)

(defun run-tests ()
  (let ((*print-pretty* t))
    (nst:nst-cmd :run-package #.*package*)))
