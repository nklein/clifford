(in-package #:clifford)

(defstruct (algebra-info (:conc-name)
                         (:copier))
  algebra-info-package
  name
  scalar-zero
  scalar-type
  vector-basis
  full-basis
  basis-multiplication-table
  basis-reversion-table
  constructor
  keywords
  accessors
  options)
