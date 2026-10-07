;; ============================================================
;; PLN DEDUCTION
;; ============================================================

;; ------------------------------------------------------------
;; Deduction strength
;;
;; A -> B and B -> C
;; therefore A -> C
;; ------------------------------------------------------------

(= (deduction-strength
      $sAB
      $sB
      $sBC
      $sC)

   (+ (* $sAB $sBC)
      (* (- 1.0 $sAB)
         (/ (- $sC
               (* $sB $sBC))
            (- 1.0 $sB)))))

;; ------------------------------------------------------------
;; Deduction confidence
;;
;; Confidence decreases as evidence passes through
;; multiple inference steps.
;; ------------------------------------------------------------

(= (deduction-confidence
      $sAB
      $cAB
      $sBC
      $cBC)

   (* (* (* $sAB $sBC) $cAB) $cBC))

;; ------------------------------------------------------------
;; Full PLN deduction
;; ------------------------------------------------------------

(= (deduction
      (STV $sAB $cAB)
      $sB
      (STV $sBC $cBC)
      $sC)

   (let*
      (($sAC
         (deduction-strength
            $sAB
            $sB
            $sBC
            $sC))

       ($cAC
         (deduction-confidence
            $sAB
            $cAB
            $sBC
            $cBC)))

      (STV
         $sAC
         $cAC)))

;; ------------------------------------------------------------
;; Simple deduction
;;
;; Simplified form:
;;
;; strength   = sAB * sBC
;; confidence = sAB * sBC * cAB * cBC
;;
;; Useful for straightforward implication chains.
;; ------------------------------------------------------------

(= (simple-deduction
      (STV $sAB $cAB)
      (STV $sBC $cBC))

   (let*
      (($sAC
         (* $sAB $sBC))

       ($cAC
         (* (* (* $sAB $sBC) $cAB) $cBC)))

      (STV
         $sAC
         $cAC)))