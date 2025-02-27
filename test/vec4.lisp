(in-package #:origin.test)

(define-test v4/accessors
  (let ((v (v4:make 1 2 3 4)))
    (is = (v4:x v) 1)
    (is = (v4:y v) 2)
    (is = (v4:z v) 3)
    (is = (v4:w v) 4)
    (psetf (v4:x v) 10.0
           (v4:y v) 20.0
           (v4:z v) 30.0
           (v4:w v) 40.0)
    (is = (v4:x v) 10)
    (is = (v4:y v) 20)
    (is = (v4:z v) 30)
    (is = (v4:w v) 40)))

(define-test v4/copy
  (let ((v (v4:make 1 2 3 4))
        (o (v4:zero)))
    (is v4:= (v4:copy! o v) v)
    (is v4:= o v)
    (is v4:= (v4:copy v) v)
    (isnt eq v (v4:copy v))))

(define-test v4/sign
  (let ((o (v4:zero)))
    (is v4:= (v4:sign (v4:zero)) (v4:zero))
    (is v4:= (v4:sign (v4:make 10 10 10 10)) (v4:make 1 1 1 1))
    (is v4:= (v4:sign (v4:make -10 -10 -10 -10)) (v4:make -1 -1 -1 -1))
    (v4:sign! o (v4:zero))
    (is v4:= o (v4:zero))
    (v4:sign! o (v4:make 10 10 10 10))
    (is v4:= o (v4:make 1 1 1 1))
    (v4:sign! o (v4:make -10 -10 -10 -10))
    (is v4:= o (v4:make -1 -1 -1 -1))))

(define-test v4/fract
  (let ((o (v4:zero))
        (v (v4:make 10.42 -10.42 0 0))
        (r (v4:make 0.42 0.58 0 0)))
    (is v4:= (v4:fract (v4:zero)) (v4:zero))
    (is v4:~ (v4:fract v) r)
    (v4:fract! o (v4:zero))
    (is v4:= o (v4:zero))
    (v4:fract! o v)
    (is v4:~ o r)))

(define-test v4/clamp
  (let ((v (v4:make -1.5185602 0.3374052 1.5218115 1.8188539))
        (r (v4:make -1 0.3374052 1 1))
        (o (v4:zero)))
    (is v4:= (v4:clamp! o v :min -1.0 :max 1.0) r)
    (is v4:= o r)
    (is v4:= (v4:clamp v :min -1.0 :max 1.0) r)
    (is v4:= (v4:clamp v) v)))

(define-test v4/zero
  (let ((v (v4:make -0.72470546 0.57963276 0.8775625 0.44206798)))
    (is v4:= (v4:zero! v) v4:+zero+)
    (is v4:= v v4:+zero+)
    (is v4:= (v4:zero) v4:+zero+)))

(define-test v4/one
  (let ((v (v4:make -81 92 46 11))
        (r (v4:make 1 1 1 1)))
    (is v4:= (v4:one! v) r)
    (is v4:= v r)
    (is v4:= (v4:one) r)))

(define-test v4/equality
  (let ((v1 (v4:make 0.8598654 -0.4803753 -0.3822465 0.2647184))
        (v2 (v4:make 1e-8 1e-8 1e-8 1e-8)))
    (true (v4:= v1 v1))
    (true (v4:~ (v4:+ v1 v2) v1))
    (true (v4:~ v2 v4:+zero+))))

(define-test v4/add
  (let ((v1 (v4:make 0.4110496 -0.87680984 -0.62870455 0.6163341))
        (v2 (v4:make 0.1166687 0.42538047 0.7360425 0.19508076))
        (r (v4:make 0.5277183 -0.45142937 0.10733795 0.81141484))
        (o (v4:zero)))
    (is v4:= (v4:+! o v1 v2) r)
    (is v4:= o r)
    (is v4:= (v4:+ v1 v2) r)
    (is v4:= (v4:+ v1 v4:+zero+) v1)
    (is v4:= (v4:+ v4:+zero+ v2) v2)))

(define-test v4/subtract
  (let ((v1 (v4:make -0.16772795 -0.7287135 -0.8905144 0.55699535))
        (v2 (v4:make -0.69658303 0.6168339 -0.7841997 0.094441175))
        (r (v4:make 0.5288551 -1.3455474 -0.10631466 0.46255416))
        (o (v4:zero)))
    (is v4:= (v4:-! o v1 v2) r)
    (is v4:= o r)
    (is v4:= (v4:- v1 v2) r)
    (is v4:= (v4:- v1 v4:+zero+) v1)))

(define-test v4/hadamard-product
  (let ((v1 (v4:make -0.6219859 -0.80110574 -0.06880522 0.37676394))
        (v2 (v4:make 0.6687746 -0.21906853 0.14335585 0.093762994))
        (r (v4:make -0.4159684 0.17549706 -0.00986363 0.035326514))
        (o (v4:zero)))
    (is v4:= (v4:*! o v1 v2) r)
    (is v4:= o r)
    (is v4:= (v4:* v1 v2) r)
    (is v4:= (v4:* v1 v4:+zero+) v4:+zero+)
    (is v4:= (v4:* v4:+zero+ v2) v4:+zero+)))

(define-test v4/hadamard-quotient
  (let ((v1 (v4:make 0.9498384 0.4066379 -0.72961855 0.9857626))
        (v2 (v4:make 0.32331443 0.17439032 -0.65894365 0.91501355))
        (r (v4:make 2.9378164 2.3317688 1.1072549 1.0773202))
        (o (v4:zero)))
    (is v4:= (v4:/! o v1 v2) r)
    (is v4:= o r)
    (is v4:= (v4:/ v1 v2) r)
    (is v4:= (v4:/ v1 v4:+zero+) v4:+zero+)
    (is v4:= (v4:/ v4:+zero+ v2) v4:+zero+)))

(define-test v4/scalar-product
  (let ((v (v4:make 0.82007027 -0.53582144 0.11559081 0.31522608))
        (r (v4:make 0.7762602 -0.5071966 0.10941568 0.29838598))
        (o (v4:zero)))
    (is v4:= (v4:scale! o v 0.94657767) r)
    (is v4:= o r)
    (is v4:= (v4:scale v 0.94657767) r)))

(define-test v4/dot-product
  (is = (v4:dot (v4:make -0.21361923 0.39387107 0.0043354034 0.8267517)
                (v4:make -0.13104868 0.399935 0.62945867 0.44206798))
      0.55372673)
  (is = (v4:dot (v4:make 1 0 0 0) (v4:make 0 1 0 0)) 0)
  (is = (v4:dot (v4:make 1 0 0 0) (v4:make 0 0 1 0)) 0)
  (is = (v4:dot (v4:make 0 1 0 0) (v4:make 0 0 1 0)) 0)
  (is = (v4:dot (v4:make 1 0 0 0) (v4:make 1 0 0 0)) 1)
  (is = (v4:dot (v4:make 1 0 0 0) (v4:make -1 0 0 0)) -1))

(define-test v4/length
  (is = (v4:length v4:+zero+) 0)
  (is = (v4:length (v4:make 1 0 0 0)) 1)
  (is = (v4:length (v4:make 0.32979298 0.2571392 0.19932675 0.2647184))
      0.5335644))

(define-test v4/normalize
  (let ((v (v4:make -0.6589291 0.23270178 -0.1047523 0.6163341))
        (r (v4:make -0.70274895 0.24817683 -0.1117185 0.6573213))
        (o (v4:zero)))
    (is v4:= (v4:normalize! o v) r)
    (is v4:= o r)
    (is v4:= (v4:normalize v) r)
    (is v4:= (v4:normalize (v4:make 2 0 0 0)) (v4:make 1 0 0 0))
    (is v4:= (v4:normalize (v4:make 0 2 0 0)) (v4:make 0 1 0 0))
    (is v4:= (v4:normalize (v4:make 0 0 2 0)) (v4:make 0 0 1 0))))

(define-test v4/round
  (let ((v (v4:make -0.70498157 0.3615427 0.50702953 0.19508076))
        (r (v4:make -1 0 1 0))
        (o (v4:zero)))
    (is v4:= (v4:round! o v) r)
    (is v4:= o r)
    (is v4:= (v4:round v) r)))

(define-test v4/abs
  (let ((v (v4:make -0.4241562 -0.52400947 0.82413125 -0.094441175))
        (r (v4:make 0.4241562 0.52400947 0.82413125 0.094441175))
        (o (v4:zero)))
    (is v4:= (v4:abs! o v) r)
    (is v4:= o r)
    (is v4:= (v4:abs v) r)))

(define-test v4/negate
  (let ((v (v4:make 0.7823446 0.95027566 -0.4147482 0.55699635))
        (r (v4:make -0.7823446 -0.95027566 0.4147482 -0.55699635))
        (o (v4:zero)))
    (is v4:= (v4:negate! o v) r)
    (is v4:= o r)
    (is v4:= (v4:negate v) r)))

(define-test v4/zero-predicate
  (true (v4:zero-p v4:+zero+))
  (true (v4:zero-p (v4:make 0 0 0 0))))

(define-test v4/lerp
  (let ((v1 (v4:make 0.74485755 0.092342734 0.2982279 0.093762994))
        (v2 (v4:make 0.19426346 0.9881369 0.64691556 0.9857626))
        (r (v4:make 0.4695605 0.5402398 0.47257173 0.5397628))
        (o (v4:zero)))
    (is v4:= (v4:lerp! o v1 v2 0.5) r)
    (is v4:= o r)
    (is v4:= (v4:lerp v1 v2 0.5) r)
    (is v4:= (v4:lerp v1 v2 0.0) v1)
    (is v4:= (v4:lerp v1 v2 1.0) v2)))

(define-test v4/compare
  (let ((v1 (v4:make 0.34003425 -0.4920528 0.8754709 0.91501355))
        (v2 (v4:make 0.6535034 -0.11586404 -0.47056317 0.91292254))
        (v3 (v4:make 0.9715252 0.8300271 0.9858451 0.929777))
        (v4 (v4:make 1 2 3 4))
        (v5 (v4:make 2 3 4 5)))
    (true (v4:< v2 v3))
    (true (v4:<= v4 v4))
    (true (v4:<= v4 v5))
    (true (v4:> v3 v1))
    (true (v4:>= v4 v4))
    (true (v4:>= v5 v4))))

(define-test v4/min
  (let* ((v1 (v4:make 0.98117805 0.06889212 0.32721102 0.93538976))
         (v2 (v4:make 0.8774886 0.25179327 0.76311684 0.31522608))
         (r (v4:make (v4:x v2) (v4:y v1) (v4:z v1) (v4:w v2)))
         (o (v4:zero)))
    (is v4:= (v4:min! o v1 v2) r)
    (is v4:= o r)
    (is v4:= (v4:min v1 v2) r)))

(define-test v4/max
  (let* ((v1 (v4:make 0.64380646 0.38965714 0.2503655 0.45167792))
         (v2 (v4:make 0.6341989 0.5274999 0.90044403 0.9411855))
         (r (v4:make (v4:x v1) (v4:y v2) (v4:z v2) (v4:w v2)))
         (o (v4:zero)))
    (is v4:= (v4:max! o v1 v2) r)
    (is v4:= o r)
    (is v4:= (v4:max v1 v2) r)))
