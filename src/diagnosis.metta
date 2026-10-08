;; ============================================================
;; SPACECRAFT DIAGNOSIS
;; ============================================================
!(import! &self "knowledge_base")

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
;; + diagnostic score
;; ------------------------------------------------------------

(= (diagnostic-candidate $observation)
   (match &self
      (Implication
         $cause
         $observation
         $implication)
      (match &self
         (Prior
            $cause
            (STV $sCause $cCause))
         (match &self
            (Evidence
               $observation
               (STV $sEvidence $cEvidence))
            (DiagnosticCandidate
               $cause
               $observation
               (Prior
                  $cause
                  (STV $sCause $cCause))
               $implication
               (STV
                  (* $sEvidence $sCause)
                  (* (* $cEvidence $cCause) $sCause)))))))

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