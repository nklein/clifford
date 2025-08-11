(in-package #:clifford)

(defun %maybe-first (item)
  (or (and (listp item)
           (first item))
      item))

(defun %find-keyword-constructor (struct-options)
  (when struct-options
    (let* ((got (member :constructor struct-options :key #'%maybe-first))
           (it (first got)))
      (cond
        ((and (listp it)
              (= (length it) 2))
         (second it))

        (t
         (%find-keyword-constructor (rest got)))))))

(defun %calculate-constructor (name struct-options)
  (acond
    ((%find-keyword-constructor struct-options)
     it)

    ((find :constructor struct-options :key #'%maybe-first)
     (error 'clifford-no-keyword-constructor
            :algebra-name name
            :struct-options struct-options))

    (t
     (intern (concatenate 'string "MAKE-" (symbol-name name))
             (symbol-package name)))))

(defun calculate-constructor (info)
  (let ((name (name info))
        (struct-options (option* (options info) :struct-options)))
    (setf (constructor info) (%calculate-constructor name struct-options))))

(defun calculate-keywords (info)
  (flet ((to-keyword (vec)
           (intern (symbol-name (basis-vector-name vec)) :keyword)))
    (setf (keywords info) (mapcar #'to-keyword (full-basis info)))))

(defun %calculate-conc-name (name struct-options)
  (acond
    ((find :conc-name struct-options)
     "")

    ((find :conc-name struct-options :key #'%maybe-first)
     (aif (second it)
        (symbol-name it)
        ""))

    (t
     (concatenate 'string (symbol-name name) "-"))))

(defun calculate-accessors (info)
  (let* ((name (name info))
         (struct-options (option* (options info) :struct-options))
         (conc-name (%calculate-conc-name name struct-options))
         (package (algebra-info-package info)))
    (flet ((aname (element)
             (intern (concatenate 'string
                                  conc-name
                                  (symbol-name (basis-vector-name element)))
                     package)))
      (setf (accessors info) (mapcar #'aname (full-basis info))))))

(defun create-algebra-info (name vector-basis options)
  (let* ((scalar-type (option options :scalar-type 'real))
         (scalar-zero (option options :scalar-zero (coerce 0 scalar-type)))
         (info (make-algebra-info :algebra-info-package (symbol-package name)
                                 :name name
                                 :vector-basis vector-basis
                                 :scalar-zero scalar-zero
                                 :scalar-type scalar-type
                                 :options options)))
    (validate-vector-basis info)
    (calculate-full-basis info)
    (calculate-constructor info)
    (calculate-keywords info)
    (calculate-accessors info)
    (calculate-basis-multiplication-table info)
    info))
