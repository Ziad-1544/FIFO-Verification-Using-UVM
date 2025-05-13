# FIFO Verification Using UVM

This project demonstrates the functional verification of a **First-In-First-Out (FIFO)** memory using **SystemVerilog** and **UVM (Universal Verification Methodology)**. It follows a structured and modular approach to ensure correctness, coverage, and reusability of the testbench components.

---

## 🔍 Project Overview

A FIFO is a commonly used buffer in digital systems. Verifying its functionality is a fundamental step in ensuring data integrity in larger systems. This project implements a UVM-based testbench to verify the behavior of a synthesizable FIFO design under different scenarios, such as:

- Normal operation (write & read)
- FIFO full and empty conditions
- Overflow and underflow handling

---

## ✅ Features

- Modular UVM Environment  
- Randomized Test Sequences  
- Scoreboarding and Self-Checking Tests  
- Assertions (optional, extendable)  
- Coverage Collection (functional + code coverage)

---

## 🛠️ Tools & Technologies

- **Simulator:** QuestaSim / ModelSim  
- **Language:** SystemVerilog  
- **Methodology:** Universal Verification Methodology (UVM)  
- **Optional:** VCS, Vivado Simulator (for RTL synthesis or reuse)

---

## 🚀 How to Run the Simulation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ziad-1544/FIFO-Verification-Using-UVM.git
   cd FIFO-Verification-Using-UVM

---

## 📊 Coverage & Results
The testbench covers the following scenarios:

- Write and read bursts

- Randomized write-read sequences

- Full and empty boundary conditions

- Overflow/underflow protection

- Functional correctness via scoreboard comparison

You can find simulation waveforms and result screenshots in the /doc folder.

## 🧠 Learning Outcomes
Deep understanding of UVM components (driver, monitor, sequencer, etc.)

Writing effective, randomized test scenarios

Building a functional scoreboard for DUT output validation

Debugging and waveform analysis in QuestaSim


## 🤝 Contributions
Feel free to open issues, suggest enhancements, or fork and build on this repository. It's a learning-based project, and collaboration is always welcome.

## 📄 License
This project is open-source and available under the MIT License.
