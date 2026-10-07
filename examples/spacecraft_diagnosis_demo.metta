;; ============================================================
;; SPACECRAFT DIAGNOSIS DEMONSTRATION
;; ============================================================
;;
;; This demonstration shows how the complete PLN system can
;; reason about a spacecraft anomaly.
;;
;; Scenario:
;;
;; A spacecraft reports:
;;
;;   - Battery voltage drop
;;   - Power fluctuation
;;   - Communication loss
;;
;; The PLN engine should:
;;
;;   1. Retrieve the observations.
;;   2. Adjust evidence using sensor reliability.
;;   3. Identify possible causes.
;;   4. Perform forward reasoning.
;;   5. Perform backward reasoning.
;;   6. Show how confidence decreases through inference.
;; ============================================================

!(import! &self "main")


;; ============================================================
;; STEP 1: OBSERVED BATTERY VOLTAGE DROP
;; ============================================================

!(get-evidence BatteryVoltageDrop)


;; ============================================================
;; STEP 2: CHECK BATTERY SENSOR RELIABILITY
;; ============================================================

!(sensor-reliability BatteryVoltageSensor)


;; ============================================================
;; STEP 3: ADJUST THE OBSERVATION USING SENSOR RELIABILITY
;; ============================================================
;;
;; Raw observation:
;;     STV <0.92, 0.80>
;;
;; Sensor reliability:
;;     STV <0.95, 0.90>
;;
;; The confidence is adjusted using both values.
;; ------------------------------------------------------------

!(sensor-adjusted-evidence
   (STV 0.92 0.80)
   (STV 0.95 0.90))


;; ============================================================
;; STEP 4: FIND POSSIBLE CAUSES OF COMMUNICATION LOSS
;; ============================================================
;;
;; CommunicationLoss has several possible explanations.
;; ------------------------------------------------------------

!(diagnose CommunicationLoss)


;; ============================================================
;; STEP 5: BACKWARD REASONING
;; ============================================================
;;
;; Ask:
;;
;;     "Why is communication being lost?"
;;
;; The engine searches for causes of CommunicationLoss.
;; ------------------------------------------------------------

!(why CommunicationLoss)


;; ============================================================
;; STEP 6: FORWARD REASONING
;; ============================================================
;;
;; Suppose BatteryFailure has evidence:
;;
;;     STV <0.90, 0.85>
;;
;; and:
;;
;;     BatteryFailure -> PowerFluctuation
;;
;; with:
;;
;;     STV <0.90, 0.85>
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


;; ============================================================
;; STEP 7: CONTINUE THE INFERENCE CHAIN
;; ============================================================
;;
;; The first step produced:
;;
;;     PowerFluctuation <0.81, 0.585225>
;;
;; Now infer:
;;
;;     PowerFluctuation -> CommunicationLoss
;;
;; ------------------------------------------------------------

!(simple-deduction
   (STV 0.81 0.585225)
   (STV 0.80 0.75))


;; ============================================================
;; STEP 8: FOLLOW THE CHAIN TO MISSION RISK
;; ============================================================
;;
;; CommunicationLoss -> MissionRisk
;;
;; The lower-confidence result from the previous step is
;; propagated again.
;; ------------------------------------------------------------

!(simple-deduction
   (STV 0.648 0.28441935000000007)
   (STV 0.90 0.85))


;; ============================================================
;; END OF DEMONSTRATION
;; ============================================================
;;
;; This demonstrates the central PLN idea:
;;
;;     uncertain evidence
;;          ↓
;;     probabilistic inference
;;          ↓
;;     new uncertain knowledge
;;          ↓
;;     further inference
;;          ↓
;;     decreasing confidence as uncertainty propagates
;;
;; At the same time, backward reasoning can search for
;; alternative explanations instead of assuming a single cause.
;; ============================================================