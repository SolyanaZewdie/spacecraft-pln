# Probabilistic Logic Network for Spacecraft Anomaly Diagnosis Under Uncertain Evidence

## 1. Introduction

Probabilistic Logic Networks (PLN) provide a framework for combining symbolic reasoning with uncertainty. Traditional logical systems generally represent propositions as true or false, while probabilistic systems represent uncertainty numerically but often rely on predefined structures such as Bayesian networks.

PLN combines these ideas by attaching uncertainty-aware truth values to structured relationships.

This project implements a domain-specific PLN reasoning engine for **spacecraft anomaly diagnosis** using **MeTTa and OpenCog Hyperon**.

The system represents spacecraft observations, possible causes, consequences, sensor reliability, and prior beliefs in a structured knowledge base. It then applies PLN inference rules to derive new knowledge while tracking the uncertainty associated with each inference.

---

## 2. Objectives

The main objectives were:

1. Represent spacecraft domain knowledge using structured relations.
2. Implement Subjective Truth Values.
3. Implement PLN deduction.
4. Implement PLN induction.
5. Implement PLN abduction.
6. Implement PLN revision.
7. Implement forward chaining.
8. Implement backward reasoning.
9. Represent sensor reliability.
10. Demonstrate diagnosis under uncertain and conflicting evidence.
11. Evaluate uncertainty propagation across multiple inference steps.

---

## 3. Domain Model

The selected domain is spacecraft anomaly diagnosis because it naturally contains uncertain observations, multiple possible causes, conflicting evidence, and multi-step causal relationships.

### 3.1 Causes

The knowledge base contains:

* BatteryFailure
* PowerFailure
* AntennaFailure
* ThermalFailure
* RadiationEvent
* VoltageSensorFailure
* ThermalSensorFailure

### 3.2 Observations

The main observations are:

* BatteryVoltageDrop
* PowerFluctuation
* HighTemperature
* CommunicationLoss
* RadiationSpike

### 3.3 Consequences

The system represents:

* SystemDegradation
* CommunicationFailure
* MissionRisk

### 3.4 Causal Relationships

Examples include:

```text
BatteryFailure -> BatteryVoltageDrop
BatteryFailure -> PowerFluctuation
PowerFailure -> PowerFluctuation
PowerFailure -> CommunicationLoss
AntennaFailure -> CommunicationLoss
RadiationEvent -> CommunicationLoss
ThermalFailure -> HighTemperature
CommunicationLoss -> MissionRisk
```

Sensor failures are also represented as possible alternative explanations for observations.

---

## 4. Subjective Truth Values

The core representation of uncertainty is:

```text
STV = <strength, confidence>
```

Strength represents the estimated degree to which a proposition is believed to hold.

Confidence represents the amount or reliability of evidence supporting that belief.

For example:

```text
(STV 0.92 0.80)
```

represents a proposition with strength 0.92 and confidence 0.80.

### 4.1 Evidence Weight

The implementation uses:

```text
w = c / (1-c)
```

and:

```text
c = w / (w+1)
```

These transformations allow confidence values to be interpreted as evidence weights during revision.

### 4.2 Revision

Revision combines independent evidence concerning the same proposition.

For two STVs:

```text
<s1,c1>
<s2,c2>
```

the implementation converts each confidence into evidence weight, combines the weighted strengths, and converts the total evidence weight back into confidence.

For:

```text
<0.70,0.50>
<0.95,0.75>
```

the result is:

```text
<0.8875,0.80>
```

The second source has greater evidence weight and therefore contributes more strongly to the revised belief.

---

## 5. PLN Inference

### 5.1 Deduction

Deduction follows a chain of implications:

```text
A -> B
B -> C
---------
A -> C
```

The implementation includes the full PLN deduction strength equation:

```text
sAC =
sAB*sBC
+
(1-sAB)
*
(sC-sB*sBC)/(1-sB)
```

The confidence is calculated as:

```text
cAC =
sAB*sBC*cAB*cBC
```

A test using:

```text
A -> B = <0.98,0.92>
B -> C = <0.95,0.88>
```

produced:

```text
<0.95,0.7537376>
```

The implementation also contains a simplified deduction function used for straightforward chaining:

```text
sAC = sAB*sBC
```

with:

```text
cAC = sAB*sBC*cAB*cBC
```

---

