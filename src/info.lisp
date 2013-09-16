(in-package #:clifford)

(defstruct (algebra-info (:conc-name)
                         (:copier))
  package
  name
  scalar-zero
  scalar-type
  vector-basis
  full-basis
  basis-multiplication-table
  constructor
  keywords
  accessors
  options)
