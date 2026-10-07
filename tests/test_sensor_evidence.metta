!(import! &self "knowledge_base")
!(import! &self "sensor_evidence")

!(get-sensor-reliability BatteryVoltageSensor)

!(sensor-adjusted-evidence
   (STV 0.92 0.80)
   (STV 0.95 0.90))