## 6. Induction

Induction generates a candidate generalization from shared observations.

The conceptual form is:

```text
C -> A
C -> B
---------
A -> B
```

Unlike deduction, induction is not a proof. It generates a hypothesis whose confidence reflects the available evidence.

The implementation follows the PLN induction equations from the assignment material.

A test case produced:

```text
(STV 0.815625 0.379653)
```

The relatively low confidence demonstrates that the induced relationship should be treated as a weaker hypothesis rather than a certain fact.

---

## 7. Abduction

Abduction searches for possible explanations.

The conceptual form is:

```text
A -> C
B -> C
---------
A -> B
```

For example, if several possible causes can produce an observed anomaly, the system can generate candidate explanations.

A test case produced approximately:

```text
(STV 0.6855 0.452846)
```

The result is explicitly treated as a candidate explanation rather than a proof that the hypothesized cause is true.

---

## 8. Forward and Backward Chaining

### 8.1 Forward Chaining

Forward reasoning starts from known evidence and follows implications.

For example:

```text
BatteryFailure
      ↓
PowerFluctuation
      ↓
CommunicationLoss
      ↓
MissionRisk
```

The first step produced:

```text
PowerFluctuation
<0.81,0.585225>
```

The next step produced:

```text
CommunicationLoss
<0.648,0.284419>
```

The final step produced:

```text
MissionRisk
<0.5832,0.140992>
```

This demonstrates uncertainty propagation through a multi-step inference chain.

### 8.2 Backward Chaining

Backward reasoning starts with a query and searches for possible causes.

For:

```text
CommunicationLoss
```

the system identifies:

```text
PowerFailure
AntennaFailure
RadiationEvent
```

This is useful for diagnosis because the system can work backward from an observed anomaly to several candidate explanations.

For:

```text
MissionRisk
```

the direct candidate cause is:

```text
CommunicationLoss
```

For:

```text
HighTemperature
```

the system identifies:

```text
ThermalFailure
ThermalSensorFailure
```

---

## 9. Sensor Evidence

Sensor reliability is represented explicitly.

For example:

```text
BatteryVoltageSensor
<0.95,0.90>
```

An observation:

```text
BatteryVoltageDrop
<0.92,0.80>
```

is adjusted using the sensor confidence.

The implementation currently calculates:

```text
adjusted confidence
=
observation confidence
*
sensor confidence
```

Therefore:

```text
0.80 * 0.90 = 0.72
```

and the resulting STV is:

```text
<0.92,0.72>
```

This provides a simple mechanism for incorporating sensor reliability into the reasoning process.

---

## 10. Diagnostic Representation

The diagnosis layer combines possible causes, priors, and causal implications.

For:

```text
CommunicationLoss
```

the system produces:

```text
PowerFailure
    Prior: <0.25,0.70>
    Implication: <0.95,0.90>

AntennaFailure
    Prior: <0.15,0.70>
    Implication: <0.88,0.82>

RadiationEvent
    Prior: <0.10,0.70>
    Implication: <0.80,0.75>
```

This representation preserves several possible explanations instead of forcing the system to select one immediately.

---

## 11. Evaluation

The system was evaluated against five required scenarios.

### 11.1 Strong Evidence

The system was given:

```text
<0.96,0.90>
<0.90,0.85>
```

The resulting inference was:

```text
<0.87,0.66096>
```

The relatively high strength and confidence demonstrate the effect of strong supporting evidence.

### 11.2 Uncertain Evidence

Using weaker evidence:

```text
<0.60,0.40>
<0.70,0.50>
```

produced:

```text
<0.62,0.084>
```

The confidence is substantially lower.

### 11.3 Multiple Explanations

For `CommunicationLoss`, the engine returned three candidate causes:

```text
PowerFailure
AntennaFailure
RadiationEvent
```

This demonstrates the ability to maintain alternative explanations.

### 11.4 Conflicting Evidence

Revision of:

```text
<0.70,0.50>
<0.95,0.75>
```

produced:

```text
<0.8875,0.80>
```

The higher-confidence evidence receives greater influence.

### 11.5 Multi-Step Inference

The chain:

```text
BatteryFailure
    -> PowerFluctuation
    -> CommunicationLoss
    -> MissionRisk
```

produced:

