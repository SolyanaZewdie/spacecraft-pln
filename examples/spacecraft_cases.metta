;; ============================================================
;; SPACECRAFT ANOMALY DIAGNOSIS
;; EXAMPLE CASES
;; ============================================================
;;
;; These cases demonstrate how PLN handles uncertainty,
;; competing explanations, conflicting evidence, and
;; multi-step reasoning.
;;
;; ============================================================


;; ============================================================
;; CASE 1: BATTERY ANOMALY
;; ============================================================
;;
;; Observations:
;;     Battery voltage is dropping.
;;     Power is fluctuating.
;;
;; Possible explanation:
;;     BatteryFailure
;;
;; Reasoning:
;;
;;     BatteryFailure
;;          ↓
;;     PowerFluctuation
;;          ↓
;;     CommunicationLoss
;;
;; ============================================================
;; ============================================================
;; SPACECRAFT DIAGNOSTIC CASES
;; ============================================================

!(import! &self "../src/main.metta")

;; ============================================================
;; CASE 1 — Strong evidence
;; ============================================================

;; Strong battery voltage-drop evidence
!(get-evidence BatteryVoltageDrop)

;; BatteryFailure is a strong cause of voltage drop
!(match &self
   (Implication BatteryFailure BatteryVoltageDrop $stv)
   (Implication BatteryFailure BatteryVoltageDrop $stv))

;; ============================================================
;; CASE 2 — Uncertain evidence
;; ============================================================

;; Radiation spike has weak/uncertain evidence
!(get-evidence RadiationSpike)

;; Possible causes of communication loss
!(diagnose CommunicationLoss)

;; ============================================================
;; CASE 3 — Multiple explanations
;; ============================================================

;; CommunicationLoss can have multiple causes
!(find-causes CommunicationLoss)

;; ============================================================
;; CASE 4 — Conflicting evidence
;; ============================================================

;; Combine two independent beliefs
!(revision
   (STV 0.70 0.50)
   (STV 0.95 0.75))

;; ============================================================
;; CASE 5 — Multi-step inference
;; ============================================================

;; BatteryFailure -> PowerFluctuation
!(forward-step
   (Evidence BatteryFailure (STV 0.90 0.85))
   (Implication
      BatteryFailure
      PowerFluctuation
      (STV 0.90 0.85)))

;; PowerFluctuation -> CommunicationLoss
!(forward-step
   (Evidence PowerFluctuation (STV 0.81 0.585225))
   (Implication
      PowerFluctuation
      CommunicationLoss
      (STV 0.80 0.75)))