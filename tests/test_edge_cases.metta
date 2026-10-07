;; ============================================================
;; PLN EDGE-CASE TESTS
;; Spacecraft Anomaly Diagnosis
;; ============================================================
;;
;; This file checks how the PLN engine behaves under unusual
;; or difficult evidence conditions.
;;
;; These tests are important because a probabilistic reasoning
;; system should not only work with ideal inputs.
;;
;; Cases tested:
;;
;;   1. Very weak evidence
;;   2. High-confidence evidence
;;   3. Strongly conflicting evidence
;;   4. Equal-confidence conflicting evidence
;;   5. Multi-step confidence degradation
;;   6. Multiple possible causes
;;   7. Observation with no known cause
;; ============================================================

!(import! &self "../src/main.metta")


;; ============================================================
;; CASE 1: VERY WEAK EVIDENCE
;; ============================================================
;;
;; Both premises have low strength and confidence.
;;
;; Expected:
;; The resulting STV should also be weak.
;; ------------------------------------------------------------

!(deduction
   (STV 0.20 0.20)
   0.30
   (STV 0.40 0.25)
   0.35)


;; ============================================================
;; CASE 2: HIGH-CONFIDENCE EVIDENCE
;; ============================================================
;;
;; Strong evidence passing through a strong implication.
;;
;; Expected:
;; Relatively strong inferred evidence.
;; ------------------------------------------------------------

!(simple-deduction
   (STV 0.98 0.99)
   (STV 0.97 0.98))


;; ============================================================
;; CASE 3: STRONGLY CONFLICTING EVIDENCE
;; ============================================================
;;
;; One source strongly supports a proposition while another
;; source strongly rejects it.
;;
;; Strengths:
;;
;;     0.90
;;     0.10
;;
;; The revision mechanism should combine them according to
;; their confidence values.
;; ------------------------------------------------------------

!(revision
   (STV 0.90 0.80)
   (STV 0.10 0.80))


;; ============================================================
;; CASE 4: CONFLICTING EVIDENCE WITH DIFFERENT CONFIDENCE
;; ============================================================
;;
;; Source 1:
;;     high strength but lower confidence
;;
;; Source 2:
;;     lower strength but higher confidence
;;
;; Revision should give more weight to the evidence with
;; greater confidence.
;; ------------------------------------------------------------

!(revision
   (STV 0.90 0.40)
   (STV 0.20 0.90))


;; ============================================================
;; CASE 5: MULTI-STEP CONFIDENCE DEGRADATION
;; ============================================================
;;
;; Three inference steps are applied sequentially.
;;
;; The purpose is to demonstrate that confidence can decrease
;; as uncertainty propagates through a longer reasoning chain.
;; ------------------------------------------------------------

;; Step 1

!(simple-deduction
   (STV 0.90 0.90)
   (STV 0.90 0.90))


;; Step 2

!(simple-deduction
   (STV 0.81 0.81)
   (STV 0.90 0.90))


;; Step 3

!(simple-deduction
   (STV 0.729 0.729)
   (STV 0.90 0.90))


;; ============================================================
;; CASE 6: MULTIPLE POSSIBLE CAUSES
;; ============================================================
;;
;; CommunicationLoss deliberately has multiple possible
;; explanations in our spacecraft knowledge base.
;; ------------------------------------------------------------

!(why CommunicationLoss)


;; ============================================================
;; CASE 7: NO KNOWN CAUSE
;; ============================================================
;;
;; This observation is not currently connected to a cause
;; in the knowledge base.
;;
;; The result should be empty rather than inventing a cause.
;; ------------------------------------------------------------

!(why UnknownObservation)