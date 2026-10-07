;; ============================================================
;; PLN CHAINING
;; Spacecraft Anomaly Diagnosis
;; ============================================================
;;
;; Chaining repeatedly applies implications to move from
;; known information toward new information.
;;
;; Two directions are implemented:
;;
;; FORWARD:
;;     evidence -> consequence -> further consequence
;;
;; BACKWARD:
;;     query -> possible causes
;;
;; STV calculations are performed by the PLN inference
;; functions in deduction.metta.
;; ============================================================


;; ============================================================
;; FORWARD REASONING
;; ============================================================

;; ------------------------------------------------------------
;; Find direct consequences of a statement.
;;
;; Example:
;;
;;     PowerFailure
;;         -> PowerFluctuation
;;         -> CommunicationLoss
;; ------------------------------------------------------------
!(import! &self "knowledge_base")

;; ============================================================
;; PLN CHAINING
;; Spacecraft Anomaly Diagnosis
;; ============================================================
(= (find-consequences $A)
   (match &self
      (Implication $A $B $stv)
      (Implication $A $B $stv)))


;; ------------------------------------------------------------
;; One-step forward inference.
;;
;; Evidence A + implication A -> B
;; produces derived evidence about B.
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


;; ------------------------------------------------------------
;; Two-step forward chaining.
;;
;; The important part is that the result of the first
;; inference is stored in $first and then passed directly
;; into the second inference.
;;
;; Therefore we do NOT manually enter the intermediate STV.
;;
;; Chain:
;;
;;     A -> B -> C
;;
;;     Evidence A
;;          |
;;          v
;;       Derived B
;;          |
;;          v
;;       Derived C
;; ------------------------------------------------------------

(= (forward-chain-2
      (Evidence $A (STV $sA $cA))
      (Implication $A $B (STV $sAB $cAB))
      (Implication $B $C (STV $sBC $cBC)))

   (let*
      (($first
         (simple-deduction
            (STV $sA $cA)
            (STV $sAB $cAB)))

       ($second
         (simple-deduction
            $first
            (STV $sBC $cBC)))

       ($result
         (DerivedChain
            $A
            $B
            $C
            $first
            $second)))

      $result))


;; ============================================================
;; BACKWARD REASONING
;; ============================================================

;; ------------------------------------------------------------
;; Find all possible causes of a statement.
;;
;; Given target B, search for:
;;
;;     A -> B
;; ------------------------------------------------------------

(= (find-causes $B)
   (match &self
      (Implication $A $B $stv)
      (Implication $A $B $stv)))


;; ------------------------------------------------------------
;; One-step backward reasoning.
;;
;; Given query B, return candidate causes A.
;;
;; This does not claim that a candidate cause is definitely
;; true. It only identifies explanations supported by the
;; knowledge base.
;; ------------------------------------------------------------

(= (backward-step $B)
   (match &self
      (Implication $A $B $stv)
      (CandidateCause $A $B $stv)))


;; ------------------------------------------------------------
;; Represent backward reasoning paths.
;; ------------------------------------------------------------

(= (backward-chain $B)
   (match &self
      (Implication $A $B $stv)
      (BackwardPath $A $B $stv)))