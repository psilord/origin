(in-package :gamebox-math)

(eval-when (:compile-toplevel :load-toplevel)
  (defun* zero-matrix () (:result matrix :abbrev mzero)
    "Create a matrix of all zeros."
    (%matrix 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0))

  (defun* matrix-identity! ((matrix matrix)) (:result matrix :abbrev mid!)
    "Modify the components of MATRIX to form an identity matrix."
    (with-matrix (m matrix)
      (psetf m00 1.0 m01 0.0 m02 0.0 m03 0.0
             m10 0.0 m11 1.0 m12 0.0 m13 0.0
             m20 0.0 m21 0.0 m22 1.0 m23 0.0
             m30 0.0 m31 0.0 m32 0.0 m33 1.0))
    matrix)

  (defun* matrix-identity () (:result matrix :abbrev mid)
    "Create an identity matrix."
    (%matrix 1.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 1.0))

  (define-constant +identity-matrix+ (matrix-identity) :test #'equalp)
  (define-constant +mid+ (matrix-identity) :test #'equalp))

(defun* matrix-test () (:result matrix :abbrev mtest)
  "create a test matrix."
  (with-matrix (m (zero-matrix))
    (psetf m00 1.0 m01 5.0 m02 9.0 m03 13.0
           m10 2.0 m11 6.0 m12 10.0 m13 14.0
           m20 3.0 m21 7.0 m22 11.0 m23 15.0
           m30 4.0 m31 8.0 m32 12.0 m33 16.0)
    m))

(defun* matrix= ((matrix1 matrix) (matrix2 matrix)) (:result boolean :abbrev m=)
  (with-matrices ((ma matrix1) (mb matrix2))
    "Check if the components of MATRIX1 are equal to the components of MATRIX2."
    (and (= ma00 mb00) (= ma01 mb01) (= ma02 mb02) (= ma03 mb03)
         (= ma10 mb10) (= ma11 mb11) (= ma12 mb12) (= ma13 mb13)
         (= ma20 mb20) (= ma21 mb21) (= ma22 mb22) (= ma23 mb23)
         (= ma30 mb30) (= ma31 mb31) (= ma32 mb32) (= ma33 mb33))))

(defun* matrix~ ((matrix1 matrix) (matrix2 matrix)
                 &key ((tolerance single-float) +epsilon+))
    (:result boolean :abbrev m~)
  "Check if the components of MATRIX1 are approximately equal to the components
of MATRIX2, according to the epsilon TOLERANCE."
  (with-matrices ((ma matrix1) (mb matrix2))
    (and (~ ma00 mb00 tolerance)
         (~ ma01 mb01 tolerance)
         (~ ma02 mb02 tolerance)
         (~ ma03 mb03 tolerance)
         (~ ma10 mb10 tolerance)
         (~ ma11 mb11 tolerance)
         (~ ma12 mb12 tolerance)
         (~ ma13 mb13 tolerance)
         (~ ma20 mb20 tolerance)
         (~ ma21 mb21 tolerance)
         (~ ma22 mb22 tolerance)
         (~ ma23 mb23 tolerance)
         (~ ma30 mb30 tolerance)
         (~ ma31 mb31 tolerance)
         (~ ma32 mb32 tolerance)
         (~ ma33 mb33 tolerance))))

(defun* matrix-copy! ((out-matrix matrix) (matrix matrix))
    (:result matrix :abbrev mcp!)
  "Copy the components of MATRIX, storing the result in OUT-MATRIX."
  (with-matrices ((o out-matrix) (m matrix))
    (psetf o00 m00 o01 m01 o02 m02 o03 m03
           o10 m10 o11 m11 o12 m12 o13 m13
           o20 m20 o21 m21 o22 m22 o23 m23
           o30 m30 o31 m31 o32 m32 o33 m33))
  out-matrix)

(defun* matrix-copy ((matrix matrix)) (:result matrix :abbrev mcp)
  "Copy the components of MATRIX, storing the result as a new matrix."
  (matrix-copy! (zero-matrix) matrix))

(defun* matrix-clamp! ((out-matrix matrix) (matrix matrix) &key
                       ((min single-float) most-negative-single-float)
                       ((max single-float) most-positive-single-float))
    (:result matrix :abbrev mclamp!)
  "Clamp each component of MATRIX within the range of [MIN, MAX], storing the
result in OUT-MATRIX."
  (with-matrices ((o out-matrix) (m matrix))
    (psetf o00 (clamp m00 min max) o01 (clamp m01 min max)
           o02 (clamp m02 min max) o03 (clamp m03 min max)
           o10 (clamp m10 min max) o11 (clamp m11 min max)
           o12 (clamp m12 min max) o13 (clamp m13 min max)
           o20 (clamp m20 min max) o21 (clamp m21 min max)
           o22 (clamp m22 min max) o23 (clamp m23 min max)
           o30 (clamp m30 min max) o31 (clamp m31 min max)
           o32 (clamp m32 min max) o33 (clamp m33 min max)))
  out-matrix)

(defun* matrix-clamp ((matrix matrix) &key
                      ((min single-float) most-negative-single-float)
                      ((max single-float) most-positive-single-float))
    (:result matrix :abbrev mclamp)
  "Clamp each component of MATRIX within the range of [MIN, MAX], storing the
result as a new matrix."
  (matrix-clamp! (zero-matrix) matrix :min min :max max))

(defun* matrix*! ((out-matrix matrix) (matrix1 matrix) (matrix2 matrix))
    (:result matrix :abbrev m*!)
  "Matrix multiplication of MATRIX1 by MATRIX2, storing the result in
OUT-MATRIX."
  (with-matrices ((o out-matrix) (a matrix1) (b matrix2))
    (psetf o00 (+ (* a00 b00) (* a01 b10) (* a02 b20) (* a03 b30))
           o10 (+ (* a10 b00) (* a11 b10) (* a12 b20) (* a13 b30))
           o20 (+ (* a20 b00) (* a21 b10) (* a22 b20) (* a23 b30))
           o30 (+ (* a30 b00) (* a31 b10) (* a32 b20) (* a33 b30))
           o01 (+ (* a00 b01) (* a01 b11) (* a02 b21) (* a03 b31))
           o11 (+ (* a10 b01) (* a11 b11) (* a12 b21) (* a13 b31))
           o21 (+ (* a20 b01) (* a21 b11) (* a22 b21) (* a23 b31))
           o31 (+ (* a30 b01) (* a31 b11) (* a32 b21) (* a33 b31))
           o02 (+ (* a00 b02) (* a01 b12) (* a02 b22) (* a03 b32))
           o12 (+ (* a10 b02) (* a11 b12) (* a12 b22) (* a13 b32))
           o22 (+ (* a20 b02) (* a21 b12) (* a22 b22) (* a23 b32))
           o32 (+ (* a30 b02) (* a31 b12) (* a32 b22) (* a33 b32))
           o03 (+ (* a00 b03) (* a01 b13) (* a02 b23) (* a03 b33))
           o13 (+ (* a10 b03) (* a11 b13) (* a12 b23) (* a13 b33))
           o23 (+ (* a20 b03) (* a21 b13) (* a22 b23) (* a23 b33))
           o33 (+ (* a30 b03) (* a31 b13) (* a32 b23) (* a33 b33))))
  out-matrix)

(defun* matrix* ((matrix1 matrix) (matrix2 matrix)) (:result matrix :abbrev m*)
  "Matrix multiplication of MATRIX1 by MATRIX2, storing the result as a new
matrix."
  (matrix*! (zero-matrix) matrix1 matrix2))

(defun* matrix-translation-to-vec! ((out-vec vec) (matrix matrix))
    (:result vec :abbrev mtr->v!)
  "Copy the components in the translation column of MATRIX, storing the result
in OUT-VEC."
  (with-vector (o out-vec)
    (with-matrix (m matrix)
      (psetf ox m03 oy m13 oz m23)))
  out-vec)

(defun* matrix-translation-to-vec ((matrix matrix)) (:result vec :abbrev mtr->v)
  "Copy the components in the translation column of MATRIX, storing the result
as a new vector."
  (matrix-translation-to-vec! (vec) matrix))

(defun* matrix-translation-from-vec! ((matrix matrix) (vec vec))
    (:result matrix :abbrev v->mtr!)
  "Copy the components of VEC, storing the result in the translation column of
MATRIX."
  (with-matrix (m matrix)
    (with-vector (v vec)
      (psetf m03 vx m13 vy m23 vz)))
  matrix)

(defun* matrix-translation-from-vec ((matrix matrix) (vec vec))
    (:result matrix :abbrev v->mtr)
  "Copy the components of VEC, storing the result in the translation column of a
new matrix."
  (matrix-translation-from-vec! (matrix-copy matrix) vec))

(defun* matrix-translate! ((out-matrix matrix) (matrix matrix) (vec vec))
    (:result matrix :abbrev mtr!)
  "Translate a matrix by the translation vector VEC, storing the result in
OUT-MATRIX."
  (matrix*! out-matrix (matrix-translation-from-vec (matrix-identity) vec)
            matrix))

(defun* matrix-translate ((matrix matrix) (vec vec)) (:result matrix :abbrev mtr)
  "Translate a matrix by the translation vector VEC, storing the result as a new
matrix."
  (matrix-translate! (matrix-identity) matrix vec))

(defun* matrix-copy-rotation! ((out-matrix matrix) (matrix matrix))
    (:result matrix :abbrev mcprot!)
  "Copy the 3x3 rotation components of MATRIX, storing the result in OUT-MATRIX."
  (with-matrices ((o out-matrix) (m matrix))
    (psetf o00 m00 o01 m01 o02 m02
           o10 m10 o11 m11 o12 m12
           o20 m20 o21 m21 o22 m22))
  out-matrix)

(defun* matrix-copy-rotation ((matrix matrix)) (:result matrix :abbrev mcprot)
  "Copy the 3x3 rotation components of MATRIX, storing the result as a new
matrix."
  (matrix-copy-rotation! (matrix-identity) matrix))

(defun* matrix-rotation-to-vec! ((out-vec vec) (matrix matrix) (axis keyword))
    (:result vec :abbrev mrot->v!)
  "Get a particular rotation AXIS from MATRIX, storing the result in OUT-VEC."
  (with-vector (v out-vec)
    (with-matrix (m matrix)
      (ecase axis
        (:x (psetf vx m00 vy m10 vz m20))
        (:y (psetf vx m01 vy m11 vz m21))
        (:z (psetf vx m02 vy m12 vz m22)))))
  out-vec)

(defun* matrix-rotation-to-vec ((matrix matrix) (axis keyword))
    (:result vec :abbrev mrot->v)
  "Get a particular rotation AXIS from MATRIX, storing the result as a new
vector."
  (matrix-rotation-to-vec! (vec) matrix axis))

(defun* matrix-rotation-from-vec! ((matrix matrix) (vec vec) (axis keyword))
    (:result matrix :abbrev v->mrot!)
  "Set a particular rotation AXIS of MATRIX, storing the result in MATRIX."
  (with-matrix (m matrix)
    (with-vector (v vec)
      (ecase axis
        (:x (psetf m00 vx m10 vy m20 vz))
        (:y (psetf m01 vx m11 vy m21 vz))
        (:z (psetf m02 vx m12 vy m22 vz)))))
  matrix)

(defun* matrix-rotation-from-vec ((matrix matrix) (vec vec) (axis keyword))
    (:result matrix :abbrev v->mrot)
  "Set a particular rotation AXIS of MATRIX, storing the result as a new matrix."
  (matrix-rotation-from-vec! (matrix-copy matrix) vec axis))

(defun* matrix-rotate! ((out-matrix matrix) (matrix matrix) (vec vec))
    (:result matrix :abbrev mrot!)
  "Rotate a matrix in each of 3 dimensions as specified by the vector of radians
VEC, storing the result in OUT-MATRIX."
  (macrolet ((rotate-angle (angle s c &body body)
               `(when (> (abs ,angle) +epsilon+)
                  (let ((,s (sin ,angle))
                        (,c (cos ,angle)))
                    ,@body
                    (matrix*! out-matrix out-matrix m)))))
    (with-matrix (m (matrix-identity))
      (with-vector (v vec)
        (matrix-copy! out-matrix matrix)
        (rotate-angle vz s c
                      (psetf m00 c m01 (- s)
                             m10 s m11 c))
        (rotate-angle vx s c
                      (psetf m00 1.0 m01 0.0 m02 0.0
                             m10 0.0 m11 c m12 (- s)
                             m20 0.0 m21 s m22 c))
        (rotate-angle vy s c
                      (psetf m00 c m01 0.0 m02 s
                             m10 0.0 m11 1.0 m12 0.0
                             m20 (- s) m21 0.0 m22 c)))))
  out-matrix)

(defun* matrix-rotate ((matrix matrix) (vec vec)) (:result matrix :abbrev mrot)
  "Rotate a matrix in each of 3 dimensions as specified by the vector of radians
VEC, storing the result as a new matrix."
  (matrix-rotate! (matrix-identity) matrix vec))

(defun* matrix-scale-to-vec! ((out-vec vec) (matrix matrix))
    (:result vec :abbrev mscale->v!)
  "Copy the components in the scaling part of MATRIX, storing the result in
OUT-VEC."
  (with-vector (o out-vec)
    (with-matrix (m matrix)
      (psetf ox m00 oy m11 oz m22)))
  out-vec)

(defun* matrix-scale-to-vec ((matrix matrix)) (:result vec :abbrev mscale->v)
  "Copy the components in the scaling part of MATRIX, storing the result as a new
vector."
  (matrix-scale-to-vec! (vec) matrix))

(defun* matrix-scale-from-vec! ((matrix matrix) (vec vec))
    (:result matrix :abbrev v->mscale!)
  "Copy the components of VEC, storing the result in the diagonal scaling part of
MATRIX."
  (with-matrix (m matrix)
    (with-vector (v vec)
      (psetf m00 vx m11 vy m22 vz)))
  matrix)

(defun* matrix-scale-from-vec ((matrix matrix) (vec vec))
    (:result matrix :abbrev v->mscale)
  "Copy the components of VEC, storing the result in the diagonal scaling part of
a new matrix."
  (matrix-scale-from-vec! (matrix-copy matrix) vec))

(defun* matrix-scale! ((out-matrix matrix) (matrix matrix) (vec vec))
    (:result matrix :abbrev mscale!)
  "Scale a matrix by the scaling vector VEC, storing the result in OUT-MATRIX."
  (matrix*! out-matrix (matrix-scale-from-vec (matrix-identity) vec) matrix))

(defun* matrix-scale ((matrix matrix) (vec vec)) (:result matrix :abbrev mscale)
  "Scale a matrix by the scaling vector VEC, storing the result as a new matrix."
  (matrix-scale! (matrix-identity) matrix vec))

(defun* matrix*vec! ((out-vec vec) (matrix matrix) (vec vec))
    (:result vec :abbrev m*v!)
  "Multiplication of MATRIX and VEC, storing the result in OUT-VEC."
  (with-vectors ((v vec) (o out-vec))
    (with-matrix (m matrix)
      (psetf ox (+ (* m00 vx) (* m01 vy) (* m02 vz) (* m03 1.0))
             oy (+ (* m10 vx) (* m11 vy) (* m12 vz) (* m13 1.0))
             oz (+ (* m20 vx) (* m21 vy) (* m22 vz) (* m23 1.0)))))
  out-vec)

(defun* matrix*vec ((matrix matrix) (vec vec)) (:result vec :abbrev m*v)
  "Multiplication of MATRIX and VEC, storing the result as a new vector."
  (matrix*vec! (vec) matrix vec))

(defun* matrix-transpose! ((out-matrix matrix) (matrix matrix))
    (:result matrix :abbrev mtranspose!)
  "Transpose MATRIX, storing the result in OUT-MATRIX."
  (with-matrix (o (matrix-copy! out-matrix matrix))
    (rotatef o01 o10)
    (rotatef o02 o20)
    (rotatef o03 o30)
    (rotatef o12 o21)
    (rotatef o13 o31)
    (rotatef o23 o32))
  out-matrix)

(defun* matrix-transpose ((matrix matrix)) (:result matrix :abbrev mtranspose)
  "Transpose MATRIX, storing the result as a new matrix."
  (matrix-transpose! (matrix-identity) matrix))

(defun* matrix-orthogonal-p ((matrix matrix)) (:result boolean :abbrev morthop)
  "Check if MATRIX is orthogonal. An orthogonal matrix is a square matrix with
all of its rows (or columns) being perpendicular to each other, and of unit
length."
  (m~ (matrix* matrix (matrix-transpose matrix)) +identity-matrix+))

(defun* matrix-orthogonalize! ((out-matrix matrix) (matrix matrix))
    (:result matrix :abbrev mortho!)
  "Orthogonalize a matrix using the 'modified' Gram-Schmidt method (MGS), storing
the result in OUT-MATRIX."
  (let* ((x (matrix-rotation-to-vec matrix :x))
         (y (matrix-rotation-to-vec matrix :y))
         (z (matrix-rotation-to-vec matrix :z)))
    (vec-normalize! x x)
    (vec-normalize! y (vec- y (vec-scale x (vec-dot y x))))
    (vec-cross! z x y)
    (matrix-rotation-from-vec! out-matrix x :x)
    (matrix-rotation-from-vec! out-matrix y :y)
    (matrix-rotation-from-vec! out-matrix z :z))
  out-matrix)

(defun* matrix-orthogonalize ((matrix matrix)) (:result matrix :abbrev mortho)
  "Orthogonalize a matrix using the 'modified' Gram-Schmidt method (MGS), storing
the result as a new matrix."
  (matrix-orthogonalize! (matrix-identity) matrix))

(defun* matrix-trace ((matrix matrix)) (:result single-float :abbrev mtrace)
  "Compute the trace of MATRIX."
  (with-matrix (m matrix)
    (+ m00 m11 m22 m33)))

(defun* matrix-determinant ((matrix matrix)) (:result single-float :abbrev mdet)
  "Compute the determinant of MATRIX."
  (with-matrix (m matrix)
    (- (+ (* m00 m11 m22 m33) (* m00 m12 m23 m31) (* m00 m13 m21 m32)
          (* m01 m10 m23 m32) (* m01 m12 m20 m33) (* m01 m13 m22 m30)
          (* m02 m10 m21 m33) (* m02 m11 m23 m30) (* m02 m13 m20 m31)
          (* m03 m10 m22 m31) (* m03 m11 m20 m32) (* m03 m12 m21 m30))
       (* m00 m11 m23 m32) (* m00 m12 m21 m33) (* m00 m13 m22 m31)
       (* m01 m10 m22 m33) (* m01 m12 m23 m30) (* m01 m13 m20 m32)
       (* m02 m10 m23 m31) (* m02 m11 m20 m33) (* m02 m13 m21 m30)
       (* m03 m10 m21 m32) (* m03 m11 m22 m30) (* m03 m12 m20 m31))))

(defun* matrix-invert-orthogonal! ((out-matrix matrix) (matrix matrix))
    (:result matrix :abbrev minvtortho!)
  "Invert MATRIX if its 3x3 rotation is an orthogonal matrix, storing the result
in OUT-MATRIX.
Warning: This will only work on matrices that have an orthogonal 3x3 rotation
matrix.
Alias: MINVTORTHO!"
  (matrix-copy! out-matrix matrix)
  (with-matrix (o out-matrix)
    (rotatef o10 o01)
    (rotatef o20 o02)
    (rotatef o21 o12)
    (psetf o03 (+ (* o00 (- o03)) (* o01 (- o13)) (* o02 (- o23)))
           o13 (+ (* o10 (- o03)) (* o11 (- o13)) (* o12 (- o23)))
           o23 (+ (* o20 (- o03)) (* o21 (- o13)) (* o22 (- o23)))))
  out-matrix)

(defun* matrix-invert-orthogonal ((matrix matrix))
    (:result matrix :abbrev minvtortho)
  "Invert MATRIX if its 3x3 rotation is an orthogonal matrix, storing the result
as a new matrix.
Warning: This will only work on matrices that have an orthogonal 3x3 rotation ~
matrix.
Alias: MINVTORTHO"
  (matrix-invert-orthogonal! (matrix-identity) matrix))

(defun* matrix-invert! ((out-matrix matrix) (matrix matrix))
    (:result matrix :abbrev minvt!)
  "Invert MATRIX, storing the result in OUT-MATRIX.
Warning: This method is slower than MATRIX-INVERT-ORTHOGONAL, but not all
matrices can be inverted with the fast method.
Warning: A matrix with a determinant of zero cannot be inverted, and will raise
an error.
Alias: MINVT!"
  (let ((determinant (matrix-determinant matrix)))
    (when (< (abs determinant) +epsilon+)
      (error "Cannot invert a matrix with a determinant of zero."))
    (with-matrices ((o out-matrix) (m matrix))
      (psetf o00 (/ (- (+ (* m11 m22 m33) (* m12 m23 m31) (* m13 m21 m32))
                       (* m11 m23 m32) (* m12 m21 m33) (* m13 m22 m31))
                    determinant)
             o01 (/ (- (+ (* m01 m23 m32) (* m02 m21 m33) (* m03 m22 m31))
                       (* m01 m22 m33) (* m02 m23 m31) (* m03 m21 m32))
                    determinant)
             o02 (/ (- (+ (* m01 m12 m33) (* m02 m13 m31) (* m03 m11 m32))
                       (* m01 m13 m32) (* m02 m11 m33) (* m03 m12 m31))
                    determinant)
             o03 (/ (- (+ (* m01 m13 m22) (* m02 m11 m23) (* m03 m12 m21))
                       (* m01 m12 m23) (* m02 m13 m21) (* m03 m11 m22))
                    determinant)
             o10 (/ (- (+ (* m10 m23 m32) (* m12 m20 m33) (* m13 m22 m30))
                       (* m10 m22 m33) (* m12 m23 m30) (* m13 m20 m32))
                    determinant)
             o11 (/ (- (+ (* m00 m22 m33) (* m02 m23 m30) (* m03 m20 m32))
                       (* m00 m23 m32) (* m02 m20 m33) (* m03 m22 m30))
                    determinant)
             o12 (/ (- (+ (* m00 m13 m32) (* m02 m10 m33) (* m03 m12 m30))
                       (* m00 m12 m33) (* m02 m13 m30) (* m03 m10 m32))
                    determinant)
             o13 (/ (- (+ (* m00 m12 m23) (* m02 m13 m20) (* m03 m10 m22))
                       (* m00 m13 m22) (* m02 m10 m23) (* m03 m12 m20))
                    determinant)
             o20 (/ (- (+ (* m10 m21 m33) (* m11 m23 m30) (* m13 m20 m31))
                       (* m10 m23 m31) (* m11 m20 m33) (* m13 m21 m30))
                    determinant)
             o21 (/ (- (+ (* m00 m23 m31) (* m01 m20 m33) (* m03 m21 m30))
                       (* m00 m21 m33) (* m01 m23 m30) (* m03 m20 m31))
                    determinant)
             o22 (/ (- (+ (* m00 m11 m33) (* m01 m13 m30) (* m03 m10 m31))
                       (* m00 m13 m31) (* m01 m10 m33) (* m03 m11 m30))
                    determinant)
             o23 (/ (- (+ (* m00 m13 m21) (* m01 m10 m23) (* m03 m11 m20))
                       (* m00 m11 m23) (* m01 m13 m20) (* m03 m10 m21))
                    determinant)
             o30 (/ (- (+ (* m10 m22 m31) (* m11 m20 m32) (* m12 m21 m30))
                       (* m10 m21 m32) (* m11 m22 m30) (* m12 m20 m31))
                    determinant)
             o31 (/ (- (+ (* m00 m21 m32) (* m01 m22 m30) (* m02 m20 m31))
                       (* m00 m22 m31) (* m01 m20 m32) (* m02 m21 m30))
                    determinant)
             o32 (/ (- (+ (* m00 m12 m31) (* m01 m10 m32) (* m02 m11 m30))
                       (* m00 m11 m32) (* m01 m12 m30) (* m02 m10 m31))
                    determinant)
             o33 (/ (- (+ (* m00 m11 m22) (* m01 m12 m20) (* m02 m10 m21))
                       (* m00 m12 m21) (* m01 m10 m22) (* m02 m11 m20))
                    determinant))))
  out-matrix)

(defun* matrix-invert ((matrix matrix)) (:result matrix :abbrev minvt)
  "Invert MATRIX, storing the result as a new matrix.
Warning: This method is slower than MATRIX-INVERT-ORTHOGONAL, but not all
matrices can be inverted with the fast method.
Warning: A matrix with a determinant of zero cannot be inverted, and will raise
an error.
Alias: MINVT"
  (matrix-invert! (matrix-identity) matrix))

(defun* make-view-matrix! ((out-matrix matrix) (eye vec) (target vec) (up vec))
    (:result matrix :abbrev mkview!)
  "Create a view matrix, storing the result in OUT-MATRIX."
  (let ((f (vec))
        (s (vec))
        (u (vec))
        (inv-eye (vec))
        (translation (mid)))
    (with-matrix (o (matrix-identity! out-matrix))
      (with-vectors ((f (vec-normalize! f (vec-! f target eye)))
                     (s (vec-normalize! s (vec-cross! s f up)))
                     (u (vec-cross! u s f)))
        (psetf o00 sx o10 ux o20 (- fx)
               o01 sy o11 uy o12 (- fy)
               o02 sz o12 uz o22 (- fz))
        (matrix-translation-from-vec! translation (vec-negate! inv-eye eye))
        (matrix*! out-matrix translation out-matrix))))
  out-matrix)

(defun* make-view-matrix ((eye vec) (target vec) (up vec))
    (:result matrix :abbrev mkview)
  "Create a view matrix, storing the result as a new matrix."
  (make-view-matrix! (matrix-identity) eye target up))

(defun* make-orthographic-matrix! ((out-matrix matrix) (left real) (right real)
                                   (bottom real) (top real) (near real)
                                   (far real))
    (:result matrix :abbrev mkortho!)
  "Create an orthographic projection matrix, storing the result in OUT-MATRIX."
  (let ((right-left (float (- right left) 1.0))
        (top-bottom (float (- top bottom) 1.0))
        (far-near (float (- far near) 1.0)))
    (with-matrix (m (matrix-identity! out-matrix))
      (psetf m00 (/ 2.0 right-left)
             m03 (- (/ (+ right left) right-left))
             m11 (/ 2.0 top-bottom)
             m13 (- (/ (+ top bottom) top-bottom))
             m22 (/ -2.0 far-near)
             m23 (- (/ (+ far near) far-near))))
    out-matrix))

(defun* make-orthographic-matrix ((left real) (right real) (bottom real)
                                  (top real) (near real) (far real))
    (:result matrix :abbrev mkortho)
  "Create an orthographic projection matrix, storing the result as a new matrix."
  (make-orthographic-matrix! (matrix-identity) left right bottom top near far))

(defun* make-perspective-matrix! ((out-matrix matrix) (fov real) (aspect real)
                                  (near real) (far real))
    (:result matrix :abbrev mkpersp!)
  "Create a perspective projection matrix, storing the result in OUT-MATRIX."
  (let ((f (float (/ (tan (/ fov 2))) 1.0))
        (z (float (- near far) 1.0)))
    (with-matrix (m (matrix-identity! out-matrix))
      (psetf m00 (/ f aspect)
             m11 f
             m22 (/ (+ near far) z)
             m23 (/ (* 2 near far) z)
             m32 -1.0)))
  out-matrix)

(defun* make-perspective-matrix ((fov real) (aspect real) (near real) (far real))
    (:result matrix :abbrev mkpersp)
  "Create a perspective projection matrix, storing the result as a new matrix."
  (make-perspective-matrix! (matrix-identity) fov aspect near far))
