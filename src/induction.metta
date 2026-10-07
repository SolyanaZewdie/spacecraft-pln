;; ============================================================
;; PLN INDUCTION
;; ============================================================
;;
;; Given:
;;   C -> A
;;   C -> B
;;
;; infer a candidate:
;;   A -> B
;;
;; This is a generalization, not a certainty.
;;
;; Boundary handling:
;;
;; The induction-strength equation contains:
;;
;;     sA
;;     1 - sC
;;
;; as denominators.
;;
;; Therefore:
;;
;;   sA = 0
;;   sC = 1
;;
;; make the equation undefined.
;; ============================================================


;; ============================================================
;; INDUCTION STRENGTH
;; ============================================================

(= (induction-strength
      $sCA
      $sCB
      $sC
      $sA
      $sB)

   (if
      (== $sA 0.0)

      (UndefinedInference InductionSAZero)

      (if
         (== $sC 1.0)

         (UndefinedInference InductionSCOne)

         (+ (/ (* (* $sCA $sCB) $sC)
                $sA)

            (* (- 1.0
                  (/ (* $sCA $sC)
                     $sA))

               (/ (- $sB
                     (* $sC $sCB))
                  (- 1.0 $sC)))))))


;; ============================================================
;; INDUCTION EVIDENCE WEIGHT
;; ============================================================

(= (induction-weight
      $sCB
      $cCB
      $cCA)

   (* (* $sCB $cCB) $cCA))


;; ============================================================
;; INDUCTION CONFIDENCE
;; ============================================================

(= (induction-confidence
      $sCB
      $cCB
      $cCA)

   (let*
      (($w
         (induction-weight
            $sCB
            $cCB
            $cCA)))

      (/ $w (+ $w 1.0))))


;; ============================================================
;; FULL PLN INDUCTION
;; ============================================================

(= (induction
      (STV $sCA $cCA)
      (STV $sCB $cCB)
      $sC
      $sA
      $sB)

   (if
      (== $sA 0.0)

      (UndefinedInference InductionSAZero)

      (if
         (== $sC 1.0)

         (UndefinedInference InductionSCOne)

         (let*
            (($sAB
               (induction-strength
                  $sCA
                  $sCB
                  $sC
                  $sA
                  $sB))

             ($cAB
               (induction-confidence
                  $sCB
                  $cCB
                  $cCA)))

            (STV
               $sAB
               $cAB)))))