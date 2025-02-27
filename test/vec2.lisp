(in-package #:origin.test)

(define-test v2/accessors
  (let ((v (v2:make 1 2)))
    (is = (v2:x v) 1)
    (is = (v2:y v) 2)
    (psetf (v2:x v) 10.0
           (v2:y v) 20.0)
    (is = (v2:x v) 10)
    (is = (v2:y v) 20)))

(define-test v2/copy
  (let ((v (v2:make 1 2))
        (o (v2:zero)))
    (is v2:= (v2:copy! o v) v)
    (is v2:= o v)
    (is v2:= (v2:copy v) v)
    (isnt eq v (v2:copy v))))

(define-test v2/sign
  (let ((o (v2:zero)))
    (is v2:= (v2:sign (v2:zero)) (v2:zero))
    (is v2:= (v2:sign (v2:make 10 10)) (v2:make 1 1))
    (is v2:= (v2:sign (v2:make -10 -10)) (v2:make -1 -1))
    (v2:sign! o (v2:zero))
    (is v2:= o (v2:zero))
    (v2:sign! o (v2:make 10 10))
    (is v2:= o (v2:make 1 1))
    (v2:sign! o (v2:make -10 -10))
    (is v2:= o (v2:make -1 -1))))

(define-test v2/fract
  (let ((o (v2:zero))
        (v (v2:make 10.42 -10.42))
        (r (v2:make 0.42 0.58)))
    (is v2:= (v2:fract (v2:zero)) (v2:zero))
    (is v2:~ (v2:fract v) r)
    (v2:fract! o (v2:zero))
    (is v2:= o (v2:zero))
    (v2:fract! o v)
    (is v2:~ o r)))

(define-test v2/clamp
  (let ((v (v2:make -1.5185602 0.3374052))
        (r (v2:make -1 0.3374052))
        (o (v2:zero)))
    (is v2:= (v2:clamp! o v :min -1.0 :max 1.0) r)
    (is v2:= o r)
    (is v2:= (v2:clamp v :min -1.0 :max 1.0) r)
    (is v2:= (v2:clamp v) v)))

(define-test v2/zero
  (let ((v (v2:make -0.72470546 0.57963276)))
    (is v2:= (v2:zero! v) v2:+zero+)
    (is v2:= v v2:+zero+)
    (is v2:= (v2:zero) v2:+zero+)))

(define-test v2/one
  (let ((v (v2:make -81 92))
        (r (v2:make 1 1)))
    (is v2:= (v2:one! v) r)
    (is v2:= v r)
    (is v2:= (v2:one) r)))

(define-test v2/equality
  (let ((v1 (v2:make 0.8598654 -0.4803753))
        (v2 (v2:make 1e-8 1e-8)))
    (true (v2:= v1 v1))
    (true (v2:~ (v2:+ v1 v2) v1))
    (true (v2:~ v2 v2:+zero+))))

(define-test v2/add
  (let ((v1 (v2:make 0.4110496 -0.87680984))
        (v2 (v2:make 0.1166687 0.42538047))
        (r (v2:make 0.5277183 -0.45142937))
        (o (v2:zero)))
    (is v2:= (v2:+! o v1 v2) r)
    (is v2:= o r)
    (is v2:= (v2:+ v1 v2) r)
    (is v2:= (v2:+ v1 v2:+zero+) v1)
    (is v2:= (v2:+ v2:+zero+ v2) v2)))

(define-test v2/subtract
  (let ((v1 (v2:make -0.16772795 -0.7287135))
        (v2 (v2:make -0.69658303 0.6168339))
        (r (v2:make 0.5288551 -1.3455474))
        (o (v2:zero)))
    (is v2:= (v2:-! o v1 v2) r)
    (is v2:= o r)
    (is v2:= (v2:- v1 v2) r)
    (is v2:= (v2:- v1 v2:+zero+) v1)))

(define-test v2/hadamard-product
  (let ((v1 (v2:make -0.6219859 -0.80110574))
        (v2 (v2:make 0.6687746 -0.21906853))
        (r (v2:make -0.4159684 0.17549706))
        (o (v2:zero)))
    (is v2:= (v2:*! o v1 v2) r)
    (is v2:= o r)
    (is v2:= (v2:* v1 v2) r)
    (is v2:= (v2:* v1 v2:+zero+) v2:+zero+)
    (is v2:= (v2:* v2:+zero+ v2) v2:+zero+)))

(define-test v2/hadamard-quotient
  (let ((v1 (v2:make 0.9498384 0.4066379))
        (v2 (v2:make 0.32331443 0.17439032))
        (r (v2:make 2.9378164 2.3317688))
        (o (v2:zero)))
    (is v2:= (v2:/! o v1 v2) r)
    (is v2:= o r)
    (is v2:= (v2:/ v1 v2) r)
    (is v2:= (v2:/ v1 v2:+zero+) v2:+zero+)
    (is v2:= (v2:/ v2:+zero+ v2) v2:+zero+)))

(define-test v2/scalar-product
  (let ((v (v2:make 0.82007027 -0.53582144))
        (r (v2:make 0.7762602 -0.5071966))
        (o (v2:zero)))
    (is v2:= (v2:scale! o v 0.94657767) r)
    (is v2:= o r)
    (is v2:= (v2:scale v 0.94657767) r)))

(define-test v2/dot-product
  (is = (v2:dot (v2:make -0.21361923 0.39387107)
                (v2:make -0.13104868 0.399935))
      0.18551734)
  (is = (v2:dot (v2:make 1 0) (v2:make 0 1)) 0)
  (is = (v2:dot (v2:make 1 0) (v2:make 1 0)) 1)
  (is = (v2:dot (v2:make 1 0) (v2:make -1 0)) -1))

(define-test v2/length
  (is = (v2:length v2:+zero+) 0)
  (is = (v2:length (v2:make 1 0)) 1)
  (is = (v2:length (v2:make 0.32979298 0.2571392)) 0.4181913))

(define-test v2/normalize
  (let ((v (v2:make -0.6589291 0.23270178))
        (r (v2:make -0.942928 0.3329964))
        (o (v2:zero)))
    (is v2:= (v2:normalize! o v) r)
    (is v2:= o r)
    (is v2:= (v2:normalize v) r)
    (is v2:= (v2:normalize (v2:make 2 0)) (v2:make 1 0))
    (is v2:= (v2:normalize (v2:make 0 2)) (v2:make 0 1))
    (is v2:= (v2:normalize (v2:make 0 0)) (v2:make 0 0))))

(define-test v2/round
  (let ((v (v2:make -0.70498157 0.3615427))
        (r (v2:make -1 0))
        (o (v2:zero)))
    (is v2:= (v2:round! o v) r)
    (is v2:= o r)
    (is v2:= (v2:round v) r)))

(define-test v2/abs
  (let ((v (v2:make -0.4241562 -0.52400947))
        (r (v2:make 0.4241562 0.52400947))
        (o (v2:zero)))
    (is v2:= (v2:abs! o v) r)
    (is v2:= o r)
    (is v2:= (v2:abs v) r)))

(define-test v2/negate
  (let ((v (v2:make 0.7823446 0.95027566))
        (r (v2:make -0.7823446 -0.95027566))
        (o (v2:zero)))
    (is v2:= (v2:negate! o v) r)
    (is v2:= o r)
    (is v2:= (v2:negate v) r)))

(define-test v2/angle
  (let ((angle (v2:angle (v2:make 0 1) (v2:make 1 0))))
    (true (<= (abs (- angle (/ pi 2))) 1e-7)))
  (let ((angle (v2:angle (v2:make 1 0) (v2:make 1 1))))
    (true (<= (abs (- angle (/ pi 4))) 1e-7))))

(define-test v2/zero-predicate
  (true (v2:zero-p v2:+zero+))
  (true (v2:zero-p (v2:make 0 0))))

(define-test v2/direction-equality
  (true (v2:direction= (v2:make 0.0073252916 0) (v2:make 0.31148136 0)))
  (true (v2:direction= (v2:make 0 0.6982585) (v2:make 0 0.72258794))))

(define-test v2/lerp
  (let ((v1 (v2:make 0.74485755 0.092342734))
        (v2 (v2:make 0.19426346 0.9881369))
        (r (v2:make 0.4695605 0.5402398))
        (o (v2:zero)))
    (is v2:= (v2:lerp! o v1 v2 0.5) r)
    (is v2:= o r)
    (is v2:= (v2:lerp v1 v2 0.5) r)
    (is v2:= (v2:lerp v1 v2 0.0) v1)
    (is v2:= (v2:lerp v1 v2 1.0) v2)))

(define-test v2/compare
  (let ((v1 (v2:make 0.34003425 -0.4920528))
        (v2 (v2:make 0.6535034 -0.11586404))
        (v3 (v2:make 0.9715252 0.8300271))
        (v4 (v2:make 1 2))
        (v5 (v2:make 3 4)))
    (true (v2:< v2 v3))
    (true (v2:<= v4 v4))
    (true (v2:<= v4 v5))
    (true (v2:> v3 v1))
    (true (v2:>= v4 v4))
    (true (v2:>= v5 v4))))

(define-test v2/min
  (let* ((v1 (v2:make 0.98117805 0.06889212))
         (v2 (v2:make 0.8774886 0.25179327))
         (r (v2:make (v2:x v2) (v2:y v1)))
         (o (v2:zero)))
    (is v2:= (v2:min! o v1 v2) r)
    (is v2:= o r)
    (is v2:= (v2:min v1 v2) r)))

(define-test v2/max
  (let* ((v1 (v2:make 0.64380646 0.38965714))
         (v2 (v2:make 0.6341989 0.5274999))
         (r (v2:make (v2:x v1) (v2:y v2)))
         (o (v2:zero)))
    (is v2:= (v2:max! o v1 v2) r)
    (is v2:= o r)
    (is v2:= (v2:max v1 v2) r)))
