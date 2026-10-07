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
;;  10. Multi-step inference
;; ============================================================

!(import! &self "../src/main.metta")


;; ============================================================
;; 1. DIAGNOSIS
;; ============================================================
;;
;; Find possible causes of CommunicationLoss.

!(diagnose CommunicationLoss)


;; ============================================================
;; 2. FORWARD PREDICTION
;; ============================================================
;;
;; Find consequences of PowerFailure.

!(predict PowerFailure)


;; ============================================================
;; 3. BACKWARD REASONING
;; ============================================================
;;
;; Ask what could cause CommunicationLoss.

!(why CommunicationLoss)


;; ============================================================
;; 4. DEDUCTION
;; ============================================================
;;
;; A -> B and B -> C
;; therefore A -> C.

!(deduction
   (STV 0.98 0.92)
   0.90
   (STV 0.95 0.88)
   0.95)


;; ============================================================
;; 5. INDUCTION
;; ============================================================
;;
;; Repeated observations are used to form a candidate
;; general relationship.

!(induction
   (STV 0.95 0.85)
   (STV 0.90 0.80)
   0.70
   0.80
   0.75)


;; ============================================================
;; 6. ABDUCTION
;; ============================================================
;;
;; Given two possible relationships to an observation,
;; generate a candidate explanation.

!(abduction
   (STV 0.99 0.95)
   (STV 0.92 0.88)
   0.60
   0.80)


;; ============================================================
;; 7. REVISION
;; ============================================================
;;
;; Combine two independent pieces of evidence about the
;; same proposition.

!(revision
   (STV 0.70 0.50)
   (STV 0.95 0.75))


;; ============================================================
;; 8. SENSOR EVIDENCE
;; ============================================================
;;
;; Retrieve evidence for BatteryVoltageDrop.

!(get-evidence BatteryVoltageDrop)


;; ============================================================
;; 9. SENSOR RELIABILITY
;; ============================================================
;;
;; Retrieve the reliability of the battery voltage sensor.

!(sensor-reliability BatteryVoltageSensor)


;; ============================================================
;; 10. SENSOR-ADJUSTED EVIDENCE
;; ============================================================
;;
;; Combine an observation's confidence with the confidence
;; of the sensor that produced it.

!(sensor-adjusted-evidence
   (STV 0.92 0.80)
   (STV 0.95 0.90))


;; ============================================================
;; 11. MULTI-STEP INFERENCE
;; ============================================================
;;
;; Step 1:
;;
;; BatteryFailure -> PowerFluctuation
;;
;; Evidence:
;; BatteryFailure <0.90, 0.85>
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
;; Step 2:
;;
;; PowerFluctuation -> CommunicationLoss
;;
;; The STV produced by step 1 is used as the evidence for
;; the second inference.
;; ------------------------------------------------------------

!(simple-deduction
   (STV 0.81 0.585225)
   (STV 0.80 0.75))