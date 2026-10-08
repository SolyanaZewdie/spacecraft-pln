# Spacecraft Anomaly Diagnosis with Probabilistic Logic Networks (MeTTa)

A mini PLN inference engine in MeTTa (OpenCog Hyperon) that diagnoses spacecraft anomalies from uncertain, possibly conflicting evidence. It implements Simple Truth Values (STV), the four PLN rules (deduction, induction, abduction, revision), and forward and backward chaining over one shared knowledge base.

## 1. Requirements

- Python 3.9+
- OpenCog Hyperon: `pip install hyperon`
  Install Hyperon:

  python -m pip install hyperon

  The installation provides the metta-py command used to run the project.
- Technical Report Link: https://docs.google.com/document/d/1AQxEX-fUR8kmjjcLLzVoEB3KXXwjzq3L32Kk1McpnYw/edit?usp=sharing

2. How to Run

Clone the repository and open a terminal in the project root.

Full demonstration
metta-py examples/spacecraft_diagnosis_demo.metta
Tests
metta-py tests/test_integration.metta
metta-py tests/test_edge_cases.metta
metta-py tests/test_pln.metta

The project uses MeTTa modules under src/. The test and demonstration files import these modules through the project's include path.

If metta-py is not recognized after installation, make sure the Python Scripts directory is available on your system PATH, or run the command through the Python environment in which Hyperon was installed.

Every file in `tests/` and `examples/` runs the same way. Each `!(...)` line in a file is one query, and its result is printed in order.

## 3. Project Structure

```text
spacecraft-pln/
├── src/
│   ├── stv.metta              STV type, accessors, weight/confidence conversion, revision
│   ├── knowledge_base.metta   entities, implications, priors, sensors
│   ├── deduction.metta        full and simplified deduction
│   ├── induction.metta
│   ├── abduction.metta
│   ├── chaining.metta         forward chaining, backward chaining
│   ├── sensor_evidence.metta  sensor-adjusted observations
│   ├── diagnosis.metta        candidate causes with priors and implications
│   └── main.metta             entry point; imports everything
├── tests/                     one test file per component, plus evaluation, edge-case and integration tests
├── examples/                  spacecraft_cases.metta, evaluation_cases.metta, spacecraft_diagnosis_demo.metta
├── README.md
└── technical_report.md
```

`main.metta` exposes: `diagnose`, `predict`, `why`, `why-path`, `get-evidence`, `sensor-reliability`.

## 4. Representation

`STV = <strength, confidence>`, written `(STV s c)` in code.

- **strength**: estimated probability that the statement holds.
- **confidence**: how much evidence supports that strength. Evidence weight is `w = c/(1-c)` and `c = w/(w+1)` (K = 1).

Knowledge base entities:

| Type | Entities |
|---|---|
| Causes | BatteryFailure, PowerFailure, AntennaFailure, ThermalFailure, RadiationEvent, VoltageSensorFailure, ThermalSensorFailure |
| Observations | BatteryVoltageDrop, PowerFluctuation, HighTemperature, CommunicationLoss, RadiationSpike |
| Consequences | SystemDegradation, CommunicationFailure, MissionRisk |

All strengths, confidences and priors are hand-assigned for illustration and are not derived from real telemetry.

## 5. Example Queries and Expected Output

Expected values below are the outputs recorded during testing.

### 5.1 Revision (conflicting sensor evidence)

```metta
!(revise (STV 0.70 0.50) (STV 0.95 0.75))
```
Expected: `(STV 0.8875 0.8)`. Weights are 1 and 3, so the second source dominates.

```metta
!(revise (STV 0.90 0.80) (STV 0.10 0.80))
```
Expected: `(STV 0.5 0.888889)`. Equal weights give a midpoint strength; confidence rises because the evidence base grew.

```metta
!(revise (STV 0.90 0.40) (STV 0.20 0.90))
```
Expected: `(STV 0.248276 0.90625)`.

### 5.2 Deduction

```metta
!(deduction (STV 0.96 0.90) (STV 0.90 0.85))
```
Expected: `(STV 0.87 0.66096)`.

```metta
!(deduction (STV 0.60 0.40) (STV 0.70 0.50))
```
Expected: `(STV 0.62 0.084)`. Weak premises give a conclusion with almost no confidence.

### 5.3 Forward chaining (multi-step)

```metta
!(predict BatteryFailure)
```
Expected chain with confidence decaying at each hop:

```text
PowerFluctuation   (STV 0.81   0.585225)
CommunicationLoss  (STV 0.648  0.284419)
MissionRisk        (STV 0.5832 0.140992)
```

### 5.4 Backward chaining (diagnosis)

```metta
!(why CommunicationLoss)
```
Expected: `PowerFailure`, `AntennaFailure`, `RadiationEvent`.

```metta
!(why MissionRisk)
```
Expected: `CommunicationLoss`.

```metta
!(why HighTemperature)
```
Expected: `ThermalFailure`, `ThermalSensorFailure`.

```metta
!(why UnknownObservation)
```
Expected: no results. The system does not invent a cause.

### 5.5 Diagnosis with priors

```metta
!(diagnose CommunicationLoss)
```
Expected candidates (prior, implication):

```text
PowerFailure     prior (0.25, 0.70)  implication (0.95, 0.90)
AntennaFailure   prior (0.15, 0.70)  implication (0.88, 0.82)
RadiationEvent   prior (0.10, 0.70)  implication (0.80, 0.75)
```

### 5.6 Sensor reliability

```metta
!(sensor-reliability BatteryVoltageSensor)
```
Expected: `(STV 0.95 0.90)`.

A `BatteryVoltageDrop` observation of `(STV 0.92 0.80)` read through that sensor becomes `(STV 0.92 0.72)`, because 0.80 × 0.90 = 0.72.

## 6. Test Scenarios

| # | Scenario | Test file | What it shows |
|---|---|---|---|
| 1 | Evidence supports a conclusion | `test_evaluation.metta` | Strong premises give a usable conclusion |
| 2 | Incomplete or uncertain evidence | `test_evaluation.metta` | Confidence collapses (0.084) |
| 3 | Multiple possible explanations | `test_backward.metta` | Three candidate causes kept |
| 4 | Conflicting evidence | `test_edge_cases.metta` | Revision shifts belief toward the stronger source |
| 5 | Multi-step inference | `test_chaining.metta` | Confidence 0.585 → 0.284 → 0.141 |

## 7. Known Limitations

- Knowledge base and truth values are hand-assigned.
- Backward chaining returns direct causes only (one hop) and does not compute truth values.
- `diagnose` lists priors and implications per cause but does not produce a combined ranking.
- Chaining uses simplified deduction (`s_AC = s_AB · s_BC`); the full formula is implemented separately.
- Sensor adjustment multiplies confidences only.
- No attention or resource control (ECAN).
