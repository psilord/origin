(in-package :gamebox-math.test)

(setf *default-test-function* #'equalp)

(plan 139)

(diag "structure")
(is-type +0vec+ '(simple-array single-float (3)))
(is-type (vec) '(simple-array single-float (3)))
(is-type (vec 1) '(simple-array single-float (3)))
(is-type (vec 1 2) '(simple-array single-float (3)))
(is-type (vec 1 2 3) '(simple-array single-float (3)))

(diag "accessors")
(is (vref (vec) 0) 0)
(is (vref (vec) 1) 0)
(is (vref (vec) 2) 0)
(is (vref (vec 1) 0) 1)
(is (vref (vec 1) 1) 0)
(is (vref (vec 1) 2) 0)
(is (vref (vec 1 2) 0) 1)
(is (vref (vec 1 2) 1) 2)
(is (vref (vec 1 2) 2) 0)
(is (vref (vec 1 2 3) 0) 1)
(is (vref (vec 1 2 3) 1) 2)
(is (vref (vec 1 2 3) 2) 3)
(let ((v (vec)))
  (psetf (vref v 0) 10.0 (vref v 1) 20.0 (vref v 2) 30.0)
  (is (vref v 0) 10)
  (is (vref v 1) 20)
  (is (vref v 2) 30))
(with-vector (v (vec 1 2 3))
  (is vx 1)
  (is vy 2)
  (is vz 3)
  (psetf vx 10.0 vy 20.0 vz 30.0)
  (is vx 10)
  (is vy 20)
  (is vz 30))
(with-vectors ((v1 (vec 1 2 3)) (v2 (vec 4 5 6)))
  (is v1x 1)
  (is v1y 2)
  (is v1z 3)
  (is v2x 4)
  (is v2y 5)
  (is v2z 6)
  (psetf v1x 10.0 v1y 20.0 v1z 30.0 v2x 40.0 v2y 50.0 v2z 60.0)
  (is v1x 10)
  (is v1y 20)
  (is v1z 30)
  (is v2x 40)
  (is v2y 50)
  (is v2z 60))

(diag "copy")
(with-vectors ((v (vec 1 2 3)) (o (vec)))
  (is (vcp! o v) v)
  (is o v)
  (is (vcp v) v)
  (isnt v (vcp v) :test #'eq))

(diag "clamp")
(with-vectors ((v (vec -1.5185602 0.3374052 1.5218115))
               (r (vec -1 0.3374052 1))
               (o (vec)))
  (is (vclamp! o v :min -1.0 :max 1.0) r)
  (is o r)
  (is (vclamp v :min -1.0 :max 1.0) r)
  (is (vclamp v) v))

(diag "stabilize")
(with-vectors ((v (vec 1e-8 1e-8 1e-8))
               (o (vec)))
  (is (vstab! o v) +0vec+)
  (is o +0vec+)
  (is (vstab v) +0vec+))

(diag "zero")
(with-vector (v (vec -0.72470546 0.57963276 0.8775625))
  (is (vzero! v) +0vec+)
  (is v +0vec+)
  (is (vec-zero) +0vec+))

(diag "list conversion")
(is (v->list (vec 1 2 3)) '(1 2 3))
(is (list->v '(1 2 3)) (vec 1 2 3))

(diag "equality")
(with-vectors ((v1 (vec 0.8598654 -0.4803753 -0.3822465))
               (v2 (vec 1e-8 1e-8 1e-8)))
  (ok (v= v1 v1))
  (ok (v~ (v+ v1 v2) v1))
  (ok (v~ v2 +0vec+)))

(diag "addition")
(with-vectors ((v1 (vec 0.4110496 -0.87680984 -0.62870455))
               (v2 (vec 0.1166687 0.42538047 0.7360425))
               (r (vec 0.5277183 -0.45142937 0.10733795))
               (o (vec)))
  (is (v+! o v1 v2) r)
  (is o r)
  (is (v+ v1 v2) r)
  (is (v+ v1 +0vec+) v1)
  (is (v+ +0vec+ v2) v2))

(diag "subtraction")
(with-vectors ((v1 (vec -0.16772795 -0.7287135 -0.8905144))
               (v2 (vec -0.69658303 0.6168339 -0.7841997))
               (r (vec 0.5288551 -1.3455474 -0.10631466))
               (o (vec)))
  (is (v-! o v1 v2) r)
  (is o r)
  (is (v- v1 v2) r)
  (is (v- v1 +0vec+) v1))

(diag "hadamard product")
(with-vectors ((v1 (vec -0.6219859 -0.80110574 -0.06880522))
               (v2 (vec 0.6687746 -0.21906853 0.14335585))
               (r (vec -0.4159684 0.17549706 -0.00986363))
               (o (vec)))
  (is (vhad*! o v1 v2) r)
  (is o r)
  (is (vhad* v1 v2) r)
  (is (vhad* v1 +0vec+) +0vec+)
  (is (vhad* +0vec+ v2) +0vec+))

(diag "hadamard quotient")
(with-vectors ((v1 (vec 0.9498384 0.4066379 -0.72961855))
               (v2 (vec 0.32331443 0.17439032 -0.65894365))
               (r (vec 2.9378164 2.3317688 1.1072549))
               (o (vec)))
  (is (vhad/! o v1 v2) r)
  (is o r)
  (is (vhad/ v1 v2) r)
  (is (vhad/ v1 +0vec+) +0vec+)
  (is (vhad/ +0vec+ v2) +0vec+))

(diag "scalar product")
(with-vectors ((v (vec 0.82007027 -0.53582144 0.11559081))
               (r (vec 0.7762602 -0.5071966 0.10941568))
               (o (vec)))
  (is (vscale! o v 0.94657767) r)
  (is o r)
  (is (vscale v 0.94657767) r))

(diag "dot product")
(is (vdot (vec -0.21361923 0.39387107 0.0043354034) (vec -0.13104868 0.399935 0.62945867)) 0.1882463)
(is (vdot (vec 1 0 0) (vec 0 1 0)) 0)
(is (vdot (vec 1 0 0) (vec 0 0 1)) 0)
(is (vdot (vec 0 1 0) (vec 0 0 1)) 0)
(is (vdot (vec 1 0 0) (vec 1 0 0)) 1)
(is (vdot (vec 1 0 0) (vec -1 0 0)) -1)

(diag "magnitude")
(is (vmag +0vec+) 0)
(is (vmag (vec 1)) 1)
(is (vmag (vec 0.32979298 0.2571392 0.19932675)) 0.46326572)

(diag "normalize")
(with-vectors ((v (vec -0.6589291 0.23270178 -0.1047523))
               (r (vec -0.9325095 0.3293171 -0.14824435))
               (o (vec)))
  (is (vnormalize! o v) r)
  (is o r)
  (is (vnormalize v) r)
  (is (vnormalize (vec 2 0 0)) (vec 1 0 0))
  (is (vnormalize (vec 0 2 0)) (vec 0 1 0))
  (is (vnormalize (vec 0 0 2)) (vec 0 0 1)))

(diag "round")
(with-vectors ((v (vec -0.70498157 0.3615427 0.50702953))
               (r (vec -1 0 1))
               (o (vec)))
  (is (vround! o v) r)
  (is o r)
  (is (vround v) r))

(diag "abs")
(with-vectors ((v (vec -0.4241562 -0.52400947 0.82413125))
               (r (vec 0.4241562 0.52400947 0.82413125))
               (o (vec)))
  (is (vabs! o v) r)
  (is o r)
  (is (vabs v) r))

(diag "negate")
(with-vectors ((v (vec 0.7823446 0.95027566 -0.4147482))
               (r (vec -0.7823446 -0.95027566 0.4147482))
               (o (vec)))
  (is (vneg! o v) r)
  (is o r)
  (is (vneg v) r))

(diag "cross product")
(with-vectors ((v1 (vec 1 0 0)) (v2 (vec 0 1 0)) (o (vec)))
  (is (vcross! o v1 v2) (vec 0 0 1))
  (is o (vec 0 0 1))
  (is (vcross (vec 1 0 0) (vec 0 1 0)) (vec 0 0 1))
  (is (vcross (vec 1 0 0) (vec 0 0 1)) (vec 0 -1 0))
  (is (vcross (vec 0 1 0) (vec 1 0 0)) (vec 0 0 -1))
  (is (vcross (vec 0 1 0) (vec 0 0 1)) (vec 1 0 0))
  (is (vcross (vec 0 0 1) (vec 1 0 0)) (vec 0 1 0))
  (is (vcross (vec 0 0 1) (vec 0 1 0)) (vec -1 0 0)))

(diag "angle")
(let ((angle (vangle (vec 0 1 0) (vec 1 0 1))))
  (ok (<= (abs (- angle (/ pi 2))) 1e-7)))
(let ((angle (vangle (vec 1 1 0) (vec 1 0 1))))
  (ok (<= (abs (- angle (/ pi 3))) 1e-7)))
(let ((angle (vangle (vec 1 0 0) (vec 1 1 0))))
  (ok (<= (abs (- angle (/ pi 4))) 1e-7)))

(diag "zero vector predicate")
(ok (vzerop +0vec+))
(ok (vzerop (vec 0 0 0)))

(diag "direction equality")
(ok (vdir= (vec 0.0073252916 0 0) (vec 0.31148136 0 0)))
(ok (vdir= (vec 0 0.6982585 0) (vec 0 0.72258794 0)))
(ok (vdir= (vec 0 0 0.86798644) (vec 0 0 42384863)))

(diag "parallelity")
(ok (vparallelp (vec 0.6883507 0 0) (vec -0.37808847 0 0)))
(ok (vparallelp (vec 0 -0.31525326 0) (vec 0 0.20765233 0)))
(ok (vparallelp (vec 0 0 0.18911958) (vec 0 0 -0.17581582)))

(diag "linear interpolation")
(with-vectors ((v1 (vec 0.74485755 0.092342734 0.2982279))
               (v2 (vec 0.19426346 0.9881369 0.64691556))
               (r (vec 0.4695605 0.5402398 0.47257173))
               (o (vec)))
  (is (vlerp! o v1 v2 0.5) r)
  (is o r)
  (is (vlerp v1 v2 0.5) r)
  (is (vlerp v1 v2 0.0) v1)
  (is (vlerp v1 v2 1.0) v2))

(diag "comparators")
(with-vectors ((v1 (vec 0.34003425 -0.4920528 0.8754709))
               (v2 (vec 0.6535034 -0.11586404 -0.47056317))
               (v3 (vec 0.9715252 0.8300271 0.9858451))
               (v4 (vec 1 2 3))
               (v5 (vec 2 3 4)))
  (ok (v< v2 v3))
  (ok (v<= v4 v4))
  (ok (v<= v4 v5))
  (ok (v> v3 v1))
  (ok (v>= v4 v4))
  (ok (v>= v5 v4)))

(diag "component-wise minimum")
(with-vectors ((v1 (vec 0.98117805 0.06889212 0.32721102))
               (v2 (vec 0.8774886 0.25179327 0.76311684))
               (r (vec v2x v1y v1z))
               (o (vec)))
  (is (vmin! o v1 v2) r)
  (is o r)
  (is (vmin v1 v2) r))

(diag "component-wise maximum")
(with-vectors ((v1 (vec 0.64380646 0.38965714 0.2503655))
               (v2 (vec 0.6341989 0.5274999 0.90044403))
               (r (vec v1x v2y v2z))
               (o (vec)))
  (is (vmax! o v1 v2) r)
  (is o r)
  (is (vmax v1 v2) r))

(finalize)
