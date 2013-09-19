(in-package #:clifford)

(defmacro-clause (FOR a IN-ACCESSORS-OF info)
  (let ((i (gensym "INFO-"))
        (k (gensym "KEYWORD-")))
    `(progn
       (with ,i = ,info)
       (for ,k in (keywords ,i))
       (for ,a in (accessors ,i))
       (collecting ,k))))

(defmacro-clause (FOR a IN-NON-SCALAR-ACCESSORS-OF info)
  (let ((i (gensym "INFO-"))
        (k (gensym "KEYWORD-")))
    `(progn
       (with ,i = ,info)
       (for ,k in (rest (keywords ,i)))
       (for ,a in (rest (accessors ,i)))
       (collecting ,k))))
