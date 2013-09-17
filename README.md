## Common Lisp Clifford Algebra Library

### Overview

The `CLIFFORD` library allows one to define Clifford algebras in
Common Lisp.  The library provides a mechanism for specifying the
algebra.  It employs `CL-GENERIC-ARITHMETIC` to allow one to add,
subtract, and multiply elements of an algebra with other elements of
the same algebra or with the scalars for that algebra.

### Defining a Clifford algebra

One can use the `DEFCLIFF` macro to define a Clifford algebra:

    (defcliff NAME (&rest VECTOR-BASIS) [[OPTIONS]])

    OPTIONS := (:struct-options STRUCT-OPTIONS) |
               (:scalar-zero SCALAR-ZERO) |
               (:scalar-type SCALAR-TYPE) |
               (:quadratic-form QUADRATIC-FORM) |
               (:inner-product INNER-PRODUCT))

The `DEFCLIFF` macro creates a struct of the given `NAME` to represent
a Clifford multivector.

The `VECTOR-BASIS` must be a non-empty list of symbols (or strings)
which label the basis vectors of the vector space of the Clifford
algebra.  The symbol names in the `VECTOR-BASIS` are used to generate
the names for the full Clifford algebra.  As such, the symbol names
must be distinct.  Further, no symbol name in the `VECTOR-BASIS` can
be a direct concatenation of the symbol names of an in-order subset of
the the `VECTOR-BASIS`.  Additionally, the symbol name `ONE` is
reserved for the scalar portion of the Clifford multivector.  This is
better shown by example:

    (E1 E2 E3)    ; Valid
    (E E*)        ; Valid
    (A B C D E)   ; Valid
    (A AA AAAA)   ; Valid
    (A B BA)      ; Valid, but only because of the order
    (ONE TWO)     ; Error: ONE is reserved
    (A AA AAA)    ; Invalid, "A" + "AA" = "AAA"
    (A B AB)      ; Invalid, "A" + "B" = "AB"

The optional `:struct-options` can be used to provide additional
arguments to the `DEFSTRUCT` form for the `NAME` structure.  The only
restriction beyond those imposed by `DEFSTRUCT` is that the `NAME`
structure have at least one keyword constructor.  For example:

    (defcliff CL2 (E1 E2)
      (:struct-options
       (:conc-name cl2)
       (:predicate real-cl2-p)
       (:constructor %make-cl2-p)
       (:constructor make-cl2 (e1 e2 &key (one 0) (e1e2 0)))))

The `:scalar-zero` option allows one to specify the default
coefficient for components of the Clifford multivector.  The
`:scalar-type` allows one to specify the type for the coefficients.
The `:scalar-zero` defaults to `0` and the `:scalar-type` defaults to
`real`.

The `:quadratic-form` and `:inner-product` are mutually exclusive.

If given, the `:quadratic-form` should be a lambda expression in one
variable.  This function will be given a list of scalars.  The
function is to interpret the list as a vector in the given
`VECTOR-BASIS` and return the evaluation of the quadratic form for
that vector.  The quadratic form for a positive-definite, orthonormal
basis of any size could be specified as:

    (:quadratic-form (lambda (v) (reduce #'+ (mapcar #'* v v))))

If given, the `:inner-product` should be a lambda expression in two
variables.  This function will be given two lists of scalars.  The
function is to interpret the lists as vectors in the given
`VECTOR-BASIS` and return the inner product for that vector.  The
dot-product for a positive-definite, orthonormal basis of any size
could be specified as:

    (:inner-product (lambda (a b) (reduce #'+ (mapcar #'* a b))))

If neither the `:quadratic-form` nor the `:inner-product` are
specified, then the default is for a positive-definite, orthonormal
basis.

### Arithmetic with Clifford algebras

For the examples in this section, we will use the following Clifford
algebra specification to declare a Clifford algebra with
`single-float` coefficients and a null basis `(E E*)`.

    (defcliff r11 (e e*)
      (:struct-options
        :conc-name
        (:constructor %make-r11)
        (:constructor make-r11 (e e* &key (one 0.0) (ee* 0.0))))
      (:scalar-type single-float)
      (:quadratic-form (lambda (v) (* 2.0 (first v) (second v)))))

We can now define several multivectors to work with:

    (defparameter e   (make-r11 1.0 0.0))
    (defparameter e*  (make-r11 0.0 1.0))
    (defparameter ee* (make-r11 0.0 0.0 :ee* 1.0))

Assuming we're in package `:clifford-user` or in package
`:common-lisp/cl-generic-arithmetic-user`, then we can add and
subtract these multivectors just as we do other numbers intermixing
the arithmetic with scalars as desired.

    (+ 1.0 (* 2.0 e) (* 3.0 e*) (* 4.0 ee*))
        => #S(R11 :ONE 1.0 :E 2.0 :E* 3.0 :EE* 4.0)
    (- 1.0 (* 2.0 e) (* 3.0 e*) (* 4.0 ee*))
        => #S(R11 :ONE 1.0 :E -2.0 :E* -3.0 :EE* -4.0)

We can also negate and multiply multivectors:

    (* e e*) => #S(R11 :ONE 0.0 :E 0.0 :E* 0.0 :EE* 1.0)
    (* e* e) => #S(R11 :ONE 0.0 :E 0.0 :E* 0.0 :EE* -1.0)
    (- (* e* e)) => #S(R11 :ONE 0.0 :E 0.0 :E* 0.0 :EE* 1.0)

We can use various predicates, comparisons, and accessors with
multivectors:

    (zerop (make-r11 0.0 0.0)) => T
    (zerop e) => NIL
    (= e e)   => T
    (= e e*)  => NIL
    (/= e e)  => NIL
    (/= e e*) => T
    (realpart (+ 2 e)) => 2
    (imagpart (+ 2 e)) => #S(R11 :ONE 0.0 :E 1.0 :E* 0.0 :EE* 0.0)

### Still to be done

In the near future, I will add: `GRADE-INVERSION`, `REVERSION`,
`CONJUGATE`, `DOT`, and `WEDGE`.

Maybe someday I will add `EXPT`, `LOG`, `EXP`, trig functions,
hyperbolic trig functions, etc.
