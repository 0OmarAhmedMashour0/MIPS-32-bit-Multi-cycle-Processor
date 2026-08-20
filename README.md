# MIPS-32-bit-Multi-cycle-Processor

---

=======
>>>>>>> Ali

## 🧠 Overview

### 🔸 1. `Memory.vhd` - Main Memory

This module simulates the **byte-addressable memory** used for instruction and data storage.

#### ✅ Features:

- 56 bytes of memory, each cell is 8 bits (`std_logic_vector(7 downto 0)`).
- Supports aligned 32-bit reads and writes (4 consecutive bytes).
- Preloaded with MIPS-like instructions for testing (e.g., `lw`, `addi`, `add`, `beq`, `j`).

#### 📥 Inputs:

- `Clock`: Clock signal.
- `Address`: Address to read/write from (32-bit).
- `MemWrite`: Write enable signal.
- `MemRead`: Read enable signal.
- `WriteData`: Data to write into memory (32-bit).

#### 📤 Output:

- `MemData`: Data read from memory (32-bit).

---

### 🔸 2. `MDR.vhd` - Memory Data Register

Temporary register that **stores memory read data** before passing it to later stages in the datapath.

#### ✅ Features:

- Stores 32-bit data at rising edge of the clock.
- Simple and synchronous with 1-register depth.

#### 📥 Input:

- `Clock`: System clock.
- `Data_In`: 32-bit input data.

#### 📤 Output:

- `Data_Out`: Output of stored 32-bit data.

---

### 🔸 3. `Registers.vhd` - Register File

Implements the 32 general-purpose registers used in the processor. Allows simultaneous reading from two registers and writing to one register on clock edge.

#### ✅ Features:

- 32 registers (R0 to R31), each 32 bits wide.
- Supports **two asynchronous reads** and **one synchronous write**.
- Write is ignored if `write_reg = "00000"` (to preserve `$zero` register).

#### 📥 Inputs:

- `clk`: Clock signal.
- `reg_write`: Write enable signal.
- `read_reg1`, `read_reg2`: 5-bit register addresses for reading.
- `write_reg`: 5-bit register address to write to.
- `write_data`: Data to write into the register.

#### 📤 Outputs:

- `read_data1`, `read_data2`: Data outputs from the two read registers.
=======
>>>>>>> Essam

<<<<<<< HEAD
🔸 **1. ALU.vhd - Arithmetic Logic Unit**

This module performs arithmetic and logical operations required by the processor.  
✅ **Features:**

- Supports operations: AND, OR, ADD, SUB, SLT, NOR.
- Produces a zero flag used for branching decisions.

📥 **Inputs:**

- A: First operand (32-bit).
- B: Second operand (32-bit).
- ALUControl: Control signal determining the operation (4-bit).

📤 **Outputs:**

- ALUResult: Result of the operation (32-bit).
- Zero: Flag indicating if ALUResult is zero.
>>>>>>> main

---

🔸 **2. ALUControl.vhd - ALU Control Unit**

This module decodes the function field of the instruction and the ALUOp to generate the ALU control signal.  
✅ **Features:**

- Supports R-type and I-type instruction decoding.
- Works in conjunction with the main Control Unit and ALU.

📥 **Inputs:**

- ALUOp: ALU operation type from Control Unit (2-bit).
- Funct: Function field from instruction (6-bit).

📤 **Output:**

- ALUControl: Specific control signal for the ALU (4-bit).

---

🔸 **3. Mux2_5bit.vhd - 2-Input MUX (5-bit)**

This multiplexer selects between two 5-bit inputs.  
✅ **Features:**

- Used for selecting register destination (e.g., rt or rd).

📥 **Inputs:**

- Input0: First input (5-bit).
- Input1: Second input (5-bit).
- Sel: Select signal.

📤 **Output:**

- Output: Selected value (5-bit).

---

🔸 **4. Mux2_32bit.vhd - 2-Input MUX (32-bit)**

This multiplexer selects between two 32-bit inputs.  
✅ **Features:**

- Commonly used for selecting between ALU result and memory data.

📥 **Inputs:**

- Input0: First input (32-bit).
- Input1: Second input (32-bit).
- Sel: Select signal.

📤 **Output:**

- Output: Selected value (32-bit).

---

🔸 **5. Mux3_32bit.vhd - 3-Input MUX (32-bit)**

This module selects between three 32-bit inputs.  
✅ **Features:**

- Useful for selecting next PC value from PC+4, branch address, or jump address.

📥 **Inputs:**

- Input0: First input (32-bit).
- Input1: Second input (32-bit).
- Input2: Third input (32-bit).
- Sel: 2-bit select signal.

📤 **Output:**

- Output: Selected value (32-bit).

---

🔸 **6. Mux4_32bit.vhd - 4-Input MUX (32-bit)**

This multiplexer selects between four 32-bit inputs.  
✅ **Features:**

- Used when multiple sources are candidates for the same data line.

📥 **Inputs:**

- Input0: First input (32-bit).
- Input1: Second input (32-bit).
- Input2: Third input (32-bit).
- Input3: Fourth input (32-bit).
- Sel: 2-bit select signal.

📤 **Output:**

- Output: Selected value (32-bit).

---


=======
>>>>>>> Merna


---

=======
>>>>>>> Omar
## 🔸 IR (Instruction Register)

The Instruction Register stores the instruction fetched from memory for the processor to parse and execute.

#### 📥 Inputs:

* `IR_in`: The instruction fetched from memory.
* `IRWrite`: Allows the IR to be updated when high.
* `clk`: Updates the IR on the rising edge.
* `reset`: Clears the IR when activated.

#### 📤 Output:

* `IR_out`: The current instruction held in the IR.

---

## 🔸 PC (Program Counter)

The Program Counter stores the address of the next instruction to be executed.

#### 📥 Inputs:

* `PC_in`: The new value to be loaded into the PC.
* `PCWrite`: Allows the PC to update only when it's high.
* `clk`: Updates the PC value on the rising edge.
* `reset`: Resets the PC to zero or an initial value when activated.

#### 📤 Output:

* `PC_out`: The current value of the PC.

---

## 🔸 Shift\_Left26To28

This module shifts all bits in a binary value to the left by 2 (used for jump instructions).

#### 📥 Input:

* `SL_in`: A 26-bit address.

#### 📤 Output:

* `SL_out`: The shifted value after performing the shift-left operation.

---

## 🔸 Shift\_Left32To32

This module shifts all bits in a 32-bit value to the left by 2 (effectively multiplying the value by 4).

#### 📥 Input:

* `SL_in`: A 32-bit value from sign-extended.

#### 📤 Output:

* `SL_out`: The shifted value after performing the shift-left operation.
>>>>>>> origin/Omar

---
## 🗂 File Structure

```bash
.
├── Memory.vhd       # Main memory (instruction/data memory)
├── MDR.vhd          # Memory Data Register
├── Registers.vhd    # Register File (32 general-purpose registers)
└── README.md        # Project documentation
=======
