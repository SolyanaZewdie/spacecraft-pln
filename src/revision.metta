;; ============================================================
;; PLN REVISION
;; ============================================================
;;
;; Revision combines independent evidence about the SAME
;; proposition.
;;
;;     Evidence 1 ──┐
;;                  ├──> Revised belief
;;     Evidence 2 ──┘
;;
;; For:
;;
;;     STV1 = <s1,c1>
;;     STV2 = <s2,c2>
;;
;; Convert confidence to evidence weight:
;;
;;     w1 = c1/(1-c1)
;;     w2 = c2/(1-c2)
;;
;; Combine:
;;
;;     w = w1 + w2
;;
;;     s = (w1*s1 + w2*s2)/(w1+w2)
;;
;;     c = w/(w+1)
;;
;; ============================================================


;; ------------------------------------------------------------
;; Evidence weight
;; ------------------------------------------------------------

(= (revision-weight $c)
   (/ $c (- 1.0 $c)))


;; ------------------------------------------------------------
;; Revised strength
;; ------------------------------------------------------------

(= (revision-strength
      $s1
      $c1
      $s2
      $c2)

   (let* (
      ($w1 (revision-weight $c1))
      ($w2 (revision-weight $c2))

      ($total-weight
         (+ $w1 $w2))

      ($weighted-sum
         (+ (* $w1 $s1)
            (* $w2 $s2)))
   )

      (/ $weighted-sum
         $total-weight)))


;; ------------------------------------------------------------
;; Revised confidence
;; ------------------------------------------------------------

(= (revision-confidence
      $c1
      $c2)

   (let* (
      ($w1 (revision-weight $c1))
      ($w2 (revision-weight $c2))

      ($total-weight
         (+ $w1 $w2))
   )

      (/ $total-weight
         (+ $total-weight 1.0))))


;; ------------------------------------------------------------
;; Complete Revision
;; ------------------------------------------------------------

(= (revise
      (STV $s1 $c1)
      (STV $s2 $c2))

   (let* (
      ($s
         (revision-strength
            $s1
            $c1
            $s2
            $c2))

      ($c
         (revision-confidence
            $c1
            $c2))
   )

      (STV $s $c)))


;; ------------------------------------------------------------
;; Example:
;;
;; Sensor 1:
;;     CommunicationLoss <0.70, 0.50>
;;
;; Sensor 2:
;;     CommunicationLoss <0.95, 0.75>
;;
;; Revised:
;;     approximately <0.8875, 0.80>
;; ------------------------------------------------------------


(= (example-revision)
   (revise
      (STV 0.70 0.50)
      (STV 0.95 0.75)))