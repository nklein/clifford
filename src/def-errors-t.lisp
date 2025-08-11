(in-package #:clifford/test)

(nst:def-criterion (:basis-error (name basis reason) (:form body))
  (handler-case
      (progn
        (eval body)
        (nst:make-failure-report
         :format "Expected CLIFFORD-BAD-BASIS-SPECIFICATION error"))

    (clifford-bad-basis-specification (err)
      (let ((nm (clifford-bad-basis-specification-algebra-name err))
            (bs (clifford-bad-basis-specification-basis-spec err))
            (re (clifford-bad-basis-specification-reason err)))

        (if (and (eq nm name)
                 (equalp bs basis)
                 (string= re reason))
            (nst:make-success-report)
            (nst:make-failure-report
             :format "Expected CLIFFORD-BAD-BASIS-SPECIFICATION ~S, got ~S"
             :args (list (list name basis reason)
                         (list nm bs re))))))))

(nst:def-test-group basis-specification-error-tests ()
  (nst:def-test must-specify-basis
      (:basis-error bad-basis nil "Must specify at least one basis vector")
    (macroexpand '(defcliff bad-basis ())))

  (nst:def-test basis-cannot-repeat
      (:basis-error bad-basis (e e) "Basis cannot have repeated elements")
    (macroexpand '(defcliff bad-basis (e e))))

  (nst:def-test basis-must-be-symbols
      (:basis-error bad-basis (5 (a b c))
                    "Basis elements must be non-keyword symbols or strings")
    (macroexpand '(defcliff bad-basis (5 (a b c)))))

  (nst:def-test basis-must-not-be-keywords
      (:basis-error bad-basis (:a :b)
                    "Basis elements must be non-keyword symbols or strings")
    (macroexpand '(defcliff bad-basis (:a :b))))

  (nst:def-test basis-symbols-not-concat-of-others
      (:basis-error bad-basis (a b ab)
                    "Basis elements cannot be concatenation of other elements")
    (macroexpand '(defcliff bad-basis (a b ab))))

  (nst:def-test basis-cannot-contain-one
      (:basis-error bad-basis (one two)
                    "Vector basis cannot contain element \"ONE\"")
    (macroexpand '(defcliff bad-basis (one two)))))
