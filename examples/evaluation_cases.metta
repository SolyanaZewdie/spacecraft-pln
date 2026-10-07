;; ============================================================
;; PLN EVALUATION CASES
;; Spacecraft Anomaly Diagnosis
;; ============================================================
;;
;; This file demonstrates the five evaluation scenarios
;; required for the PLN assignment:
;;
;; 1. Strong evidence
;; 2. Incomplete / uncertain evidence
;; 3. Multiple explanations
;; 4. New / conflicting evidence
;; 5. Multi-step inference and confidence degradation
;;
;; Each case uses the actual PLN functions implemented in
;; the project rather than manually calculated results.
;; ============================================================

!(import! &self "../src/main.metta")


;; ============================================================
;; CASE 1: STRONG EVIDENCE
;; ============================================================
;;
;; We have strong evidence for A and a strong implication
;; from A to B.
;;
;; Example:
;;
;;     Battery failure evidence
;;             +
;;     BatteryFailure -> BatteryVoltageDrop
;;
;; PLN deduction should produce a relatively strong result.
;; ------------------------------------------------------------

!(deduction
   (STV 0.96 0.90)
   0.80
   (STV 0.90 0.85)
   0.75)


;; ============================================================
;; CASE 2: INCOMPLETE / UNCERTAIN EVIDENCE
;; ============================================================
;;
;; Here both pieces of evidence are weaker.
;;
;; The resulting confidence should therefore be much lower.
;;
;; This demonstrates that PLN does not treat every fact as
;; equally reliable.
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
;; CommunicationLoss can have several possible causes:
;;
;;     PowerFailure
;;     AntennaFailure
;;     RadiationEvent
;;
;; This is an important advantage of probabilistic reasoning:
;; the system does not have to choose one explanation
;; immediately.
;; ------------------------------------------------------------

!(why CommunicationLoss)


;; Also show the same relationships directly from the
;; knowledge base.

!(find-causes CommunicationLoss)


;; ============================================================
;; CASE 4: NEW / CONFLICTING EVIDENCE
;; ============================================================
;;
;; Suppose one source supports a proposition with:
;;
;;     strength = 0.70
;;     confidence = 0.50
;;
;; and a second source supports it with:
;;
;;     strength = 0.95
;;     confidence = 0.75
;;
;; Revision combines the evidence instead of simply replacing
;; the old belief.
;; ------------------------------------------------------------

!(revision
   (STV 0.70 0.50)
   (STV 0.95 0.75))


;; ============================================================
;; CASE 5: MULTI-STEP INFERENCE
;; ============================================================
;;
;; This demonstrates confidence degradation through a chain.
;;
;; Step 1:
;;
;;     BatteryFailure
;;          -> PowerFluctuation
;;
;; Step 2:
;;
;;     PowerFluctuation
;;          -> CommunicationLoss
;;
;; The output of step 1 becomes the evidence used in step 2.
;;
;; This demonstrates that uncertainty propagates through
;; multiple inference steps.
;; ============================================================


;; -------------------------
;; Step 1
;; -------------------------

!(forward-step
   (Evidence
      BatteryFailure
      (STV 0.90 0.85))

   (Implication
      BatteryFailure
      PowerFluctuation
      (STV 0.90 0.85)))


;; -------------------------
;; Step 2
;; -------------------------
;;
;; We use the resulting STV from step 1:
;;
;;     <0.81, 0.585225>
;;
;; as the evidence for the next inference.
;; ------------------------------------------------------------

!(simple-deduction
   (STV 0.81 0.585225)
   (STV 0.80 0.75))