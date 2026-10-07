;; ============================================================
;; PLN ABDUCTION
;; ============================================================

(= (abduction-strength
      $sAC
      $sBC
      $sB
      $sC)

   (+ (/ (* (* $sAC $sBC) $sB)
          $sC)

      (/ (* (* $sB (- 1.0 $sAC))
            (- 1.0 $sBC))
         (- 1.0 $sC))))

(= (abduction-weight
      $sAC
      $cAC
      $cBC)

   (* (* $sAC $cAC) $cBC))

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

(= (abduction
      (STV $sAC $cAC)
      (STV $sBC $cBC)
      $sB
      $sC)

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
         $cAB)))