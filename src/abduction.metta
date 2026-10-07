;; ============================================================
;; PLN ABDUCTION
;; ============================================================
;;
;; Given:
;;   A -> C
;;   B -> C
;;
;; infer:
;;   A -> B
;;
;; Abduction proposes a possible explanation. It is not
;; deductive proof.
;;
;; Boundary handling:
;;
;; The abduction-strength equation contains:
;;
;;     sC
;;     1 - sC
;;
;; as denominators.
;;
;; Therefore sC = 0 or sC = 1 makes the equation undefined.
;; ============================================================


;; ============================================================
;; ABDUCTION STRENGTH
;; ============================================================

(= (abduction-strength
      $sAC
      $sBC
      $sB
      $sC)

   (if
      (== $sC 0.0)

      (UndefinedInference AbductionSCZero)

      (if
         (== $sC 1.0)

         (UndefinedInference AbductionSCOne)

         (+ (/ (* (* $sAC $sBC) $sB)
                $sC)

            (/ (* (* $sB (- 1.0 $sAC))
                  (- 1.0 $sBC))
               (- 1.0 $sC))))))


;; ============================================================
;; ABDUCTION EVIDENCE WEIGHT
;; ============================================================

(= (abduction-weight
      $sAC
      $cAC
      $cBC)

   (* (* $sAC $cAC) $cBC))


;; ============================================================
;; ABDUCTION CONFIDENCE
;; ============================================================

(= (abduction-confidence
      $sAC
      $cAC
      $cBC)

   (let*
      (($w
         (abduction-weight
            $sAC
            $cAC
            $cBC)))

      (/ $w (+ $w 1.0))))


;; ============================================================
;; FULL PLN ABDUCTION
;; ============================================================

(= (abduction
      (STV $sAC $cAC)
      (STV $sBC $cBC)
      $sB
      $sC)

   (if
      (== $sC 0.0)

      (UndefinedInference AbductionSCZero)

      (if
         (== $sC 1.0)

         (UndefinedInference AbductionSCOne)

         (let*
            (($sAB
               (abduction-strength
                  $sAC
                  $sBC
                  $sB
                  $sC))

             ($cAB
               (abduction-confidence
                  $sAC
                  $cAC
                  $cBC)))

            (STV
               $sAB
               $cAB)))))