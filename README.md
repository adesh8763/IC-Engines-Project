# Early Prediction of Knock and Misfire in Spark-Ignition Engines

### A Data-Driven Approach to Predicting Abnormal Combustion Before It Occurs

![MATLAB](https://img.shields.io/badge/MATLAB-Development-orange?logo=mathworks)
![Simulink](https://img.shields.io/badge/Simulink-Modeling-blue?logo=mathworks)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-Classification-purple)
![Status](https://img.shields.io/badge/Project-Research%20Prototype-green)

## Overview

Knock and misfire are two major forms of abnormal combustion in Spark-Ignition (SI) engines. Conventional detection techniques generally identify these events after they have occurred, potentially exposing the engine to mechanical stress, reduced performance, increased emissions, and component damage.

This project explores a **data-driven approach to predicting knock and misfire one combustion cycle ahead** using statistical characteristics of in-cylinder pressure signals.

A MATLAB/Simulink framework was developed to generate synthetic combustion pressure traces, extract relevant signal features, train a machine-learning classifier, and predict the combustion condition of the upcoming engine cycle.

The long-term objective is to develop a predictive combustion monitoring framework that can eventually be integrated with Engine Control Unit (ECU) decision-making systems.

## Key Features

- Synthetic in-cylinder pressure signal generation for normal combustion, knock, and misfire.
- Cycle-to-cycle combustion variation modeling.
- Identification of pre-event conditions (Knock_Pre and Misfire_Pre).
- Statistical feature extraction from pressure signals.
- Machine-learning-based combustion classification.
- Next-cycle prediction using current-cycle pressure features.
- MATLAB/Simulink-based condition classifier implementation.
- Performance evaluation using confusion matrices, precision, recall, F1-score, and accuracy.

## Project Methodology

The proposed framework follows a six-stage architecture:

1. **Sensor Inputs:** In-cylinder pressure, crank angle, and engine speed.
2. **Signal Pre-processing:** Band-pass filtering to reduce unwanted noise and preserve relevant combustion characteristics.
3. **Feature Extraction:** Calculation of statistical pressure features for each combustion cycle.
4. **Condition Classification:** Classification of combustion cycles into normal, knock, and misfire conditions.
5. **Early Prediction:** Using the features of cycle *n* to predict the combustion condition of cycle *n+1*.
6. **ECU Decision Logic:** Proposed control actions based on predicted combustion abnormalities.

The first five stages form the developed and evaluated framework. Closed-loop ECU decision logic remains future work.

## Dataset and Combustion Modeling

The project uses a synthetically generated dataset created in MATLAB.

A total of **500 combustion cycles** were generated across five conditions:

| Condition | Number of Cycles | Description |
|---|---:|---|
| Normal | 388 | Regular combustion |
| Knock_Pre | 31 | Cycle immediately preceding knock |
| Knock | 31 | Abnormal combustion with pressure oscillations |
| Misfire_Pre | 25 | Cycle immediately preceding misfire |
| Misfire | 25 | Incomplete or absent combustion |
| **Total** | **500** | |

### Synthetic Pressure Characteristics

Three fundamental combustion conditions were modeled:

- **Normal:** Smooth pressure development with a peak near 9 bar.
- **Knock:** Elevated peak pressure (approximately 10.3 bar) with high-frequency pressure oscillations.
- **Misfire:** Significantly reduced pressure development, with a peak near 2.5 bar.

Pre-event conditions were generated with intermediate characteristics to represent the designed pressure-statistical drift preceding abnormal combustion.

## Feature Extraction

Four statistical features are extracted from each pressure cycle:

| Feature | Description |
|---|---|
| Maximum Pressure | Peak cylinder pressure during the cycle |
| Mean Pressure | Average pressure across the cycle |
| RMS Pressure | Root Mean Square pressure, representing signal magnitude |
| Standard Deviation | Variation in pressure values across the cycle |

These features provide a compact representation of combustion behavior while keeping the computational requirements relatively low.

## Early Prediction Approach

The central idea is to identify changes in combustion behavior before an abnormal event occurs.

Instead of simply classifying the current cycle, the prediction model uses the extracted features of the current cycle to estimate the condition of the next cycle.

\[
\hat{y}_{n+1}=g(x_n)
\]

Where:

- \(x_n\) = Feature vector extracted from combustion cycle \(n\).
- \(g\) = Trained machine-learning classifier.
- \(\hat{y}_{n+1}\) = Predicted combustion condition of the next cycle.

This approach uses the pre-event conditions incorporated into the synthetic dataset to learn potential warning patterns.

## Results

The framework was evaluated using a held-out test dataset of 149 cycles.

<details>
<summary><strong>Early Prediction Performance</strong></summary>

| Metric | Result |
|---|---:|
| Early Prediction Accuracy | **99.33%** |
| Current-Cycle Classification Accuracy | 95.56% |
| Knock Precision | 100.00% |
| Knock Recall | 88.89% |
| Knock F1-score | 94.12% |
| Misfire Precision | 100.00% |
| Misfire Recall | 100.00% |
| Misfire F1-score | 100.00% |

</details>

### Early Prediction Confusion Matrix

| Actual / Predicted | Knock | Misfire | Normal |
|---|---:|---:|---:|
| Knock | 8 | 0 | 1 |
| Misfire | 0 | 8 | 0 |
| Normal | 0 | 0 | 132 |

The early-prediction model correctly classified 148 out of 149 test cycles.

The only misclassification was one knock cycle predicted as normal.

### Current-Cycle vs Next-Cycle Prediction

| Approach | Accuracy |
|---|---:|
| Current-Cycle Classification | 95.56% |
| Next-Cycle Prediction | **99.33%** |

The results demonstrate the feasibility of next-cycle prediction within the constructed synthetic-data framework.

**Important:** These performance figures are obtained entirely from synthetic data. They should not be interpreted as real-engine prediction accuracy or validated field performance.

## MATLAB/Simulink Implementation

MATLAB was used for:

- Synthetic pressure signal generation.
- Dataset construction.
- Signal processing and feature extraction.
- Machine-learning model training.
- Performance evaluation and visualization.

Simulink was used to implement a condition classifier using a MATLAB Function block.

The implemented Simulink model accepts combustion pressure signals and produces the following condition codes:

| Output | Combustion Condition |
|---|---|
| 1 | Normal |
| 2 | Knock |
| 3 | Misfire |

The current Simulink demonstration implements current-cycle condition classification. Integration of the next-cycle prediction model and closed-loop ECU control remains planned.


## Getting Started

### Prerequisites

- MATLAB
- Simulink
- MATLAB toolboxes required by the implemented machine-learning and signal-processing scripts.

### Installation

Clone the repository:

```bash
git clone https://github.com/adesh8763/IC-Engines-Project
```

Navigate to the project directory:

```bash
cd IC-Engines-Project
```

Open the project in MATLAB and execute the scripts in the appropriate workflow:

1. Generate the synthetic combustion dataset.
2. Perform signal preprocessing.
3. Extract statistical features.
4. Train and evaluate the classification model.
5. Execute the next-cycle prediction workflow.
6. Open and simulate the Simulink condition classifier.

Refer to the individual source files for the actual execution sequence and dependencies.

## Limitations

This project is currently a feasibility study based on synthetic combustion data.

The major limitations are:

- Training and testing are performed using data generated by the same synthetic data generator.
- The test dataset contains a relatively small number of abnormal combustion cycles.
- Pre-event pressure variations are incorporated by design into the synthetic dataset.
- Prediction lead time has been established as one combustion cycle, but crank-angle lead time has not yet been quantified.
- The Simulink implementation has not undergone hardware-in-the-loop testing.
- Closed-loop ECU correction has not been implemented or evaluated.
- Performance on experimentally measured engine data remains unverified.

Consequently, the reported accuracy demonstrates feasibility within the synthetic framework rather than real-world engine performance.

## Future Work

The project can be extended toward a more comprehensive predictive combustion monitoring system.

Planned developments include:

- Validation using experimentally measured in-cylinder pressure data.
- Quantification of prediction lead time in crank-angle degrees.
- Incorporation of pressure derivative (\(dP/d\theta\)) and heat-release-rate features.
- Extraction of combustion phasing parameters such as MFB10 and MFB50.
- Investigation of longer prediction horizons.
- Cross-validation and evaluation using larger datasets.
- Integration of next-cycle prediction into Simulink.
- Development of closed-loop ECU correction logic.
- Hardware-in-the-loop (HIL) testing.
- Robustness evaluation under measurement noise and varying engine operating conditions.

## Applications

The underlying concept has potential applications in:

- Predictive engine diagnostics.
- Intelligent combustion monitoring.
- Engine knock prevention.
- Misfire prediction and detection.
- Adaptive engine control systems.
- ECU-based combustion optimization.

## Contributors

**Department of Mechanical Engineering**  
VIT Chennai | Fall Semester 2026–27

| Contributor | Roll Number |
|---|---|
| Adharsh Manoj | 24BME1138 |
| Adesh Prasad Dash | 24BME1165 |
| N Dharanikanth Reddy | 24BME1021 |

**Project Guide:** Dr Venugopal T.

## References

1. Heywood, J. B., *Internal Combustion Engine Fundamentals*, McGraw-Hill, 1988.
2. Stone, R., *Introduction to Internal Combustion Engines*, 4th Edition, Palgrave Macmillan, 2012.
3. [MathWorks MATLAB Documentation](https://www.mathworks.com/help/)
4. [MathWorks Simulink Documentation](https://www.mathworks.com/help/simulink/)

---

## Project Status

**Research Prototype – Synthetic Data Validation Completed**

The project establishes a preliminary framework for predicting abnormal combustion using cycle-level pressure statistics. Experimental validation, crank-angle lead-time analysis, and closed-loop engine control are the next major development stages.

---

*Developed as an academic engineering project at VIT Chennai.*
