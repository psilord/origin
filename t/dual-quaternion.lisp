(in-package :gamebox-math.test)

(setf *default-test-function* #'equalp)

(plan 95)

(diag "structure")
(is-type +dqid+ 'dquat)
(is-type (dquat) 'dquat)

(diag "accessors")
(with-dquat (d (dquat (quat 1 2 3 4) (quat 5 6 7 8)))
  (is drw 1)
  (is drx 2)
  (is dry 3)
  (is drz 4)
  (is ddw 5)
  (is ddx 6)
  (is ddy 7)
  (is ddz 8)
  (psetf drw 10.0 drx 20.0 dry 30.0 drz 40.0 ddw 50.0 ddx 60.0 ddy 70.0 ddz 80.0)
  (is drw 10)
  (is drx 20)
  (is dry 30)
  (is drz 40)
  (is ddw 50)
  (is ddx 60)
  (is ddy 70)
  (is ddz 80))
(with-dquats ((d1 (dquat (quat 1 2 3 4) (quat 5 6 7 8)))
              (d2 (dquat (quat 10 11 12 13) (quat 14 15 16 17))))
  (is d1rw 1)
  (is d1rx 2)
  (is d1ry 3)
  (is d1rz 4)
  (is d1dw 5)
  (is d1dx 6)
  (is d1dy 7)
  (is d1dz 8)
  (is d2rw 10)
  (is d2rx 11)
  (is d2ry 12)
  (is d2rz 13)
  (is d2dw 14)
  (is d2dx 15)
  (is d2dy 16)
  (is d2dz 17)
  (psetf d1rw 10.0 d1rx 20.0 d1ry 30.0 d1rz 40.0 d1dw 50.0 d1dx 60.0 d1dy 70.0 d1dz 80.0
         d2rw 100.0 d2rx 200.0 d2ry 300.0 d2rz 400.0 d2dw 500.0 d2dx 600.0 d2dy 700.0 d2dz 800.0)
  (is d1rw 10)
  (is d1rx 20)
  (is d1ry 30)
  (is d1rz 40)
  (is d1dw 50)
  (is d1dx 60)
  (is d1dy 70)
  (is d1dz 80)
  (is d2rw 100)
  (is d2rx 200)
  (is d2ry 300)
  (is d2rz 400)
  (is d2dw 500)
  (is d2dx 600)
  (is d2dy 700)
  (is d2dz 800))

(diag "identity")
(with-dquats ((d (dqid)) (r (dquat (quat 1 0 0 0) (quat 0 0 0 0))))
  (is d r)
  (is +dqid+ r))

(diag "equality")
(pass "redundant")

(diag "copy")
(pass "redundant")

(diag "addition")
(pass "redundant")

(diag "subtraction")
(pass "redundant")

(diag "multiplication")
(pass "redundant")

(diag "scalar product")
(pass "redundant")

(diag "conjugate")
(pass "redundant")

(diag "magnitude")
(pass "redundant")

(diag "normalize")
(with-dquats ((d (dquat (quat -0.6114731 0.9762738 0.2938311 0.28761292)
                        (quat -0.22068572 -0.499269 0.2683978 0.05499983)))
              (r (dquat (quat -0.4999214 0.79817116 0.2402272 0.2351434)
                        (quat -0.1804258 -0.40818685 0.21943371 0.044966154)))
              (o (dquat)))
  (is (dqnormalize! o d) r)
  (is o r)
  (is (dqnormalize d) r)
  (is (dqnormalize (dquat (quat 2 0 0 0) (quat 0 0 0 0))) +dqid+))

(diag "negate")
(pass "redundant")

(diag "dot product")
(pass "redundant")

(diag "inverse")
(with-dquats ((d (dquat (quat 0.80088806 0.9623561 -0.86221576 -0.34557796)
                        (quat 0.7549772 -0.49641347 0.5262337 -0.15916371)))
              (r (dquat (quat 0.32953054 -0.39596757 0.3547642 0.14219026)
                        (quat 0.38434494 0.115688086 -0.13717361 0.09729204)))
              (o (dquat)))
  (is (dqinv! o d) r)
  (is o r)
  (is (dqinv d) r))

(diag "translation conversion")
(with-dquats ((d (dquat (quat 0.8660254 0.5 0 0)
                        (quat -2.0669873 4.580127 16.160254 7.9903812)))
              (rd (dquat (quat 1 0 0 0) (quat 0.5 5.0 10.0 15.0)))
              (od (dquat)))
  (with-vectors ((rv (vec 10 20 30))
                 (ov (vec)))
    (ok (v~ (dqtr->v! ov d) rv :tolerance 1e-5))
    (ok (v~ ov rv :tolerance 1e-5))
    (ok (v~ (dqtr->v d) rv :tolerance 1e-5))
    (is (v->dqtr! od rv) rd)
    (is od rd)
    (is (v->dqtr rv) rd)))

(diag "rotation conversion")
(pass "redundant")

(diag "rotation")
(pass "redundant")

(diag "matrix conversion")
(with-dquat (d (dquat (quat 0.8660254 0.5 0 0)
                      (quat -2.0669873 4.580127 16.160254 7.9903812)))
  (with-matrices ((r (matrix 1 0 0 10 0 0.5 -0.8660254 20 0 0.8660254 0.5 30 0 0 0 1))
                  (o (mid)))
    (ok (m~ (dq->m! o d) r :tolerance 1e-5))
    (ok (m~ o r :tolerance 1e-5))
    (ok (m~ (dq->m d) r :tolerance 1e-5))))

(diag "screw parameter conversion")
(with-dquats ((d (dquat (quat 0.8660254 0.5 0 0)
                        (quat -2.0669873 4.580127 16.160254 7.9903812)))
              (r (dquat (quat 0.8660254 0.5 0 0)
                        (quat -2.4999998 4.330127 16.160254 7.9903817))))
  (multiple-value-bind (angle pitch dir moment) (dq->screw d)
    (ok (< (abs (- angle 1.0471976)) 1e-5))
    (ok (< (abs (- pitch 10)) 1e-5))
    (ok (v~ dir (vec 1 0 0) :tolerance 1e-5))
    (ok (v~ moment (vec 0 32.320507 15.980763) :tolerance 1e-5))
    (ok (dq~ (screw->dq angle pitch dir moment) r :tolerance 1e-5))))

(diag "screw spherical linear interpolation")
(with-dquats ((d1 (dquat (quat 0.8660254 0.5 0 0)
                         (quat -2.0669873 4.580127 16.160254 7.9903812)))
              (d2 (dquat (quat 0.9238795 0.38268346 0 0)
                         (quat -3.3648949 9.430137 21.511862 12.737339)))
              (r (dquat (quat 0.89687264 0.44228896 0 0)
                        (quat -2.868731 6.947688 18.876476 10.386089)))
              (o (dquat)))
  (is (dqsclerp! o d1 d2 0.5) r)
  (is o r)
  (is (dqsclerp d1 d2 0.5) r)
  (is (dqsclerp d1 d2 0.0) d1)
  (ok (dq~ (dqsclerp d1 d2 1.0) d2 :tolerance 1e-4)))

(diag "normalized linear interpolation")
(with-dquats ((d1 (dquat (quat 0.8660254 0.5 0 0)
                         (quat -2.0669873 4.580127 16.160254 7.9903812)))
              (d2 (dquat (quat 0.9238795 0.38268346 0 0)
                         (quat -3.3648949 9.430137 21.511862 12.737339)))
              (r (dquat (quat 0.8949524 0.44134173 0 0)
                        (quat -2.715941 7.0051317 18.836058 10.36386)))
              (o (dquat)))
  (is (dqnlerp! o d1 d2 0.5) r)
  (is o r)
  (is (dqnlerp d1 d2 0.5) r)
  (is (dqnlerp d1 d2 0.0) d1)
  (is (dqnlerp d1 d2 1.0) d2))

(finalize)
