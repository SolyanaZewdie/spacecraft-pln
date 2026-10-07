;; ============================================================
;; PLN DEDUCTION
;; ============================================================
;;
;; A -> B and B -> C
;; therefore A -> C
;;
;; Boundary handling:
;;
;; The PLN deduction-strength equation contains:
;;
;;     1 - sB
;;
;; in its denominator.
;;
;; Therefore sB = 1 makes the equation undefined.
;; We explicitly return UndefinedInference instead of allowing
;; NaN to propagate through the engine.
;; ============================================================


;; ============================================================
;; DEDUCTION STRENGTH
;; ============================================================

(= (deduction-strength
      $sAB
      $sB
      $sBC
      $sC)

   (if
      (== $sB 1.0)

      (UndefinedInference DeductionDenominatorZero)

      (+ (* $sAB $sBC)
         (* (- 1.0 $sAB)
            (/ (- $sC
                  (* $sB $sBC))
               (- 1.0 $sB))))))


;; ============================================================
;; DEDUCTION CONFIDENCE
;; ============================================================

(= (deduction-confidence
      $sAB
      $cAB
      $sBC
      $cBC)

   (* (* (* $sAB $sBC) $cAB) $cBC))


;; ============================================================
;; FULL PLN DEDUCTION
;; ============================================================

(= (deduction
      (STV $sAB $cAB)
      $sB
      (STV $sBC $cBC)
      $sC)

   (if
      (== $sB 1.0)

      (UndefinedInference DeductionDenominatorZero)

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
            $cAC))))


;; ============================================================
;; SIMPLE DEDUCTION
;;
;; Simplified form:
;;
;;   strength   = sAB * sBC
;;   confidence = sAB * sBC * cAB * cBC
;;
;; This version has no division and therefore has no
;; denominator boundary problem.
;; ============================================================

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