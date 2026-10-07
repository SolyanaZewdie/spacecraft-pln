# Probabilistic Logic Network for Spacecraft Anomaly Diagnosis

A domain-specific Probabilistic Logic Network (PLN) implemented in MeTTa using OpenCog Hyperon for reasoning about spacecraft anomalies under uncertain evidence.

## 1. Project Overview

Spacecraft systems generate information from multiple sensors and monitoring systems. These observations are not always completely reliable: sensors can be noisy, evidence can be incomplete, and the same anomaly can have several possible causes.

This project applies **Probabilistic Logic Networks (PLN)** to spacecraft anomaly diagnosis.

Instead of treating every statement as simply true or false, the system represents beliefs using **Subjective Truth Values (STVs)**:

```text
STV = <strength, confidence>
```

where:

* **strength** represents the estimated degree of belief in a statement.
* **confidence** represents how much supporting evidence exists for that belief.

The system combines symbolic relationships with uncertainty-aware inference.

## 2. Objectives

The project implements a small PLN reasoning engine capable of:

* Representing domain knowledge in a hypergraph-oriented knowledge base.
* Representing uncertain information using STVs.
* Performing PLN deduction.
* Performing PLN induction.
* Performing PLN abduction.
* Revising beliefs when new evidence arrives.
* Performing forward chaining.
* Performing backward reasoning.
* Incorporating sensor reliability into observations.
* Diagnosing spacecraft anomalies with multiple possible causes.
* Demonstrating confidence degradation through multi-step reasoning.

## 3. Domain

The selected domain is **Spacecraft Anomaly Diagnosis**.

### Causes

The knowledge base includes causes such as:

* BatteryFailure
* PowerFailure
* AntennaFailure
* ThermalFailure
* RadiationEvent
* VoltageSensorFailure
* ThermalSensorFailure

### Observations

The system represents observations including:

* BatteryVoltageDrop
* PowerFluctuation
* HighTemperature
* CommunicationLoss
* RadiationSpike

### Consequences

The knowledge base also represents:

* SystemDegradation
* CommunicationFailure
* MissionRisk

### Example relationships

```text
BatteryFailure
    -> BatteryVoltageDrop

BatteryFailure
    -> PowerFluctuation

PowerFailure
    -> PowerFluctuation

PowerFailure
    -> CommunicationLoss

AntennaFailure
    -> CommunicationLoss

RadiationEvent
    -> CommunicationLoss

CommunicationLoss
    -> MissionRisk
```

This allows the system to reason in both directions.

For example:

```text
BatteryFailure
    -> PowerFluctuation
    -> CommunicationLoss
    -> MissionRisk
```

can be used for forward reasoning, while:

```text
MissionRisk
    <- CommunicationLoss
    <- PowerFailure
```

can be used for backward reasoning.

## 4. PLN Components

### Subjective Truth Values

The system represents uncertain knowledge using:

```text
STV <strength, confidence>
```

Evidence weight is related to confidence by:

```text
w = c / (1-c)
```

and:

```text
c = w / (w+1)
```

### Deduction

Deduction derives a consequence from an existing chain of implications.

Conceptually:

```text
A -> B
B -> C
---------
A -> C
```

The implementation includes both the full PLN deduction formula and a simplified deduction operation used during chaining.

### Induction

Induction generates a candidate generalization from shared observations.

Conceptually:

```text
C -> A
C -> B
---------
A -> B
```

The result is treated as a hypothesis rather than a certainty.

### Abduction

Abduction searches for a possible explanation.

Conceptually:

```text
A -> C
B -> C
---------
A -> B
```

The result represents a candidate explanation, not proof.

### Revision

Revision combines independent evidence about the same proposition.

For example:

```text
Evidence 1: <0.70, 0.50>
Evidence 2: <0.95, 0.75>
```

produces:

```text
<0.8875, 0.80>
```

The more reliable evidence receives greater weight.

## 5. Reasoning

### Forward chaining

Forward reasoning starts with known evidence and follows implications toward consequences.

Example:

```text
BatteryFailure
      |
      v
PowerFluctuation
      |
      v
CommunicationLoss
      |
      v
MissionRisk
```

As inference continues, uncertainty propagates through the chain.

### Backward chaining

Backward reasoning starts with a query and searches for possible causes.

For:

```text
CommunicationLoss
```

the system finds:

```text
PowerFailure
AntennaFailure
RadiationEvent
```

The system therefore preserves multiple explanations instead of immediately selecting one cause.

## 6. Sensor Evidence

Sensor reliability is explicitly represented.

For example:

```text
BatteryVoltageSensor
    STV <0.95, 0.90>
```

An observation such as:

```text
BatteryVoltageDrop
    STV <0.92, 0.80>
```

can be adjusted using the sensor reliability.

The current implementation multiplies the observation confidence by the sensor confidence:

```text
0.80 × 0.90 = 0.72
```

resulting in:

```text
STV <0.92, 0.72>
```

