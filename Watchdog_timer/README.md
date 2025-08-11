# ⏱️ Watchdog Timer – RTL Verilog Design
A **Watchdog Timer (WDT)** is a system reliability feature. If the system doesn’t send a periodic **kick pulse**, the WDT triggers a reset.  
This Verilog design models a simple 4-bit watchdog timer.

## 📦 Files

- `watchdog_timer.v`: RTL module
- `watchdog_timer_tb.v`: Testbench
- `watchdog_timer.vcd`: Waveform output

## 🧮 Parameters

| Parameter | Description                  |
|----------|------------------------------|
| TIMEOUT  | Timeout duration (default: 10 clock cycles) |

## 📋 I/O Ports

| Signal      | Direction | Description                      |
|-------------|-----------|----------------------------------|
| `clk`       | Input     | Clock signal                     |
| `rst`       | Input     | Reset signal                     |
| `kick`      | Input     | Kick pulse to reset timer        |
| `wdt_reset` | Output    | Output reset when timeout occurs |

## ▶️ To Simulate

```bash
iverilog -o watchdog_timer.out watchdog_timer.v watchdog_timer_tb.v
vvp watchdog_timer.out
gtkwave watchdog_timer.vcd
```
## 🔍 Waveform Output

Here’s the output of the simulation viewed in GTKWave:

![Waveform](watchdog_timer.png)