;; ============================================================
;; SPACECRAFT PLN ENGINE
;; ============================================================
;;
;; This is the main entry point for the spacecraft anomaly
;; diagnosis system.
;;
;; It imports all PLN components and exposes higher-level
;; functions that can be used by the user or test files.
;;
;; Main capabilities:
;;
;;   diagnose
;;       Find possible causes of an observation.
;;
;;   predict
;;       Find consequences of a cause.
;;
;;   why
;;       Perform backward reasoning for an observation.
;;
;;   get-evidence
;;       Retrieve direct evidence for an observation.
;;
;;   sensor-reliability
;;       Retrieve the reliability information of a sensor.
;; ============================================================


;; ============================================================
;; IMPORT PLN COMPONENTS
;; ============================================================

!(import! &self "stv")
!(import! &self "knowledge_base")
!(import! &self "deduction")
!(import! &self "induction")
!(import! &self "abduction")
!(import! &self "chaining")
!(import! &self "sensor_evidence")
!(import! &self "diagnosis")


;; ============================================================
;; DIAGNOSIS
;; ============================================================

;; ------------------------------------------------------------
;; Find possible causes of an observation.
;;
;; Example:
;;
;;     (diagnose CommunicationLoss)
;;
;; returns diagnostic candidates including:
;;
;;     PowerFailure
;;     AntennaFailure
;;     RadiationEvent
;;
;; together with their prior probabilities and causal
;; implications.
;; ------------------------------------------------------------

(= (diagnose $observation)
   (diagnostic-candidate $observation))


;; ============================================================
;; FORWARD PREDICTION
;; ============================================================

;; ------------------------------------------------------------
;; Find direct consequences of a cause.
;;
;; Example:
;;
;;     (predict PowerFailure)
;;
;; can return:
;;
;;     PowerFailure -> PowerFluctuation
;;     PowerFailure -> CommunicationLoss
;; ------------------------------------------------------------

(= (predict $cause)
   (find-consequences $cause))


;; ============================================================
;; BACKWARD REASONING
;; ============================================================

;; ------------------------------------------------------------
;; Ask "why?" about an observation.
;;
;; This performs one-step backward reasoning and returns
;; possible causes.
;;
;; Example:
;;
;;     (why CommunicationLoss)
;;
;; means:
;;
;;     "What could cause CommunicationLoss?"
;; ------------------------------------------------------------

(= (why $observation)
   (backward-step $observation))


;; ------------------------------------------------------------
;; Show backward paths.
;;
;; Example:
;;
;;     (why-path MissionRisk)
;;
;; returns the direct relationship that could explain
;; MissionRisk.
;; ------------------------------------------------------------

(= (why-path $observation)
   (backward-chain $observation))


;; ============================================================
;; EVIDENCE
;; ============================================================

;; ------------------------------------------------------------
;; Retrieve direct evidence associated with an observation.
;;
;; Example:
;;
;;     (get-evidence BatteryVoltageDrop)
;;
;; returns:
;;
;;     Evidence BatteryVoltageDrop (STV ...)
;; ------------------------------------------------------------

(= (get-evidence $observation)
   (match &self
      (Evidence $observation $stv)
      (Evidence $observation $stv)))


;; ============================================================
;; SENSOR RELIABILITY
;; ============================================================

;; ------------------------------------------------------------
;; Retrieve the reliability information for a sensor.
;;
;; Example:
;;
;;     (sensor-reliability BatteryVoltageSensor)
;;
;; returns the stored reliability STV.
;; ------------------------------------------------------------

(= (sensor-reliability $sensor)
   (get-sensor-reliability $sensor))