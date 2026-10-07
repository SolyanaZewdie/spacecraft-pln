;; ============================================================
;; SPACECRAFT ANOMALY DIAGNOSIS KNOWLEDGE BASE
;; ============================================================

;; ------------------------------------------------------------
;; CAUSES
;; ------------------------------------------------------------

(Cause BatteryFailure)
(Cause PowerFailure)
(Cause AntennaFailure)
(Cause ThermalFailure)
(Cause RadiationEvent)
(Cause VoltageSensorFailure)
(Cause ThermalSensorFailure)


;; ------------------------------------------------------------
;; OBSERVATIONS
;; ------------------------------------------------------------

(Observation BatteryVoltageDrop)
(Observation PowerFluctuation)
(Observation HighTemperature)
(Observation CommunicationLoss)
(Observation RadiationSpike)


;; ------------------------------------------------------------
;; CONSEQUENCES
;; ------------------------------------------------------------

(Consequence SystemDegradation)
(Consequence CommunicationFailure)
(Consequence MissionRisk)


;; ------------------------------------------------------------
;; SENSOR SOURCES
;; ------------------------------------------------------------

(Sensor BatteryVoltageSensor)
(Sensor PowerSensor)
(Sensor ThermalSensor)
(Sensor CommunicationMonitor)
(Sensor RadiationSensor)


;; ------------------------------------------------------------
;; SENSOR RELIABILITY
;;
;; These values represent the reliability of the sensor
;; producing the corresponding observation.
;; ------------------------------------------------------------

(SensorReliability
   BatteryVoltageSensor
   (STV 0.95 0.90))

(SensorReliability
   PowerSensor
   (STV 0.90 0.85))

(SensorReliability
   ThermalSensor
   (STV 0.92 0.88))

(SensorReliability
   CommunicationMonitor
   (STV 0.97 0.92))

(SensorReliability
   RadiationSensor
   (STV 0.85 0.75))


;; ------------------------------------------------------------
;; CAUSAL IMPLICATIONS
;; ------------------------------------------------------------

(Implication
   BatteryFailure
   BatteryVoltageDrop
   (STV 0.96 0.90))

(Implication
   BatteryFailure
   PowerFluctuation
   (STV 0.90 0.85))

(Implication
   PowerFailure
   PowerFluctuation
   (STV 0.92 0.88))

(Implication
   PowerFailure
   CommunicationLoss
   (STV 0.95 0.90))

(Implication
   AntennaFailure
   CommunicationLoss
   (STV 0.88 0.82))

(Implication
   RadiationEvent
   CommunicationLoss
   (STV 0.80 0.75))

(Implication
   RadiationEvent
   RadiationSpike
   (STV 0.97 0.95))

(Implication
   ThermalFailure
   HighTemperature
   (STV 0.98 0.92))

(Implication
   CommunicationLoss
   MissionRisk
   (STV 0.90 0.85))


;; ------------------------------------------------------------
;; SENSOR FAILURE RELATIONSHIPS
;;
;; These prevent the model from assuming that every anomaly
;; necessarily comes from the physical subsystem itself.
;; ------------------------------------------------------------

(Implication
   VoltageSensorFailure
   BatteryVoltageDrop
   (STV 0.30 0.70))

(Implication
   ThermalSensorFailure
   HighTemperature
   (STV 0.25 0.70))


;; ------------------------------------------------------------
;; OBSERVED EVIDENCE
;; ------------------------------------------------------------

(Evidence
   BatteryVoltageDrop
   (STV 0.92 0.80))

(Evidence
   PowerFluctuation
   (STV 0.75 0.65))

(Evidence
   CommunicationLoss
   (STV 0.85 0.78))

(Evidence
   HighTemperature
   (STV 0.70 0.60))

(Evidence
   RadiationSpike
   (STV 0.40 0.45))


;; ------------------------------------------------------------
;; PRIOR BELIEFS
;;
;; These are used when ranking possible explanations.
;; They represent the prior likelihood of each cause before
;; considering the current observation.
;; ------------------------------------------------------------

(Prior BatteryFailure
   (STV 0.20 0.70))

(Prior PowerFailure
   (STV 0.25 0.70))

(Prior AntennaFailure
   (STV 0.15 0.70))

(Prior ThermalFailure
   (STV 0.15 0.70))

(Prior RadiationEvent
   (STV 0.10 0.70))

(Prior VoltageSensorFailure
   (STV 0.05 0.60))

(Prior ThermalSensorFailure
   (STV 0.05 0.60))


;; ------------------------------------------------------------
;; INHERITANCE RELATIONSHIPS
;; ------------------------------------------------------------

(InheritanceLink
   BatteryFailure
   PowerSystemAnomaly)

(InheritanceLink
   PowerFailure
   PowerSystemAnomaly)

(InheritanceLink
   AntennaFailure
   CommunicationAnomaly)

(InheritanceLink
   ThermalFailure
   ThermalAnomaly)

(InheritanceLink
   RadiationEvent
   EnvironmentalAnomaly)

(InheritanceLink
   VoltageSensorFailure
   SensorAnomaly)

(InheritanceLink
   ThermalSensorFailure
   SensorAnomaly)