# RISC CPU

A minimal 32-bit Reduced Instruction Set Computer (RISC) CPU inspired by Berkeley's RISC-V instruction set architecture

## Table of Contents
1. [Architecture](#architecture)
2. [Instructions](#instructions)
3. [Example Instruction Simulation](#example-instructions)
4. [Future Extensions](#future-extensions)

# Architecture

The architecture of this CPU uses several key components that allow it to perform basic CPU instructions.

- **Control Unit**: The control unit decodes the instruction opcode and generates control signals to guide data flow, ALU operations, memory access and specific register updates. 
- **Register File**: The register file stores the 32 general purpose registers (with the exception of register x0 being hardwired to 0). It reads from two source registers at any given moment and writes into one destination register per clock cycle.
- **Extend Unit**: The extend unit extracts and formats the immediate fields for I-, S-, B- and J-type instructions. It uses sign-extension to cover the full 32-bits and can use up to 11-20 bit numbers for the respective instructions.
- **Instruction Memory**: The instruction memory holds the programs instructions. It reads the instruction address from the program counter and provides the corresponding instruction held at that address. The instruction memory is byte-addressable, meaning each instruction location responds to four bytes holdig the entire 32-bit word split. 
- **Data Memory**: The data memory provides storage for load and store operations. Data can be read and written from memory based on the control signals and effective addresses. The data memory is also byte-addressable and it uses little-endianness to store bytes, meaning your 32-bit word gets split into four bytes and stored in four different byte addresses in memory where the lowest byte of the word goes in the lowest byte of memory and so on. 

# Instructions

The CPU currently supports R-, I-, S-, B-, and J-type instructions.

### Core Instruction Format

| 31‒25          | 24‒20 | 19‒15 | 14‒12 | 11‒7      | 6‒0    | Type   |
|----------------|-------|-------|-------|-----------|--------|--------|
| funct7         | rs2   | rs1   | funct3| rd        | opcode | R-type |
| immediate[11:0]|       | rs1   | funct3| rd        | opcode | I-type | 
| imm[11:5]      | rs2   | rs1   | funct3| imm[4:0]  | opcode | S-type |
| imm[12\|10:5]  | rs2   | rs1   | funct3| imm[4:1\|11] | opcode | B-type |
| imm[20\|10:1\|11\|19:12] |       |       |       | rd        | opcode | J-type |

### Instructions

| Inst | Name | Type | Opcode | funct3 | funct7 | Description |
|------|------|------|--------|--------|--------|-------------|
| add  | ADD  |   R  |0110011 | 000 | 00000000 | rd = rs1 + rs2 |
| sub  | SUB  |   R  |0110011 | 000 | 00100000 | rd = rs1 - rs2 |
| or  | OR  |   R  |0110011 | 110 | 00000000 | rd = rs1 | rs2 |
| and  | AND  |   R  |0110011 | 111 | 00000000 | rd = rs1 & rs2 |
| slt  | Set Less Than  |   R  |0110011 | 011 | 00000000 | rd = (rs1 < rs2)?1:0 |
| addi | Add Immediate | I | 0010011 | 000 | | rd = rs1 + imm |
| lw | Load Word | I | 0000011 | 010 | | rd = M[rs1+imm][0:31] |
| sw | Store Word | S | 0100011 | 010 | | M[rs1+imm][0:31] = rs2[0:31] |
| beq | Branch == | B | 1100011 | 000 | | if(rs1 == rs2) PC += imm |
| jal | Jump And Link | J | 1101111 | | | rd = PC+4; PC += imm |

# Example Instructions

Note: If you plan on tracing the waveform images for each instruction from this README, please check the .mem file for each respective instruction (which are linked with "Check out the machine code **here**") to have some context of what I'm explaining. 

### ADD

Adds the contents of source register 2 to source register 1 and stores it in a destination register. 

**Example Usage:**
```verilog
rd = rs1 + rs2
```
```verilog
32'b0000000_00111_00110_000_00101_0110011;  // add x5, x6, x7
```

In this example, we initialize r6 = 5, r7 = 7 and store the result of the addition r5 into memory address 0 (just for simplicity of viewing the waveform). Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/add_demo.mem)

![alt text](img/waveform1.png)

And the result 12 is stored into memory address 0.

### SUB

Subtracts the contents of source register 1 with the contents of source register 2 and stores it in a  destination register.

**Example Usage:**
```verilog
rd = rs1 - rs2
```
```verilog
32'b0100000_01100_01011_000_01010_0110011 // sub x10, x11, x12
```

In this example, we initialize r11 = 35 and r12 = 30 and store the result of the subtraction r10 into memory address 4. Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/sub_demo.mem)

![alt text](img/waveform2.png)

and the result 5 is stored into memory address 4.

### OR

Performs a bitwise OR on the contents of source register 1 and source register 2 and stores it in a destination register.

**Example Usage:**
```verilog
rd = rs1 | rs2
```
```verilog
32'b0000000_00010_00001_110_00011_0110011 // or x3, x1, x2
```

In this example, we initialize r1 = 12'b000011110000 and r2 = 12'b000011001100 and we store the result of the bitwise OR r3 into memory address 8. Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/or_demo.mem) 

![alt text](img/waveform3.png)

and the result of the bitwise OR 12'b000011111100 (upper 20 bits zero) is stored into memory address 8.

### AND

Performs a bitwise AND on the contents of source register 1 and source register 2 and stores it in a destination register.

**Example Usage:**
```verilog
rd = rs1 & rs2
```
```verilog
32'b0000000_00010_00001_111_00011_0110011 // and x3, x1, x2
```

In this example, we initialize r1 = 12'b000011110000 and r2 = 12'b000011001100 and we store the result of the bitwise AND r3 into memory address 8. Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/and_demo.mem) 

