(require :asdf)

(asdf:defsystem #:clifford
  :description "Clifford algebra library"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.2.20130918"
  :license "unlicense"
  :depends-on (:conduit-packages :cl-generic-arithmetic :iterate :anaphora)
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

(asdf:defsystem #:clifford-tests
  :description "Tests for the Clifford algebra library."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.2.20130918"
  :license "unlicense"
  :depends-on (#:clifford #:nst)
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

(defmethod asdf:perform ((op asdf:test-op)
                         (system (eql (asdf:find-system :clifford))))
  (asdf:load-system :clifford-tests)
  (funcall (find-symbol (symbol-name :run-tests) :clifford-tests)))
