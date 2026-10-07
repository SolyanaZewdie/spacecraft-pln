;; ============================================================
;; BACKWARD REASONING TESTS
;; ============================================================
;;
;; These tests verify that the PLN engine can reason backward
;; from an observed consequence to possible causes.
;; ============================================================

!(import! &self "main")


;; ============================================================
;; ONE-STEP BACKWARD REASONING
;; ============================================================

;; CommunicationLoss has multiple possible causes.

!(why CommunicationLoss)


;; MissionRisk has CommunicationLoss as a direct cause.

!(why MissionRisk)


;; HighTemperature has two possible causes:
;; ThermalFailure and ThermalSensorFailure.

!(why HighTemperature)


;; ============================================================
;; BACKWARD PATHS
;; ============================================================

!(why-path CommunicationLoss)

!(why-path MissionRisk)

!(why-path PowerFluctuation)