![alt text](img/waveform4.png)

and  the result of the bitwise AND 12'b000011000000 upper (20 bits zero) is stored in memory address 8.

### SLT

Compares the contents of source register 1 and source register 2. If the value in source register 1 is less than the value in source register 2, the destination register is set to 1; otherwise it is set to 0.

**Example Usage:**
```verilog
rd = (rs1 < rs2) ? 1 : 0
```
```verilog
32'b0000000_00100_00101_010_00110_0110011 // slt x6, x5, x4
```

In this example, we initialize r4 = 99 and r5 = 98. We are going to do two SLT operations to prove both cases of the destination register being set to 1 and 0. This first example we set source register 2 as r4 = 99 and source register 1 as r5 = 98 and store it into data address 0. Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/slt_demo.mem) 

![alt text](img/waveform5.png)

and the result is 1 stored in memory address 0.

Now we switch the values of source register 2 and source register 1 so rs1 > rs2 and store it in address 4

![alt text](img/waveform6.png)

and voila, the resultant 0 from source register 1 being greater than source register 2 is stored into memory address 4.

### ADDI

Adds an immediate 12 bit number into source register 1 and stores the content in the destination register. RISC-V uses sign-extension when handling it's immediates, so the 12th bit will fill the upper 20 bits of the 32 bit number to handle two's complement signed numbers.

**Example Usage:**
```verilog
rd = rs1 + imm
```
```verilog
32'b111111111111_00000_000_00010_0010011 // addi x2, x0, 12'b111111111111
```

In this example, we initialize r1 = 12'b011111111111 and r2 = 12'b1111111111 using the ADDI instruction and store the values into memory address 16 and 20 respectively. Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/addi_demo.mem) 

![alt text](img/waveform7.png)

There's the 12'b011111111111 with the MSB/sign '0' being extended the entire 32 bits

![alt text](img/waveform8.png)

and the 12'b111111111111 with the MSB/sign '1' being extended the entire 32 bits as well.

### SW 

Stores a 32-bit word from source register 2 into a memory address using source register one and an immediate to select an address. 

