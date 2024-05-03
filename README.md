## APTPU
Generic APTPU RTL Design 

## Introduction
This repository contains the RTL (Register Transfer Level) code for the APTPU design, which is based on a systolic array architecture. The design utilizes various approximate multipliers and adders to explore trade-offs between accuracy, area and power consumption, making it suitable for applications in power-constrained environments.

## Project Structure

├── DCC_flow
│   ├── clean.sh
│   ├── net
│   │   ├── rtl
│   │   │   ├── accurate_multiplier.v
│   │   │   ├── Adder_Compensation.v
│   │   │   ├── adder_RoBA.v
│   │   │   ├── Adder.v
│   │   │   ├── ALM_Gen_multiplication_unit.v
│   │   │   ├── ALM_Gen_pre_approximate.v
│   │   │   ├── ALM_LOA_top.v
│   │   │   ├── ALM_MAA3_top.v
│   │   │   ├── ALM_multiplication_unit.v
│   │   │   ├── ALM_pre_approximate.v
│   │   │   ├── ALM_SOA_top.v
│   │   │   ├── ALM_top.v
│   │   │   ├── Antilogarithmic_Converter.v
│   │   │   ├── approx5_adder.v
│   │   │   ├── approximate_adder_SA.v
│   │   │   ├── approx_units_array.v
│   │   │   ├── ASM_A_pre_approximate.v
│   │   │   ├── ASM_B_pre_approximate.v
│   │   │   ├── ASM_gen.v
│   │   │   ├── ASM_multiplication_unit.v
│   │   │   ├── ASM_pre_approximate.v
│   │   │   ├── BAM_16x16.v
│   │   │   ├── BAM_4x4.v
│   │   │   ├── BAM_8x8.v
│   │   │   ├── BAM_top.v
│   │   │   ├── barrel_shifter.v
│   │   │   ├── base2_mux.v
│   │   │   ├── BLC.v
│   │   │   ├── control_unit.v
│   │   │   ├── decision_mux_Rounding.v
│   │   │   ├── decision_mux.v
│   │   │   ├── decoder.v
│   │   │   ├── DR_ALM_multiplication_unit.v
│   │   │   ├── DR_ALM_pre_approximate.v
│   │   │   ├── DR_ALM_TOP.v
│   │   │   ├── Dynamic_truncation.v
│   │   │   ├── EIM16x16.v
│   │   │   ├── EIM32x32.v
│   │   │   ├── EIM4x4.v
│   │   │   ├── EIM8x8.v
│   │   │   ├── EIM.v
│   │   │   ├── fifo_array.v
│   │   │   ├── fifo.v
│   │   │   ├── full_adder.v
│   │   │   ├── Half_adder.v
│   │   │   ├── heaa_adder.v
│   │   │   ├── herloa_adder.v
│   │   │   ├── hoaaned_adder.v
│   │   │   ├── hoeraa_adder.v
│   │   │   ├── LBC.v
│   │   │   ├── ldca_adder.v
│   │   │   ├── loa_adder.v
│   │   │   ├── LOA.v
│   │   │   ├── loawa_adder.v
│   │   │   ├── LOD.v
│   │   │   ├── Logarithmic_Converter.v
│   │   │   ├── lzta_adder.v
│   │   │   ├── MAA3.v
│   │   │   ├── matrix.v
│   │   │   ├── mheaa_adder.v
│   │   │   ├── mherloa_adder.v
│   │   │   ├── mitchell_multiplication_unit.v
│   │   │   ├── mitchell_pre_approximate.v
│   │   │   ├── mitchell.v
│   │   │   ├── multiplication_unit.v
│   │   │   ├── mux.v
│   │   │   ├── oloca_adder.v
│   │   │   ├── options_definitions.vh
│   │   │   ├── P_Encoder.v
│   │   │   ├── pe.v
│   │   │   ├── power_k_mux.v
│   │   │   ├── pre_comp_bank.v
│   │   │   ├── RoBA_A_pre_approximate.v
│   │   │   ├── RoBA_B_pre_approximate.v
│   │   │   ├── RoBA_multiplication_unit.v
│   │   │   ├── RoBA_top.v
│   │   │   ├── Rounding_unit.v
│   │   │   ├── row.v
│   │   │   ├── select_unit.v
│   │   │   ├── seta_adder.v
│   │   │   ├── shared_approx_units.v
│   │   │   ├── shared_units_tb.v
│   │   │   ├── shifter.v
│   │   │   ├── shift_left_mux.v
│   │   │   ├── shift_unit.v
│   │   │   ├── signed_product.v
│   │   │   ├── SOA.v
│   │   │   ├── subtractor.v
│   │   │   ├── systolic_array_top.v
│   │   │   ├── top_demux.v
│   │   │   ├── top_mux.v
│   │   │   ├── UDM_16x16.v
│   │   │   ├── UDM_32x32.v
│   │   │   ├── UDM_4x4.v
│   │   │   ├── UDM_8x8.v
│   │   │   ├── UDM_BB.v
│   │   │   ├── UDM.v
│   │   │   ├── unsign.v
│   │   │   └── Zero_Mux.v
│   │   └── syn
│   ├── reports
│   ├── scripts
│   │   └── script.tcl
│   └── start_syn
├── LICENSE
└── README.md



## Features
- **Systolic Array Design**: Efficient parallel data processing suitable for matrix operations.
- **Approximate Computing Elements**: Includes a variety of approximate computing modules (adders and multipliers) designed to reduce power, area, and critical path delay under specific accuracy constraints.
- **Scalable Architecture**: Modular design allows for easy scaling of the processing units and adjustment of approximation levels.

## Getting Started
To clone the repository and view the contents, run the following command:
```bash
git clone https://github.com/iCAS-Lab/APTPU


