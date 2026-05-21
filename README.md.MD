# UART to SPI Bridge using Verilog

## Project Overview
This project implements a UART to SPI Bridge in Verilog HDL.

The design receives serial UART data and transfers it to an SPI interface using a bridge controller.

## Modules
- UART Receiver (uart_rx)
- SPI Master (spi_master)
- UART to SPI Bridge (uart_to_spi_bridge)

## Features
- UART Serial Reception
- SPI Data Transmission
- FSM-based UART RX
- SPI Clock Generation
- Bridge Logic Integration
- Behavioral Simulation in Vivado 2025.2

## Tools Used
- Verilog HDL
- Xilinx Vivado 2025.2

## Folder Structure
rtl/        -> RTL source files
tb/         -> Testbench files
waveforms/  -> Simulation screenshots
docs/       -> Project documentation

## Simulation Results

### UART RX Waveform
![UART RX](waveforms/uart_rx_waveform.png)

### SPI Master Waveform
![SPI MASTER](waveforms/spi_master_waveform.png)

### UART to SPI Bridge Waveform
![UART TO SPI](waveforms/uart_to_spi_bridge_waveform.png)

## Author
Pranay kumar Beepyata