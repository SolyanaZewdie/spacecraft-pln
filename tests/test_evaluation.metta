;; ============================================================
;; PLN EVALUATION TESTS
;; Spacecraft Anomaly Diagnosis
;; ============================================================
;;
;; This file directly executes the five required evaluation
;; scenarios.
;;
;; The results are printed here so we can verify the behavior
;; of the PLN engine before using the cases in the final report.
;; ============================================================

!(import! &self "main")


;; ============================================================
;; CASE 1: STRONG EVIDENCE
;; ============================================================
;;
;; Strong evidence + strong implication
;; should produce relatively strong inferred evidence.
;; ------------------------------------------------------------

!(deduction
   (STV 0.96 0.90)
   0.80
   (STV 0.90 0.85)
   0.75)


;; ============================================================
;; CASE 2: UNCERTAIN EVIDENCE
;; ============================================================
;;
;; Weaker evidence should result in lower confidence.
;; ------------------------------------------------------------

!(deduction
   (STV 0.60 0.40)
   0.50
   (STV 0.70 0.50)
   0.60)


;; ============================================================
;; CASE 3: MULTIPLE EXPLANATIONS
;; ============================================================
;;
;; CommunicationLoss has three possible causes.
;; ------------------------------------------------------------

!(why CommunicationLoss)


;; ============================================================
;; CASE 4: CONFLICTING EVIDENCE
;; ============================================================
;;
;; Two pieces of evidence about the same proposition are
;; combined using PLN revision.
;; ------------------------------------------------------------

!(revision
   (STV 0.70 0.50)
   (STV 0.95 0.75))


;; ============================================================
;; CASE 5: MULTI-STEP INFERENCE
;; ============================================================
;;
;; First inference:
;;
;;     BatteryFailure -> PowerFluctuation
;;
;; ------------------------------------------------------------

!(forward-step
   (Evidence
      BatteryFailure
      (STV 0.90 0.85))

   (Implication
      BatteryFailure
      PowerFluctuation
      (STV 0.90 0.85)))


;; ------------------------------------------------------------
;; Second inference:
;;
;;     PowerFluctuation -> CommunicationLoss
;;
;; We use the result from the first inference:
;;
;;     STV <0.81, 0.585225>
;;
;; ------------------------------------------------------------

!(simple-deduction
   (STV 0.81 0.585225)
   (STV 0.80 0.75))