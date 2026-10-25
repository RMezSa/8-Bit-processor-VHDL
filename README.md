# 8 Bit Processor in VHDL

An 8 bit processor written in VHDL following the RTL methodology and implemented on an Intel MAX 10 FPGA (DE10 Lite board). It has a 26 instruction set, a memory mapped I/O system with 16 input and 16 output ports, and a GHDL testbench that runs its demo program in simulation.

Built for the Embedded Systems Design course at Tecnológico de Monterrey (Intel Industry Partner Program, 2025).

## Architecture

* **Registers:** instruction register (IR), memory address register (MAR), program counter (PC), two general purpose registers (A and B) and a condition code register with N, Z, V and C flags.
* **Datapath:** two internal buses. Bus 1 selects PC, A or B; Bus 2 selects the ALU result, Bus 1 or data coming from memory.
* **ALU:** 8 bits, built structurally from eight 1 bit ALU slices (each one made of half adders), with carry and overflow detection.
* **Control unit:** a finite state machine with a fetch and decode cycle (F0, F1, F2, DS) followed by the states of each instruction.
* **Clock:** the 10 MHz board clock is divided down to 250 Hz so the program can be followed on the board's LEDs.

## Memory map

| Address | Contents |
|---|---|
| `0x00` to `0x7F` | Program memory (ROM, 128 bytes) |
| `0x80` to `0xDF` | Data memory (RAM, 96 bytes) |
| `0xE0` to `0xEF` | 16 input ports |
| `0xF0` to `0xFF` | 16 output ports |

## Instruction set

| Group | Instructions (opcode) |
|---|---|
| Data transfer | `LDA #imm` (86), `LDB #imm` (87), `LDA addr` (88), `LDB addr` (89), `STA addr` (96), `STB addr` (97) |
| Arithmetic and logic | `ADD` (40), `SUB` (41), `AND` (42), `OR` (43), `XOR` (44), `INC A` (45), `INC B` (46), `DEC A` (47), `DEC B` (48), `NOT A` (50), `NOT B` (51) |
| Jumps | `JMP` (20), `JN` (21), `JNN` (22), `JZ` (23), `JNZ` (24), `JOV` (25), `JNOV` (26), `JC` (27), `JNC` (28) |

Two operand instructions combine A and B and write the result to A; `INC`, `DEC` and `NOT` act on the register they name. Conditional jumps test the N, Z, V and C flags.

## Demo program

The program in `rtl/mem_programa.vhd` reads bit 0 of input port 0 (`0xE0`), masks it with an `AND`, and uses `JZ` to write 1 or 0 to output port 0 (`0xF0`), which drives an LED. It loops forever.

## Simulation

`sim/tb_cpu.vhd` connects the CPU to the memory system with a fast clock, runs the demo program and checks the LED output for both input values.

```bash
sudo apt install ghdl
cd sim
make          # prints PASS / FAIL for each check
make wave     # also saves tb_cpu.ghw for GTKWave
```

## FPGA build

Open `quartus/Top_Level_Entity.qpf` in Quartus Prime Lite 18.1 and compile. The project targets the `10M50DAF484C7G` (DE10 Lite) and includes the pin assignments for the clock, reset, input port 0 and output port 0.

The architecture follows the one presented in the course; the VHDL implementation, memory system and testbench are my own.

## Repository layout

```
rtl/      VHDL sources (Top_Level_Entity.vhd is the top module)
sim/      GHDL testbench and Makefile
quartus/  Quartus Prime project and pin assignments
```
