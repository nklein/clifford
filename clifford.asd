(require :asdf)

(asdf:defsystem #:clifford
  :description "Clifford algebra library"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.3.20250811"
  :license "UNLICENSE"
  :depends-on (:generic-cl.arithmetic :generic-cl.math :generic-cl.comparison :iterate :anaphora)
  :in-order-to ((asdf:test-op (asdf:test-op :clifford/test)))
  :components ((:static-file "README.md")
               (:static-file "UNLICENSE")
               (:module "src"
                :components ((:file "package")
                             (:file "def-errors" :depends-on ("package"))
                             (:file "options" :depends-on ("package"))
                             (:file "info" :depends-on ("package"
                                                        "options"))
                             (:file "vbasis" :depends-on ("package"
                                                          "info"
                                                          "def-errors"))
                             (:file "basis" :depends-on ("package"
                                                         "info"
                                                         "def-errors"
                                                         "vbasis"))
                             (:file "struct" :depends-on ("package"
                                                          "info"))
                             (:file "printer" :depends-on ("package"
                                                           "info"))
                             (:file "iter" :depends-on ("package"
                                                        "info"))
                             (:file "add" :depends-on ("package"
                                                       "info"
                                                       "iter"))
                             (:file "sub" :depends-on ("package"
                                                       "info"
                                                       "iter"))
                             (:file "mul" :depends-on ("package"
                                                       "info"
                                                       "iter"))
                             (:file "predicates" :depends-on ("package"
                                                              "info"))
                             (:file "accessors" :depends-on ("package"
                                                             "info"
                                                             "iter"))
                             (:file "involutions" :depends-on ("package"
                                                               "info"
                                                               "iter"))
                             (:file "product" :depends-on ("package"
                                                           "info"))
                             (:file "create-info" :depends-on ("package"
                                                               "info"
                                                               "vbasis"
                                                               "basis"))
                             (:file "define" :depends-on ("package"
                                                          "create-info"
                                                          "struct"
                                                          "add"
                                                          "sub"
                                                          "mul"
                                                          "predicates"
                                                          "accessors"
                                                          "involutions"))))))

(asdf:defsystem #:clifford/test
  :description "Tests for the Clifford algebra library."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.3.20250811"
  :license "UNLICENSE"
  :depends-on (#:clifford #:nst)
  :perform (asdf:test-op (o c)
                         (uiop:symbol-call :clifford/test :run-tests))
  :components ((:module "src"
                :components ((:file "package-t")
                             (:file "def-errors-t" :depends-on ("package-t"))
                             (:file "add-t"
                                    :depends-on ("package-t" "define-t"))
                             (:file "sub-t"
                                    :depends-on ("package-t" "define-t"))
                             (:file "mul-t"
                                    :depends-on ("package-t" "define-t"))
                             (:file "define-t"
                                    :depends-on ("package-t"))
                             (:file "predicates-t"
                                    :depends-on ("package-t" "define-t"))
                             (:file "accessors-t"
                                    :depends-on ("package-t" "define-t"))
                             (:file "involutions-t"
                                    :depends-on ("package-t" "define-t"))
                             (:file "product-t"
                                    :depends-on ("package-t" "define-t"))))))
