(in-package :box.math.vectors)

(eval-when (:compile-toplevel :load-toplevel)
  (defun %swizzle/permutations (n items)
    (if (= n 1)
        (mapcar #'list items)
        (mapcan
         (lambda (x)
           (mapcar
            (lambda (y)
              (cons x y))
            (%swizzle/permutations (1- n) items)))
         items)))

  (defun %swizzle/component-groups ()
    (loop :for masks :in '((x y z w) (r g b a) (s t p q))
          :append
          (loop :with size = 4
                :with set = (subseq masks 0 size)
                :for i from 1 :to size
                :for items = (%swizzle/permutations i set)
                :append (mapcar (lambda (x) (format nil "~{~a~}" x)) items))))

  (defun %swizzle/char-position (components index)
    (let ((char (char components index)))
      (or (position char "XYZW")
          (position char "RGBA")
          (position char "STPQ"))))

  (defun %swizzle/function-body (components)
    (let ((size (length components)))
      (if (= size 1)
          `(aref vec ,(%swizzle/char-position components 0))
          `(let ((result (make-array ,size :element-type 'single-float)))
             ,@(loop :for i :below size
                     :for pos = (%swizzle/char-position components i)
                     :collect `(setf (aref result ,i) (aref vec ,pos)))
             result))))

  (defun %swizzle/generate-docstring (components)
    (let ((size (length components)))
      (if (= size 1)
          (format nil "Swizzle: Get the scalar component ~a from VEC." components)
          (format nil "Swizzle: Create a vec~a from the ~{~a~#[~;, and ~:;, ~]~} components of VEC."
                  size (coerce components 'list))))))

(defmacro generate-swizzle-functions ()
  `(progn
     ,@(loop :for components :in (%swizzle/component-groups)
             :for func-name = (alexandria:symbolicate "." components)
             :for component-list = (coerce components 'list)
             :append
             `((declaim (inline ,func-name))
               (export ',func-name)
               (setf (documentation ',func-name 'function)
                     (%swizzle/generate-docstring ,components))
               (defun ,func-name (vec)
                 ,(%swizzle/function-body components))))))

(generate-swizzle-functions)