```text
PowerFluctuation:
<0.81,0.585225>

CommunicationLoss:
<0.648,0.284419>

MissionRisk:
<0.5832,0.140992>
```

The results demonstrate confidence degradation as uncertain information passes through multiple inference steps.

---

## 12. Edge-Case Evaluation

Additional tests examined non-ideal conditions.

### Weak Evidence

Very weak premises produced:

```text
<0.342857,0.004>
```

The extremely low confidence reflects insufficient supporting evidence.

### Strong Evidence

Strong premises produced:

```text
<0.9506,0.922272>
```

showing high inferred confidence.

### Equal-Confidence Conflict

Revising:

```text
<0.90,0.80>
<0.10,0.80>
```

produced:

```text
<0.50,0.888889>
```

The equal evidence weights resulted in a midpoint strength.

### Unequal-Confidence Conflict

Revising:

```text
<0.90,0.40>
<0.20,0.90>
```

produced:

```text
<0.248276,0.90625>
```

The higher-confidence second source dominates the resulting belief.

### Unknown Observation

Querying:

```text
UnknownObservation
```

produced no result.

This is important because the system does not invent an explanation when no corresponding knowledge exists.

---

## 13. Implementation Structure

The implementation is divided into modular MeTTa files.

### `stv.metta`

Defines STVs, strength/confidence accessors, evidence-weight conversion, and revision.

### `knowledge_base.metta`

Contains the spacecraft domain entities, observations, causes, sensor information, implications, evidence, and priors.

### `deduction.metta`

Implements the PLN deduction equations and simplified deduction used by chaining.

### `induction.metta`

Implements the PLN induction equations.

### `abduction.metta`

Implements the PLN abduction equations.

### `chaining.metta`

Implements forward reasoning, backward reasoning, and backward paths.

### `sensor_evidence.metta`

Handles sensor reliability and sensor-adjusted observations.

### `diagnosis.metta`

Provides diagnostic candidates and diagnostic scoring.

### `main.metta`

Acts as the main interface by importing all components and exposing higher-level functions such as:

```text
diagnose
predict
why
why-path
get-evidence
sensor-reliability
```

---

## 14. Testing

The project contains separate tests for the major components as well as integration and edge-case tests.

The test suite covers:

* STV operations
* Deduction
* Induction
* Abduction
* Chaining
* Diagnosis
* Sensor evidence
* Backward reasoning
* Evaluation scenarios
* Edge cases
* Full integration

The complete integration test successfully demonstrated that the major components operate together through the main PLN interface.

---

## 15. Limitations

The implementation is a focused educational PLN engine and does not represent a complete spacecraft diagnostic system.

Important limitations include:

1. The knowledge base is manually constructed.
2. The sensor-adjustment mechanism is simplified.
3. Diagnostic scoring is not a calibrated real-world probability.
4. Full unrestricted multi-hop backward search is not implemented.
5. ECAN attention/resource management is not implemented.
6. The system does not learn new domain knowledge automatically.
7. The spacecraft relationships are illustrative rather than derived from real mission telemetry.

Therefore, the numerical results demonstrate the behavior of the implemented PLN equations rather than claiming real spacecraft failure probabilities.

---

## 16. Future Work

Potential extensions include:

* Automated extraction of spacecraft knowledge from telemetry.
* More realistic sensor error models.
* Full recursive backward chaining.
* Resource-aware inference.
* ECAN attention mechanisms.
* Larger knowledge graphs.
* Learning of implication strengths from historical data.
* Comparison with Bayesian networks.
* Evaluation using real spacecraft anomaly datasets.
* Integration with real-time spacecraft monitoring systems.

---

## 17. Conclusion

The project demonstrates a complete small-scale PLN reasoning engine for spacecraft anomaly diagnosis.

The system combines:

```text
Structured knowledge
        +
Subjective Truth Values
        +
Probabilistic inference
        +
Forward/backward reasoning
        +
Evidence revision
        ↓
Uncertainty-aware diagnosis
```

The experiments demonstrate that the system can represent uncertain knowledge, derive new conclusions, maintain multiple possible explanations, revise beliefs when new evidence arrives, and propagate uncertainty through multi-step reasoning.

The implementation therefore provides a concrete demonstration of how Probabilistic Logic Networks can bridge symbolic reasoning and uncertainty in a domain where incomplete and unreliable information are natural characteristics of the problem.