## 7. Project Structure

```text
spacecraft-pln/
│
├── src/
│   ├── stv.metta
│   ├── knowledge_base.metta
│   ├── deduction.metta
│   ├── induction.metta
│   ├── abduction.metta
│   ├── chaining.metta
│   ├── sensor_evidence.metta
│   ├── diagnosis.metta
│   └── main.metta
│
├── tests/
│   ├── test_stv.metta
│   ├── test_deduction.metta
│   ├── test_induction.metta
│   ├── test_abduction.metta
│   ├── test_chaining.metta
│   ├── test_diagnosis.metta
│   ├── test_sensor_evidence.metta
│   ├── test_backward.metta
│   ├── test_evaluation.metta
│   ├── test_edge_cases.metta
│   ├── test_integration.metta
│   └── test_pln.metta
│
├── examples/
│   ├── spacecraft_cases.metta
│   ├── evaluation_cases.metta
│   └── spacecraft_diagnosis_demo.metta
│
├── README
└── technical_report.md
```

## 8. Evaluation

The system was evaluated using five required scenarios.

### 1. Strong evidence

```text
(STV 0.96 0.90)
(STV 0.90 0.85)
```

produced:

```text
(STV 0.87 0.66096)
```

### 2. Uncertain evidence

Weaker premises:

```text
(STV 0.60 0.40)
(STV 0.70 0.50)
```

produced:

```text
(STV 0.62 0.084)
```

The substantially lower confidence demonstrates uncertainty propagation.

### 3. Multiple explanations

For `CommunicationLoss`, the system returns:

```text
PowerFailure
AntennaFailure
RadiationEvent
```

### 4. Conflicting evidence

Revision of:

```text
(STV 0.70 0.50)
(STV 0.95 0.75)
```

produced:

```text
(STV 0.8875 0.8)
```

### 5. Multi-step inference

The chain:

```text
BatteryFailure
    -> PowerFluctuation
    -> CommunicationLoss
    -> MissionRisk
```

produced progressively lower confidence:

```text
PowerFluctuation
<0.81, 0.585225>

CommunicationLoss
<0.648, 0.284419>

MissionRisk
<0.5832, 0.140992>
```

This demonstrates confidence degradation as uncertain information propagates through several inference steps.

## 9. Edge Cases

Additional testing demonstrated that:

* Very weak evidence produces very low confidence.
* Strong evidence produces high-confidence conclusions.
* Conflicting evidence can be revised.
* Higher-confidence evidence receives greater weight during revision.
* Longer inference chains progressively reduce confidence.
* Multiple explanations can coexist.
* Unknown observations do not cause the system to invent explanations.

For an unknown observation:

```text
(why UnknownObservation)
```

the system produces:

```text
(no results)
```

rather than fabricating a cause.

## 10. Implementation Technology

The project uses:

* **MeTTa**
* **OpenCog Hyperon**
* Hypergraph-oriented knowledge representation
* Subjective Truth Values
* Symbolic probabilistic inference

The implementation was intentionally kept focused on PLN rather than introducing unrelated machine-learning or quantum-computing components.

## 11. Limitations

This is a small educational PLN implementation rather than a complete industrial spacecraft diagnosis system.

Current limitations include:

* The knowledge base is manually constructed.
* The sensor-adjustment model is simplified.
* Chaining is currently demonstrated on controlled inference paths.
* Attention mechanisms such as ECAN are not implemented.
* The system does not learn its knowledge base automatically from real spacecraft telemetry.
* The diagnostic scores are simplified and should not be interpreted as calibrated real-world probabilities.

These limitations leave room for future work.

## 12. Future Work

Possible extensions include:

* Larger spacecraft knowledge bases.
* Automated knowledge extraction from telemetry.
* More sophisticated sensor reliability models.
* Full multi-hop backward reasoning.
* Attention/resource management using ECAN.
* More advanced PLN inference rules.
* Comparison with probabilistic graphical models.
* Evaluation using real or simulated spacecraft anomaly datasets.

## 13. Main Demonstration

The complete spacecraft scenario can be run from:

```text
examples/spacecraft_diagnosis_demo.metta
```

The integration tests can be run from:

```text
tests/test_integration.metta
```

and the edge-case tests from:

```text
tests/test_edge_cases.metta
```

## 14. Conclusion

This project demonstrates how Probabilistic Logic Networks can combine symbolic relationships with uncertainty for spacecraft anomaly diagnosis.

Rather than representing knowledge as simply true or false, the system attaches uncertainty to relationships and propagates that uncertainty during reasoning.

The resulting engine can:

```text
Represent uncertain knowledge
        ↓
Apply probabilistic inference
        ↓
Generate new uncertain knowledge
        ↓
Chain additional inferences
        ↓
Diagnose possible causes
```

The implementation therefore demonstrates the central PLN idea: **reasoning over structured knowledge while explicitly representing uncertainty in the evidence supporting that knowledge.**
