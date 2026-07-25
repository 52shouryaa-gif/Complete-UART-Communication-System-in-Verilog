# UART (Transmitter + Receiver) — Verilog RTL

An 8-N-1 asynchronous UART core written in Verilog, consisting of a transmitter, a 16x-oversampling receiver, and a shared baud-rate generator, integrated into a single top module and verified with a self-checking testbench.

## Features

- Standard 8-N-1 framing: 1 start bit, 8 data bits (LSB first), 1 stop bit
- 16x oversampled receiver with mid-bit sampling for noise immunity
- Glitch filter on the receiver's start-bit detection
- Independent `rdy` / `rdy_clr` handshake for the receiver
- `busy` flag on the transmitter to prevent mid-frame overwrites
- Self-looped-back testbench (TX output feeds directly into RX input) for standalone verification — no external UART hardware needed

## Architecture

```
                ┌─────────────┐
   data_in ───► │             │
   wr_en   ───► │ Transmitter │──tx──┐
                │     (t)     │      │
                └─────────────┘      │  (tx_temp)
                       ▲             │
                  tx_enb│            │
                ┌───────┴────┐       │
                │ baud_rate  │       │
                └───────┬────┘       │
                  rx_enb│            │
                       ▼             ▼
                ┌─────────────┐
                │  Receiver   │──► data_out
   rdy_clr ───► │    (rx)     │──► rdy
                └─────────────┘
```

All three blocks are instantiated inside `topuart`, which exposes a single clean interface to the outside world.

## Module Overview

| File            | Module      | Description                                                                 |
|------------------|------------|-------------------------------------------------------------------------------|
| `baud_rate.v`    | `baud_rate` | Generates `tx_enb` (1 pulse every 64 clk cycles) and `rx_enb` (1 pulse every 4 clk cycles) — giving the receiver exactly 16x oversampling per transmitted bit. |
| `t.v`            | `t`         | UART transmitter FSM (idle → start → data → stop). Shifts `data_in` out LSB-first on each `enb` tick; asserts `busy` for the full frame duration. |
| `rx.v`           | `rx`        | UART receiver FSM (idle → start → data → stop). Detects the start bit, samples each bit at its mid-point (`sample==7` of a 0–15 count), reconstructs the byte in `data_out`, and raises `rdy`. |
| `topuart.v`      | `topuart`   | Top-level wrapper connecting `baud_rate`, `t`, and `rx` together. |
| `testuart.v`     | `testuart`  | Self-checking testbench: sends a byte through the TX path, loops it back into RX, and verifies `data_out` matches what was sent. |

## Port List — `topuart`

| Signal      | Dir | Width | Description                              |
|-------------|-----|-------|-------------------------------------------|
| `clk`       | in  | 1     | System clock                              |
| `rst`       | in  | 1     | Synchronous reset (active high)           |
| `wr_en`     | in  | 1     | Pulse high for 1 cycle to start a transmit |
| `rdy_clr`   | in  | 1     | Pulse high to clear the `rdy` flag        |
| `data_in`   | in  | 8     | Byte to transmit                          |
| `rdy`       | out | 1     | High when a received byte is ready to read |
| `busy`      | out | 1     | High while a transmission is in progress  |
| `data_out`  | out | 8     | Last byte received                        |

## Simulation

Using Icarus Verilog:

```bash
iverilog -o uart_sim baud_rate.v t.v rx.v topuart.v testuart.v
vvp uart_sim
gtkwave uart.vcd
```

Expected console output:

```
SUCCESS!
```

The testbench sends `8'hA5` through the transmitter, loops it back into the receiver, and checks `data_out` against the original byte.

## Possible Extensions

- Stop-bit validity check + `framing_error` output
- Parameterizable baud divisor (currently fixed at /64 for TX, /4 for RX)
- TX/RX FIFO buffering for back-to-back byte streaming
- Parity bit support (odd/even)

## Author

Shourya — [github.com/52shouryaa-gif](https://github.com/52shouryaa-gif)
