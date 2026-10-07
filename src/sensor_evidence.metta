;; ============================================================
;; SENSOR EVIDENCE
;; ============================================================

;; ------------------------------------------------------------
;; Combine an observation's raw evidence with sensor reliability.
;;
;; Effective confidence:
;; observation confidence × sensor reliability confidence
;; ------------------------------------------------------------
!(import! &self "knowledge_base")

;; ============================================================
;; SENSOR EVIDENCE
;; ============================================================
(= (sensor-adjusted-evidence
      (STV $sObservation $cObservation)
      (STV $sSensor $cSensor))

   (STV
      $sObservation
      (* $cObservation $cSensor)))

;; ------------------------------------------------------------
;; Retrieve sensor reliability
;; ------------------------------------------------------------

(= (get-sensor-reliability $sensor)
   (match &self
      (SensorReliability $sensor $stv)
      (SensorReliability $sensor $stv)))