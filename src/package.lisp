(defpackage #:clifford
  (:use #:iterate #:anaphora #:cl)
  (:shadowing-import-from #:generic-cl.arithmetic
      :+ :- :* :/
      :negate :zerop
      :add :subtract :multiply :divide
      :1+ :1-
      :incf :decf)
  (:shadowing-import-from #:generic-cl.math
      :realpart :imagpart :conjugate)
  (:shadowing-import-from #:generic-cl.comparison
      := :/= :equalp)
  (:export :+ :- :* :/
      :negate :zerop
      :1+ :1-
      :incf :decf)
  (:export :realpart :imagpart :conjugate)
  (:export := :/= :equalp)

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
