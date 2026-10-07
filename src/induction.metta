;; ============================================================
;; PLN INDUCTION
;; ============================================================

;; ------------------------------------------------------------
;; Induction strength
;;
;; Given:
;;   C -> A
;;   C -> B
;;
;; infer a candidate:
;;   A -> B
;;
;; This is a generalization, not a certainty.
;; ------------------------------------------------------------

(= (induction-strength
      $sCA
      $sCB
      $sC
      $sA
      $sB)

   (+ (/ (* (* $sCA $sCB) $sC)
          $sA)

      (* (- 1.0
            (/ (* $sCA $sC)
               $sA))

         (/ (- $sB
               (* $sC $sCB))
            (- 1.0 $sC)))))

;; ------------------------------------------------------------
;; Induction evidence weight
;;
;; Stronger evidence about both premises gives
;; greater evidence weight for the induced relation.
;; ------------------------------------------------------------

(= (induction-weight
      $sCB
      $cCB
      $cCA)

   (* (* $sCB $cCB) $cCA))

;; ------------------------------------------------------------
;; Convert induction weight into confidence
;; ------------------------------------------------------------

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

;; ------------------------------------------------------------
;; Full PLN induction
;; ------------------------------------------------------------

(= (induction
      (STV $sCA $cCA)
      (STV $sCB $cCB)
      $sC
      $sA
      $sB)

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
         $cAB)))