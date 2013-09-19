(in-package #:clifford)

(defmacro defcliff (name (&rest vector-basis) &body options)
  (let ((info (create-algebra-info name vector-basis options)))
    `(progn
       ,(create-struct info)
       ,@(create-addition-functions info)
       ,@(create-subtraction-functions info)
       ,@(create-multiplication-functions info)
       ,@(create-predicate-functions info)
       ,@(create-accessors-functions info)
       ,@(create-involution-functions info)
       ,@(create-product-functions info)
       ',name)))
