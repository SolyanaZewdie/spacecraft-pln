!(import! &self "../src/main.metta")

!(diagnose CommunicationLoss)

!(predict PowerFailure)

!(get-evidence BatteryVoltageDrop)