;; ============================================================
;; SPACECRAFT DIAGNOSIS
;; ============================================================

(= (possible-causes $observation)
   (match &self
      (Implication $cause $observation $stv)
      (Implication $cause $observation $stv)))

(= (get-prior $cause)
   (match &self
      (Prior $cause $stv)
      (Prior $cause $stv)))

;; ------------------------------------------------------------
;; Diagnostic candidate = cause + prior + causal strength
;; ------------------------------------------------------------

(= (diagnostic-candidate $observation)
   (match &self
      (Implication $cause $observation $implication)
      (DiagnosticCandidate
         $cause
         $observation
         (get-prior $cause)
         $implication)))

;; ------------------------------------------------------------
;; Combine observed evidence with a causal implication
;;
;; This produces a simple abductive diagnostic score.
;; ------------------------------------------------------------

(= (diagnostic-score
      (STV $sEvidence $cEvidence)
      (STV $sCause $cCause))

   (STV
      (* $sEvidence $sCause)
      (* (* $cEvidence $cCause) $sCause)))