# Complete-UART-Communication-System-in-Verilog
This project implements a full UART communication system in Verilog HDL. The top module connects:  • Baud Rate Generator • UART Receiver (RX) • UART Transmitter (TX)  The design supports serial communication with ready and busy control signals and can be directly used in FPGA-based systems for serial data transfer.  
# Verilog UART Transceiver

## Overview
This project implements a complete UART (Universal Asynchronous Receiver Transmitter) in Verilog HDL including transmitter, receiver, and baud rate generator.

## Modules
- baudrate.v  → Generates TX and RX enable pulses
- tx_enaa.v   → UART transmitter
- rx_enaa.v   → UART receiver
- topfina.v   → Top integration module

## Features
- 8-bit serial communication
- TX busy flag
- RX ready flag
- Baud rate enable logic
- Fully synthesizable
- FPGA friendly

## Ports
### RX
- rx → serial input
- rdy → data ready
- data_out → received byte

### TX
- wr → write enable
- data_in → data to send
- busy → transmitter busy
- tx → serial output

## Tools
ModelSim / Vivado / Icarus Verilog

## Author
Shourya Shukla
