;; ============================================================================
;; SPACECRAFT KNOWLEDGE BASE
;; ============================================================================
;;
;; This module defines the domain knowledge used by the spacecraft
;; anomaly-diagnosis system.
;;
;; The knowledge base contains:
;;   1. Spacecraft causes
;;   2. Observable symptoms
;;   3. Consequences
;;   4. Sensors and sensor reliability
;;   5. Causal implications
;;   6. Observed evidence
;;   7. Prior beliefs
;;   8. Inheritance relationships
;;
;; All uncertain relationships use Simple Truth Values (STVs):
;;   (STV strength confidence)
;;
;; Strength represents how strongly a relationship holds.
;; Confidence represents how certain we are about that strength.
;; ============================================================================


;; ============================================================================
;; CAUSE TYPES
;; ============================================================================

(Cause BatteryFailure)
(Cause PowerFailure)
(Cause AntennaFailure)
(Cause ThermalFailure)
(Cause RadiationEvent)
(Cause VoltageSensorFailure)
(Cause ThermalSensorFailure)


;; ============================================================================
;; OBSERVATION TYPES
;; ============================================================================

(Observation BatteryVoltageDrop)
(Observation PowerFluctuation)
(Observation HighTemperature)
(Observation CommunicationLoss)
(Observation RadiationSpike)


;; ============================================================================
;; CONSEQUENCE TYPES
;; ============================================================================

(Consequence SystemDegradation)
(Consequence CommunicationFailure)
(Consequence MissionRisk)


;; ============================================================================
;; SENSOR TYPES
;; ============================================================================

(Sensor BatteryVoltageSensor)
(Sensor PowerSensor)
(Sensor ThermalSensor)
(Sensor CommunicationMonitor)
(Sensor RadiationSensor)


;; ============================================================================
;; SENSOR RELIABILITY
;; ============================================================================
;;
;; Each sensor has an STV representing its reliability.
;;
;; Higher strength means the sensor is considered more reliable.
;; Higher confidence means we are more certain about that reliability.
;;
;; These values are used by sensor-adjusted-evidence to reduce the
;; confidence of observations according to sensor reliability.
;; ============================================================================

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


;; ============================================================================
;; CAUSAL IMPLICATIONS
;; ============================================================================
;;
;; An implication has the form:
;;
;;   (Implication Cause Observation STV)
;;
;; The STV describes the uncertain strength and confidence of the
;; causal relationship.
;;
;; Example:
;;
;;   BatteryFailure -> BatteryVoltageDrop
;;
;; means that a battery failure provides evidence for a battery-voltage drop.
;; ============================================================================

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
   PowerFluctuation
   CommunicationLoss
   (STV 0.80 0.75))

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

(Implication
   VoltageSensorFailure
   BatteryVoltageDrop
   (STV 0.30 0.70))

(Implication
   ThermalSensorFailure
   HighTemperature
   (STV 0.25 0.70))


;; ============================================================================
;; OBSERVED EVIDENCE
;; ============================================================================
;;
;; These STVs represent the current evidence observed from spacecraft
;; sensors.
;;
;; They are intentionally domain-specific demonstration values used to
;; exercise uncertain reasoning in the PLN implementation.
;; ============================================================================

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


;; ============================================================================
;; PRIOR BELIEFS
;; ============================================================================
;;
;; Priors represent the initial belief associated with each possible cause
;; before considering a particular observation.
;;
;; These values are synthetic domain assumptions for the demonstration
;; system and are not calibrated spacecraft-failure probabilities.
;; ============================================================================

(Prior
   BatteryFailure
   (STV 0.20 0.70))

(Prior
   PowerFailure
   (STV 0.25 0.70))

(Prior
   AntennaFailure
   (STV 0.15 0.70))

(Prior
   ThermalFailure
   (STV 0.15 0.70))

(Prior
   RadiationEvent
   (STV 0.10 0.70))

(Prior
   VoltageSensorFailure
   (STV 0.05 0.60))

(Prior
   ThermalSensorFailure
   (STV 0.05 0.60))


;; ============================================================================
;; INHERITANCE RELATIONSHIPS
;; ============================================================================
;;
;; These relationships organize causes into higher-level anomaly classes.
;;
;; They are currently represented as knowledge-organization relationships
;; rather than being used directly by the numerical inference functions.
;; ============================================================================

(Inheritance
   BatteryFailure
   PowerSystemAnomaly)

(Inheritance
   PowerFailure
   PowerSystemAnomaly)

(Inheritance
   AntennaFailure
   CommunicationAnomaly)

(Inheritance
   ThermalFailure
   ThermalAnomaly)

(Inheritance
   RadiationEvent
   EnvironmentalAnomaly)

(Inheritance
   VoltageSensorFailure
   SensorAnomaly)

(Inheritance
   ThermalSensorFailure
   SensorAnomaly)