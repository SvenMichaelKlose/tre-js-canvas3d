(fn get-line-values (line)
  (remove-if #'not (cdr (split #\  line))))

(fn get-face (line)
  (filter [car (split #\/ _)] line))

(fn print-expressions-0 (out cmd x)
  (format out "(~A '(~%" cmd)
  (adolist x
    (princ #\( out)
    (adolist !
      (format out "~A " !))
    (princ #\) out))
  (format out "))~%"))

(fn print-expressions (out name x)
  (with (grps (group x 1000)
         n    (+ "*" name "*"))
    (print-expressions-0 out (format nil "defvar ~A~%" n) grps.)
    (@ (! .grps)
      (print-expressions-0 out (format nil "= ~A (nconc ~A~%" n n) !)
      (princ #\) out))))

(fn obj2lisp (in out)
  (with (lines           (read-all-lines in)
         vertices        (remove-if-not [head? _ "v "] lines)
         faces           (remove-if-not [head? _ "f "] lines)
         split-vertices  (filter #'get-line-values vertices)
         split-faces     (filter #'get-face (filter #'get-line-values faces)))
    (format out "; ~A vertices and ~A faces.~%" (length vertices) (length faces))
    (print-expressions out "vertices" split-vertices)
    (print-expressions out "faces" split-faces)))

(with-open-file in (open "CC-Logo2.obj" :direction 'input)
  (with-open-file out (open "logo.lisp" :direction 'output)
    (obj2lisp in out)))

(quit)
