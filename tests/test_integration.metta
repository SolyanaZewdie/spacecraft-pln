;; ============================================================
;; PLN INTEGRATION TEST
;; Spacecraft Anomaly Diagnosis
;; ============================================================

;;
;; This test verifies that the major components of the PLN
;; system work together through the main interface.
;;
;; Components tested:
;;
;;   1. Diagnosis
;;   2. Forward prediction
;;   3. Backward reasoning
;;   4. Deduction
;;   5. Induction
;;   6. Abduction
;;   7. Revision
;;   8. Sensor evidence
;;   9. Sensor reliability
;;  10. Automatic multi-step forward chaining
;; ============================================================

!(import! &self "main")


;; ============================================================
;; 1. DIAGNOSIS
;; ============================================================

!(diagnose CommunicationLoss)


;; ============================================================
;; 2. FORWARD PREDICTION
;; ============================================================

!(predict PowerFailure)


;; ============================================================
;; 3. BACKWARD REASONING
;; ============================================================

!(why CommunicationLoss)


;; ============================================================
;; 4. DEDUCTION
;; ============================================================

!(deduction
   (STV 0.98 0.92)
   0.90
   (STV 0.95 0.88)
   0.95)


;; ============================================================
;; 5. INDUCTION
;; ============================================================

!(induction
   (STV 0.95 0.85)
   (STV 0.90 0.80)
   0.70
   0.80
   0.75)


;; ============================================================
;; 6. ABDUCTION
;; ============================================================

!(abduction
   (STV 0.99 0.95)
   (STV 0.92 0.88)
   0.60
   0.80)


;; ============================================================
;; 7. REVISION
;; ============================================================

!(revision
   (STV 0.70 0.50)
   (STV 0.95 0.75))


;; ============================================================
;; 8. SENSOR EVIDENCE
;; ============================================================

!(get-evidence BatteryVoltageDrop)


;; ============================================================
;; 9. SENSOR RELIABILITY
;; ============================================================

!(sensor-reliability BatteryVoltageSensor)


;; ============================================================
;; 10. SENSOR-ADJUSTED EVIDENCE
;; ============================================================

!(sensor-adjusted-evidence
   (STV 0.92 0.80)
   (STV 0.95 0.90))


;; ============================================================
;; 11. AUTOMATIC MULTI-STEP FORWARD CHAINING
;; ============================================================
;;
;; BatteryFailure
;;      |
;;      |  <0.90, 0.85>
;;      v
;; PowerFluctuation
;;      |
;;      |  <0.80, 0.75>
;;      v
;; CommunicationLoss
;;
;; The STV for PowerFluctuation is calculated internally
;; and automatically passed to the second inference.
;;
;; No intermediate STV is hardcoded in this test.
;; ============================================================

!(forward-chain-2

   (Evidence
      BatteryFailure
      (STV 0.90 0.85))

   (Implication
      BatteryFailure
      PowerFluctuation
      (STV 0.90 0.85))

   (Implication
      PowerFluctuation
      CommunicationLoss
      (STV 0.80 0.75)))