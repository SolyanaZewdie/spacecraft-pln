;; ============================================================
;; SUBJECTIVE TRUTH VALUES
;; ============================================================

;; STV = <strength, confidence>
;;
;; strength   = degree of belief
;; confidence = amount of supporting evidence

(= (stv $s $c)
   (STV $s $c))


;; ------------------------------------------------------------
;; Accessors
;; ------------------------------------------------------------

(= (get-strength (STV $s $c))
   $s)

(= (get-confidence (STV $s $c))
   $c)


;; ------------------------------------------------------------
;; Confidence <-> Evidence Weight
;;
;; w = c / (1-c)
;; c = w / (w+1)
;; ------------------------------------------------------------

(= (confidence-to-weight $c)
   (/ $c (- 1.0 $c)))

(= (weight-to-confidence $w)
   (/ $w (+ $w 1.0)))


;; ------------------------------------------------------------
;; Revision
;;
;; Combines two independent pieces of evidence about
;; the same proposition.
;; ------------------------------------------------------------

(= (revision
      (STV $s1 $c1)
      (STV $s2 $c2))

   (let* (
      ($w1 (confidence-to-weight $c1))
      ($w2 (confidence-to-weight $c2))

      ($total-weight
         (+ $w1 $w2))

      ($new-strength
         (/ (+ (* $s1 $w1)
               (* $s2 $w2))
            $total-weight))

      ($new-confidence
         (weight-to-confidence $total-weight))
   )

      (STV
         $new-strength
         $new-confidence)))