!(import! &self "../src/knowledge_base.metta")
!(import! &self "../src/sensor_evidence.metta")

!(get-sensor-reliability BatteryVoltageSensor)

!(sensor-adjusted-evidence
   (STV 0.92 0.80)
   (STV 0.95 0.90))