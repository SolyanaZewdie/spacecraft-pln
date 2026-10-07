;; ============================================================
;; SUBJECTIVE TRUTH VALUES
;; ============================================================
;;
;; STV = <strength, confidence>
;;
;; strength   = degree of belief
;; confidence = amount of supporting evidence
;;
;; Boundary handling:
;;
;;   confidence = 1
;;       represents complete confidence. The normal
;;       c/(1-c) weight formula is undefined there, so
;;       revision handles it explicitly.
;;
;;   both confidences = 0
;;       provide no evidence, so revision is undefined.
;; ============================================================


(= (stv $s $c)
   (STV $s $c))


;; ============================================================
;; ACCESSORS
;; ============================================================

(= (get-strength (STV $s $c))
   $s)

(= (get-confidence (STV $s $c))
   $c)


;; ============================================================
;; CONFIDENCE <-> EVIDENCE WEIGHT
;;
;; w = c / (1-c)
;; c = w / (w+1)
;;
;; c = 1 is mathematically undefined for this conversion.
;; ============================================================

(= (confidence-to-weight $c)
   (if
      (== $c 1.0)
      (UndefinedInference ConfidenceWeightAtOne)
      (/ $c (- 1.0 $c))))


(= (weight-to-confidence $w)
   (/ $w (+ $w 1.0)))


;; ============================================================
;; REVISION
;;
;; Combines two independent pieces of evidence about the
;; same proposition.
;;
;; Normal case:
;;
;;   w1 = c1/(1-c1)
;;   w2 = c2/(1-c2)
;;   w  = w1+w2
;;
;; Boundary cases:
;;
;;   c1 = 1 -> first evidence is completely trusted
;;   c2 = 1 -> second evidence is completely trusted
;;   c1 = c2 = 0 -> there is no evidence to combine
;; ============================================================

(= (revision
      (STV $s1 $c1)
      (STV $s2 $c2))

   (if
      (== $c1 1.0)

      (STV $s1 1.0)

      (if
         (== $c2 1.0)

         (STV $s2 1.0)

         (if
            (and
               (== $c1 0.0)
               (== $c2 0.0))

            (UndefinedInference RevisionNoEvidence)

            (let*
               (($w1
                  (confidence-to-weight $c1))

                ($w2
                  (confidence-to-weight $c2))

                ($total-weight
                   (+ $w1 $w2))

                ($new-strength
                   (/ (+ (* $s1 $w1)
                         (* $s2 $w2))
                      $total-weight))

                ($new-confidence
                   (weight-to-confidence $total-weight)))

               (STV
                  $new-strength
                  $new-confidence))))))