**Example Usage:**
```verilog
M[rs1+imm][0:31] = rs2[0:31]
```
```verilog
32'b0000000_00001_00000_010_00000_0100011 // sw x1, 0x0(x0)
```

In this example, we initialize r1 = 12'b111111111110 (sign extend from add immediate) and we store it into memory address 0. Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/sw_demo.mem) 

![alt text](img/waveform9.png)

And the sign extended r1 is stored in memory address 0.

### LW

Loads a 32-bit word from memory into a destination register using source register one and an immediate to calculate the address

**Example Usage:**
```verilog
rd = M[rs1+imm][0:31]
```
```verilog
32'b000000000000_00000_010_00010_0000011 // lw x2, 0x0(x0)
```

In this example, we build off of the stored value in the previous SW instruction. Now we just load the value that was stored in memory from the contents of register 1 into register 2. Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/lw_demo.mem) 

![alt text](img/waveform10.png)

We can notice here at the next positive clock edge, the value in r1 is loaded into r2.

### BEQ

Branches to another instruction by adding a 13-bit sign-extended immediate to the program counter if the condition of source register 1 being equal to source register 2 is true. 

**Example Usage:**
```verilog
if(rs1 == rs2) PC += imm
```
```verilog
32'b0_000000_00010_00001_000_01000_1100011 // beq x1, x2, +8
```

In this example, we add immediate 5 to both register 1 and register 2 and we use the branch if equal instruction to branch the 8 byte offset (This instruction uses a left shift for the offset incremented into the program counter, take a look at bit 10 in the example. The number field uses 4 bytes, but it will left shift one and sign-extend to cover the immediate so it's really 8 bytes represented as a 13-bit hexadecimal immediate. This is mainly due to RISC-V's use of byte-addressing and little-endianness, the program counter can only count in bytes, so if you put something in bits 1 and 0, 0 gets removed in the machine code and bit 1 gets shifted left so a single byte is the lowest number you can increment by) and skip the next instruction. Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/beq_demo.mem) 

![alt text](img/waveform11.png)

As you can see here, the program counters register increments by 2 bytes instead of 1 (RISC-V is byte-addressable so +4 is actually 4 bytes, not bits for the program counter and memory if you have noticed in each example), indicating the branch comparison was satisfied. The next clock cycle also stores 42 into register 3 with no indication of 99 ever being loaded.

### JAL

Jumps to another instruction address by adding an immediate value into the program counter and links the next instruction from the instruction address of the jump by incrementing the program counter by 4 bytes. 

**Example Usage:**
```verilog
rd = PC+4; PC += imm
```
```verilog
32'b0_0000000100_0_00000000_00001_1101111 // jal  x1, +8
```

In this example, we jump and link immediately from the first instruction address (0) to an offset of 8 bytes and save the next instruction after the 0, (0x4) into register 1. (This instruction also uses a left shift for the offset incremented by the program counter, take a look at bit 23, it represents a 4-byte address, but our program uses 8-bytes. This is the same idea with the last instruction where the lowest bit in the immediate field (1) is shifted left so that the smallest increment you can put into the program counter is 4 bytes). Check out the machine code [**here**](https://github.com/andynguyen20/risc-cpu/blob/main/risc-cpu/risc-cpu.srcs/sources_1/new/jal_demo.mem) 

![alt text](img/waveform12.png)

As you can see here, the program counter immediately jumps from the first instruction address 0x0 to the third one at 8 byte offset and the immediate add operation for 42 get loaded into register 2 as soon as the next clock cycle is hit after it is fetched in the output of the program counter register. Notice the second instruction for adding 99 into that same register never goes through. We also notice that register 1 is linked with the instruction address of the next instruction before it jumped (4 byte), confirming the jump and link was successful.

# Future Extensions

As you may have noticed, this is a minimal reduced instruction set architecture compared to the actual RISC-V ISA which includes many more instructions. I'm currently working on the pipelined version of this cpu, but in terms of future plans I actually want to do the RTL-To-GDSII flow for the pipelined version of this processor before actually implementing the entire RV32I ISA.



