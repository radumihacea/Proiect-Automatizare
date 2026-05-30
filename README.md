**Course:** Automatic Control Engineering II (Ingineria Reglării Automate 2)  
**Author:** Radu Mihacea-Geger

## 📖 Project Overview
This repository contains the design, mathematical modeling, and simulation of a multivariable automatic control system. The process models an industrial chemical plant setup where a granular material is transported via a screw conveyor (TM) and a bucket elevator (TC) into a drying oven (C). 

The main objectives of this control system are:
1. **Flow Control:** Maintaining a constant mass flow rate of the granular material.
2. **Temperature Control:** Regulating the output temperature of the material leaving the oven.
3. **Loop Decoupling:** Minimizing the interactions between the two control loops.

## 🛠️ Control Strategies Implemented
The project explores multiple control design methodologies, progressively moving from basic compensators to advanced control architectures:

### 1. Flow Control Loop
* **Analytical Design (Guillemin-Truxal):** Design of HR1 and HR2 (dipole correction) to achieve strict transient performance requirements.
* **Frequency Domain Design:** Step-by-step design of P, PI, PD, and PID controllers using Bode diagrams to achieve the desired phase margin and crossover frequency.
* **Quasi-Optimal Tuning:** Application of the **Modulus Method** (optimized for reference tracking) and the **Symmetry Method** (optimized for disturbance rejection).
* **Cascade Control:** Implementation of a master-slave architecture to reject load disturbances efficiently.

### 2. Temperature Control Loop
* **Phase Margin Design:** Tuning PI, PD, and PID controllers to guarantee robust stability (Phase Margin > 45°-60°) for a highly sluggish process with large time constants.
* **Cascade Control:** Used to linearize and improve the overall precision of the heating process.

### 3. Advanced Control (Dead-Time Compensation)
* **Smith Predictor:** Designed and simulated to overcome the severe instability issues caused by the massive transport delay (dead time) introduced by the bucket elevator.

## 🚀 Technologies & Tools
* **MATLAB / Simulink:** Used for transfer function modeling, Bode plot analysis, step/ramp response simulations, and controller tuning.
* **Control Theory:** Classical control, frequency response, time-domain analysis, dead-time compensation.

## 📈 Key Results
* Successfully simplified theoretical ideal controllers into implementable, industry-standard **PID controllers** with first-order filters.
* Demonstrated the superiority of **Cascade Control** for rapid disturbance rejection.
* Proven that the **Smith Predictor** completely eliminates the overshoot and oscillatory behavior typical of systems with dominant dead times.
"""
