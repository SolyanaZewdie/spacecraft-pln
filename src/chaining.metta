;; ============================================================
;; PLN CHAINING
;; Spacecraft Anomaly Diagnosis
;; ============================================================
;;
;; This file implements the chaining part of the PLN engine.
;;
;; Chaining means repeatedly using relationships in the
;; knowledge base to move from known information to new
;; information.
;;
;; We implement two directions:
;;
;; 1. FORWARD CHAINING
;;    Evidence/facts -> consequences
;;
;;    Example:
;;    BatteryFailure
;;        -> PowerFluctuation
;;        -> CommunicationLoss
;;
;; 2. BACKWARD CHAINING
;;    Query/consequence -> possible causes
;;
;;    Example:
;;    CommunicationLoss
;;        <- PowerFailure
;;        <- AntennaFailure
;;        <- RadiationEvent
;;
;; The actual STV calculations are performed by the PLN
;; inference functions in deduction.metta.
;; ============================================================


;; ============================================================
;; FORWARD REASONING
;; ============================================================

;; ------------------------------------------------------------
;; Find all direct consequences of a statement.
;;
;; Given:
;;
;;     Implication A B STV
;;
;; return the implication describing:
;;
;;     A -> B
;;
;; Example:
;;
;;     (find-consequences PowerFailure)
;;
;; can find:
;;
;;     PowerFailure -> PowerFluctuation
;;     PowerFailure -> CommunicationLoss
;; ------------------------------------------------------------

(= (find-consequences $A)
   (match &self
      (Implication $A $B $stv)
      (Implication $A $B $stv)))


;; ------------------------------------------------------------
;; One-step forward inference.
;;
;; Input:
;;
;;     Evidence A
;;     A -> B
;;
;; Output:
;;
;;     Derived B
;;
;; The STV of the evidence and the STV of the implication
;; are combined using simplified PLN deduction.
;;
;; Example:
;;
;;     Evidence PowerFailure <0.80,0.75>
;;     PowerFailure -> CommunicationLoss <0.95,0.90>
;;
;; produces a Derived CommunicationLoss with a lower
;; confidence because the evidence passes through an
;; inference step.
;; ------------------------------------------------------------

(= (forward-step
      (Evidence $A (STV $sA $cA))
      (Implication $A $B (STV $sAB $cAB)))

   (let*
      (($result
         (simple-deduction
            (STV $sA $cA)
            (STV $sAB $cAB))))

      (Derived $B $result)))


;; ============================================================
;; BACKWARD REASONING
;; ============================================================

;; ------------------------------------------------------------
;; Find all possible causes of a statement.
;;
;; Given a target B, search for:
;;
;;     A -> B
;;
;; and return the matching implications.
;;
;; Example:
;;
;;     (find-causes CommunicationLoss)
;;
;; returns:
;;
;;     PowerFailure -> CommunicationLoss
;;     AntennaFailure -> CommunicationLoss
;;     RadiationEvent -> CommunicationLoss
;; ------------------------------------------------------------

(= (find-causes $B)
   (match &self
      (Implication $A $B $stv)
      (Implication $A $B $stv)))


;; ------------------------------------------------------------
;; One-step backward reasoning.
;;
;; Given a query B, return candidate causes A.
;;
;; Example:
;;
;;     (backward-step CommunicationLoss)
;;
;; returns:
;;
;;     CandidateCause PowerFailure CommunicationLoss ...
;;     CandidateCause AntennaFailure CommunicationLoss ...
;;     CandidateCause RadiationEvent CommunicationLoss ...
;;
;; This does NOT claim that any cause is definitely true.
;; It only identifies causes supported by relationships
;; already present in the knowledge base.
;; ------------------------------------------------------------

(= (backward-step $B)
   (match &self
      (Implication $A $B $stv)
      (CandidateCause $A $B $stv)))


;; ------------------------------------------------------------
;; Backward-chain
;;
;; This is a named representation of a backward path.
;;
;; Given:
;;
;;     A -> B
;;
;; return:
;;
;;     BackwardPath A B STV
;;
;; This allows us to distinguish a backward reasoning path
;; from a normal implication in the knowledge base.
;; ------------------------------------------------------------

(= (backward-chain $B)
   (match &self
      (Implication $A $B $stv)
      (BackwardPath $A $B $stv)))